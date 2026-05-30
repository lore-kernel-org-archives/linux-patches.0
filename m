Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AD3132BF24;
	Sat, 30 May 2026 16:57:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780160235; cv=none; b=SrLLMZsvxzEH0fOpOXP84ZFOULAWHDaqJiLpFIrfC05QOZ8+wUaFFf0ZJT2kmlxUPz7rKc0cTyAzsGpgCl+ifQqRv67eZ5VOmfLzQS9XJRMKBLJvoDWMAfn78/2cqhez6PhTG0Z9Z5eIe7U9oG9SMTs9C5F5Pt4WJBhWFzzJqHk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780160235; c=relaxed/simple;
	bh=MG5jG0+zo0cCFfqrDIt77myETbOkdNAORf3bEfoYSYk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pRJdHbJSF5cEImzOEITrcwz+h5tXOj0O1LnkqDqTf35BIjyqmKLObPhAKSeEQ4UnZvi4x6Zu4J9qk4mnJKynZrGYgokf13gjNFG4Hlal1veHnoZYKWajpRPWA+zWoebl4HgUmmOTbfuG+lNT74+shhhYdkWTOIKrVOrzpa0QXtI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nWnUwW7j; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nWnUwW7j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90D161F00893;
	Sat, 30 May 2026 16:57:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780160234;
	bh=whWWNG7L8gUt5sI0btk/FjFmgAfjKf67HZ4KjOLPT4E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nWnUwW7jsj5PNenC0X4b6UteecngvRfOauzQygwFP3IuKQj6McXnNLHoPE766iw0p
	 Ox/7JGK1Y9JluerUChJCW+MtCNczXlzbuRRR736h1C8Mf8up9c0WqAaLyvooBjmUbm
	 tQVrex4tlRehO/lwGtQqIMOKtmh2vh7xz7uZFUls=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rajat Gupta <rajgupt@qti.qualcomm.com>,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 6.1 283/969] fbdev: udlfb: add vm_ops to dlfb_ops_mmap to prevent use-after-free
Date: Sat, 30 May 2026 17:56:47 +0200
Message-ID: <20260530160308.280953007@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rajat Gupta <rajgupt@qti.qualcomm.com>

commit 8de779dc40d35d39fa07387b6f921eb11df0f511 upstream.

dlfb_ops_mmap() uses remap_pfn_range() to map vmalloc framebuffer pages
to userspace but sets no vm_ops on the VMA. This means the kernel cannot
track active mmaps. When dlfb_realloc_framebuffer() replaces the backing
buffer via FBIOPUT_VSCREENINFO, existing mmap PTEs are not invalidated.
On USB disconnect, dlfb_ops_destroy() calls vfree() on the old pages
while userspace PTEs still reference them, resulting in a use-after-free:
the process retains read/write access to freed kernel pages.

Add vm_operations_struct with open/close callbacks that maintain an
atomic mmap_count on struct dlfb_data. In dlfb_realloc_framebuffer(),
check mmap_count and return -EBUSY if the buffer is currently mapped,
preventing buffer replacement while userspace holds stale PTEs.

Tested with PoC using dummy_hcd + raw_gadget USB device emulation.

Signed-off-by: Rajat Gupta <rajgupt@qti.qualcomm.com>
Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/video/fbdev/udlfb.c |   31 ++++++++++++++++++++++++++++++-
 include/video/udlfb.h       |    1 +
 2 files changed, 31 insertions(+), 1 deletion(-)

--- a/drivers/video/fbdev/udlfb.c
+++ b/drivers/video/fbdev/udlfb.c
@@ -321,12 +321,32 @@ static int dlfb_set_video_mode(struct dl
 	return retval;
 }
 
+static void dlfb_vm_open(struct vm_area_struct *vma)
+{
+	struct dlfb_data *dlfb = vma->vm_private_data;
+
+	atomic_inc(&dlfb->mmap_count);
+}
+
+static void dlfb_vm_close(struct vm_area_struct *vma)
+{
+	struct dlfb_data *dlfb = vma->vm_private_data;
+
+	atomic_dec(&dlfb->mmap_count);
+}
+
+static const struct vm_operations_struct dlfb_vm_ops = {
+	.open  = dlfb_vm_open,
+	.close = dlfb_vm_close,
+};
+
 static int dlfb_ops_mmap(struct fb_info *info, struct vm_area_struct *vma)
 {
 	unsigned long start = vma->vm_start;
 	unsigned long size = vma->vm_end - vma->vm_start;
 	unsigned long offset = vma->vm_pgoff << PAGE_SHIFT;
 	unsigned long page, pos;
+	struct dlfb_data *dlfb = info->par;
 
 	if (info->fbdefio)
 		return fb_deferred_io_mmap(info, vma);
@@ -356,6 +376,9 @@ static int dlfb_ops_mmap(struct fb_info
 			size = 0;
 	}
 
+	vma->vm_ops = &dlfb_vm_ops;
+	vma->vm_private_data = dlfb;
+	atomic_inc(&dlfb->mmap_count);
 	return 0;
 }
 
@@ -1219,7 +1242,6 @@ static void dlfb_deferred_vfree(struct d
 
 /*
  * Assumes &info->lock held by caller
- * Assumes no active clients have framebuffer open
  */
 static int dlfb_realloc_framebuffer(struct dlfb_data *dlfb, struct fb_info *info, u32 new_len)
 {
@@ -1231,6 +1253,13 @@ static int dlfb_realloc_framebuffer(stru
 	new_len = PAGE_ALIGN(new_len);
 
 	if (new_len > old_len) {
+		if (atomic_read(&dlfb->mmap_count) > 0) {
+			dev_warn(info->dev,
+				"refusing realloc: %d active mmaps\n",
+				atomic_read(&dlfb->mmap_count));
+			return -EBUSY;
+		}
+
 		/*
 		 * Alloc system memory for virtual framebuffer
 		 */
--- a/include/video/udlfb.h
+++ b/include/video/udlfb.h
@@ -56,6 +56,7 @@ struct dlfb_data {
 	spinlock_t damage_lock;
 	struct work_struct damage_work;
 	struct fb_ops ops;
+	atomic_t mmap_count;
 	/* blit-only rendering path metrics, exposed through sysfs */
 	atomic_t bytes_rendered; /* raw pixel-bytes driver asked to render */
 	atomic_t bytes_identical; /* saved effort with backbuffer comparison */


