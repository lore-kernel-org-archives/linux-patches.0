Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F020D30C611;
	Mon, 13 Oct 2025 15:11:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760368298; cv=none; b=XsphwBeQmskhqtRdDY2n+L7iPfbhZBNvEVVs1lyUDuPEfBdJbENJ2WMDq0Cfyu6mCcy55i2gP1PydfwuPZugcXi+ZeYqt+tRSs8zcfFhaKLPLCzWhsOSXxL172LIy6ozUfn1jMxgjdpbu9U/PjNZRhb1jb7g03DdEqxqI7Li3AA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760368298; c=relaxed/simple;
	bh=csxZDkJkBq7OCqlnRiqthjgHCyDPNTmub2/nf74bSkE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NI6UxbbYxB9MnaXA6Mkh8QMIYeXoQtgJYF+dO7i+zS7K9EvMnLhbZBMLDdeuA4aalA4KeCW6/RwPR9QP50200+eCKIPrF7K/QGTOpek5EgobaoVTQHRJMZO4YwY61yw2pnwNoAu26J+4vsyo2fTmrVSHFCGsk96b42RQ3T1cooM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2tQkEee1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2tQkEee1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C71EC4CEE7;
	Mon, 13 Oct 2025 15:11:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760368297;
	bh=csxZDkJkBq7OCqlnRiqthjgHCyDPNTmub2/nf74bSkE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2tQkEee1DbUv4x3WByKh3Ui0QYTceIrcNNBGY/BQpCRdyeEsAPK2xdclsMyH3wxKj
	 N+GsmaFS27riksG0ancNnFhy3Gt+KJdQEsrhMS1sfPsetpRg1wVld1No3MJ/Wceg8R
	 X5t1op1xrWJjg2KQ/gtHZqugjQemlWJrqAImwQQY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhushuai Yin <yinzhushuai@huawei.com>,
	Chenghai Huang <huangchenghai2@huawei.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 113/262] crypto: hisilicon/qm - check whether the input function and PF are on the same device
Date: Mon, 13 Oct 2025 16:44:15 +0200
Message-ID: <20251013144330.194614490@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144326.116493600@linuxfoundation.org>
References: <20251013144326.116493600@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 5bbb2759a6691..a9550a05dfbd3 100644
--- a/drivers/crypto/hisilicon/qm.c
+++ b/drivers/crypto/hisilicon/qm.c
@@ -3657,6 +3657,10 @@ static ssize_t qm_get_qos_value(struct hisi_qm *qm, const char *buf,
 	}
 
 	pdev = container_of(dev, struct pci_dev, dev);
+	if (pci_physfn(pdev) != qm->pdev) {
+		pci_err(qm->pdev, "the pdev input does not match the pf!\n");
+		return -EINVAL;
+	}
 
 	*fun_index = pdev->devfn;
 
-- 
2.51.0



