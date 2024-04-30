Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE5EA12BF32;
	Tue, 30 Apr 2024 11:30:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714476618; cv=none; b=my226K3/jU40c2/NQ1RPEnMj7FB1qOdn2yOHFd+MgjR6P+SJ9zwP88jvpLjuFyWqugh9J3pEqFRahYni/t6a8YvclhKmMSamdsd5aKwkMAtx6qXypEekiK33dZS954wO0WF3TK4ycSozPxnNTonSBBTV+K0IhS+7dRvNvf2PXNU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714476618; c=relaxed/simple;
	bh=sWdRggoEmKWm0h+XORMGhtmBRLH92rlKF9zdwop/BvY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZIKafl+Rig9uUn/XcMFiIcYSE1MrAm57HoqQMe+aNBrBNrndG1obBYJ/6eWD58oqHfzH8sl8i+g7+2ViQNpaQvAPEv71N9d5gM6l+rHm7lG3fODa4nk9KxYHIKQ4+BW//Io1tuPTvR+wi0ZlETbxXToczOnkU5jbDiPq5BRMs6s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ptzb8T4P; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ptzb8T4P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 553FEC2BBFC;
	Tue, 30 Apr 2024 11:30:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714476618;
	bh=sWdRggoEmKWm0h+XORMGhtmBRLH92rlKF9zdwop/BvY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ptzb8T4Ps4f4ojREIvBtfLsxBBRiHqmvbqP0M2TsvZInbwFzoahTOohl77JwUkA4t
	 0PV8SBNmlpWlgSD3fFpMI2ZhFeaHp8gEaS6azKfE/KBpv8Q7MIwf/Ywx67v/A7rxaf
	 CaZvVeyKD4RmUp8DsRR89R10cWxOAdIf7V2V0Ot8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>,
	Nam Cao <namcao@linutronix.de>,
	Thomas Zimmermann <tzimmermann@suse.de>
Subject: [PATCH 6.1 087/110] fbdev: fix incorrect address computation in deferred IO
Date: Tue, 30 Apr 2024 12:40:56 +0200
Message-ID: <20240430103050.137245363@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103047.561802595@linuxfoundation.org>
References: <20240430103047.561802595@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -200,7 +200,7 @@ err_mutex_unlock:
  */
 static vm_fault_t fb_deferred_io_page_mkwrite(struct fb_info *info, struct vm_fault *vmf)
 {
-	unsigned long offset = vmf->address - vmf->vma->vm_start;
+	unsigned long offset = vmf->pgoff << PAGE_SHIFT;
 	struct page *page = vmf->page;
 
 	file_update_time(vmf->vma->vm_file);


