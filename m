Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1F7535B658;
	Wed,  8 Apr 2026 18:56:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775674574; cv=none; b=kkQSlMOq8gLGF/ARfh/AVWXIjF80w9IzhRPB+l4waDFA2N2mdc6WQ9CYRYUCoLQcoEMpyoLN3iBQFoiR/o04OPwv9UpEPyXMjxPI1kX5qG5wTCb2LEO7VGbndEusBd24c3O4Hk/l5z3uvj312dUak1gff/ZBtnf4az/LW1qRrRk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775674574; c=relaxed/simple;
	bh=Ubfd1RdePg9AcF9UvMAD5O0x1lxyMqymjWbQxeRHnGI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=b0PdKHC0HXvuGbNgtDcYOIQdAq09HwGPsAN2ivYeXkUrQ94hVkMmdfBhGe//HrL0YDGANr5j8pEYH8wto88WRj2+0jyOamIaU05kk+XppZw1YSjtnvA5r6ewCFNuYPY/nG61knisOh6TAldNqSrySd0w1mBYsstrZ6DjSxQ1hhA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zE12jli7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zE12jli7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C3E4C19421;
	Wed,  8 Apr 2026 18:56:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775674574;
	bh=Ubfd1RdePg9AcF9UvMAD5O0x1lxyMqymjWbQxeRHnGI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zE12jli7rDfRIkWF9j/MgDg5w0gJ9lbq8a5EzHyHxNbMcNaBpbtWmeg287DiHWKDh
	 9X7MYi3/skf7oUkm34sB5D1ctsKe7PV3NVKhIAypzCexVClYp+ib6h6FbxBHghfpWN
	 wcsWPAMHIIhcPgjow7WXTHv5ExaGnAcyS6Ncstig=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jessica Liu <liu.xuemei1@zte.com.cn>,
	Thomas Gleixner <tglx@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 151/311] irqchip/riscv-aplic: Restrict genpd notifier to device tree only
Date: Wed,  8 Apr 2026 20:02:31 +0200
Message-ID: <20260408175945.046433136@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175939.393281918@linuxfoundation.org>
References: <20260408175939.393281918@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jessica Liu <liu.xuemei1@zte.com.cn>

[ Upstream commit af416cd9b3fb9d17ac7f4cfa12d1ea83dfd0e4be ]

On ACPI systems, the aplic's pm_domain is set to acpi_general_pm_domain,
which provides its own power management callbacks (e.g., runtime_suspend
via acpi_subsys_runtime_suspend).

aplic_pm_add() unconditionally calls dev_pm_genpd_add_notifier() when
dev->pm_domain is non‑NULL, leading to a comparison between runtime_suspend
and genpd_runtime_suspend. This results in the following errors when ACPI
is enabled:

  riscv-aplic RSCV0002:00: failed to create APLIC context
  riscv-aplic RSCV0002:00: error -ENODEV: failed to setup APLIC in MSI mode

Fix this by checking for dev->of_node before adding or removing the genpd
notifier, ensuring it is only used for device tree based systems.

Fixes: 95a8ddde3660 ("irqchip/riscv-aplic: Preserve APLIC states across suspend/resume")
Signed-off-by: Jessica Liu <liu.xuemei1@zte.com.cn>
Signed-off-by: Thomas Gleixner <tglx@kernel.org>
Link: https://patch.msgid.link/20260331093029749vRpdH-0qoEqjS0Wnn9M4x@zte.com.cn
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/irqchip/irq-riscv-aplic-main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/irqchip/irq-riscv-aplic-main.c b/drivers/irqchip/irq-riscv-aplic-main.c
index 9f53979b69625..d9afb6ae98cf5 100644
--- a/drivers/irqchip/irq-riscv-aplic-main.c
+++ b/drivers/irqchip/irq-riscv-aplic-main.c
@@ -150,7 +150,7 @@ static void aplic_pm_remove(void *data)
 	struct device *dev = priv->dev;
 
 	list_del(&priv->head);
-	if (dev->pm_domain)
+	if (dev->pm_domain && dev->of_node)
 		dev_pm_genpd_remove_notifier(dev);
 }
 
@@ -165,7 +165,7 @@ static int aplic_pm_add(struct device *dev, struct aplic_priv *priv)
 
 	priv->saved_hw_regs.srcs = srcs;
 	list_add(&priv->head, &aplics);
-	if (dev->pm_domain) {
+	if (dev->pm_domain && dev->of_node) {
 		priv->genpd_nb.notifier_call = aplic_pm_notifier;
 		ret = dev_pm_genpd_add_notifier(dev, &priv->genpd_nb);
 		if (ret)
-- 
2.53.0



