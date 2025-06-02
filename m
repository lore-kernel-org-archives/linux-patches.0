Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F29C221CA07;
	Mon,  2 Jun 2025 14:20:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748874032; cv=none; b=dMIWa+SP/JBF6WlqBG2bVD4ry0nMcLB0W89+cNu0GGRlUUtgv6uHikhDJqOCjh1JvWCgBaSVF8Pinp6SFGwReutgIxKLyjhgZZSUbnVg0pwy09wCpsW4rDzkswAONggl1FmP4CSStM7HmgELkXe0LyEAK60QRhq70o2gRt5wW6s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748874032; c=relaxed/simple;
	bh=qQtNnzVCZrcXS0GmsUKQkEwAxzFsPggCoTWdcFKQgF8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YIGvw7tvvq/qqoQftbX8LJEkUR+/mYw7iqYTJaOfcdgNLsO1f0QtfDGhYVRW70tr7/wZFJo3o9URJYwR/SiaRs8+62KO6wO+kjW+HBpGiX9UvDX+dSPcZ9rbjjNphhp0YBvmNO7IE2UtTHTtkexfYC7JW+FvkDsypB/D5CLMAvQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=N5hD5pZF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N5hD5pZF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85745C4CEEB;
	Mon,  2 Jun 2025 14:20:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748874031;
	bh=qQtNnzVCZrcXS0GmsUKQkEwAxzFsPggCoTWdcFKQgF8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=N5hD5pZF5Ar7hHdaXmec4/GU2uHB96Frm+Ha6XDWhMCWP1to4FN4ZUCO3Rbyg7PH+
	 ZQEuV1WnX7SNClm+KSLpEWqKBi+XgsuBXcu4Q2kJ4ztJeugn9hCKaXjtIEzXig8U3V
	 R34mK6luZRjkGTpC5kvtzU73vpAHVgnBh5HBU4Kw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vinicius Costa Gomes <vinicius.gomes@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 333/444] dmaengine: idxd: Fix allowing write() from different address spaces
Date: Mon,  2 Jun 2025 15:46:37 +0200
Message-ID: <20250602134354.445861517@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134340.906731340@linuxfoundation.org>
References: <20250602134340.906731340@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 7ddf5f933475d..ba53675ced55a 100644
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



