Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 997873B7741;
	Tue, 21 Jul 2026 20:31:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784665865; cv=none; b=HOjtvhfAu20RnNYumYN4r7RwNgP9CnsVYgykr3KEc4Zjg8cRWxIRiVH0bDXbPZvCaxTyaQgPTSYW9wqsVn/8pcLaBFZ9GVBD0OzQwHgz2dC+ZY58mbARjZTZ97IpNZyL88iUyM//mK5a5Wm3RzChWv/Vovklk5W9BEks4HhE29I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784665865; c=relaxed/simple;
	bh=C/qf9t5+DqYssPy9OiXNiRFw3Zn87wRTcyU3zoXLI8U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XGwPhj/untWXCe6u1P0tuCKoqbw4mkuc0zHEkd97K3sU/+HQtJxDP2DfqibWryFIji3VygcGtrOvy3/b+9MVhQu5qOX7d6znjQ+zK6nDHszYmGKwMnq+Vxiy0vEBWr4e9JsKIZdK7FvtdY43z4x6wex8mFRDIUmr3W8znC6RiHM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YDSRWlIi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YDSRWlIi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6BBC1F000E9;
	Tue, 21 Jul 2026 20:31:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784665864;
	bh=+DHzB2LAbA3yTO5TrGTBzYaC1SO17e5x/EwFj0L4+HM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YDSRWlIiMIIdhoXGgTFVeW2DJ/0EDzPfiTZTSFoUBjx/PUZIGiXP8EQBujZAbVOVj
	 dtZ962y0MAYVWy8FkHpw8wyH2KF/qRnim8/ARJsVqLnDyJ4zXRZ/JtqQRXBhms1N3N
	 +IDfNEiMfQ/UjfktJTfB5OsGnR2CKUjFUIOOPGaU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Weili Qian <qianweili@huawei.com>,
	Zongyu Wu <wuzongyu1@huawei.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0458/1266] crypto: hisilicon/qm - disable error report before flr
Date: Tue, 21 Jul 2026 17:14:55 +0200
Message-ID: <20260721152452.083494423@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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
index e09357fea057ca..c7f87457038349 100644
--- a/drivers/crypto/hisilicon/qm.c
+++ b/drivers/crypto/hisilicon/qm.c
@@ -4568,8 +4568,6 @@ void hisi_qm_reset_prepare(struct pci_dev *pdev)
 	u32 delay = 0;
 	int ret;
 
-	hisi_qm_dev_err_uninit(pf_qm);
-
 	/*
 	 * Check whether there is an ECC mbit error, If it occurs, need to
 	 * wait for soft reset to fix it.
@@ -4586,6 +4584,8 @@ void hisi_qm_reset_prepare(struct pci_dev *pdev)
 		return;
 	}
 
+	hisi_qm_dev_err_uninit(pf_qm);
+
 	/* PF obtains the information of VF by querying the register. */
 	if (qm->fun_type == QM_HW_PF)
 		qm_cmd_uninit(qm);
-- 
2.53.0



