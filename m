Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB7D3408634;
	Tue, 21 Jul 2026 19:24:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784661882; cv=none; b=f9yWkvrnyl8R3ez9p8Iymx2plyohdvVA0qOK2hZ9UKQRcD+t/KxPMdvhOcYGzNywiS4snJ+hVjnIfvTfE7p79UWYGxjMCBwcygb2KjoBPOe/51WVBdMmG07Al+WkJVUp9k4tTcwTZfcbN558Bee7SmfaEr0ntkoq1KsbgRIAiMg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784661882; c=relaxed/simple;
	bh=FeDfwmFB/y39+mduIWCW9/JSXWXWTdpjiP7cAXf7zcg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Lv+ema5zaGktrY9KFTY0TN7ReOs6MKn3lqWcnuV6SybINMAcmIKgR6cziShHbD9r5vRX0iv9to6DpBNVx/C0T2JnQvQml6H2176k3QTSWsZkfn6qZq6BGsd0wgPHkv85InU6vim1AUskby2he4PwNinbj3qZ05FwKFLyThSDjR0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=We04kZ+5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="We04kZ+5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D7B81F000E9;
	Tue, 21 Jul 2026 19:24:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784661881;
	bh=gL7xHkUMUnVBxWk0wRjdyOQecIrm+tMmMXidEO3KQRg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=We04kZ+5xhjxmG9Sshbu7zMQjXkG/tl901dyv2Xf/dbB/gMPTD7Qz4eSkBtVEDk3F
	 aWt9epESs3azI7BkW1navc7LtMk8GvppiuQZTEZU8ewB4Etrg6LSUrDDwGCjPBzkKu
	 ddASf3cqC2GVyIZw6/KzaPnWkBFkm47XtuS6X3dU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Weili Qian <qianweili@huawei.com>,
	Zongyu Wu <wuzongyu1@huawei.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0190/1276] crypto: hisilicon/qm - disable error report before flr
Date: Tue, 21 Jul 2026 17:10:33 +0200
Message-ID: <20260721152450.341132244@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

From: Weili Qian <qianweili@huawei.com>

[ Upstream commit e71dc5602b9a29027f6aedd5990d3e8c4f638c8c ]

Before function level reset, driver first disable device error report
and then waits for the device reset to complete. However, when the
error is recovered, the error bits will be enabled again, resulting in
invalid disable. It is modified to detect that there is no error
before disable error report, and then do FLR.

Fixes: 7ce396fa12a9 ("crypto: hisilicon - add FLR support")
Signed-off-by: Weili Qian <qianweili@huawei.com>
Signed-off-by: Zongyu Wu <wuzongyu1@huawei.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/hisilicon/qm.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/hisilicon/qm.c b/drivers/crypto/hisilicon/qm.c
index 2c64bf4cdf0dce..38c9d633db5f42 100644
--- a/drivers/crypto/hisilicon/qm.c
+++ b/drivers/crypto/hisilicon/qm.c
@@ -4505,8 +4505,6 @@ void hisi_qm_reset_prepare(struct pci_dev *pdev)
 	u32 delay = 0;
 	int ret;
 
-	hisi_qm_dev_err_uninit(pf_qm);
-
 	/*
 	 * Check whether there is an ECC mbit error, If it occurs, need to
 	 * wait for soft reset to fix it.
@@ -4523,6 +4521,8 @@ void hisi_qm_reset_prepare(struct pci_dev *pdev)
 		return;
 	}
 
+	hisi_qm_dev_err_uninit(pf_qm);
+
 	/* PF obtains the information of VF by querying the register. */
 	if (qm->fun_type == QM_HW_PF)
 		qm_cmd_uninit(qm);
-- 
2.53.0



