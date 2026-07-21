Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E25A44607D;
	Tue, 21 Jul 2026 15:49:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784648974; cv=none; b=O/+OkOaXh7x8MSzqXpY3XyrsbWRrt6yM9jztccds0TSOrDy6k0BkhBXgm5rMc5jGcw8IMZ7OjJaqEu3HK/EmXDpMU9Y5V/8iB1icvN7MqTtjIsZlOnQ4u9u0d6QBXGS82DBXjMcOLzct/t1+nEkd2SigPgi+NKC/uQugGYqAqgQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784648974; c=relaxed/simple;
	bh=O+ghqGi9PhLm4Hx6yl/BfdwyAKcc6DWIKQ9hjHUGQYA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QBumiuVxlwzLY90Zrg1Eey9MY2gSXIDr3hgE8zGizqvnjZZqW+N3BGRkyrEgje9rBbKq2FNps073Vb674/qluDur7EwpLMhPReu7disHFfMmbNrbzY7HrWkwL5/eZ4q+vgwC2g7jti5nknM8OS+G3z785CG6hujV+z5ocCEZZHE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wmHwBCLW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wmHwBCLW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73F761F000E9;
	Tue, 21 Jul 2026 15:49:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784648973;
	bh=BM9De+Nf8U3yghNQJ0uUuMfafeESdxcD6v4/W+6DZnM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wmHwBCLWr+GcjhdbWdgDzJZhN3cIHjVm9Il9hb7xVV1l/4Fe4orVqoPEcP7p3JiJ+
	 Wc7I6lSAp7cD8PQ6aTA1yPpt/XO/DqR+0sNqEFhmrT4o1nwY6TlU8qFWlc9Z3DzNWw
	 W/su6RGhVutV5zDm3+zqumD2AC3+IeyM9bpjUmKM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Weili Qian <qianweili@huawei.com>,
	Zongyu Wu <wuzongyu1@huawei.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0365/2077] crypto: hisilicon/qm - disable error report before flr
Date: Tue, 21 Jul 2026 17:00:38 +0200
Message-ID: <20260721152601.297515488@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
index 3ca47e2a9719f1..26e2ccb70c2ae0 100644
--- a/drivers/crypto/hisilicon/qm.c
+++ b/drivers/crypto/hisilicon/qm.c
@@ -4917,8 +4917,6 @@ void hisi_qm_reset_prepare(struct pci_dev *pdev)
 	u32 delay = 0;
 	int ret;
 
-	hisi_qm_dev_err_uninit(pf_qm);
-
 	/*
 	 * Check whether there is an ECC mbit error, If it occurs, need to
 	 * wait for soft reset to fix it.
@@ -4935,6 +4933,8 @@ void hisi_qm_reset_prepare(struct pci_dev *pdev)
 		return;
 	}
 
+	hisi_qm_dev_err_uninit(pf_qm);
+
 	/* PF obtains the information of VF by querying the register. */
 	if (qm->fun_type == QM_HW_PF)
 		qm_cmd_uninit(qm);
-- 
2.53.0



