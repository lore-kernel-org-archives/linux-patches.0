Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DAAA331220;
	Wed, 20 May 2026 17:17:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779297478; cv=none; b=nhcHXeA51zs8wPTaqoyvPtSvist8NG/FXVvso86fQvywcAnKEJnXaKqCUedmm7zXeJbV193fENFFeIrkVtzVLoih9o277MGrpSj6OxEx6LTVQ6G834XphAzjESZGVdfNNHsId4OtJZg8sQU3+ShXu+836ZDbRn3ayZEtRB2JZA8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779297478; c=relaxed/simple;
	bh=ww3FYpGNpxTdV6FfdpPAu3f1Iv4ZR/gDGFXUYoqQzJY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HbDLXOGHuoDaXAKKjxXF6u/CPPnD2KCYxKgLAFER4Y7Hv7T6nPYrYhkz8Vx71B9SiMAYIBzsMFVCWpFPJIkXpBSghzJymzqF4aqHpl7QIuf9oDstRbTViRrWmZHCOXDwFws9Pd/AKyL+/gfXB6/1i3MPQw6IVmgrV7xMI0NAdC0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F9DpeBek; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F9DpeBek"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A466E1F00893;
	Wed, 20 May 2026 17:17:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779297476;
	bh=k0mRf2wHuDXlsb2ja+kWXpOzRL7tR7D3adJMXbtUMCY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=F9DpeBekoGxHYeOFbOTGlXiIFYXbJnJ0hlG1ZuS4LQHAODxmEN67e8Y9jiwk1vsiN
	 ikmlJjxX/XmF4pSoVPh1DsK+WUZo4WkoMCzSgUId36crjozfQnuytSojSFZxB94SIZ
	 EIqLcPE+k1p+BgRMngHq+zwxqYJS4p3v8spGfwj4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Biju Das <biju.das.jz@bp.renesas.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 047/957] irqchip/renesas-rzg2l: Fix error path in rzg2l_irqc_common_probe()
Date: Wed, 20 May 2026 18:08:50 +0200
Message-ID: <20260520162135.578618457@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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

From: Biju Das <biju.das.jz@bp.renesas.com>

[ Upstream commit fb74e35f78105efd8635c89b39f4389f567edbdc ]

Replace pm_runtime_put() with pm_runtime_put_sync() when
irq_domain_create_hierarchy() fails to ensure the device suspends
synchronously before devres cleanup disables runtime PM via
pm_runtime_disable().

[ tglx: Fix up subject and change log to be precise ]

Fixes: 7de11369ef30 ("irqchip/renesas-rzg2l: Use devm_pm_runtime_enable()")
Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
Signed-off-by: Thomas Gleixner <tglx@kernel.org>
Link: https://patch.msgid.link/20260325192451.172562-4-biju.das.jz@bp.renesas.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/irqchip/irq-renesas-rzg2l.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/irqchip/irq-renesas-rzg2l.c b/drivers/irqchip/irq-renesas-rzg2l.c
index 1bf19deb02c4e..c938ab1592895 100644
--- a/drivers/irqchip/irq-renesas-rzg2l.c
+++ b/drivers/irqchip/irq-renesas-rzg2l.c
@@ -573,7 +573,7 @@ static int rzg2l_irqc_common_probe(struct platform_device *pdev, struct device_n
 	irq_domain = irq_domain_create_hierarchy(parent_domain, 0, IRQC_NUM_IRQ, dev_fwnode(dev),
 						 &rzg2l_irqc_domain_ops, rzg2l_irqc_data);
 	if (!irq_domain) {
-		pm_runtime_put(dev);
+		pm_runtime_put_sync(dev);
 		return -ENOMEM;
 	}
 
-- 
2.53.0



