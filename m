Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B47E43C1081;
	Tue, 21 Jul 2026 22:05:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784671517; cv=none; b=t4pNJAtxM9880/ME5tNqRoEsg5U0bj4BdUvXr/jnv8hUal16Neu/ojDNbiW6cSx5DedxWxhkIr9V4aH025kLEFAbkVGPncJ6l+XzGt4CQoB7pacq+t/Bc5WeWb5vlAkUmVmk0/5pcZrZ5nqCSkzCHY/6OpqwDrU8kbdQPR6aRw8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784671517; c=relaxed/simple;
	bh=o8KkhpilZ5823uG79fPUEeoO6etHQFViBMOGkrNm1m8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b0bYu5u4pqls6mj6J1CykZhsQOXRsyP63GZ3jvCTsQeLek0BNnYjwuav43MpHwImNlUVpgvhu54Km61TMlZvqRfNbBFQDnX/YxlSNJN6m6ZC9xD9HdjrvCRGRIS4MZduzTYM+ibXcpibu+ioUGSjnR3er9iZI7547AUuKynonT8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VlCZWBi6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VlCZWBi6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 275661F00A3A;
	Tue, 21 Jul 2026 22:05:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784671516;
	bh=dWgyAQUe+VLlaQJDUi4VSf9f8x96jsy3i1qUuMg6gcE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VlCZWBi6Y9socfjmVCAAmhuB2AREHOH1OgMeHF0ri14O9Qp43Zexnl+ljb50R9+KG
	 rURD45IbejyIR5f5dEV6u1SdUUWB2v1Y4s7N6vRYX1id99AuIXq2Gu31jYufG/sp3W
	 p9jPkmT1AoQXDgdhtudCfc/r1tPTJGABy/ZmLbR4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Weili Qian <qianweili@huawei.com>,
	Zongyu Wu <wuzongyu1@huawei.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 277/843] crypto: hisilicon/qm - disable error report before flr
Date: Tue, 21 Jul 2026 17:18:32 +0200
Message-ID: <20260721152412.256876713@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index a48c6306a8cb21..ec20ee5cf760f1 100644
--- a/drivers/crypto/hisilicon/qm.c
+++ b/drivers/crypto/hisilicon/qm.c
@@ -5113,8 +5113,6 @@ void hisi_qm_reset_prepare(struct pci_dev *pdev)
 	u32 delay = 0;
 	int ret;
 
-	hisi_qm_dev_err_uninit(pf_qm);
-
 	/*
 	 * Check whether there is an ECC mbit error, If it occurs, need to
 	 * wait for soft reset to fix it.
@@ -5131,6 +5129,8 @@ void hisi_qm_reset_prepare(struct pci_dev *pdev)
 		return;
 	}
 
+	hisi_qm_dev_err_uninit(pf_qm);
+
 	/* PF obtains the information of VF by querying the register. */
 	if (qm->fun_type == QM_HW_PF)
 		qm_cmd_uninit(qm);
-- 
2.53.0



