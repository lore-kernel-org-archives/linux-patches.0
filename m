Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0283F355027;
	Tue, 16 Dec 2025 11:51:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765885912; cv=none; b=EnkP0v9cSjhsdiIPXy7iTtE5Mo4Uq1kbqADPGm7d9aZdx65GSDXszR9z7MU5ueVeFsNwapV38sxtL4FZmyGAnrDxmvan6ZHCimZzrBUu3nc9ghPdzwyo+lanBX2ER2WRmFul74bAZNLRQX8Bz59Cd7RYWqrwpYvyLAfQz6PNmCU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765885912; c=relaxed/simple;
	bh=ZpvhSpKhfyITuaHkDjCfBYynYbV4KGt1SrCmJqNugNA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p9gHKkm/GXccubmuUg8ysxFnfh8m5bEAYwy9CzL4fe++9qhUHIjk55y7jdMtP7W46TTXKCMKOUrncFbitDm04ZsgExMxvLJfvXHO+woh0w1lUU3F+fEwgnm2GYNf9+q4JCBkz4wUxYokWEYMMXXhImnEC0wbeVG0y+rSieOqP+M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=H0z6i//u; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H0z6i//u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E3F4C4CEF1;
	Tue, 16 Dec 2025 11:51:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765885911;
	bh=ZpvhSpKhfyITuaHkDjCfBYynYbV4KGt1SrCmJqNugNA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=H0z6i//u5eInop6/xSOAzXYptLw7KkTNxmoZAumuUPhcTqQS7hstwCcZj+RsYVVdL
	 KcD/eHMVX4tZN0KEnlnAHWomV980nn8gSp4ls7xote8cuM1fIOuhz5/G3wKFXxT+u2
	 HHWJNteWm9j3C+asJ/5Yq7NmpJRT++0/Nge0R9Ms=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Roman Kisel <romank@linux.microsoft.com>,
	Tianyu Lan <tiala@microsoft.com>,
	Michael Kelley <mhklinux@outlook.com>,
	Wei Liu <wei.liu@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 248/507] Drivers: hv: Allocate encrypted buffers when requested
Date: Tue, 16 Dec 2025 12:11:29 +0100
Message-ID: <20251216111354.479243388@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111345.522190956@linuxfoundation.org>
References: <20251216111345.522190956@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Roman Kisel <romank@linux.microsoft.com>

[ Upstream commit 0a4534bdf29a5b7f5a355c267d28dad9c40ba252 ]

Confidential VMBus is built around using buffers not shared with
the host.

Support allocating encrypted buffers when requested.

Signed-off-by: Roman Kisel <romank@linux.microsoft.com>
Reviewed-by: Tianyu Lan <tiala@microsoft.com>
Reviewed-by: Michael Kelley <mhklinux@outlook.com>
Signed-off-by: Wei Liu <wei.liu@kernel.org>
Stable-dep-of: 510164539f16 ("Drivers: hv: Free msginfo when the buffer fails to decrypt")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hv/channel.c      | 49 +++++++++++++++++++++++----------------
 drivers/hv/hyperv_vmbus.h |  3 ++-
 drivers/hv/ring_buffer.c  |  5 ++--
 3 files changed, 34 insertions(+), 23 deletions(-)

diff --git a/drivers/hv/channel.c b/drivers/hv/channel.c
index 7c7c66e0dc3f2..1621b95263a5b 100644
--- a/drivers/hv/channel.c
+++ b/drivers/hv/channel.c
@@ -444,20 +444,23 @@ static int __vmbus_establish_gpadl(struct vmbus_channel *channel,
 		return ret;
 	}
 
