Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62EB638382;
	Tue,  9 Jul 2024 11:11:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720523494; cv=none; b=F+zXUponQmzsMlJcqjh9rk2kp7LvT4sbHwaNL4IlX/3OJTEp0Rg5UpbVphRUXu5v82GMW5nRe43bElPagT/7IYv1Iq6xgJ6UWkXKI/hryXtrFhI7MwvjW5wfd8CZjT+mB6GLzds5EJBbPyNxvfDEb6FWcVUTP3iZALNvKDZmqCg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720523494; c=relaxed/simple;
	bh=szNkF71DO3VER4rsXK4AWP70rOl2WqIch7XmNjmSdWI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sMpGUeBYXqclxt56qi8pdhkdfzEk6XtO3m/LHoU54czQ64aadt3nA49TdYNBrCSspttWoa1L4WUWx71mHVjz69D6PT6yAv2u9uMP4D2iAEvCLFBmGtjqnYeOKx6Kmf/arZPBdcQ/HMKJ3za6rXg7lm2cp9KvIop6odAsp+nqBxg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SEG8X93C; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SEG8X93C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE86EC32786;
	Tue,  9 Jul 2024 11:11:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720523494;
	bh=szNkF71DO3VER4rsXK4AWP70rOl2WqIch7XmNjmSdWI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SEG8X93CHfDEtsdHS5Zv/znZuG4fpjK7S38JG8u27SlHu1KOoyhcg5bPhrtA6iCvv
	 FVuJS9Yuc3+PnIGrLckEF+ETpPdafCSrUH9bNw6i1rxP2GYaibQVy/pbB/fY120rxc
	 Skj/XjXY1kzsMNUd31VUTECuTmefnrFa+8QvXl0o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chenghai Huang <huangchenghai2@huawei.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 003/139] crypto: hisilicon/debugfs - Fix debugfs uninit process issue
Date: Tue,  9 Jul 2024 13:08:23 +0200
Message-ID: <20240709110658.282351098@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240709110658.146853929@linuxfoundation.org>
References: <20240709110658.146853929@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chenghai Huang <huangchenghai2@huawei.com>

[ Upstream commit 8be0913389718e8d27c4f1d4537b5e1b99ed7739 ]

During the zip probe process, the debugfs failure does not stop
the probe. When debugfs initialization fails, jumping to the
error branch will also release regs, in addition to its own
rollback operation.

As a result, it may be released repeatedly during the regs
uninit process. Therefore, the null check needs to be added to
the regs uninit process.

Signed-off-by: Chenghai Huang <huangchenghai2@huawei.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/hisilicon/debugfs.c | 21 ++++++++++++++++++---
 1 file changed, 18 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/hisilicon/debugfs.c b/drivers/crypto/hisilicon/debugfs.c
index 2cc1591949db7..bd205f1f2279e 100644
--- a/drivers/crypto/hisilicon/debugfs.c
+++ b/drivers/crypto/hisilicon/debugfs.c
@@ -794,8 +794,14 @@ static void dfx_regs_uninit(struct hisi_qm *qm,
 {
 	int i;
 
+	if (!dregs)
+		return;
+
 	/* Setting the pointer is NULL to prevent double free */
 	for (i = 0; i < reg_len; i++) {
+		if (!dregs[i].regs)
+			continue;
+
 		kfree(dregs[i].regs);
 		dregs[i].regs = NULL;
 	}
@@ -845,14 +851,21 @@ static struct dfx_diff_registers *dfx_regs_init(struct hisi_qm *qm,
 static int qm_diff_regs_init(struct hisi_qm *qm,
 		struct dfx_diff_registers *dregs, u32 reg_len)
 {
+	int ret;
+
 	qm->debug.qm_diff_regs = dfx_regs_init(qm, qm_diff_regs, ARRAY_SIZE(qm_diff_regs));
-	if (IS_ERR(qm->debug.qm_diff_regs))
-		return PTR_ERR(qm->debug.qm_diff_regs);
+	if (IS_ERR(qm->debug.qm_diff_regs)) {
+		ret = PTR_ERR(qm->debug.qm_diff_regs);
+		qm->debug.qm_diff_regs = NULL;
+		return ret;
+	}
 
 	qm->debug.acc_diff_regs = dfx_regs_init(qm, dregs, reg_len);
 	if (IS_ERR(qm->debug.acc_diff_regs)) {
 		dfx_regs_uninit(qm, qm->debug.qm_diff_regs, ARRAY_SIZE(qm_diff_regs));
-		return PTR_ERR(qm->debug.acc_diff_regs);
+		ret = PTR_ERR(qm->debug.acc_diff_regs);
+		qm->debug.acc_diff_regs = NULL;
+		return ret;
 	}
 
 	return 0;
@@ -893,7 +906,9 @@ static int qm_last_regs_init(struct hisi_qm *qm)
 static void qm_diff_regs_uninit(struct hisi_qm *qm, u32 reg_len)
 {
 	dfx_regs_uninit(qm, qm->debug.acc_diff_regs, reg_len);
+	qm->debug.acc_diff_regs = NULL;
 	dfx_regs_uninit(qm, qm->debug.qm_diff_regs, ARRAY_SIZE(qm_diff_regs));
+	qm->debug.qm_diff_regs = NULL;
 }
 
 /**
-- 
2.43.0



