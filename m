Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F064367;
	Tue, 27 May 2025 17:12:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748365940; cv=none; b=L0YnzEAWmkbpeYyO08XJIBrcly36On2Dt3M8yIdw+jIRbcD+6SlBdmFwQTnmZBvyyTR/TuizFHSuCjNhjxmtKJYA/2pW3MY4Y5oQ9onRRWHf7EKkJWYqfRwpSXcZRjLVBOlzd2nGWu+uf+DEUyZ/hJezZXUKkUwsuRO6j2fD+t8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748365940; c=relaxed/simple;
	bh=kg7gBzgH8unAz6nkA9x3WowcJdZg9eliBVE/HdQMrRc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZJE0bcg4FBnGiXvvuWQ/8StgSPspgHuQVCCLfPRSH0Fb0bEmVdqxvlt5e1+xWSKm8YRIXDCa0qy65ElgCzMyW5TuzFgi946Vbyw+TA25Pw0f3qvM9xjoWAaVxb+tYvjYbM3nq5v17fr5383fil4F4W0RA/nDb8jS/xOdnR/BfAY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M+xVnPhv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M+xVnPhv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 124E5C4CEEB;
	Tue, 27 May 2025 17:12:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748365938;
	bh=kg7gBzgH8unAz6nkA9x3WowcJdZg9eliBVE/HdQMrRc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=M+xVnPhvCi8WiZNqUx3hFuTLUEmESHdi/x7T4aTzcL6wSEVU9I62qjDLWUzQfqwH8
	 f53KyfwIuK44n4+BEP/w61zQmHKvYG0nfxRoT96xpUihK/+x5CmUNucmhvYhhT74Ky
	 029xPbcK0WbdqegL8xSPloyjs25Z8VlpcECUHBi4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vinicius Costa Gomes <vinicius.gomes@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 538/626] dmaengine: idxd: Fix allowing write() from different address spaces
Date: Tue, 27 May 2025 18:27:11 +0200
Message-ID: <20250527162506.848140192@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162445.028718347@linuxfoundation.org>
References: <20250527162445.028718347@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Vinicius Costa Gomes <vinicius.gomes@intel.com>

[ Upstream commit 8dfa57aabff625bf445548257f7711ef294cd30e ]

Check if the process submitting the descriptor belongs to the same
address space as the one that opened the file, reject otherwise.

Fixes: 6827738dc684 ("dmaengine: idxd: add a write() method for applications to submit work")
Signed-off-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Link: https://lore.kernel.org/r/20250421170337.3008875-1-dave.jiang@intel.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/idxd/cdev.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/dma/idxd/cdev.c b/drivers/dma/idxd/cdev.c
index 57f1bf2ab20be..928b8ab8499a7 100644
--- a/drivers/dma/idxd/cdev.c
+++ b/drivers/dma/idxd/cdev.c
@@ -412,6 +412,9 @@ static int idxd_cdev_mmap(struct file *filp, struct vm_area_struct *vma)
 	if (!idxd->user_submission_safe && !capable(CAP_SYS_RAWIO))
 		return -EPERM;
 
+	if (current->mm != ctx->mm)
+		return -EPERM;
+
 	rc = check_vma(wq, vma, __func__);
 	if (rc < 0)
 		return rc;
@@ -478,6 +481,9 @@ static ssize_t idxd_cdev_write(struct file *filp, const char __user *buf, size_t
 	ssize_t written = 0;
 	int i;
 
+	if (current->mm != ctx->mm)
+		return -EPERM;
+
 	for (i = 0; i < len/sizeof(struct dsa_hw_desc); i++) {
 		int rc = idxd_submit_user_descriptor(ctx, udesc + i);
 
@@ -498,6 +504,9 @@ static __poll_t idxd_cdev_poll(struct file *filp,
 	struct idxd_device *idxd = wq->idxd;
 	__poll_t out = 0;
 
+	if (current->mm != ctx->mm)
+		return -EPERM;
+
 	poll_wait(filp, &wq->err_queue, wait);
 	spin_lock(&idxd->dev_lock);
 	if (idxd->sw_err.valid)
-- 
2.39.5



