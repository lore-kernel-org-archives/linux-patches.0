Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 622343E5A28;
	Tue, 12 May 2026 17:49:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778608165; cv=none; b=lH+empPlNbkBc9slwemCNGi9uljUnuazJ2HsgirjYoVM0p5Yf0A9u1j6yqbeLCHqweeWsZGE1jd7kIgJN/rBYrSqFAS8X1d4iyRYRSsWBEJbdQhcrSRhdHtWr7xazIquT55un3GDm00UtqKjLfcP6e5ZK4GjjTbuBIuiLZaxbhU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778608165; c=relaxed/simple;
	bh=/VaqD2NcPVmlTIba4tR6oSQlc15W+HOFadGsnqKAR7M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VRoZjisp6Sn6ZqNm/V9a2LakMQwDQCFopsUB42z71DPtmM11OIHS+YNFEs4gJuorOatz93+qm+I2FqsYULJZnurxO8LfEyxJF6chj5LbVPWvdpi4HC1uhX4SXYI/sru9asl6NoY/9gB21EvP3zFtrG77Wn/WehYebhhBw365+V8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aC03QF1i; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aC03QF1i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDA7DC2BCB0;
	Tue, 12 May 2026 17:49:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778608165;
	bh=/VaqD2NcPVmlTIba4tR6oSQlc15W+HOFadGsnqKAR7M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aC03QF1iOdGYAk+zv0OuOmIHtsSgdlCOLycvyotbtAD2O0/fY9IBEOKEbW5ElNiXs
	 fHE2MqSThi5hfoorALs/b0VLrkKsARLKpSEexM67eKVvwb0eeG8G7LxKeN0OyT20i1
	 ZDTtTdyZje2OxL7Uj9DLbk2NryEbSDKJviBvWysQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Helge Deller <deller@gmx.de>,
	linux-fbdev@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 179/206] fbdev: defio: Disconnect deferred I/O from the lifetime of struct fb_info
Date: Tue, 12 May 2026 19:40:31 +0200
Message-ID: <20260512173936.650816671@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173932.810559588@linuxfoundation.org>
References: <20260512173932.810559588@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Zimmermann <tzimmermann@suse.de>

[ Upstream commit 9ded47ad003f09a94b6a710b5c47f4aa5ceb7429 ]

Hold state of deferred I/O in struct fb_deferred_io_state. Allocate an
instance as part of initializing deferred I/O and remove it only after
the final mapping has been closed. If the fb_info and the contained
deferred I/O meanwhile goes away, clear struct fb_deferred_io_state.info
to invalidate the mapping. Any access will then result in a SIGBUS
signal.

