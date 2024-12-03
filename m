Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37B2C1DFD91;
	Tue,  3 Dec 2024 15:44:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733240643; cv=none; b=GROMrjtAyeh+ngjmD/bMyaYYRgD0SJ1MIRiI59zCrvBO6npWq7k+dyaSZWaeR+HS8DHOIUCp41vGu5eKzq41Q15wzPobNYKsIKu3LCaYcXdJYxQL3dOwu8FLz6p979wyd1IYpC2zcwiMBDemegN8KVpYsF8pg70JupUgyF9takY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733240643; c=relaxed/simple;
	bh=4pQbO/saCoBwGNWmoi3n9EtkekJNFkb4NLq8Lhl4mZE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WiAGxavcYzt8SEn1f8h8tH3lexJPfRxNQ1Z3HIc3PerQaRqWSUIEIgpVz6mEmZgdghQWvti5wLxOy5yQrBtBCKSkb8zLTEQMw9sDWxAB9iFhItDs8udqa54n5SwZyf9CI0TJmo7AMQqfmeV143c3cg3Bf0wvyDQXlKPuSNU2X8k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aUzAt1OJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aUzAt1OJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98E01C4CED8;
	Tue,  3 Dec 2024 15:44:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733240643;
	bh=4pQbO/saCoBwGNWmoi3n9EtkekJNFkb4NLq8Lhl4mZE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aUzAt1OJjp0F9RNSg0FukyaNxZzU557vw6zRVLXCtHNIK/eGdLbEv+ks0b4FFipET
	 AIXEHy+Ujgu+2FUJ+hhF3vGEBKr9H/ppe3O/OtP0mlFxFkOBGy7ilnF1K4bkuOu1Pc
	 qARXs2IYQqYaPyd4gPY5wSjhwAb7LflaSZryiokg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Huan Yang <link@vivo.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Vivek Kasireddy <vivek.kasireddy@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 195/826] udmabuf: change folios array from kmalloc to kvmalloc
Date: Tue,  3 Dec 2024 15:38:42 +0100
Message-ID: <20241203144751.355709404@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Huan Yang <link@vivo.com>

[ Upstream commit 1c0844c6184e658064e14c4335885785ad3bf84b ]

When PAGE_SIZE 4096, MAX_PAGE_ORDER 10, 64bit machine,
page_alloc only support 4MB.
If above this, trigger this warn and return NULL.

udmabuf can change size limit, if change it to 3072(3GB), and then alloc
3GB udmabuf, will fail create.

[ 4080.876581] ------------[ cut here ]------------
[ 4080.876843] WARNING: CPU: 3 PID: 2015 at mm/page_alloc.c:4556 __alloc_pages+0x2c8/0x350
[ 4080.878839] RIP: 0010:__alloc_pages+0x2c8/0x350
[ 4080.879470] Call Trace:
[ 4080.879473]  <TASK>
[ 4080.879473]  ? __alloc_pages+0x2c8/0x350
[ 4080.879475]  ? __warn.cold+0x8e/0xe8
[ 4080.880647]  ? __alloc_pages+0x2c8/0x350
[ 4080.880909]  ? report_bug+0xff/0x140
[ 4080.881175]  ? handle_bug+0x3c/0x80
[ 4080.881556]  ? exc_invalid_op+0x17/0x70
[ 4080.881559]  ? asm_exc_invalid_op+0x1a/0x20
[ 4080.882077]  ? udmabuf_create+0x131/0x400

Because MAX_PAGE_ORDER, kmalloc can max alloc 4096 * (1 << 10), 4MB
memory, each array entry is pointer(8byte), so can save 524288 pages(2GB).

Further more, costly order(order 3) may not be guaranteed that it can be
applied for, due to fragmentation.

This patch change udmabuf array use kvmalloc_array, this can fallback
alloc into vmalloc, which can guarantee allocation for any size and does
not affect the performance of kmalloc allocations.

Signed-off-by: Huan Yang <link@vivo.com>
Acked-by: Christian König <christian.koenig@amd.com>
Acked-by: Vivek Kasireddy <vivek.kasireddy@intel.com>
Signed-off-by: Vivek Kasireddy <vivek.kasireddy@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240918025238.2957823-3-link@vivo.com
Stable-dep-of: 18d7de823b71 ("udmabuf: fix vmap_udmabuf error page set")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma-buf/udmabuf.c | 26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

