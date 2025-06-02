Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03A5B22A808;
	Mon,  2 Jun 2025 15:14:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748877299; cv=none; b=lvFJxUo4tCT5CYdIZQjHIqrujGd+pP9YdoMQRlqmpSyINkoFlg1VowfLL/vUS2pyhVR3fCfIJ1/ERk2liqZODeei1cMsWELCQEO3swDjbhHoEw5LDzqFShjee9+c9Zt8n6DkBpmNuvenG0zNPOjE+vLlCE4OjV5RkzQGhUoZssU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748877299; c=relaxed/simple;
	bh=eKBMNlLk2GhqeK4T+JkVtprvbiqTAj4s0LknRFo7+S8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TG+3kivvKe9T9LNj4rn4yLfKBmCGWY6MLxgw3uZW79gjv/2jsipwa8dwsPAamwVztdsVt3ObrQWUTlMqeKwcg6A/NKxQVCrjSY/x7MZ4vc17UEFhvNA5vbaB7TGhpfziSz2LkWOpqpKkDlxR4+07LhT5Q3Xa2dW75pZiFCejEwQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cFwxwFha; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cFwxwFha"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 802B8C4CEEB;
	Mon,  2 Jun 2025 15:14:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748877298;
	bh=eKBMNlLk2GhqeK4T+JkVtprvbiqTAj4s0LknRFo7+S8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cFwxwFha/pyscc12b8ALQIEOJpqD4if+gCkF7/NwwYYuJHlHi8PrMqLvnDGVi28r9
	 9cyGHApAFSi2glJp+brg4avPt2VRtLO8yT0kaW6LAkZKANnmaudFU7IvAr4+5+r4+8
	 IL0VOn2CicD3NQn7sIbFTZVV/lKgjO51wCgLRPKI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vinicius Costa Gomes <vinicius.gomes@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 233/325] dmaengine: idxd: Fix allowing write() from different address spaces
Date: Mon,  2 Jun 2025 15:48:29 +0200
Message-ID: <20250602134329.251132440@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134319.723650984@linuxfoundation.org>
References: <20250602134319.723650984@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index c7aa47f01df02..186f005bfa8fd 100644
--- a/drivers/dma/idxd/cdev.c
+++ b/drivers/dma/idxd/cdev.c
@@ -240,6 +240,9 @@ static int idxd_cdev_mmap(struct file *filp, struct vm_area_struct *vma)
 	if (!idxd->user_submission_safe && !capable(CAP_SYS_RAWIO))
 		return -EPERM;
 
+	if (current->mm != ctx->mm)
+		return -EPERM;
+
 	rc = check_vma(wq, vma, __func__);
 	if (rc < 0)
 		return rc;
@@ -306,6 +309,9 @@ static ssize_t idxd_cdev_write(struct file *filp, const char __user *buf, size_t
 	ssize_t written = 0;
 	int i;
 
+	if (current->mm != ctx->mm)
+		return -EPERM;
+
 	for (i = 0; i < len/sizeof(struct dsa_hw_desc); i++) {
 		int rc = idxd_submit_user_descriptor(ctx, udesc + i);
 
@@ -326,6 +332,9 @@ static __poll_t idxd_cdev_poll(struct file *filp,
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



