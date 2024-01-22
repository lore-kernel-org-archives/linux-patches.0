Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2DF350272;
	Tue, 23 Jan 2024 00:08:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705968506; cv=none; b=l6QIMyWuwn+KFbn6FOfsURkozi5p77hwGR/ovV/tZTNKIDCCTVfgwx/WegYu/SElPLVohUBwLr+a8znMYpH3VNoyO76gFFEG2XfL2rUHHRz+dgn5CQWzXz8tV2x1P+nZp7/MT2tkexhwUTBOJHDfgvsU+rLchQLfg9ynypYlhvc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705968506; c=relaxed/simple;
	bh=n6qFvWMRGRYRdQ7EGNy6hN3U60KDgMgmY6MTeBlMy0k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R5hkqfG9qAHJZVeMKKNWEjSebtYdKPSxfwy3hGa5LfoXAMSsFvAJP6W9SJxUraMz/vhAS215oHJk7IQbGBft4oj8nA2PWZzCAV+8AZAPQTlxEeCtknaC0VMVZyR1ex2YYUswVVSi3VQXcrq0lSpfqnVaZUlF+1ZvVJ6DGWiEy5E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FdAvkHzm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FdAvkHzm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7CFBC433F1;
	Tue, 23 Jan 2024 00:08:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705968506;
	bh=n6qFvWMRGRYRdQ7EGNy6hN3U60KDgMgmY6MTeBlMy0k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FdAvkHzmmP1D1X0sIIUv6YO5i3DaQY0DKlap8/msws7bFMTz8tFEV7I2+q0hm5bjc
	 7SJa+kTB6QrArrLgmCSJr2TCa0zPfqLspvO6xdGK+rRa9lgFKXC0kTHPITJzcaZhgS
	 o/arStFb9prbRoVoWo0BML384AYfM8SCj7d5I+rE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gui-Dong Han <2045gemini@gmail.com>
Subject: [PATCH 4.19 126/148] usb: mon: Fix atomicity violation in mon_bin_vma_fault
Date: Mon, 22 Jan 2024 15:58:02 -0800
Message-ID: <20240122235717.624116259@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235712.442097787@linuxfoundation.org>
References: <20240122235712.442097787@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gui-Dong Han <2045gemini@gmail.com>

commit 2dd23cc4d0e6aa55cf9fb3b05f2f4165b01de81c upstream.

In mon_bin_vma_fault():
    offset = vmf->pgoff << PAGE_SHIFT;
    if (offset >= rp->b_size)
        return VM_FAULT_SIGBUS;
    chunk_idx = offset / CHUNK_SIZE;
    pageptr = rp->b_vec[chunk_idx].pg;
The code is executed without holding any lock.

In mon_bin_vma_close():
    spin_lock_irqsave(&rp->b_lock, flags);
    rp->mmap_active--;
    spin_unlock_irqrestore(&rp->b_lock, flags);

In mon_bin_ioctl():
    spin_lock_irqsave(&rp->b_lock, flags);
    if (rp->mmap_active) {
        ...
    } else {
        ...
        kfree(rp->b_vec);
        rp->b_vec  = vec;
        rp->b_size = size;
        ...
    }
    spin_unlock_irqrestore(&rp->b_lock, flags);

Concurrent execution of mon_bin_vma_fault() with mon_bin_vma_close() and
mon_bin_ioctl() could lead to atomicity violations. mon_bin_vma_fault()
accesses rp->b_size and rp->b_vec without locking, risking array
out-of-bounds access or use-after-free bugs due to possible modifications
in mon_bin_ioctl().

This possible bug is found by an experimental static analysis tool
developed by our team, BassCheck[1]. This tool analyzes the locking APIs
to extract function pairs that can be concurrently executed, and then
analyzes the instructions in the paired functions to identify possible
concurrency bugs including data races and atomicity violations. The above
possible bug is reported when our tool analyzes the source code of
Linux 6.2.

To address this issue, it is proposed to add a spin lock pair in
mon_bin_vma_fault() to ensure atomicity. With this patch applied, our tool
never reports the possible bug, with the kernel configuration allyesconfig
for x86_64. Due to the lack of associated hardware, we cannot test the
patch in runtime testing, and just verify it according to the code logic.

[1] https://sites.google.com/view/basscheck/

Fixes: 19e6317d24c2 ("usb: mon: Fix a deadlock in usbmon between ...")
Cc:  <stable@vger.kernel.org>
Signed-off-by: Gui-Dong Han <2045gemini@gmail.com>
Link: https://lore.kernel.org/r/20240105052412.9377-1-2045gemini@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/mon/mon_bin.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/drivers/usb/mon/mon_bin.c
+++ b/drivers/usb/mon/mon_bin.c
@@ -1247,14 +1247,19 @@ static vm_fault_t mon_bin_vma_fault(stru
 	struct mon_reader_bin *rp = vmf->vma->vm_private_data;
 	unsigned long offset, chunk_idx;
 	struct page *pageptr;
+	unsigned long flags;
 
+	spin_lock_irqsave(&rp->b_lock, flags);
 	offset = vmf->pgoff << PAGE_SHIFT;
-	if (offset >= rp->b_size)
+	if (offset >= rp->b_size) {
+		spin_unlock_irqrestore(&rp->b_lock, flags);
 		return VM_FAULT_SIGBUS;
+	}
 	chunk_idx = offset / CHUNK_SIZE;
 	pageptr = rp->b_vec[chunk_idx].pg;
 	get_page(pageptr);
 	vmf->page = pageptr;
+	spin_unlock_irqrestore(&rp->b_lock, flags);
 	return 0;
 }
 


