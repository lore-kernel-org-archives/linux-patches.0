Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE330246764;
	Tue, 20 May 2025 14:11:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747750286; cv=none; b=kFA0yp+N52LsNeIX23jI3RsQTegeulur1tcoOQ6eXkTpxbGVzGvgoT0RM6B7+s4Mt++GsRhKJ9iVu8Dk3MiKKDmrzWH0hmj72s9hSYaX+JIog7bpMDYhrIOW8Pb9ejblzXJvx5GPY09hix206VSjcPSzaoDRtgN62yxBoSJO0RU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747750286; c=relaxed/simple;
	bh=6wj8utrLPHz+ddB58wupfJyaSl3AJ7VqJhi1sooJ9hQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Kx3ceiArbSN0cZp5BsHmFboUZLxxmwGbg/h5icqupUVHtQqCod1YTrPefdh6shSrF4YnVP7RnInqkwpEO6lUjvpMn8OhDuVl/3Kt8KNuucqStMTp4ne2joGPca9YJxmVIKhO21oqpmjpU5BW1UZL4NUsREI9YpFSr7sQsRM+HEs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lUerOW5A; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lUerOW5A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 658DDC4CEE9;
	Tue, 20 May 2025 14:11:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747750285;
	bh=6wj8utrLPHz+ddB58wupfJyaSl3AJ7VqJhi1sooJ9hQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lUerOW5AW7D2uJ0QWc+ZIOQJ3PhTC7r6lZvyuOL0UC94GnfYDdLGvwBL0kpV56V2S
	 7k4mr8PXzSz3kcPS6jjJXg/cKcGxU4PJxoIfUQUpbaTaPjEyO46Ju4IAf88Y5c/Hnc
	 nVaBu3XwU/ZE6glHxQfwZPhz4J2XD0Zfb+pLO4R0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Kelley <mhklinux@outlook.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.12 101/143] Drivers: hv: vmbus: Remove vmbus_sendpacket_pagebuffer()
Date: Tue, 20 May 2025 15:50:56 +0200
Message-ID: <20250520125814.020111988@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250520125810.036375422@linuxfoundation.org>
References: <20250520125810.036375422@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Kelley <mhklinux@outlook.com>

commit 45a442fe369e6c4e0b4aa9f63b31c3f2f9e2090e upstream.

With the netvsc driver changed to use vmbus_sendpacket_mpb_desc()
instead of vmbus_sendpacket_pagebuffer(), the latter has no remaining
callers. Remove it.

Cc: <stable@vger.kernel.org> # 6.1.x
Signed-off-by: Michael Kelley <mhklinux@outlook.com>
Link: https://patch.msgid.link/20250513000604.1396-6-mhklinux@outlook.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hv/channel.c   |   59 -------------------------------------------------
 include/linux/hyperv.h |    7 -----
 2 files changed, 66 deletions(-)

--- a/drivers/hv/channel.c
+++ b/drivers/hv/channel.c
@@ -1077,65 +1077,6 @@ int vmbus_sendpacket(struct vmbus_channe
 EXPORT_SYMBOL(vmbus_sendpacket);
 
 /*
- * vmbus_sendpacket_pagebuffer - Send a range of single-page buffer
- * packets using a GPADL Direct packet type. This interface allows you
- * to control notifying the host. This will be useful for sending
- * batched data. Also the sender can control the send flags
- * explicitly.
- */
-int vmbus_sendpacket_pagebuffer(struct vmbus_channel *channel,
-				struct hv_page_buffer pagebuffers[],
-				u32 pagecount, void *buffer, u32 bufferlen,
-				u64 requestid)
-{
-	int i;
-	struct vmbus_channel_packet_page_buffer desc;
-	u32 descsize;
-	u32 packetlen;
-	u32 packetlen_aligned;
-	struct kvec bufferlist[3];
-	u64 aligned_data = 0;
-
-	if (pagecount > MAX_PAGE_BUFFER_COUNT)
-		return -EINVAL;
-
-	/*
-	 * Adjust the size down since vmbus_channel_packet_page_buffer is the
-	 * largest size we support
-	 */
-	descsize = sizeof(struct vmbus_channel_packet_page_buffer) -
-			  ((MAX_PAGE_BUFFER_COUNT - pagecount) *
-			  sizeof(struct hv_page_buffer));
-	packetlen = descsize + bufferlen;
-	packetlen_aligned = ALIGN(packetlen, sizeof(u64));
-
-	/* Setup the descriptor */
-	desc.type = VM_PKT_DATA_USING_GPA_DIRECT;
-	desc.flags = VMBUS_DATA_PACKET_FLAG_COMPLETION_REQUESTED;
-	desc.dataoffset8 = descsize >> 3; /* in 8-bytes granularity */
-	desc.length8 = (u16)(packetlen_aligned >> 3);
-	desc.transactionid = VMBUS_RQST_ERROR; /* will be updated in hv_ringbuffer_write() */
-	desc.reserved = 0;
-	desc.rangecount = pagecount;
-
-	for (i = 0; i < pagecount; i++) {
-		desc.range[i].len = pagebuffers[i].len;
-		desc.range[i].offset = pagebuffers[i].offset;
-		desc.range[i].pfn	 = pagebuffers[i].pfn;
-	}
-
-	bufferlist[0].iov_base = &desc;
-	bufferlist[0].iov_len = descsize;
-	bufferlist[1].iov_base = buffer;
-	bufferlist[1].iov_len = bufferlen;
-	bufferlist[2].iov_base = &aligned_data;
-	bufferlist[2].iov_len = (packetlen_aligned - packetlen);
-
-	return hv_ringbuffer_write(channel, bufferlist, 3, requestid, NULL);
-}
-EXPORT_SYMBOL_GPL(vmbus_sendpacket_pagebuffer);
-
-/*
  * vmbus_sendpacket_mpb_desc - Send one or more multi-page buffer packets
  * using a GPADL Direct packet type.
  * The desc argument must include space for the VMBus descriptor. The
--- a/include/linux/hyperv.h
+++ b/include/linux/hyperv.h
@@ -1232,13 +1232,6 @@ extern int vmbus_sendpacket(struct vmbus
 				  enum vmbus_packet_type type,
 				  u32 flags);
 
-extern int vmbus_sendpacket_pagebuffer(struct vmbus_channel *channel,
-					    struct hv_page_buffer pagebuffers[],
-					    u32 pagecount,
-					    void *buffer,
-					    u32 bufferlen,
-					    u64 requestid);
-
 extern int vmbus_sendpacket_mpb_desc(struct vmbus_channel *channel,
 				     struct vmbus_packet_mpb_array *mpb,
 				     u32 desc_size,