Fixes a long-standing problem, where a device hot-unplug happens while
user space still has an active mapping of the graphics memory. The hot-
unplug frees the instance of struct fb_info. Accessing the memory will
operate on undefined state.

Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
Fixes: 60b59beafba8 ("fbdev: mm: Deferred IO support")
Cc: Helge Deller <deller@gmx.de>
Cc: linux-fbdev@vger.kernel.org
Cc: dri-devel@lists.freedesktop.org
Cc: stable@vger.kernel.org # v2.6.22+
Signed-off-by: Helge Deller <deller@gmx.de>
[ replaced `kzalloc_obj()` with `kzalloc(sizeof(*fbdefio_state), GFP_KERNEL)` ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/video/fbdev/core/fb_defio.c |  179 ++++++++++++++++++++++++++++--------
 include/linux/fb.h                  |    4 
 2 files changed, 145 insertions(+), 38 deletions(-)

--- a/drivers/video/fbdev/core/fb_defio.c
+++ b/drivers/video/fbdev/core/fb_defio.c
@@ -23,6 +23,75 @@
 #include <linux/rmap.h>
 #include <linux/pagemap.h>
 
+/*
+ * struct fb_deferred_io_state
+ */
+
+struct fb_deferred_io_state {
+	struct kref ref;
+
+	struct mutex lock; /* mutex that protects the pageref list */
+	/* fields protected by lock */
+	struct fb_info *info;
+};
+
+static struct fb_deferred_io_state *fb_deferred_io_state_alloc(void)
+{
+	struct fb_deferred_io_state *fbdefio_state;
+
+	fbdefio_state = kzalloc(sizeof(*fbdefio_state), GFP_KERNEL);
+	if (!fbdefio_state)
+		return NULL;
+
+	kref_init(&fbdefio_state->ref);
+	mutex_init(&fbdefio_state->lock);
+
+	return fbdefio_state;
+}
+
+static void fb_deferred_io_state_release(struct fb_deferred_io_state *fbdefio_state)
+{
+	mutex_destroy(&fbdefio_state->lock);
+
+	kfree(fbdefio_state);
+}
+
+static void fb_deferred_io_state_get(struct fb_deferred_io_state *fbdefio_state)
+{
+	kref_get(&fbdefio_state->ref);
+}
+
+static void __fb_deferred_io_state_release(struct kref *ref)
+{
+	struct fb_deferred_io_state *fbdefio_state =
+		container_of(ref, struct fb_deferred_io_state, ref);
+
+	fb_deferred_io_state_release(fbdefio_state);
+}
+
+static void fb_deferred_io_state_put(struct fb_deferred_io_state *fbdefio_state)
+{
+	kref_put(&fbdefio_state->ref, __fb_deferred_io_state_release);
+}
+
+/*
+ * struct vm_operations_struct
+ */
+
+static void fb_deferred_io_vm_open(struct vm_area_struct *vma)
+{
+	struct fb_deferred_io_state *fbdefio_state = vma->vm_private_data;
+
+	fb_deferred_io_state_get(fbdefio_state);
+}
+
+static void fb_deferred_io_vm_close(struct vm_area_struct *vma)
+{
+	struct fb_deferred_io_state *fbdefio_state = vma->vm_private_data;
+
+	fb_deferred_io_state_put(fbdefio_state);
+}
+
 static struct page *fb_deferred_io_get_page(struct fb_info *info, unsigned long offs)
 {
 	struct fb_deferred_io *fbdefio = info->fbdefio;
@@ -128,17 +197,31 @@ static void fb_deferred_io_pageref_put(s
 /* this is to find and return the vmalloc-ed fb pages */
 static vm_fault_t fb_deferred_io_fault(struct vm_fault *vmf)
 {
+	struct fb_info *info;
 	unsigned long offset;
 	struct page *page;
-	struct fb_info *info = vmf->vma->vm_private_data;
+	vm_fault_t ret;
+	struct fb_deferred_io_state *fbdefio_state = vmf->vma->vm_private_data;
+
+	mutex_lock(&fbdefio_state->lock);
+
+	info = fbdefio_state->info;
+	if (!info) {
+		ret = VM_FAULT_SIGBUS; /* our device is gone */
+		goto err_mutex_unlock;
+	}
 
 	offset = vmf->pgoff << PAGE_SHIFT;
-	if (offset >= info->fix.smem_len)
-		return VM_FAULT_SIGBUS;
+	if (offset >= info->fix.smem_len) {
+		ret = VM_FAULT_SIGBUS;
+		goto err_mutex_unlock;
+	}
 
 	page = fb_deferred_io_get_page(info, offset);
-	if (!page)
-		return VM_FAULT_SIGBUS;
+	if (!page) {
+		ret = VM_FAULT_SIGBUS;
+		goto err_mutex_unlock;
+	}
 
 	if (vmf->vma->vm_file)
 		page->mapping = vmf->vma->vm_file->f_mapping;
@@ -148,8 +231,15 @@ static vm_fault_t fb_deferred_io_fault(s
 	BUG_ON(!page->mapping);
 	page->index = vmf->pgoff; /* for folio_mkclean() */
 
+	mutex_unlock(&fbdefio_state->lock);
+
 	vmf->page = page;
+
 	return 0;
+
+err_mutex_unlock:
+	mutex_unlock(&fbdefio_state->lock);
+	return ret;
 }
 
 int fb_deferred_io_fsync(struct file *file, loff_t start, loff_t end, int datasync)
@@ -176,15 +266,24 @@ EXPORT_SYMBOL_GPL(fb_deferred_io_fsync);
  * Adds a page to the dirty list. Call this from struct
  * vm_operations_struct.page_mkwrite.
  */
-static vm_fault_t fb_deferred_io_track_page(struct fb_info *info, unsigned long offset,
-					    struct page *page)
+static vm_fault_t fb_deferred_io_track_page(struct fb_deferred_io_state *fbdefio_state,
+					    unsigned long offset, struct page *page)
 {
-	struct fb_deferred_io *fbdefio = info->fbdefio;
+	struct fb_info *info;
+	struct fb_deferred_io *fbdefio;
 	struct fb_deferred_io_pageref *pageref;
 	vm_fault_t ret;
 
 	/* protect against the workqueue changing the page list */
-	mutex_lock(&fbdefio->lock);
+	mutex_lock(&fbdefio_state->lock);
+
+	info = fbdefio_state->info;
+	if (!info) {
+		ret = VM_FAULT_SIGBUS; /* our device is gone */
+		goto err_mutex_unlock;
+	}
+
+	fbdefio = info->fbdefio;
 
 	pageref = fb_deferred_io_pageref_get(info, offset, page);
 	if (WARN_ON_ONCE(!pageref)) {
@@ -202,50 +301,38 @@ static vm_fault_t fb_deferred_io_track_p
 	 */
 	lock_page(pageref->page);
 
-	mutex_unlock(&fbdefio->lock);
+	mutex_unlock(&fbdefio_state->lock);
 
 	/* come back after delay to process the deferred IO */
 	schedule_delayed_work(&info->deferred_work, fbdefio->delay);
 	return VM_FAULT_LOCKED;
 
 err_mutex_unlock:
-	mutex_unlock(&fbdefio->lock);
+	mutex_unlock(&fbdefio_state->lock);
 	return ret;
 }
 
-/*
- * fb_deferred_io_page_mkwrite - Mark a page as written for deferred I/O
- * @fb_info: The fbdev info structure
- * @vmf: The VM fault
- *
- * This is a callback we get when userspace first tries to
- * write to the page. We schedule a workqueue. That workqueue
- * will eventually mkclean the touched pages and execute the
- * deferred framebuffer IO. Then if userspace touches a page
- * again, we repeat the same scheme.
- *
- * Returns:
- * VM_FAULT_LOCKED on success, or a VM_FAULT error otherwise.
- */
-static vm_fault_t fb_deferred_io_page_mkwrite(struct fb_info *info, struct vm_fault *vmf)
+static vm_fault_t fb_deferred_io_page_mkwrite(struct fb_deferred_io_state *fbdefio_state,
+					      struct vm_fault *vmf)
 {
 	unsigned long offset = vmf->pgoff << PAGE_SHIFT;
 	struct page *page = vmf->page;
 
 	file_update_time(vmf->vma->vm_file);
 
-	return fb_deferred_io_track_page(info, offset, page);
+	return fb_deferred_io_track_page(fbdefio_state, offset, page);
 }
 
-/* vm_ops->page_mkwrite handler */
 static vm_fault_t fb_deferred_io_mkwrite(struct vm_fault *vmf)
 {
-	struct fb_info *info = vmf->vma->vm_private_data;
+	struct fb_deferred_io_state *fbdefio_state = vmf->vma->vm_private_data;
 
-	return fb_deferred_io_page_mkwrite(info, vmf);
+	return fb_deferred_io_page_mkwrite(fbdefio_state, vmf);
 }
 
 static const struct vm_operations_struct fb_deferred_io_vm_ops = {
+	.open		= fb_deferred_io_vm_open,
+	.close		= fb_deferred_io_vm_close,
 	.fault		= fb_deferred_io_fault,
 	.page_mkwrite	= fb_deferred_io_mkwrite,
 };
@@ -262,7 +349,10 @@ int fb_deferred_io_mmap(struct fb_info *
 	vm_flags_set(vma, VM_DONTEXPAND | VM_DONTDUMP);
 	if (!(info->flags & FBINFO_VIRTFB))
 		vm_flags_set(vma, VM_IO);
-	vma->vm_private_data = info;
+	vma->vm_private_data = info->fbdefio_state;
+
+	fb_deferred_io_state_get(info->fbdefio_state); /* released in vma->vm_ops->close() */
+
 	return 0;
 }
 EXPORT_SYMBOL_GPL(fb_deferred_io_mmap);
@@ -273,9 +363,10 @@ static void fb_deferred_io_work(struct w
 	struct fb_info *info = container_of(work, struct fb_info, deferred_work.work);
 	struct fb_deferred_io_pageref *pageref, *next;
 	struct fb_deferred_io *fbdefio = info->fbdefio;
+	struct fb_deferred_io_state *fbdefio_state = info->fbdefio_state;
 
 	/* here we mkclean the pages, then do all deferred IO */
-	mutex_lock(&fbdefio->lock);
+	mutex_lock(&fbdefio_state->lock);
 	list_for_each_entry(pageref, &fbdefio->pagereflist, list) {
 		struct folio *folio = page_folio(pageref->page);
 
@@ -291,12 +382,13 @@ static void fb_deferred_io_work(struct w
 	list_for_each_entry_safe(pageref, next, &fbdefio->pagereflist, list)
 		fb_deferred_io_pageref_put(pageref, info);
 
-	mutex_unlock(&fbdefio->lock);
+	mutex_unlock(&fbdefio_state->lock);
 }
 
 int fb_deferred_io_init(struct fb_info *info)
 {
 	struct fb_deferred_io *fbdefio = info->fbdefio;
+	struct fb_deferred_io_state *fbdefio_state;
 	struct fb_deferred_io_pageref *pagerefs;
 	unsigned long npagerefs;
 	int ret;
@@ -306,7 +398,11 @@ int fb_deferred_io_init(struct fb_info *
 	if (WARN_ON(!info->fix.smem_len))
 		return -EINVAL;
 
-	mutex_init(&fbdefio->lock);
+	fbdefio_state = fb_deferred_io_state_alloc();
+	if (!fbdefio_state)
+		return -ENOMEM;
+	fbdefio_state->info = info;
+
 	INIT_DELAYED_WORK(&info->deferred_work, fb_deferred_io_work);
 	INIT_LIST_HEAD(&fbdefio->pagereflist);
 	if (fbdefio->delay == 0) /* set a default of 1 s */
@@ -323,10 +419,12 @@ int fb_deferred_io_init(struct fb_info *
 	info->npagerefs = npagerefs;
 	info->pagerefs = pagerefs;
 
+	info->fbdefio_state = fbdefio_state;
+
 	return 0;
 
 err:
-	mutex_destroy(&fbdefio->lock);
+	fb_deferred_io_state_release(fbdefio_state);
 	return ret;
 }
 EXPORT_SYMBOL_GPL(fb_deferred_io_init);
@@ -364,11 +462,18 @@ EXPORT_SYMBOL_GPL(fb_deferred_io_release
 
 void fb_deferred_io_cleanup(struct fb_info *info)
 {
-	struct fb_deferred_io *fbdefio = info->fbdefio;
+	struct fb_deferred_io_state *fbdefio_state = info->fbdefio_state;
 
 	fb_deferred_io_lastclose(info);
 
+	info->fbdefio_state = NULL;
+
+	mutex_lock(&fbdefio_state->lock);
+	fbdefio_state->info = NULL;
+	mutex_unlock(&fbdefio_state->lock);
+
+	fb_deferred_io_state_put(fbdefio_state);
+
 	kvfree(info->pagerefs);
-	mutex_destroy(&fbdefio->lock);
 }
 EXPORT_SYMBOL_GPL(fb_deferred_io_cleanup);
--- a/include/linux/fb.h
+++ b/include/linux/fb.h
@@ -222,12 +222,13 @@ struct fb_deferred_io {
 	unsigned long delay;
 	bool sort_pagereflist; /* sort pagelist by offset */
 	int open_count; /* number of opened files; protected by fb_info lock */
-	struct mutex lock; /* mutex that protects the pageref list */
 	struct list_head pagereflist; /* list of pagerefs for touched pages */
 	/* callback */
 	struct page *(*get_page)(struct fb_info *info, unsigned long offset);
 	void (*deferred_io)(struct fb_info *info, struct list_head *pagelist);
 };
+
+struct fb_deferred_io_state;
 #endif
 
 /*
@@ -485,6 +486,7 @@ struct fb_info {
 	unsigned long npagerefs;
 	struct fb_deferred_io_pageref *pagerefs;
 	struct fb_deferred_io *fbdefio;
+	struct fb_deferred_io_state *fbdefio_state;
 #endif
 
 	const struct fb_ops *fbops;


