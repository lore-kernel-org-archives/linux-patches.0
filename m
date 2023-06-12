Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E445D512
	for <patches@lists.linux.dev>; Mon, 12 Jun 2023 10:38:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B482C433D2;
	Mon, 12 Jun 2023 10:38:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1686566299;
	bh=v2BrSqRNMp8NySsv92SzCQlC5pKQXFPtsYAUG9mTth8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nGAmhYA2QwLDSmHgaixLnbfyeAsS8IIWLEI0TlG5Sa2IL+2yxPI7ur3N2HOafxvRt
	 eRSNA2xOgncN9o5p2i/pI9IgeqtE+b79cQHX2J521ZJQtC2Je8YV8IzrFvKjbb7+2h
	 vzo4TbM0ivDbGuk2Z/QZ2p0GpnAM1d/6i1mIehms=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+fcf1a817ceb50935ce99@syzkaller.appspotmail.comm,
	Ruihan Li <lrh2000@pku.edu.cn>,
	Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH 5.15 69/91] usb: usbfs: Enforce page requirements for mmap
Date: Mon, 12 Jun 2023 12:26:58 +0200
Message-ID: <20230612101704.962816916@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230612101702.085813286@linuxfoundation.org>
References: <20230612101702.085813286@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Ruihan Li <lrh2000@pku.edu.cn>

commit 0143d148d1e882fb1538dc9974c94d63961719b9 upstream.

The current implementation of usbdev_mmap uses usb_alloc_coherent to
allocate memory pages that will later be mapped into the user space.
Meanwhile, usb_alloc_coherent employs three different methods to
allocate memory, as outlined below:
 * If hcd->localmem_pool is non-null, it uses gen_pool_dma_alloc to
   allocate memory;
 * If DMA is not available, it uses kmalloc to allocate memory;
 * Otherwise, it uses dma_alloc_coherent.

However, it should be noted that gen_pool_dma_alloc does not guarantee
that the resulting memory will be page-aligned. Furthermore, trying to
map slab pages (i.e., memory allocated by kmalloc) into the user space
is not resonable and can lead to problems, such as a type confusion bug
when PAGE_TABLE_CHECK=y [1].

To address these issues, this patch introduces hcd_alloc_coherent_pages,
which addresses the above two problems. Specifically,
hcd_alloc_coherent_pages uses gen_pool_dma_alloc_align instead of
gen_pool_dma_alloc to ensure that the memory is page-aligned. To replace
kmalloc, hcd_alloc_coherent_pages directly allocates pages by calling
__get_free_pages.

Reported-by: syzbot+fcf1a817ceb50935ce99@syzkaller.appspotmail.comm
Closes: https://lore.kernel.org/lkml/000000000000258e5e05fae79fc1@google.com/ [1]
Fixes: f7d34b445abc ("USB: Add support for usbfs zerocopy.")
Fixes: ff2437befd8f ("usb: host: Fix excessive alignment restriction for local memory allocations")
Cc: stable@vger.kernel.org
Signed-off-by: Ruihan Li <lrh2000@pku.edu.cn>
Acked-by: Alan Stern <stern@rowland.harvard.edu>
Link: https://lore.kernel.org/r/20230515130958.32471-2-lrh2000@pku.edu.cn
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/core/buffer.c |   41 +++++++++++++++++++++++++++++++++++++++++
 drivers/usb/core/devio.c  |    9 +++++----
 include/linux/usb/hcd.h   |    5 +++++
 3 files changed, 51 insertions(+), 4 deletions(-)

--- a/drivers/usb/core/buffer.c
+++ b/drivers/usb/core/buffer.c
@@ -172,3 +172,44 @@ void hcd_buffer_free(
 	}
 	dma_free_coherent(hcd->self.sysdev, size, addr, dma);
 }
+
+void *hcd_buffer_alloc_pages(struct usb_hcd *hcd,
+		size_t size, gfp_t mem_flags, dma_addr_t *dma)
+{
+	if (size == 0)
+		return NULL;
+
+	if (hcd->localmem_pool)
+		return gen_pool_dma_alloc_align(hcd->localmem_pool,
+				size, dma, PAGE_SIZE);
+
+	/* some USB hosts just use PIO */
+	if (!hcd_uses_dma(hcd)) {
+		*dma = DMA_MAPPING_ERROR;
+		return (void *)__get_free_pages(mem_flags,
+				get_order(size));
+	}
+
+	return dma_alloc_coherent(hcd->self.sysdev,
+			size, dma, mem_flags);
+}
+
+void hcd_buffer_free_pages(struct usb_hcd *hcd,
+		size_t size, void *addr, dma_addr_t dma)
+{
+	if (!addr)
+		return;
+
+	if (hcd->localmem_pool) {
+		gen_pool_free(hcd->localmem_pool,
+				(unsigned long)addr, size);
+		return;
+	}
+
+	if (!hcd_uses_dma(hcd)) {
+		free_pages((unsigned long)addr, get_order(size));
+		return;
+	}
+
+	dma_free_coherent(hcd->self.sysdev, size, addr, dma);
+}
--- a/drivers/usb/core/devio.c
+++ b/drivers/usb/core/devio.c
@@ -174,6 +174,7 @@ static int connected(struct usb_dev_stat
 static void dec_usb_memory_use_count(struct usb_memory *usbm, int *count)
 {
 	struct usb_dev_state *ps = usbm->ps;
+	struct usb_hcd *hcd = bus_to_hcd(ps->dev->bus);
 	unsigned long flags;
 
 	spin_lock_irqsave(&ps->lock, flags);
@@ -182,8 +183,8 @@ static void dec_usb_memory_use_count(str
 		list_del(&usbm->memlist);
 		spin_unlock_irqrestore(&ps->lock, flags);
 
-		usb_free_coherent(ps->dev, usbm->size, usbm->mem,
-				usbm->dma_handle);
+		hcd_buffer_free_pages(hcd, usbm->size,
+				usbm->mem, usbm->dma_handle);
 		usbfs_decrease_memory_usage(
 			usbm->size + sizeof(struct usb_memory));
 		kfree(usbm);
@@ -235,8 +236,8 @@ static int usbdev_mmap(struct file *file
 		goto error_decrease_mem;
 	}
 
-	mem = usb_alloc_coherent(ps->dev, size, GFP_USER | __GFP_NOWARN,
-			&dma_handle);
+	mem = hcd_buffer_alloc_pages(hcd,
+			size, GFP_USER | __GFP_NOWARN, &dma_handle);
 	if (!mem) {
 		ret = -ENOMEM;
 		goto error_free_usbm;
--- a/include/linux/usb/hcd.h
+++ b/include/linux/usb/hcd.h
@@ -515,6 +515,11 @@ void *hcd_buffer_alloc(struct usb_bus *b
 void hcd_buffer_free(struct usb_bus *bus, size_t size,
 	void *addr, dma_addr_t dma);
 
+void *hcd_buffer_alloc_pages(struct usb_hcd *hcd,
+		size_t size, gfp_t mem_flags, dma_addr_t *dma);
+void hcd_buffer_free_pages(struct usb_hcd *hcd,
+		size_t size, void *addr, dma_addr_t dma);
+
 /* generic bus glue, needed for host controllers that don't use PCI */
 extern irqreturn_t usb_hcd_irq(int irq, void *__hcd);
 


