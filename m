Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE90532862F;
	Tue, 16 Dec 2025 11:20:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765884012; cv=none; b=XCqdp2AgLGmHrPWewfZEtMHflpivp+RHBpRvHy+CnnTbRsMpLcdafg30evlPCK+qbJikJCs0gB1Wdl2o75228mmNq1XnTqMFbnGpV6R38wAxXbtHXwEBr2M2kGbUQ8DqNFjITeqckrSSnQ/bCUfwwxXMWVJmmyoCaFWDv8auifo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765884012; c=relaxed/simple;
	bh=Sls7WTI28KgdVbJbsAR84khPW0HBzaVIKgBG+1RABpE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SZ5GDhRdtCm/k+VKtYqzVZeDTS+AGBgGFl/ejvK8jDOYhilmbKhc4OQbuuNwdwe/8wNC1xy7aBRKUB8UTK2I2TfYtoi/9CvDQRK0UTNz2bZSkX8svZSrxABCaPiL3Oc/jCCN9NRnLBnJUk83FsyiXi/f/fHX1Le3ujccfGBxYtM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TjSF0efl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TjSF0efl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BF33C4CEF1;
	Tue, 16 Dec 2025 11:20:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765884011;
	bh=Sls7WTI28KgdVbJbsAR84khPW0HBzaVIKgBG+1RABpE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TjSF0eflEoFWf2FJJlTVpuT+awZpYP4D34lZY4SwUCzm4SeZjovhHQrHDnhiVlisZ
	 g0C4RoqubginO2OHC7FI7MPG/1DY85L9L5bJINStmtDFphQBA9Z0q/c9islrywHqMf
	 WG7DceBGQg3wtiqAx+bHjFR8CFJjvpSU5oOoReGk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 033/354] irqchip/imx-mu-msi: Fix section mismatch
Date: Tue, 16 Dec 2025 12:10:00 +0100
Message-ID: <20251216111322.112287899@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111320.896758933@linuxfoundation.org>
References: <20251216111320.896758933@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 4342a21de1eb0..b14b2e6db0b5c 100644
--- a/drivers/irqchip/irq-imx-mu-msi.c
+++ b/drivers/irqchip/irq-imx-mu-msi.c
@@ -295,9 +295,8 @@ static const struct imx_mu_dcfg imx_mu_cfg_imx8ulp = {
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
@@ -415,20 +414,17 @@ static const struct dev_pm_ops imx_mu_pm_ops = {
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



