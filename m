Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D37B197A75;
	Thu,  6 Jun 2024 14:13:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683236; cv=none; b=Nwm/WhjAjM9hWv6ELOeO1D+QqxTY00thFdTkZX5fdbUrnYQHqihr4HW8f1bDb1LNIgz6yR1jY6KPa+Hv4tBKF/SFxXVJRbePvYDv+cJMXMm8G34uuZJlM/3lv8ZhXHr/iX4JQZl72lBOup8Rz1wEcsAV3BEYR2XUgRV87hJ1J8E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683236; c=relaxed/simple;
	bh=2C+0iR6lL3Sk+fr8R9T4WQaNplbzPxHYkI+yBeOYiI8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WA8alk6J3bB7UbQHcHg3g0nxGX9HXNHEjjfYISLN99onchfe/sDaA6ED74M2oMOkhoo0puQfe9quKT4zNLsie1RQFZ5ea2OUGroHbyIYem+uhe+kzHXYtJE321UJugVw3H4gEH2xNDjR+/QQPoJTah5AZOTmxEtC5Tn490ce5ao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I+GloCnL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I+GloCnL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E99FC2BD10;
	Thu,  6 Jun 2024 14:13:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683236;
	bh=2C+0iR6lL3Sk+fr8R9T4WQaNplbzPxHYkI+yBeOYiI8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=I+GloCnLgEZGtnRSBG+Wp3yKOjTUORMoDHo3QhfN9Ku2fJcfxHL2sIRMIp3xaacuR
	 lrKIDzEVSIrPWFNhVcyT+dpk7avHlX/pei+BPdIXhxzT+seJXQI/pbB97kDYPLKDZm
	 4wEfkPxWG5JGeiRl6v8T9nAYY9IsNGDSOWFPtfmw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zenghui Yu <yuzenghui@huawei.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Jiaxun Yang <jiaxun.yang@flygoat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 114/473] irqchip/loongson-pch-msi: Fix off-by-one on allocation error path
Date: Thu,  6 Jun 2024 16:00:43 +0200
Message-ID: <20240606131703.707861281@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131659.786180261@linuxfoundation.org>
References: <20240606131659.786180261@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zenghui Yu <yuzenghui@huawei.com>

[ Upstream commit b327708798809328f21da8dc14cc8883d1e8a4b3 ]

When pch_msi_parent_domain_alloc() returns an error, there is an off-by-one
in the number of interrupts to be freed.

Fix it by passing the number of successfully allocated interrupts, instead of the
relative index of the last allocated one.

Fixes: 632dcc2c75ef ("irqchip: Add Loongson PCH MSI controller")
Signed-off-by: Zenghui Yu <yuzenghui@huawei.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Jiaxun Yang <jiaxun.yang@flygoat.com>
Link: https://lore.kernel.org/r/20240327142334.1098-1-yuzenghui@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/irqchip/irq-loongson-pch-msi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/irqchip/irq-loongson-pch-msi.c b/drivers/irqchip/irq-loongson-pch-msi.c
index a72ede90ffc69..8b642927b522b 100644
--- a/drivers/irqchip/irq-loongson-pch-msi.c
+++ b/drivers/irqchip/irq-loongson-pch-msi.c
@@ -136,7 +136,7 @@ static int pch_msi_middle_domain_alloc(struct irq_domain *domain,
 
 err_hwirq:
 	pch_msi_free_hwirq(priv, hwirq, nr_irqs);
-	irq_domain_free_irqs_parent(domain, virq, i - 1);
+	irq_domain_free_irqs_parent(domain, virq, i);
 
 	return err;
 }
-- 
2.43.0



