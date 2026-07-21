Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6118E3AA4F9;
	Tue, 21 Jul 2026 22:36:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784673379; cv=none; b=XU+JKx85E4fJKqMxI3uUqcKjvWTI2/rJRw+OkdBcIIQrVpRj2X8dJjJlCLMZ6KJuj6dYJlgwYVgQrC1IrdOeFRj3w7jMabYLyu0K2YveSXV98ZpS3vp6KHoc1xMbVtESMMjcvTn/VQqv2u3b5Z6/a8RTIg7JS1LMHgkcFSWl7hY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784673379; c=relaxed/simple;
	bh=AJ0bhRau5lZP7Szm2ZKouELT6HBCJluf6HcRQuV615k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CFeTl8vWAxl4aoOCsTuB/OvZ+xcx3Lwls8KRMKxQYgiAk+68Js2QJ4sfwx4tXjJJBQ2Q2+aHh/3X+8NVFrvfl/JjXYnlxdDdvppcI4MVwUHCC8R0jmo+fZKnIRuly2mmb+qIBnvbIlUvFYCDVoZjkLF7NnGhVso4T7+4dEAFAoU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=s97m21Jg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="s97m21Jg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C54F61F000E9;
	Tue, 21 Jul 2026 22:36:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784673378;
	bh=ZjdXEyl5u0qqs+WTdGVSS4A7uJo576j34jLr2Agx/As=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=s97m21JgIBj6mzU+32ooAFxAMB21RnMCbRruI2LYLeSAmERPbAUCgQe3DSvDBqNtk
	 kp/hXTkktY4EPRNbst7h2vt/EBUtamFeEDgWQ4tKOxd/aI5ASTnP49RBMXYCLlh03Q
	 XCEG3QuI1c2djdlPPbP7C+wIKq5J/+PZG9LKEJNQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>,
	Vivek Kasireddy <vivek.kasireddy@intel.com>
Subject: [PATCH 5.10 141/699] udmabuf: fix DMA direction mismatch in release_udmabuf()
Date: Tue, 21 Jul 2026 17:18:20 +0200
Message-ID: <20260721152358.888061211@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152355.667394603@linuxfoundation.org>
References: <20260721152355.667394603@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>

commit fb7b1a0ab25a6077d26cb3829e31743972d4f31d upstream.

begin_cpu_udmabuf() maps the sg_table with the caller-provided direction
(e.g., DMA_TO_DEVICE for a write-only sync), and caches it in ubuf->sg
for reuse.  However, release_udmabuf() always unmaps this sg_table with
a hardcoded DMA_BIDIRECTIONAL, regardless of the direction that was
originally used for the mapping.

With CONFIG_DMA_API_DEBUG=y this produces:

  DMA-API: misc udmabuf: device driver frees DMA memory with different
  direction [device address=0x000000044a123000] [size=4096 bytes]
  [mapped with DMA_TO_DEVICE] [unmapped with DMA_BIDIRECTIONAL]

The issue was found during video playback when GStreamer performed a
write-only DMA_BUF_IOCTL_SYNC on a udmabuf.  It can be reproduced
with CONFIG_DMA_API_DEBUG=y by creating a udmabuf from a memfd,
performing a write-only sync (DMA_BUF_SYNC_WRITE without
DMA_BUF_SYNC_READ), and closing the file descriptor.

Fix this by storing the DMA direction used when the sg_table is first
created in begin_cpu_udmabuf(), and passing that same direction to
put_sg_table() in release_udmabuf().

Fixes: 284562e1f348 ("udmabuf: implement begin_cpu_access/end_cpu_access hooks")
Cc: stable@vger.kernel.org
Signed-off-by: Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>
Reviewed-by: Vivek Kasireddy <vivek.kasireddy@intel.com>
Signed-off-by: Vivek Kasireddy <vivek.kasireddy@intel.com>
Link: https://patch.msgid.link/20260314232722.15555-1-mikhail.v.gavrilov@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/dma-buf/udmabuf.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/dma-buf/udmabuf.c
+++ b/drivers/dma-buf/udmabuf.c
@@ -19,6 +19,7 @@ struct udmabuf {
 	pgoff_t pagecount;
 	struct page **pages;
 	struct sg_table *sg;
+	enum dma_data_direction sg_dir;
 	struct miscdevice *device;
 };
 
@@ -105,7 +106,7 @@ static void release_udmabuf(struct dma_b
 	pgoff_t pg;
 
 	if (ubuf->sg)
-		put_sg_table(dev, ubuf->sg, DMA_BIDIRECTIONAL);
+		put_sg_table(dev, ubuf->sg, ubuf->sg_dir);
 
 	for (pg = 0; pg < ubuf->pagecount; pg++)
 		put_page(ubuf->pages[pg]);
@@ -125,6 +126,8 @@ static int begin_cpu_udmabuf(struct dma_
 		if (IS_ERR(ubuf->sg)) {
 			ret = PTR_ERR(ubuf->sg);
 			ubuf->sg = NULL;
+		} else {
+			ubuf->sg_dir = direction;
 		}
 	} else {
 		dma_sync_sgtable_for_cpu(dev, ubuf->sg, direction);


