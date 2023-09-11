Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 743711170E
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 14:29:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA763C433C8;
	Mon, 11 Sep 2023 14:29:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694442565;
	bh=dwuiljBiRonneZT0apemdaWowWslluoFqgnifVuxWAA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=M4EH8rFXse2NBrLvgwMhFpGnWyT54do5pCZ14C0/+ckx/55R5b1ZbRfrKbbzfMUGk
	 YTpjpNHp9NuCcg+a8QGMfoafe/Ah1fwgmiSRNJ/xfXX6+XDMdNOAcrA7pmlEEP8z17
	 HSSqVlbi6MuHjy+RbzZaYrkJLGVLmnOyGc6jmY84=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Hildenbrand <david@redhat.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 070/737] virtio-mem: remove unsafe unplug in Big Block Mode (BBM)
Date: Mon, 11 Sep 2023 15:38:49 +0200
Message-ID: <20230911134652.469704456@linuxfoundation.org>
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

[ Upstream commit f504e15b94eb4e5b47f8715da59c0207f68dffe1 ]

When "unsafe unplug" is enabled, we don't fake-offline all memory ahead of
actual memory offlining using alloc_contig_range(). Instead, we rely on
offline_pages() to also perform actual page migration, which might fail
or take a very long time.

In that case, it's possible to easily run into endless loops that cannot be
aborted anymore (as offlining is triggered by a workqueue then): For
example, a single (accidentally) permanently unmovable page in
ZONE_MOVABLE results in an endless loop. For ZONE_NORMAL, races between
isolating the pageblock (and checking for unmovable pages) and
concurrent page allocation are possible and similarly result in endless
loops.

The idea of the unsafe unplug mode was to make it possible to more
reliably unplug large memory blocks. However, (a) we really should be
tackling that differently, by extending the alloc_contig_range()-based
mechanism; and (b) this mode is not the default and as far as I know,
it's unused either way.

So let's simply get rid of it.

Signed-off-by: David Hildenbrand <david@redhat.com>
Message-Id: <20230713145551.2824980-2-david@redhat.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/virtio/virtio_mem.c | 51 +++++++++++++++----------------------
 1 file changed, 20 insertions(+), 31 deletions(-)

diff --git a/drivers/virtio/virtio_mem.c b/drivers/virtio/virtio_mem.c
index 835f6cc2fb664..ed15d2a4bd96b 100644
--- a/drivers/virtio/virtio_mem.c
+++ b/drivers/virtio/virtio_mem.c
@@ -38,11 +38,6 @@ module_param(bbm_block_size, ulong, 0444);
 MODULE_PARM_DESC(bbm_block_size,
 		 "Big Block size in bytes. Default is 0 (auto-detection).");
 
-static bool bbm_safe_unplug = true;
-module_param(bbm_safe_unplug, bool, 0444);
-MODULE_PARM_DESC(bbm_safe_unplug,
-	     "Use a safe unplug mechanism in BBM, avoiding long/endless loops");
-
 /*
  * virtio-mem currently supports the following modes of operation:
  *
@@ -2111,38 +2106,32 @@ static int virtio_mem_bbm_offline_remove_and_unplug_bb(struct virtio_mem *vm,
 			 VIRTIO_MEM_BBM_BB_ADDED))
 		return -EINVAL;
 
-	if (bbm_safe_unplug) {
-		/*
-		 * Start by fake-offlining all memory. Once we marked the device
-		 * block as fake-offline, all newly onlined memory will
-		 * automatically be kept fake-offline. Protect from concurrent
-		 * onlining/offlining until we have a consistent state.
-		 */
-		mutex_lock(&vm->hotplug_mutex);
-		virtio_mem_bbm_set_bb_state(vm, bb_id,
-					    VIRTIO_MEM_BBM_BB_FAKE_OFFLINE);
+	/*
+	 * Start by fake-offlining all memory. Once we marked the device
+	 * block as fake-offline, all newly onlined memory will
+	 * automatically be kept fake-offline. Protect from concurrent
+	 * onlining/offlining until we have a consistent state.
+	 */
+	mutex_lock(&vm->hotplug_mutex);
+	virtio_mem_bbm_set_bb_state(vm, bb_id, VIRTIO_MEM_BBM_BB_FAKE_OFFLINE);
 
-		for (pfn = start_pfn; pfn < end_pfn; pfn += PAGES_PER_SECTION) {
-			page = pfn_to_online_page(pfn);
-			if (!page)
-				continue;
+	for (pfn = start_pfn; pfn < end_pfn; pfn += PAGES_PER_SECTION) {
+		page = pfn_to_online_page(pfn);
+		if (!page)
+			continue;
 
-			rc = virtio_mem_fake_offline(pfn, PAGES_PER_SECTION);
-			if (rc) {
-				end_pfn = pfn;
-				goto rollback_safe_unplug;
-			}
+		rc = virtio_mem_fake_offline(pfn, PAGES_PER_SECTION);
+		if (rc) {
+			end_pfn = pfn;
+			goto rollback;
 		}
-		mutex_unlock(&vm->hotplug_mutex);
 	}
+	mutex_unlock(&vm->hotplug_mutex);
 
 	rc = virtio_mem_bbm_offline_and_remove_bb(vm, bb_id);
 	if (rc) {
-		if (bbm_safe_unplug) {
-			mutex_lock(&vm->hotplug_mutex);
-			goto rollback_safe_unplug;
-		}
-		return rc;
+		mutex_lock(&vm->hotplug_mutex);
+		goto rollback;
 	}
 
 	rc = virtio_mem_bbm_unplug_bb(vm, bb_id);
@@ -2154,7 +2143,7 @@ static int virtio_mem_bbm_offline_remove_and_unplug_bb(struct virtio_mem *vm,
 					    VIRTIO_MEM_BBM_BB_UNUSED);
 	return rc;
 
-rollback_safe_unplug:
+rollback:
 	for (pfn = start_pfn; pfn < end_pfn; pfn += PAGES_PER_SECTION) {
 		page = pfn_to_online_page(pfn);
 		if (!page)
-- 
2.40.1



