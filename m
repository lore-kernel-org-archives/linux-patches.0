Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48CB315749F;
	Tue,  9 Jul 2024 11:29:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720524542; cv=none; b=AE0cuaBP5oStUfV2hZelATTifeW0f1+Z+0FvWck5FZCaJPQDJ4w+KcdkTmaa61clcmZjNG/oDM2isqrzV36OBO34wO2VZFolYGcAtQl880Q/Djn1jBRTodp2tYYetm4JjvtbOvF0Mi1g5+/WPen8518V0EMZk+ryowHA+j/V7yA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720524542; c=relaxed/simple;
	bh=+9PFez0zBIwXqNOXGp6d1xKG4hfzDoPo2+YCRSioQPY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZEmNkMj2G0okcqQrdiuIlnuvyPl7WOp+WfGfnNNXSu1iTWc7k0fcYZ9N5MoKTAzQVdFKkV9Dm2yVyz0OC6YxhjClAgOlqS5AePrl+ZSe23qmhA+ZXrZqEQ5AKlJQdweVw3Sf4pqhKstnFTiROzKJ66s17uhTRdd20dLzvIXHmuI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=n09CmkeY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="n09CmkeY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79E09C3277B;
	Tue,  9 Jul 2024 11:29:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720524541;
	bh=+9PFez0zBIwXqNOXGp6d1xKG4hfzDoPo2+YCRSioQPY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=n09CmkeY77jfIGgkWAxHEDI9cLNDmTmXD2n1BQJzqLW+vhqS8dvtsXaEBwIA8b6hJ
	 dlStpAUO+z3yuVJQBllBr2wy/1SMPw8DI9vWTP+jeEGP636e/OTWRLvIBp5aPOFktT
	 SSLDGgMLcx4nwzAa6HSQ0cnM2WvOca6SXOfyG3TY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chenghai Huang <huangchenghai2@huawei.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 002/102] crypto: hisilicon/debugfs - Fix debugfs uninit process issue
Date: Tue,  9 Jul 2024 13:09:25 +0200
Message-ID: <20240709110651.453922745@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240709110651.353707001@linuxfoundation.org>
References: <20240709110651.353707001@linuxfoundation.org>
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
index 13bec8b2d7237..a1d41ee39816b 100644
--- a/drivers/crypto/hisilicon/debugfs.c
+++ b/drivers/crypto/hisilicon/debugfs.c
@@ -744,8 +744,14 @@ static void dfx_regs_uninit(struct hisi_qm *qm,
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
@@ -795,14 +801,21 @@ static struct dfx_diff_registers *dfx_regs_init(struct hisi_qm *qm,
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
@@ -843,7 +856,9 @@ static int qm_last_regs_init(struct hisi_qm *qm)
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



