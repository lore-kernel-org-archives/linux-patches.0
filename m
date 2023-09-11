Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F48E1170E
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 14:29:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83E95C433C7;
	Mon, 11 Sep 2023 14:29:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694442570;
	bh=qpeaX6xi+dR3AOnu7uDUFbJWKYYdDVKJwNLOKoKjwck=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ISO5WxlRyKxcK+7ma/q3FYwf0x4SoGUgQgtzpOiATqQN//H8PO1yHlaoMd7I7+XUT
	 kXZMO2syw6N/lnT/5e02GYlkXyXqBTa9uu9ywNMHzs12mTuEcRiHAJl1hAsoO5fr7S
	 LhZGNmXlnj6fofN90fIg3dRjC7DWSMBot9IVGps4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Hildenbrand <david@redhat.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 072/737] virtio-mem: keep retrying on offline_and_remove_memory() errors in Sub Block Mode (SBM)
Date: Mon, 11 Sep 2023 15:38:51 +0200
Message-ID: <20230911134652.526904325@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134650.286315610@linuxfoundation.org>
References: <20230911134650.286315610@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Hildenbrand <david@redhat.com>

[ Upstream commit a31648fd4f96fbe0a4d0aeb16b57a2405c6943c0 ]

In case offline_and_remove_memory() fails in SBM, we leave a completely
unplugged Linux memory block stick around until we try plugging memory
again. We won't try removing that memory block again.

offline_and_remove_memory() may, for example, fail if we're racing with
another alloc_contig_range() user, if allocating temporary memory fails,
or if some memory notifier rejected the offlining request.

Let's handle that case better, by simple retrying to offline and remove
such memory.

Tested using CONFIG_MEMORY_NOTIFIER_ERROR_INJECT.

Signed-off-by: David Hildenbrand <david@redhat.com>
Message-Id: <20230713145551.2824980-4-david@redhat.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/virtio/virtio_mem.c | 92 +++++++++++++++++++++++++++++--------
 1 file changed, 73 insertions(+), 19 deletions(-)

diff --git a/drivers/virtio/virtio_mem.c b/drivers/virtio/virtio_mem.c
index 1a76ba2bc118c..a5cf92e3e5af2 100644
--- a/drivers/virtio/virtio_mem.c
+++ b/drivers/virtio/virtio_mem.c
@@ -168,6 +168,13 @@ struct virtio_mem {
 			/* The number of subblocks per Linux memory block. */
 			uint32_t sbs_per_mb;
 
+			/*
+			 * Some of the Linux memory blocks tracked as "partially
+			 * plugged" are completely unplugged and can be offlined
+			 * and removed -- which previously failed.
+			 */
+			bool have_unplugged_mb;
+
 			/* Summary of all memory block states. */
 			unsigned long mb_count[VIRTIO_MEM_SBM_MB_COUNT];
 
@@ -765,6 +772,34 @@ static int virtio_mem_sbm_offline_and_remove_mb(struct virtio_mem *vm,
 	return virtio_mem_offline_and_remove_memory(vm, addr, size);
 }
 
+/*
+ * Try (offlining and) removing memory from Linux in case all subblocks are
+ * unplugged. Can be called on online and offline memory blocks.
+ *
+ * May modify the state of memory blocks in virtio-mem.
+ */
+static int virtio_mem_sbm_try_remove_unplugged_mb(struct virtio_mem *vm,
+						  unsigned long mb_id)
+{
+	int rc;
+
+	/*
+	 * Once all subblocks of a memory block were unplugged, offline and
+	 * remove it.
+	 */
+	if (!virtio_mem_sbm_test_sb_unplugged(vm, mb_id, 0, vm->sbm.sbs_per_mb))
+		return 0;
+
+	/* offline_and_remove_memory() works for online and offline memory. */
+	mutex_unlock(&vm->hotplug_mutex);
+	rc = virtio_mem_sbm_offline_and_remove_mb(vm, mb_id);
+	mutex_lock(&vm->hotplug_mutex);
+	if (!rc)
+		virtio_mem_sbm_set_mb_state(vm, mb_id,
+					    VIRTIO_MEM_SBM_MB_UNUSED);
+	return rc;
+}
+
 /*
  * See virtio_mem_offline_and_remove_memory(): Try to offline and remove a
  * all Linux memory blocks covered by the big block.
@@ -1988,20 +2023,10 @@ static int virtio_mem_sbm_unplug_any_sb_online(struct virtio_mem *vm,
 	}
 
 unplugged:
-	/*
-	 * Once all subblocks of a memory block were unplugged, offline and
-	 * remove it. This will usually not fail, as no memory is in use
-	 * anymore - however some other notifiers might NACK the request.
-	 */
-	if (virtio_mem_sbm_test_sb_unplugged(vm, mb_id, 0, vm->sbm.sbs_per_mb)) {
-		mutex_unlock(&vm->hotplug_mutex);
-		rc = virtio_mem_sbm_offline_and_remove_mb(vm, mb_id);
-		mutex_lock(&vm->hotplug_mutex);
-		if (!rc)
-			virtio_mem_sbm_set_mb_state(vm, mb_id,
-						    VIRTIO_MEM_SBM_MB_UNUSED);
-	}
-
+	rc = virtio_mem_sbm_try_remove_unplugged_mb(vm, mb_id);
+	if (rc)
+		vm->sbm.have_unplugged_mb = 1;
+	/* Ignore errors, this is not critical. We'll retry later. */
 	return 0;
 }
 
