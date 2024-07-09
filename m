Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1997B158A07;
	Tue,  9 Jul 2024 11:19:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720523971; cv=none; b=ZaskSzMv5Rhz33NA8LGp8GIwd6qOL0RACw//nbmd0IqBZNEHTJaZXggBrwzoinyp0VDTQjmVWnwe52FLFmMC5AwPHh3HdRgOMePZMSa/HycItaZcFPuB77kEdGQ6r/dCfXJZPKdWZ7RkWfci82wxBGQ9AaCT5PEGtmNMDysmNCU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720523971; c=relaxed/simple;
	bh=k/MZTv6Y2Xp2Q7AB+1FSZ8tIGvdUfIuNTy4LZn8r8SY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oDR+V2jdNrMKkKSbKA7Wo7g5+pjqQQLF4o92lm27emxXzmljX62/fo0Igh9l0Tc75u6KrFTLNBDRu895s9u1Dyr5W0O7VV5EK2Pnx4LUCtcfxoDwLb72TqdyXZuu3oi7qUB4GzynMs8+T40R95/SUzMP+nWn6qhbD2aOPyStODY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DPfxHugJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DPfxHugJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FF65C32786;
	Tue,  9 Jul 2024 11:19:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720523971;
	bh=k/MZTv6Y2Xp2Q7AB+1FSZ8tIGvdUfIuNTy4LZn8r8SY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DPfxHugJ/V59f7948lZ/yrpRH92FQpntHWeE2ixl7XWcxJadqTxCWtZX78Up9iArK
	 vwElwQA2NmGiw0iz96PP+OGv4qEpiL02BTCBAkQ+MDRNsbb/tGUdoElTG0XWlB+i03
	 9sczYvBqSotikBXwGjvPA8ibvTDdkTlKKBb/mqQc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chenghai Huang <huangchenghai2@huawei.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 005/197] crypto: hisilicon/debugfs - Fix debugfs uninit process issue
Date: Tue,  9 Jul 2024 13:07:39 +0200
Message-ID: <20240709110709.116756195@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240709110708.903245467@linuxfoundation.org>
References: <20240709110708.903245467@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

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
index cd67fa348ca72..6351a452878dd 100644
--- a/drivers/crypto/hisilicon/debugfs.c
+++ b/drivers/crypto/hisilicon/debugfs.c
@@ -809,8 +809,14 @@ static void dfx_regs_uninit(struct hisi_qm *qm,
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
@@ -860,14 +866,21 @@ static struct dfx_diff_registers *dfx_regs_init(struct hisi_qm *qm,
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
@@ -908,7 +921,9 @@ static int qm_last_regs_init(struct hisi_qm *qm)
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



