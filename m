Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64EB212C48B;
	Tue, 30 Apr 2024 10:55:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714474545; cv=none; b=dQ6A5IzVCJE+L5R7Lu78QnbIjc8NvlgGlyHgT6KxNiWMFNmIs8QtA/GDG1DPZw6y0LHRQz0RAg8CUa4B9HmIrZBn09jBju55iUaTQPYLIQNKM0Qil/mAcGzuWe1WKo2BmdngHSgZ/qfXG56UhmihRK9IYWi2kcbCZvaQTFdyxm0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714474545; c=relaxed/simple;
	bh=lmiHvjrgeVIPx4Ek4xwMlDrv60K3tTt9jNRz+Pz2Dj8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=luo5TBSXZc8tIKEGZwVk/NL4eViWXUI6lL01rCieeRX53jA4AeuUYm5Yf5jmjzXmRYf79jvlJsOESqD2mFvTQy5/vxeHTrwfl5UJMLSgqDqkL/FoMEW214LFQ7quuU8ixqClk4TfeJMeb+41qWALfG66Ik+FlqW9Xr+G4+Xmtxs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qg2sYsBh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qg2sYsBh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3320C2BBFC;
	Tue, 30 Apr 2024 10:55:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714474545;
	bh=lmiHvjrgeVIPx4Ek4xwMlDrv60K3tTt9jNRz+Pz2Dj8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qg2sYsBh9F0gjLFYJhRePZuZd4/pw/yu/LQCZaSiS+6goOvZfnyoc+In7M98gW+XB
	 LPuOuAa0aJH0qiOqbNPmhGKS4KFaN3S39fJ5cg8POP14nUd6T854BYrOXbTCfXTub6
	 hNbWCXn59vz+HYj4W7yq4/P2znLP/qq/L0yKzrm4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>,
	Nam Cao <namcao@linutronix.de>,
	Thomas Zimmermann <tzimmermann@suse.de>
Subject: [PATCH 6.8 191/228] fbdev: fix incorrect address computation in deferred IO
Date: Tue, 30 Apr 2024 12:39:29 +0200
Message-ID: <20240430103109.311633104@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103103.806426847@linuxfoundation.org>
References: <20240430103103.806426847@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nam Cao <namcao@linutronix.de>

commit 78d9161d2bcd442d93d917339297ffa057dbee8c upstream.

With deferred IO enabled, a page fault happens when data is written to the
framebuffer device. Then driver determines which page is being updated by
calculating the offset of the written virtual address within the virtual
memory area, and uses this offset to get the updated page within the
internal buffer. This page is later copied to hardware (thus the name
"deferred IO").

This offset calculation is only correct if the virtual memory area is
mapped to the beginning of the internal buffer. Otherwise this is wrong.
For example, if users do:
    mmap(ptr, 4096, PROT_WRITE, MAP_FIXED | MAP_SHARED, fd, 0xff000);

Then the virtual memory area will mapped at offset 0xff000 within the
internal buffer. This offset 0xff000 is not accounted for, and wrong page
is updated.

Correct the calculation by using vmf->pgoff instead. With this change, the
variable "offset" will no longer hold the exact offset value, but it is
rounded down to multiples of PAGE_SIZE. But this is still correct, because
this variable is only used to calculate the page offset.

Reported-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Closes: https://lore.kernel.org/linux-fbdev/271372d6-e665-4e7f-b088-dee5f4ab341a@oracle.com
Fixes: 56c134f7f1b5 ("fbdev: Track deferred-I/O pages in pageref struct")
Cc: <stable@vger.kernel.org>
Signed-off-by: Nam Cao <namcao@linutronix.de>
Reviewed-by: Thomas Zimmermann <tzimmermann@suse.de>
Tested-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
Link: https://patchwork.freedesktop.org/patch/msgid/20240423115053.4490-1-namcao@linutronix.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/video/fbdev/core/fb_defio.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/video/fbdev/core/fb_defio.c
+++ b/drivers/video/fbdev/core/fb_defio.c
@@ -196,7 +196,7 @@ err_mutex_unlock:
  */
 static vm_fault_t fb_deferred_io_page_mkwrite(struct fb_info *info, struct vm_fault *vmf)
 {
-	unsigned long offset = vmf->address - vmf->vma->vm_start;
+	unsigned long offset = vmf->pgoff << PAGE_SHIFT;
 	struct page *page = vmf->page;
 
 	file_update_time(vmf->vma->vm_file);


