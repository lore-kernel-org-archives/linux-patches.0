Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98E83341666;
	Tue, 16 Dec 2025 11:38:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765885114; cv=none; b=mHzAHrBociM2rdiH9c2izHUVo8QbgDWy+gcMEZalL6XhjkI2FtA1mw2/WZkojSk178G1F3eEHq6SRzc8gy1Fv8RUQkzGqZ6aHsj2w1AQ/M2UBqIBe4XOGpmnE1JApLRM9Txt9rHF7MNyAqR/f4Qg++D6tohR3BdcKam1jma0vKA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765885114; c=relaxed/simple;
	bh=Oc7aCkeo5YKagqTarL5C3axZuhCwEKMeHO9j0tupZk8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q2J2oqpMOGL2JJM7G+y9L/cnOd6lIWut07NETumtvnswUMvue88tO0k1Z38Lgm9ybSHBN+QrhVDPJS7V3HJ3+W3Kws1curR5aU55x8mVYGw9VS2ZzgWRNGAdv9ygRccjBgp/SpD0kia3+vr0qWubPxUcW4IC8WWQR57NFhrcyFA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ltq8bQoR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ltq8bQoR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5C4AC19422;
	Tue, 16 Dec 2025 11:38:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765885114;
	bh=Oc7aCkeo5YKagqTarL5C3axZuhCwEKMeHO9j0tupZk8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ltq8bQoRkJy0zTywhBNbuThij/aaw7/wkgvcqdiATtoPYF7G8AvriX3LyIqXfAGya
	 vT9XCMEDj+/Pf7jJ0Wo03XIqP/r88RddCvI1e16jrb8uJt5x4gqG6DtdPnaEYXHrDj
	 OHcxZUWccNAnqWiqkZMNiHxDGuYNVGaINu1V3KCg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 043/507] irqchip/imx-mu-msi: Fix section mismatch
Date: Tue, 16 Dec 2025 12:08:04 +0100
Message-ID: <20251216111347.103509711@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111345.522190956@linuxfoundation.org>
References: <20251216111345.522190956@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan@kernel.org>

[ Upstream commit 64acfd8e680ff8992c101fe19aadb112ce551072 ]

Platform drivers can be probed after their init sections have been
discarded so the irqchip init callbacks must not live in init.

Fixes: 70afdab904d2 ("irqchip: Add IMX MU MSI controller driver")
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/irqchip/irq-imx-mu-msi.c | 14 +++++---------
 1 file changed, 5 insertions(+), 9 deletions(-)

diff --git a/drivers/irqchip/irq-imx-mu-msi.c b/drivers/irqchip/irq-imx-mu-msi.c
index d2a4e8a61a42b..41df168aa7da2 100644
--- a/drivers/irqchip/irq-imx-mu-msi.c
+++ b/drivers/irqchip/irq-imx-mu-msi.c
@@ -296,9 +296,8 @@ static const struct imx_mu_dcfg imx_mu_cfg_imx8ulp = {
 		  },
 };
 
-static int __init imx_mu_of_init(struct device_node *dn,
-				 struct device_node *parent,
-				 const struct imx_mu_dcfg *cfg)
+static int imx_mu_of_init(struct device_node *dn, struct device_node *parent,
+			  const struct imx_mu_dcfg *cfg)
 {
 	struct platform_device *pdev = of_find_device_by_node(dn);
 	struct device_link *pd_link_a;
@@ -416,20 +415,17 @@ static const struct dev_pm_ops imx_mu_pm_ops = {
 			   imx_mu_runtime_resume, NULL)
 };
 
-static int __init imx_mu_imx7ulp_of_init(struct device_node *dn,
-					 struct device_node *parent)
+static int imx_mu_imx7ulp_of_init(struct device_node *dn, struct device_node *parent)
 {
 	return imx_mu_of_init(dn, parent, &imx_mu_cfg_imx7ulp);
 }
 
-static int __init imx_mu_imx6sx_of_init(struct device_node *dn,
-					struct device_node *parent)
+static int imx_mu_imx6sx_of_init(struct device_node *dn, struct device_node *parent)
 {
 	return imx_mu_of_init(dn, parent, &imx_mu_cfg_imx6sx);
 }
 
-static int __init imx_mu_imx8ulp_of_init(struct device_node *dn,
-					 struct device_node *parent)
+static int imx_mu_imx8ulp_of_init(struct device_node *dn, struct device_node *parent)
 {
 	return imx_mu_of_init(dn, parent, &imx_mu_cfg_imx8ulp);
 }
-- 
2.51.0



