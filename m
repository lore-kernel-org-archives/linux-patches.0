Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3CC03191D0;
	Wed, 20 May 2026 16:39:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779295159; cv=none; b=tThMQsqyliC1UbOJh7787PZuxIJYFF5DnWfdunFQX2HkrSBuFUzIZN3qRl3p6DHtHLIFVrImuJPjhqv95HWZRHIETu4MwTF50wQzrbhUkN0ejPu8IU/kDU/yXGbIZBjYyBT3j1A0THuG1hYeYXw0SkqfHot9GE8eFZY3R5m+XoE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779295159; c=relaxed/simple;
	bh=YvsQVmzEDNMSdVVmub73nUAjLc5ambd66AQHlqcOYyg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eVg46jh77r/dOB7n0tgL85n5aB+PhG85JnINbHEExHI5e8NbQ7liyR1DDik+nzU2+v8yCjMlr3Jgrvzg5w+GqimX2SbWCJye/B2eiJlYDzbS/RzSkdLZO6qJwyvyptcSAOAoZ7YLLEScIrqWrP7YQZODlh7lbZBZK2qHWHvn21g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L2+Z+Fc6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L2+Z+Fc6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12C911F00893;
	Wed, 20 May 2026 16:39:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779295158;
	bh=FZYs0pk+rdKOOyo9Xgh0EhskMkjd/PeVwR1eNc8wBD4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=L2+Z+Fc6UF3EBxd2zh0dPr8Iu3sA1njaNZTwcDN1d26+gCHlnfu7gxpIdgyOPQt9G
	 WpA/w2SiQOCTv9kNPVCZgr1hCobRs8HdkdFOYhXppXgtncIRfEyAQ37xo/U8g5etty
	 PLrYgyxjOHpdnDuS34KYVdqQVsjbrumK5y18uk7g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Gu <ustc.gu@gmail.com>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Hans Zhang <18255117159@163.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0314/1146] PCI: sky1: Fix missing cleanup of ECAM config on probe failure
Date: Wed, 20 May 2026 18:09:24 +0200
Message-ID: <20260520162155.305591733@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felix Gu <ustc.gu@gmail.com>

[ Upstream commit 72e76b63d6ff6d1f96acccbfc6c118656f63e66a ]

When devm_kzalloc() for reg_off fails, the code returns -ENOMEM without
freeing pcie->cfg, which was allocated earlier by pci_ecam_create().

Add the missing pci_ecam_free() call to properly release the allocated ECAM
configuration window on this error path.

Fixes: a0d9f2c08f45 ("PCI: sky1: Add PCIe host support for CIX Sky1")
Signed-off-by: Felix Gu <ustc.gu@gmail.com>
Signed-off-by: Manivannan Sadhasivam <mani@kernel.org>
Reviewed-by: Hans Zhang <18255117159@163.com>
Link: https://patch.msgid.link/20260324-sky1-v1-1-6a00cb2776b6@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/cadence/pci-sky1.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/pci/controller/cadence/pci-sky1.c b/drivers/pci/controller/cadence/pci-sky1.c
index d8c216dc120d6..9853a9c82c0e6 100644
--- a/drivers/pci/controller/cadence/pci-sky1.c
+++ b/drivers/pci/controller/cadence/pci-sky1.c
@@ -176,8 +176,10 @@ static int sky1_pcie_probe(struct platform_device *pdev)
 	cdns_pcie->is_rc = 1;
 
 	reg_off = devm_kzalloc(dev, sizeof(*reg_off), GFP_KERNEL);
-	if (!reg_off)
+	if (!reg_off) {
+		pci_ecam_free(pcie->cfg);
 		return -ENOMEM;
+	}
 
 	reg_off->ip_reg_bank_offset = SKY1_IP_REG_BANK;
 	reg_off->ip_cfg_ctrl_reg_offset = SKY1_IP_CFG_CTRL_REG_BANK;
-- 
2.53.0



