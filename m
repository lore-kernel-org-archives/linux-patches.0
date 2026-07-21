Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0DD743CEF5;
	Tue, 21 Jul 2026 22:02:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784671372; cv=none; b=MY9spOtyrf9m7xqODgUqlwSWqkHHkkrPRiQzo0HSKBuGxnOOTV9ayV0nvbKPJAPbmLFXOo3iIwyPERpEn/+CAbFKSTvo1CBv5ApV5U+Xe1JrIZlNOhnde2VlzhddsYrihIvd2hx9NktlQhFhcaZj2H1dAMENwFaNtY+t/QfhclE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784671372; c=relaxed/simple;
	bh=YKCu+2Q4R4DhsG+ylBUvRISsbwHX3mkapS+Itgsifnc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nrF3DvAuiuVoZI3T0blD4ehmIe/xJeJRb/33/7IJIzpd0zukvSrzgAV2Ys7oYgyKFKfJWoV1TMqEvNo0IUUOd01V+9FNe0Fl+gBWYFkVA9Nhg8UYn5r3rxRpqzrY4sVq11uTQjyB66C5hTNbqyOEiRtSa728Ljingy2+/ggurfA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ourq5SAI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ourq5SAI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AE451F000E9;
	Tue, 21 Jul 2026 22:02:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784671371;
	bh=Kk9bjKayME+VFz6+vyhE4M7dkTbNEo+xd20iLjNZMYo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ourq5SAII7/yM/z7uKJ0QtFtOR31iNGoKw11SxH3KqaXJ6hHXWdDzqYojI0YvF7pk
	 mNQUyoZi/hUpth17vZLwbHweHS5n3DtlGfcDRL0hDUDBj+r911r/h7P3qj4/W9X1fd
	 BDX5MEX/aDSOno+fh4wTKlV7Zr5I+wZyXZ+BSPh8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>,
	Vivek Kasireddy <vivek.kasireddy@intel.com>
Subject: [PATCH 5.15 178/843] udmabuf: fix DMA direction mismatch in release_udmabuf()
Date: Tue, 21 Jul 2026 17:16:53 +0200
Message-ID: <20260721152410.020103390@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -25,6 +25,7 @@ struct udmabuf {
 	pgoff_t pagecount;
 	struct page **pages;
 	struct sg_table *sg;
+	enum dma_data_direction sg_dir;
 	struct miscdevice *device;
 };
 
@@ -111,7 +112,7 @@ static void release_udmabuf(struct dma_b
 	pgoff_t pg;
 
 	if (ubuf->sg)
-		put_sg_table(dev, ubuf->sg, DMA_BIDIRECTIONAL);
+		put_sg_table(dev, ubuf->sg, ubuf->sg_dir);
 
 	for (pg = 0; pg < ubuf->pagecount; pg++)
 		put_page(ubuf->pages[pg]);
@@ -131,6 +132,8 @@ static int begin_cpu_udmabuf(struct dma_
 		if (IS_ERR(ubuf->sg)) {
 			ret = PTR_ERR(ubuf->sg);
 			ubuf->sg = NULL;
+		} else {
+			ubuf->sg_dir = direction;
 		}
 	} else {
 		dma_sync_sgtable_for_cpu(dev, ubuf->sg, direction);


