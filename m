Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 726EF30E849;
	Mon, 13 Oct 2025 15:03:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760367795; cv=none; b=jIkbSE7F+onAansRYQfCo7Bge3iunlNnnAKPweg8mtuNnTkVSzftS84ueeEWAYtOWOk9T80CIV+Avkq+rj07RHN5IQE8xrOGPjE9zvpEsOFl1eHZTdyhGfPWi3dE2Tl4uQhN5c6iGBDoOxQFaEx7JDmxwk5B32jBXyaSamcYqIk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760367795; c=relaxed/simple;
	bh=5VZa6XCmUNXRN87xcFHT470lLuEBoyT/gKPaON3yqp4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W89lAScPWF2YULJxMYrM4PH01OdQ7k46xHAd2cbZAxSXGRthb5yBg8r/Hc/W2B/HmpRzgiH9ndcU1mUkisYLnC2uHG7dAkXU1xzv0HrhvRJ2WZIFN49RwWtvHrbhZZh8soFjdSx+/tbxGDuwrdqnBORO18ABXWb7pMuOhxUmQw4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kuabf7ub; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kuabf7ub"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFF40C4CEE7;
	Mon, 13 Oct 2025 15:03:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760367795;
	bh=5VZa6XCmUNXRN87xcFHT470lLuEBoyT/gKPaON3yqp4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kuabf7ubU8SpzsZ4F8nUoQTlFu5koghRzxGTBMteNQosN5it+r0T9R9tUdZWFsZSL
	 YTEcpUEJIvDUTLfV0WALy/cfo8FBGXOkZcDwLAKxmXOhUst1UuLWKh1p7cZhUsZTkm
	 6prKnpiraPvcig4ylAZ8SX+TP/ggFtYm1EWwkmDA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chenghai Huang <huangchenghai2@huawei.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 135/196] crypto: hisilicon/qm - set NULL to qm->debug.qm_diff_regs
Date: Mon, 13 Oct 2025 16:45:26 +0200
Message-ID: <20251013144320.198587730@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144315.184275491@linuxfoundation.org>
References: <20251013144315.184275491@linuxfoundation.org>
User-Agent: quilt/0.69
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

[ Upstream commit f0cafb02de883b3b413d34eb079c9680782a9cc1 ]

When the initialization of qm->debug.acc_diff_reg fails,
the probe process does not exit. However, after qm->debug.qm_diff_regs is
freed, it is not set to NULL. This can lead to a double free when the
remove process attempts to free it again. Therefore, qm->debug.qm_diff_regs
should be set to NULL after it is freed.

Fixes: 8be091338971 ("crypto: hisilicon/debugfs - Fix debugfs uninit process issue")
Signed-off-by: Chenghai Huang <huangchenghai2@huawei.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/hisilicon/debugfs.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/crypto/hisilicon/debugfs.c b/drivers/crypto/hisilicon/debugfs.c
index bd205f1f2279e..573c0033a5afe 100644
--- a/drivers/crypto/hisilicon/debugfs.c
+++ b/drivers/crypto/hisilicon/debugfs.c
@@ -865,6 +865,7 @@ static int qm_diff_regs_init(struct hisi_qm *qm,
 		dfx_regs_uninit(qm, qm->debug.qm_diff_regs, ARRAY_SIZE(qm_diff_regs));
 		ret = PTR_ERR(qm->debug.acc_diff_regs);
 		qm->debug.acc_diff_regs = NULL;
+		qm->debug.qm_diff_regs = NULL;
 		return ret;
 	}
 
-- 
2.51.0



