Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3A4512F5A8;
	Tue, 23 Jan 2024 00:16:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969006; cv=none; b=cBR+h5BJFxTMaC68T4756f46632nc9B21cMmJCPRxza8U+BzU4/9QpgHOdbFkPztWekGRYWvQro6amv7t19dbPV07a95fo9hEaUZmAvOcOAsoEDnTjmzDcLntWaVzrVhetnnMJGBGxSlm1aJhBadyqEAGFWWyxJWeI4w3CpXnlY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969006; c=relaxed/simple;
	bh=Wxm389+3akAEnu2gGjVKi+5h4oRMK+XXPGhTq0QMP30=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=axgSIACJmR7K+r2zsZssvOgLjM5hfRfWvSW0QGH6UEUDl2noEBk9X47ZUsW4kUcH7NsRSgAUM5BOQ/GdxAIp1dBsAUc1dlSxBW04kwGSy08zbdFrNZsxAO8JiYWOGq+UlMB+7Q/2XXTZ4wUX1xnlLkfqBPMHEbITJq/oEa4PQh4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VKo8DugM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VKo8DugM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36D04C433C7;
	Tue, 23 Jan 2024 00:16:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969005;
	bh=Wxm389+3akAEnu2gGjVKi+5h4oRMK+XXPGhTq0QMP30=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VKo8DugMUypF8ZOyjrbs2HJ7xYXG9U2YdhrJD/kISv8wGAc8bJDvZg/WDYJiISiTk
	 lFX1CWbgoCwR264j0kP+2CaQzukjQyin+GNSXIeVdLWrlkeRtvvcJIUqOJE+yI/fnm
	 i5UG0E1VeQW11+taYswwKIpLnrkb2sB67D8ARq9Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gui-Dong Han <2045gemini@gmail.com>
Subject: [PATCH 5.4 154/194] usb: mon: Fix atomicity violation in mon_bin_vma_fault
Date: Mon, 22 Jan 2024 15:58:04 -0800
Message-ID: <20240122235725.791822359@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235719.206965081@linuxfoundation.org>
References: <20240122235719.206965081@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
 


