Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65E5F39934B;
	Sat, 17 Oct 2026 17:24:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792257893; cv=none; b=XOsmHICcoLQbJZZLy+8Fz7QDR/px7/uPbSM3nCMKVG2WmuaymR3zAWMX2WCFf9TPd/aVW9i6z+B0l3m+3RmkW6QH1nkHPwLllfDbGOVKgdZzToXTpWPrrepQTUSPULBG0oKHYsIEM1c/OakzKhW1K3o7tOahSYQFSUszMoTt8eI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792257893; c=relaxed/simple;
	bh=pmG2hkK36vm7t7dQBeBmsYxsvgF4EnrPouNq8LACmRU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PJbjwA22Gh5ZylgqVcd8qC2emSMco4DjNwzJ2qqvDHb1NuL51KiCQqccgXd26QAFFpPnG26Su0kzjZTXtRkYXe70IETToPhOYFcuBg/dZYFKNQ1cu1pa2ev8AQjVQiV6nJ+/HhhJPpBbfebBgnM8L9i6DYIMUWiEGift4FA12nM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pWS94ZQZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pWS94ZQZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2DF41F000C4;
	Sat, 17 Oct 2026 17:24:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792257892;
	bh=OaAtxvv4xKMBXujzU5AwJofARxzSH3ScTVeGAYBO9pc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pWS94ZQZcO2arzwwKx5wOnwjI/dOQTAMIU0oDfESZtxAcKBNHbuers+7al2EdhqZf
	 NtcEnbw8VmlMCVNabp4R5PUwpGbVLL/Hqsw3HdzL23ze0AgR6BvyGhYY6ALNDriy4x
	 6z+upVekqJkKe5Xw3ukUcBEDZ3TgCZP+tCl4nz6g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Huan Yang <link@vivo.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Vivek Kasireddy <vivek.kasireddy@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0662/1674] udmabuf: change folios array from kmalloc to kvmalloc
Date: Sat, 17 Oct 2026 17:48:54 +0200
Message-ID: <20261017160448.103529879@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
User-Agent: quilt/0.69
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma-buf/udmabuf.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/dma-buf/udmabuf.c b/drivers/dma-buf/udmabuf.c
index cdb6c30352ae5..12d49793b0f2d 100644
--- a/drivers/dma-buf/udmabuf.c
+++ b/drivers/dma-buf/udmabuf.c
@@ -146,7 +146,7 @@ static void release_udmabuf(struct dma_buf *buf)
 
 	for (pg = 0; pg < ubuf->pagecount; pg++)
 		put_page(ubuf->pages[pg]);
-	kfree(ubuf->pages);
+	kvfree(ubuf->pages);
 	kfree(ubuf);
 }
 
@@ -233,8 +233,8 @@ static long udmabuf_create(struct miscdevice *device,
 	if (!ubuf->pagecount)
 		goto err;
 
-	ubuf->pages = kmalloc_array(ubuf->pagecount, sizeof(*ubuf->pages),
-				    GFP_KERNEL);
+	ubuf->pages = kvmalloc_array(ubuf->pagecount, sizeof(*ubuf->pages),
+				     GFP_KERNEL);
 	if (!ubuf->pages) {
 		ret = -ENOMEM;
 		goto err;
@@ -292,7 +292,7 @@ static long udmabuf_create(struct miscdevice *device,
 		put_page(ubuf->pages[--pgbuf]);
 	if (memfd)
 		fput(memfd);
-	kfree(ubuf->pages);
+	kvfree(ubuf->pages);
 	kfree(ubuf);
 	return ret;
 }
-- 
2.53.0



