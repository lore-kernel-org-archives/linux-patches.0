Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA1D5282F31;
	Tue, 21 Jul 2026 21:21:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784668907; cv=none; b=GjsWqzdfaLggcz+C0NcucjlH4ULK7BjvphFsrkUHmZ7AbXupFj/Vw5rk8h7ggcV733MOHo/ptk1sE3bSUF/AnO0ObKnIIhoOKrDj8VqoYpo7di6GCDHiYip5F1C444V314MKqSli1Kz4go6+LHS8HLJPCxCdjGzIykNMQ7rzglE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784668907; c=relaxed/simple;
	bh=2p5qTPz7cLJoLvibgfMuRGY6ly0bQyL+rHQ4JKk5jEo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Cs6520Jyoca3keNBZkXu5V70coiVf4ECGO6Mq4LVACV2LpQvZLF2rkMf4gYcXPKvTprUS2XWPQHCHXZJ1oJvTzEt8O38ihCKRosr8hgPncY12hfA7Jg1/NQtRVeLto6b/4xKLIWvq12QnHQFQorxcyzm9uL3iOKafRklzFsX7lI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jZ1WUVml; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jZ1WUVml"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8AEC1F000E9;
	Tue, 21 Jul 2026 21:21:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784668905;
	bh=KwPKTjAUPqIXm2uUwxPjLPVRiWax3dv7omaPI3dO4Iw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jZ1WUVml7fj5VA8lDzcwNED9u9WRaFkU0tt3AXgIxqWK/IRglWempHWfEASA66uxo
	 umPMr6ux4z/ssKO3ZdrCetkrVF5zf7r3YF699CkWogE+Hikir9jdVIhlGnObLzdYsx
	 c1hoR7HcXCVoEooDzrrRy4dk96qXzHBVgs6n+dhs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Weili Qian <qianweili@huawei.com>,
	Zongyu Wu <wuzongyu1@huawei.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0353/1067] crypto: hisilicon/qm - disable error report before flr
Date: Tue, 21 Jul 2026 17:15:54 +0200
Message-ID: <20260721152432.506328624@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 23fff5de3325a9..9ebd7b3d97be76 100644
--- a/drivers/crypto/hisilicon/qm.c
+++ b/drivers/crypto/hisilicon/qm.c
@@ -4459,8 +4459,6 @@ void hisi_qm_reset_prepare(struct pci_dev *pdev)
 	u32 delay = 0;
 	int ret;
 
-	hisi_qm_dev_err_uninit(pf_qm);
-
 	/*
 	 * Check whether there is an ECC mbit error, If it occurs, need to
 	 * wait for soft reset to fix it.
@@ -4477,6 +4475,8 @@ void hisi_qm_reset_prepare(struct pci_dev *pdev)
 		return;
 	}
 
+	hisi_qm_dev_err_uninit(pf_qm);
+
 	/* PF obtains the information of VF by querying the register. */
 	if (qm->fun_type == QM_HW_PF)
 		qm_cmd_uninit(qm);
-- 
2.53.0