diff --git a/drivers/dma-buf/udmabuf.c b/drivers/dma-buf/udmabuf.c
index 047c3cd2cefff..bc94c194e172d 100644
--- a/drivers/dma-buf/udmabuf.c
+++ b/drivers/dma-buf/udmabuf.c
@@ -80,7 +80,7 @@ static int vmap_udmabuf(struct dma_buf *buf, struct iosys_map *map)
 
 	dma_resv_assert_held(buf->resv);
 
-	pages = kmalloc_array(ubuf->pagecount, sizeof(*pages), GFP_KERNEL);
+	pages = kvmalloc_array(ubuf->pagecount, sizeof(*pages), GFP_KERNEL);
 	if (!pages)
 		return -ENOMEM;
 
@@ -88,7 +88,7 @@ static int vmap_udmabuf(struct dma_buf *buf, struct iosys_map *map)
 		pages[pg] = &ubuf->folios[pg]->page;
 
 	vaddr = vm_map_ram(pages, ubuf->pagecount, -1);
-	kfree(pages);
+	kvfree(pages);
 	if (!vaddr)
 		return -EINVAL;
 
@@ -196,8 +196,8 @@ static void release_udmabuf(struct dma_buf *buf)
 		put_sg_table(dev, ubuf->sg, DMA_BIDIRECTIONAL);
 
 	unpin_all_folios(&ubuf->unpin_list);
-	kfree(ubuf->offsets);
-	kfree(ubuf->folios);
+	kvfree(ubuf->offsets);
+	kvfree(ubuf->folios);
 	kfree(ubuf);
 }
 
@@ -322,14 +322,14 @@ static long udmabuf_create(struct miscdevice *device,
 	if (!ubuf->pagecount)
 		goto err;
 
-	ubuf->folios = kmalloc_array(ubuf->pagecount, sizeof(*ubuf->folios),
-				    GFP_KERNEL);
+	ubuf->folios = kvmalloc_array(ubuf->pagecount, sizeof(*ubuf->folios),
+				      GFP_KERNEL);
 	if (!ubuf->folios) {
 		ret = -ENOMEM;
 		goto err;
 	}
-	ubuf->offsets = kcalloc(ubuf->pagecount, sizeof(*ubuf->offsets),
-				GFP_KERNEL);
+	ubuf->offsets = kvcalloc(ubuf->pagecount, sizeof(*ubuf->offsets),
+				 GFP_KERNEL);
 	if (!ubuf->offsets) {
 		ret = -ENOMEM;
 		goto err;
@@ -343,7 +343,7 @@ static long udmabuf_create(struct miscdevice *device,
 			goto err;
 
 		pgcnt = list[i].size >> PAGE_SHIFT;
-		folios = kmalloc_array(pgcnt, sizeof(*folios), GFP_KERNEL);
+		folios = kvmalloc_array(pgcnt, sizeof(*folios), GFP_KERNEL);
 		if (!folios) {
 			ret = -ENOMEM;
 			goto err;
@@ -353,7 +353,7 @@ static long udmabuf_create(struct miscdevice *device,
 		ret = memfd_pin_folios(memfd, list[i].offset, end,
 				       folios, pgcnt, &pgoff);
 		if (ret <= 0) {
-			kfree(folios);
+			kvfree(folios);
 			if (!ret)
 				ret = -EINVAL;
 			goto err;
@@ -382,7 +382,7 @@ static long udmabuf_create(struct miscdevice *device,
 			}
 		}
 
-		kfree(folios);
+		kvfree(folios);
 		fput(memfd);
 		memfd = NULL;
 	}
@@ -398,8 +398,8 @@ static long udmabuf_create(struct miscdevice *device,
 	if (memfd)
 		fput(memfd);
 	unpin_all_folios(&ubuf->unpin_list);
-	kfree(ubuf->offsets);
-	kfree(ubuf->folios);
+	kvfree(ubuf->offsets);
+	kvfree(ubuf->folios);
 	kfree(ubuf);
 	return ret;
 }
-- 
2.43.0



