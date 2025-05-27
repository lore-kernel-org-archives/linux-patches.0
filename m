Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 279AB194A45;
	Tue, 27 May 2025 17:52:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748368369; cv=none; b=SVGRgYOd0D/jHpx6lckHag6FaxNLeHyGXgL4gDiq7WQNc52wfYZCpiwCEsr5tvE3ZCI1KViOUJptkD8/yM9meOGNe3sUcyrwmoiFTXoaYdJFu8/1lFfzNNmQ83PPwFM32v7E3BqnnKbsviCWdkCZ+PENsldPvFrfF+T3AfdoAZc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748368369; c=relaxed/simple;
	bh=yxVyo+iBytK6Dy0nvFTYioU1kkSJwkooYQU7JsxmZ5Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C2dpXXVpzqcdEXMSubgErnzSYe+ou0nk20NMNlG3djgpMmEd9wWsRZpzq/pu8b+LzeRvrzgD4NiKyP6OnNC9KFIYqZJ0X+SgyezwjURUEtpGj9VQSh80qADSvo5oymBCSwj6VLZgBpp5NB+T44o4/iuxMAPT/be1gnQk/roPnQM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GiB1+1Qx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GiB1+1Qx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2855C4CEE9;
	Tue, 27 May 2025 17:52:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748368369;
	bh=yxVyo+iBytK6Dy0nvFTYioU1kkSJwkooYQU7JsxmZ5Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GiB1+1QxqCJu+U3cpvRG4VynfS3jgeNyK7EocUyGTtjk3vdKJI5fPrW66OkN4xOhY
	 h8K4W7Zfw1v4zhTSdbDD9h4x4o/P+kCXvr5TUUhlYeeW7zjAbkHHV9uejXfth1xjR8
	 UvhuN0NfbwF23V0X+msbhzC0/QZJdB0yWNYQbZIg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vinicius Costa Gomes <vinicius.gomes@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 685/783] dmaengine: idxd: Fix allowing write() from different address spaces
Date: Tue, 27 May 2025 18:28:02 +0200
Message-ID: <20250527162541.025823287@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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
index ff94ee892339d..b847b74949f19 100644
--- a/drivers/dma/idxd/cdev.c
+++ b/drivers/dma/idxd/cdev.c
@@ -407,6 +407,9 @@ static int idxd_cdev_mmap(struct file *filp, struct vm_area_struct *vma)
 	if (!idxd->user_submission_safe && !capable(CAP_SYS_RAWIO))
 		return -EPERM;
 
+	if (current->mm != ctx->mm)
+		return -EPERM;
+
 	rc = check_vma(wq, vma, __func__);
 	if (rc < 0)
 		return rc;
@@ -473,6 +476,9 @@ static ssize_t idxd_cdev_write(struct file *filp, const char __user *buf, size_t
 	ssize_t written = 0;
 	int i;
 
+	if (current->mm != ctx->mm)
+		return -EPERM;
+
 	for (i = 0; i < len/sizeof(struct dsa_hw_desc); i++) {
 		int rc = idxd_submit_user_descriptor(ctx, udesc + i);
 
@@ -493,6 +499,9 @@ static __poll_t idxd_cdev_poll(struct file *filp,
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



