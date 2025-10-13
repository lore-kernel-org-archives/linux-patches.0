Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9FD3309EFD;
	Mon, 13 Oct 2025 15:00:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760367638; cv=none; b=qlDa7LZj8PCR53R5wxF/w1rX4OQy9suse776xaTLWnbsmN1S/mW3lCWPk3KmVbJB2xpGxReKsgrfcry2oqzeVeXuGZFrmdE8lHtjFNhmOB7Bb4kgSuP8qMuJPLS2968bRpTONTorso+Q/Lx/T9ldb/3yQaKFc5X4gFBKhzb9DKA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760367638; c=relaxed/simple;
	bh=y2RCJGMr6nQw0rZYXAt7Jt6CdsclQluBxMiHTun9TnY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oyt+td3+QOFTiwApZ7tDeZ8nkWbqn34P8bi32JAbEaWzJq70hy9cW5BtY6Z8Ewl4RYVB1bdinFpTcdyJRwbru2QobgnPCttl6xPXnL5j1UeTia1R7tjavqkZXRaORl0OJ2WFTxahXoJReMeePC9UYoaPdCtNrFtL2mZ/Fdaco1Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2MUybptm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2MUybptm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BD35C4CEE7;
	Mon, 13 Oct 2025 15:00:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760367638;
	bh=y2RCJGMr6nQw0rZYXAt7Jt6CdsclQluBxMiHTun9TnY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2MUybptm4jU4PA+Xxgsx8ExUxkcUWQAsAI5di+eD4LPF6strq0qsSVLHb3W00jvsH
	 7hqvvgeVMCV5M2PMtPGkvDxWRzO7tjpqQGLK07p4IbcdHBhBlF6zn2vvwkAJ62bFFk
	 YoUdqIM68Gg2YHAb7dH8GIgurSEbVoEeIGscsAVk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhushuai Yin <yinzhushuai@huawei.com>,
	Chenghai Huang <huangchenghai2@huawei.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 082/196] crypto: hisilicon/qm - check whether the input function and PF are on the same device
Date: Mon, 13 Oct 2025 16:44:33 +0200
Message-ID: <20251013144318.281510310@linuxfoundation.org>
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
index 183885619eb8b..203240e78f6ad 100644
--- a/drivers/crypto/hisilicon/qm.c
+++ b/drivers/crypto/hisilicon/qm.c
@@ -3748,6 +3748,10 @@ static ssize_t qm_get_qos_value(struct hisi_qm *qm, const char *buf,
 	}
 
 	pdev = container_of(dev, struct pci_dev, dev);
+	if (pci_physfn(pdev) != qm->pdev) {
+		pci_err(qm->pdev, "the pdev input does not match the pf!\n");
+		return -EINVAL;
+	}
 
 	*fun_index = pdev->devfn;
 
-- 
2.51.0



