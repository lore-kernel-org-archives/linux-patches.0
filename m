Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59CA01F754A;
	Tue,  3 Dec 2024 15:38:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733240321; cv=none; b=oyy/uNvbr+AWZHIf0LNzsIimwsjLTP3rrp0fjoaoL1lACsJWekOMMIDGubrsDMezBbwtKDA1SnB+mxm0/sfQmiprnzUhVBtAE6hSMl+LzCMl1Dg7lgAWSfmCMZgOKtz1Vy9zSSBEuHG79h1C/km22BBX8HaizxnuSqiP344fsuE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733240321; c=relaxed/simple;
	bh=e0UZueV2MU3eZXli0a7Mn+HpN5CDD81Z54vhJlzdIEo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Lne6X4UbN7o/EB8r3bwPiWhupHisiTgCRqTDU/+v4T49wbf/JweuRxdvHNEmtUG7iJy7e/scsFbr37arpGJGY65SUu23tTqrW4GG0g7gvcrQpMq1jnMF14DG64rmIw3u1vFj/tKfYGdFTcXABQTPhcho7aweeVcAEQGtfcj38pI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=otDgoc7E; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="otDgoc7E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D778FC4CECF;
	Tue,  3 Dec 2024 15:38:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733240321;
	bh=e0UZueV2MU3eZXli0a7Mn+HpN5CDD81Z54vhJlzdIEo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=otDgoc7EcdzRcRti869OOnvmqmM/rG9sspy8DrU8sV1vw25STaBfvntCk+scI1wq0
	 VgumdCVV3I5JMyASnFzfaFGfLQe9QskRFuQN0SjTaqgGLueHrXp7O0dRPXELwJDhmJ
	 NmiWR0toynnFKNETMvcCKbqjx3AS4pd+UmeUk1wo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Samuel Holland <samuel.holland@sifive.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 098/826] irqchip/riscv-aplic: Prevent crash when MSI domain is missing
Date: Tue,  3 Dec 2024 15:37:05 +0100
Message-ID: <20241203144747.555001581@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Samuel Holland <samuel.holland@sifive.com>

[ Upstream commit 1f181d1cda56c2fbe379c5ace1aa1fac6306669e ]

If the APLIC driver is probed before the IMSIC driver, the parent MSI
domain will be missing, which causes a NULL pointer dereference in
msi_create_device_irq_domain().

Avoid this by deferring probe until the parent MSI domain is available. Use
dev_err_probe() to avoid printing an error message when returning
-EPROBE_DEFER.

Fixes: ca8df97fe679 ("irqchip/riscv-aplic: Add support for MSI-mode")
Signed-off-by: Samuel Holland <samuel.holland@sifive.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Link: https://lore.kernel.org/all/20241114200133.3069460-1-samuel.holland@sifive.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/irqchip/irq-riscv-aplic-main.c | 3 ++-
 drivers/irqchip/irq-riscv-aplic-msi.c  | 3 +++
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/irqchip/irq-riscv-aplic-main.c b/drivers/irqchip/irq-riscv-aplic-main.c
index 900e72541db9e..93e7c51f944ab 100644
--- a/drivers/irqchip/irq-riscv-aplic-main.c
+++ b/drivers/irqchip/irq-riscv-aplic-main.c
@@ -207,7 +207,8 @@ static int aplic_probe(struct platform_device *pdev)
 	else
 		rc = aplic_direct_setup(dev, regs);
 	if (rc)
-		dev_err(dev, "failed to setup APLIC in %s mode\n", msi_mode ? "MSI" : "direct");
+		dev_err_probe(dev, rc, "failed to setup APLIC in %s mode\n",
+			      msi_mode ? "MSI" : "direct");
 
 #ifdef CONFIG_ACPI
 	if (!acpi_disabled)
diff --git a/drivers/irqchip/irq-riscv-aplic-msi.c b/drivers/irqchip/irq-riscv-aplic-msi.c
index 945bff28265cd..fb8d1838609fb 100644
--- a/drivers/irqchip/irq-riscv-aplic-msi.c
+++ b/drivers/irqchip/irq-riscv-aplic-msi.c
@@ -266,6 +266,9 @@ int aplic_msi_setup(struct device *dev, void __iomem *regs)
 			if (msi_domain)
 				dev_set_msi_domain(dev, msi_domain);
 		}
+
+		if (!dev_get_msi_domain(dev))
+			return -EPROBE_DEFER;
 	}
 
 	if (!msi_create_device_irq_domain(dev, MSI_DEFAULT_DOMAIN, &aplic_msi_template,
-- 
2.43.0



