Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16E6A2737EE;
	Fri,  9 Jan 2026 12:25:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767961547; cv=none; b=RplJ+uz2CWWaPRQypktjhAKELr4cXEb9zPygE6A28gc+2AKAbPkddU9R5DLcv4h55rTU207lHUSSesh/T3TsPBG08yWxr+VLIEPY92xDaB2mne0dLryrCGkpuTqhCVqIPDeKmCPW+XQmwVm6X6Z15r3Ghjy9U6p8tLLRVSsHhOc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767961547; c=relaxed/simple;
	bh=Mn1/MLBSHJ6eiVIxqOjADrv0c4cGHwSEiM2MpJJXKDM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aGn+hn8lY3L5MxRfNoBtn1JNr11RZhErjyLd4SvjkOpSa/YwY+DLUgEkEdv9+lTnZHT/sq19XW+khQXIsTiIvYUwWTqbweQjmYiDTrxgOqzosCJUIDTbI4JNATPvIvV90XVH370vZugcq9tnz5jZjFQCz8ZVbmO3QsJhuk3Hqcw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bobypMZC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bobypMZC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C9D4C4CEF1;
	Fri,  9 Jan 2026 12:25:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767961546;
	bh=Mn1/MLBSHJ6eiVIxqOjADrv0c4cGHwSEiM2MpJJXKDM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bobypMZC/Cy5ZdjsBHL2kPfrpremD1b0QzfKmrhNc1PS2TpzRJfk9OmTs5UXp9Jxj
	 Z370pbauv0r/Anv19qSHTWtdGr1EDwLrEP8IMu1gpabiAlIMwm042wdchdHVlZlM4n
	 CWzxO11Xqid7B2NKnEpTpAcavaq7q4hgjUUE1ugg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 052/634] irqchip/imx-mu-msi: Fix section mismatch
Date: Fri,  9 Jan 2026 12:35:30 +0100
Message-ID: <20260109112119.402992933@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112117.407257400@linuxfoundation.org>
References: <20260109112117.407257400@linuxfoundation.org>
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
index 229039eda1b1f..9b158d0043fb4 100644
--- a/drivers/irqchip/irq-imx-mu-msi.c
+++ b/drivers/irqchip/irq-imx-mu-msi.c
@@ -303,9 +303,8 @@ static const struct imx_mu_dcfg imx_mu_cfg_imx8ulp = {
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
@@ -423,20 +422,17 @@ static const struct dev_pm_ops imx_mu_pm_ops = {
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