@@ -2253,12 +2278,13 @@ static int virtio_mem_unplug_request(struct virtio_mem *vm, uint64_t diff)
 
 /*
  * Try to unplug all blocks that couldn't be unplugged before, for example,
- * because the hypervisor was busy.
+ * because the hypervisor was busy. Further, offline and remove any memory
+ * blocks where we previously failed.
  */
-static int virtio_mem_unplug_pending_mb(struct virtio_mem *vm)
+static int virtio_mem_cleanup_pending_mb(struct virtio_mem *vm)
 {
 	unsigned long id;
-	int rc;
+	int rc = 0;
 
 	if (!vm->in_sbm) {
 		virtio_mem_bbm_for_each_bb(vm, id,
@@ -2280,6 +2306,27 @@ static int virtio_mem_unplug_pending_mb(struct virtio_mem *vm)
 					    VIRTIO_MEM_SBM_MB_UNUSED);
 	}
 
+	if (!vm->sbm.have_unplugged_mb)
+		return 0;
+
+	/*
+	 * Let's retry (offlining and) removing completely unplugged Linux
+	 * memory blocks.
+	 */
+	vm->sbm.have_unplugged_mb = false;
+
+	mutex_lock(&vm->hotplug_mutex);
+	virtio_mem_sbm_for_each_mb(vm, id, VIRTIO_MEM_SBM_MB_MOVABLE_PARTIAL)
+		rc |= virtio_mem_sbm_try_remove_unplugged_mb(vm, id);
+	virtio_mem_sbm_for_each_mb(vm, id, VIRTIO_MEM_SBM_MB_KERNEL_PARTIAL)
+		rc |= virtio_mem_sbm_try_remove_unplugged_mb(vm, id);
+	virtio_mem_sbm_for_each_mb(vm, id, VIRTIO_MEM_SBM_MB_OFFLINE_PARTIAL)
+		rc |= virtio_mem_sbm_try_remove_unplugged_mb(vm, id);
+	mutex_unlock(&vm->hotplug_mutex);
+
+	if (rc)
+		vm->sbm.have_unplugged_mb = true;
+	/* Ignore errors, this is not critical. We'll retry later. */
 	return 0;
 }
 
@@ -2361,9 +2408,9 @@ static void virtio_mem_run_wq(struct work_struct *work)
 		virtio_mem_refresh_config(vm);
 	}
 
-	/* Unplug any leftovers from previous runs */
+	/* Cleanup any leftovers from previous runs */
 	if (!rc)
-		rc = virtio_mem_unplug_pending_mb(vm);
+		rc = virtio_mem_cleanup_pending_mb(vm);
 
 	if (!rc && vm->requested_size != vm->plugged_size) {
 		if (vm->requested_size > vm->plugged_size) {
@@ -2375,6 +2422,13 @@ static void virtio_mem_run_wq(struct work_struct *work)
 		}
 	}
 
+	/*
+	 * Keep retrying to offline and remove completely unplugged Linux
+	 * memory blocks.
+	 */
+	if (!rc && vm->in_sbm && vm->sbm.have_unplugged_mb)
+		rc = -EBUSY;
+
 	switch (rc) {
 	case 0:
 		vm->retry_timer_ms = VIRTIO_MEM_RETRY_TIMER_MIN_MS;
-- 
2.40.1