-	/*
-	 * Set the "decrypted" flag to true for the set_memory_decrypted()
-	 * success case. In the failure case, the encryption state of the
-	 * memory is unknown. Leave "decrypted" as true to ensure the
-	 * memory will be leaked instead of going back on the free list.
-	 */
-	gpadl->decrypted = true;
-	ret = set_memory_decrypted((unsigned long)kbuffer,
-				   PFN_UP(size));
-	if (ret) {
-		dev_warn(&channel->device_obj->device,
-			 "Failed to set host visibility for new GPADL %d.\n",
-			 ret);
-		return ret;
+	gpadl->decrypted = !((channel->co_external_memory && type == HV_GPADL_BUFFER) ||
+		(channel->co_ring_buffer && type == HV_GPADL_RING));
+	if (gpadl->decrypted) {
+		/*
+		 * The "decrypted" flag being true assumes that set_memory_decrypted() succeeds.
+		 * But if it fails, the encryption state of the memory is unknown. In that case,
+		 * leave "decrypted" as true to ensure the memory is leaked instead of going back
+		 * on the free list.
+		 */
+		ret = set_memory_decrypted((unsigned long)kbuffer,
+					PFN_UP(size));
+		if (ret) {
+			dev_warn(&channel->device_obj->device,
+				"Failed to set host visibility for new GPADL %d.\n",
+				ret);
+			return ret;
+		}
 	}
 
 	init_completion(&msginfo->waitevent);
@@ -545,8 +548,10 @@ static int __vmbus_establish_gpadl(struct vmbus_channel *channel,
 		 * left as true so the memory is leaked instead of being
 		 * put back on the free list.
 		 */
-		if (!set_memory_encrypted((unsigned long)kbuffer, PFN_UP(size)))
-			gpadl->decrypted = false;
+		if (gpadl->decrypted) {
+			if (!set_memory_encrypted((unsigned long)kbuffer, PFN_UP(size)))
+				gpadl->decrypted = false;
+		}
 	}
 
 	return ret;
@@ -677,12 +682,13 @@ static int __vmbus_open(struct vmbus_channel *newchannel,
 		goto error_clean_ring;
 
 	err = hv_ringbuffer_init(&newchannel->outbound,
-				 page, send_pages, 0);
+				 page, send_pages, 0, newchannel->co_ring_buffer);
 	if (err)
 		goto error_free_gpadl;
 
 	err = hv_ringbuffer_init(&newchannel->inbound, &page[send_pages],
-				 recv_pages, newchannel->max_pkt_size);
+				 recv_pages, newchannel->max_pkt_size,
+				 newchannel->co_ring_buffer);
 	if (err)
 		goto error_free_gpadl;
 
@@ -863,8 +869,11 @@ int vmbus_teardown_gpadl(struct vmbus_channel *channel, struct vmbus_gpadl *gpad
 
 	kfree(info);
 
-	ret = set_memory_encrypted((unsigned long)gpadl->buffer,
-				   PFN_UP(gpadl->size));
+	if (gpadl->decrypted)
+		ret = set_memory_encrypted((unsigned long)gpadl->buffer,
+					PFN_UP(gpadl->size));
+	else
+		ret = 0;
 	if (ret)
 		pr_warn("Fail to set mem host visibility in GPADL teardown %d.\n", ret);
 
diff --git a/drivers/hv/hyperv_vmbus.h b/drivers/hv/hyperv_vmbus.h
index 4a01797d48513..0d969f77388ef 100644
--- a/drivers/hv/hyperv_vmbus.h
+++ b/drivers/hv/hyperv_vmbus.h
@@ -182,7 +182,8 @@ extern int hv_synic_cleanup(unsigned int cpu);
 void hv_ringbuffer_pre_init(struct vmbus_channel *channel);
 
 int hv_ringbuffer_init(struct hv_ring_buffer_info *ring_info,
-		       struct page *pages, u32 pagecnt, u32 max_pkt_size);
+		       struct page *pages, u32 pagecnt, u32 max_pkt_size,
+			   bool confidential);
 
 void hv_ringbuffer_cleanup(struct hv_ring_buffer_info *ring_info);
 
diff --git a/drivers/hv/ring_buffer.c b/drivers/hv/ring_buffer.c
index 23ce1fb70de14..3c421a7f78c00 100644
--- a/drivers/hv/ring_buffer.c
+++ b/drivers/hv/ring_buffer.c
@@ -184,7 +184,8 @@ void hv_ringbuffer_pre_init(struct vmbus_channel *channel)
 
 /* Initialize the ring buffer. */
 int hv_ringbuffer_init(struct hv_ring_buffer_info *ring_info,
-		       struct page *pages, u32 page_cnt, u32 max_pkt_size)
+		       struct page *pages, u32 page_cnt, u32 max_pkt_size,
+			   bool confidential)
 {
 	struct page **pages_wraparound;
 	int i;
@@ -208,7 +209,7 @@ int hv_ringbuffer_init(struct hv_ring_buffer_info *ring_info,
 
 	ring_info->ring_buffer = (struct hv_ring_buffer *)
 		vmap(pages_wraparound, page_cnt * 2 - 1, VM_MAP,
-			pgprot_decrypted(PAGE_KERNEL));
+			confidential ? PAGE_KERNEL : pgprot_decrypted(PAGE_KERNEL));
 
 	kfree(pages_wraparound);
 	if (!ring_info->ring_buffer)
-- 
2.51.0



