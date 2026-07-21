Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3024646D0B9;
	Tue, 21 Jul 2026 17:48:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784656108; cv=none; b=iRX8VKBcbRIGlul10pFNvc7GcsS1PN2754jnY3QSbC/iGzqR7RVxqmWvWQPOeo961KPAZoXz0vTREOA1AWzMrNrL1TE76RupoVH6/rMg9E6dc+zF+xiimPFsHmXd2THxSFHW4i9gISQcZWV285obN+mlBag9GAZqOSbuwN4ELqk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784656108; c=relaxed/simple;
	bh=6AKyMuIwVUQfN9QzlvlluaWJyqbAHyBJDEqE7nZKfIE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AFxv0kuK1gw/5gcYukNepA1E1FyPbzBarEcyHGsaWRg6vISH7ITJvISyVvyVJZUU/NEl1Ct1PPMEUa9dSCMHaebadJBpWuNHxvzgw7a1PjYWGPvLLWMLumda3kkiJF101snHikibJuEHKAaDe2FofM+I/MOmO0XiJhODdR1v1/0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KG1nyT3O; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KG1nyT3O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36CFF1F000E9;
	Tue, 21 Jul 2026 17:48:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784656106;
	bh=X38GplaLZLeUjdpExLwrFtXz8Nis51bae2R//H8GBxc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KG1nyT3O6uoU7GqQOl0z1/B8IcjSFnltruoeFePRP6ya+sZX6h1DjEUnwEjSfJ5TW
	 dr7h93J4xBOtkvuEQJpxmjtnTvdcDyAP/sNAqtqnr0gA/LBFEXA3mrmT8A8k+GNEi4
	 Uss6OeGQanVF5QufpURz9liJ0T/oWsJHRMNIzGC0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Weili Qian <qianweili@huawei.com>,
	Zongyu Wu <wuzongyu1@huawei.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0262/1611] crypto: hisilicon/qm - disable error report before flr
Date: Tue, 21 Jul 2026 17:06:18 +0200
Message-ID: <20260721152520.937703651@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index b92ee2fcb18aa9..fa808eeaf005b7 100644
--- a/drivers/crypto/hisilicon/qm.c
+++ b/drivers/crypto/hisilicon/qm.c
@@ -4785,8 +4785,6 @@ void hisi_qm_reset_prepare(struct pci_dev *pdev)
 	u32 delay = 0;
 	int ret;
 
-	hisi_qm_dev_err_uninit(pf_qm);
-
 	/*
 	 * Check whether there is an ECC mbit error, If it occurs, need to
 	 * wait for soft reset to fix it.
@@ -4803,6 +4801,8 @@ void hisi_qm_reset_prepare(struct pci_dev *pdev)
 		return;
 	}
 
+	hisi_qm_dev_err_uninit(pf_qm);
+
 	/* PF obtains the information of VF by querying the register. */
 	if (qm->fun_type == QM_HW_PF)
 		qm_cmd_uninit(qm);
-- 
2.53.0



