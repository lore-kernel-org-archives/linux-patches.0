Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C9662F83BA;
	Mon, 13 Oct 2025 15:32:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760369577; cv=none; b=jSM1v5aHgyp4D1K9wi4rbOM+QXt+dpK7tkIptcCO6FrbXnLgTzIs0FqH7Iiu5BR+e425T7kGweORMIZm6zM3L3Ix6ND7Kf74BOqs30gghnMwah861LTcsY5Cq8gesC239kLBfskryD2dQKeQ248iJrLG8V7/jGCQFJbbmzPBE9c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760369577; c=relaxed/simple;
	bh=B8YNcDlEqStkSkN+lgOw62nKQBGZSlKo85Jc2sWFtyc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uGtOWHChZFCuew3dHN+Rm0mWvp4vX+Lc4IvvP6rRnvlZGtgGKcCqkys5jbwWsj5apTpIJ68EasEYR0N4VVSPiXdhifzC4fZSYymgN3jJ5gPt/tnIqtASqn0zzz9XRI5BXiZR1C033tclMqnspWvzc3Yx5PAGIiI1za0IsN8cvIw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h5wd0zm3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h5wd0zm3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A05EC4CEE7;
	Mon, 13 Oct 2025 15:32:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760369577;
	bh=B8YNcDlEqStkSkN+lgOw62nKQBGZSlKo85Jc2sWFtyc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=h5wd0zm3ZYzbKq+qpyBctkwPPCLaOhKH8seyllKorVtzfSNnKDD99pzefAnCLIftp
	 uMnGjZoq4oiCYMkUcufKhaJu94AM1IAycT3F1EMk9yZ2wo6+hAk6C1Rd59v8Cou94K
	 1k0C9fmmL9hKqtAkXLIKDlq5Aug20jbdh595xCMQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhushuai Yin <yinzhushuai@huawei.com>,
	Chenghai Huang <huangchenghai2@huawei.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 295/563] crypto: hisilicon/qm - check whether the input function and PF are on the same device
Date: Mon, 13 Oct 2025 16:42:36 +0200
Message-ID: <20251013144421.957003190@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhushuai Yin <yinzhushuai@huawei.com>

[ Upstream commit 6a2c9164b52e6bc134127fd543461fdef95cc8ec ]

Function rate limiting is set through physical function driver.
Users configure by providing function information and rate limit values.
Before configuration, it is necessary to check whether the
provided function and PF belong to the same device.

Fixes: 22d7a6c39cab ("crypto: hisilicon/qm - add pci bdf number check")
Signed-off-by: Zhushuai Yin <yinzhushuai@huawei.com>
Signed-off-by: Chenghai Huang <huangchenghai2@huawei.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/hisilicon/qm.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/crypto/hisilicon/qm.c b/drivers/crypto/hisilicon/qm.c
index a5cc0ccd94f1f..2f96c673b60a5 100644
--- a/drivers/crypto/hisilicon/qm.c
+++ b/drivers/crypto/hisilicon/qm.c
@@ -3826,6 +3826,10 @@ static ssize_t qm_get_qos_value(struct hisi_qm *qm, const char *buf,
 	}
 
 	pdev = container_of(dev, struct pci_dev, dev);
+	if (pci_physfn(pdev) != qm->pdev) {
+		pci_err(qm->pdev, "the pdev input does not match the pf!\n");
+		return -EINVAL;
+	}
 
 	*fun_index = pdev->devfn;
 
-- 
2.51.0



