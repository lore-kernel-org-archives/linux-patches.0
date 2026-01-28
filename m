Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D15C724DFF9;
	Wed, 28 Jan 2026 15:30:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769614215; cv=none; b=Jv9/ke39O/ilxsuavVsDiQv1UdCVho1LPxcDAxUt/j8ojs5W8Kb9kEubctyUgHsxZEgL0VG+ImJBmnmNiv3A4U3qd0ctv/+ljaIzJL1C7CfchU46ZneGhZ4AosOYsa6bSonaHfUmPUHB+nZ/eyE9tnlm/UULZ35DHzfHJbtErOc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769614215; c=relaxed/simple;
	bh=75JTW3wYnLN9M3nHjtalZBH0WtVcUQmYgNb3seo3rhg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mbY1hCQCcMMDnn/2MfgLEW0v2LLJL1ZucJlN43kk8mNnxwsMvJScAetnjYwi3xnQUAEXANTI6994GRO1wkPv2KwqFMXiXfrAwEjlgWS88R9yC15bvOG4Ra+ze+r99uN3tqoK2+iEHAw9TIEzG2yPCXShAHrzrXZoOobieN6u12o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L5Ei5lKO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L5Ei5lKO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05B97C4CEF1;
	Wed, 28 Jan 2026 15:30:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769614215;
	bh=75JTW3wYnLN9M3nHjtalZBH0WtVcUQmYgNb3seo3rhg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L5Ei5lKOjqek7O1h9zs4benJKYTSl0iWGFxHaTUB1TtQmIkcP+n6pi9yqtZv0c1Du
	 kAA7yd5FliQvcJeybof3NrOPOYhr8fVA8oVEgfdSX1dlYUOzihDDzeP02YENdha0mq
	 6JXFTtGIkPMrrtyTJtTgF9QCiAnM+TNvgwwunOMs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Loic Poulain <loic.poulain@oss.qualcomm.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Abel Vesa <abel.vesa@oss.qualcomm.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 038/254] phy: qcom-qusb2: Fix NULL pointer dereference on early suspend
Date: Wed, 28 Jan 2026 16:20:14 +0100
Message-ID: <20260128145346.072981063@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260128145344.698118637@linuxfoundation.org>
References: <20260128145344.698118637@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Loic Poulain <loic.poulain@oss.qualcomm.com>

[ Upstream commit 1ca52c0983c34fca506921791202ed5bdafd5306 ]

Enabling runtime PM before attaching the QPHY instance as driver data
can lead to a NULL pointer dereference in runtime PM callbacks that
expect valid driver data. There is a small window where the suspend
callback may run after PM runtime enabling and before runtime forbid.
This causes a sporadic crash during boot:

```
Unable to handle kernel NULL pointer dereference at virtual address 00000000000000a1
[...]
CPU: 0 UID: 0 PID: 11 Comm: kworker/0:1 Not tainted 6.16.7+ #116 PREEMPT
Workqueue: pm pm_runtime_work
pstate: 20000005 (nzCv daif -PAN -UAO -TCO -DIT -SSBS BTYPE=--)
pc : qusb2_phy_runtime_suspend+0x14/0x1e0 [phy_qcom_qusb2]
lr : pm_generic_runtime_suspend+0x2c/0x44
[...]
```

Attach the QPHY instance as driver data before enabling runtime PM to
prevent NULL pointer dereference in runtime PM callbacks.

Reorder pm_runtime_enable() and pm_runtime_forbid() to prevent a
short window where an unnecessary runtime suspend can occur.

Use the devres-managed version to ensure PM runtime is symmetrically
disabled during driver removal for proper cleanup.

Fixes: 891a96f65ac3 ("phy: qcom-qusb2: Add support for runtime PM")
Signed-off-by: Loic Poulain <loic.poulain@oss.qualcomm.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Reviewed-by: Abel Vesa <abel.vesa@oss.qualcomm.com>
Link: https://patch.msgid.link/20251219085640.114473-1-loic.poulain@oss.qualcomm.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/phy/qualcomm/phy-qcom-qusb2.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/phy/qualcomm/phy-qcom-qusb2.c b/drivers/phy/qualcomm/phy-qcom-qusb2.c
index 531c3860c3160..d3c26a39873f7 100644
--- a/drivers/phy/qualcomm/phy-qcom-qusb2.c
+++ b/drivers/phy/qualcomm/phy-qcom-qusb2.c
@@ -1063,29 +1063,29 @@ static int qusb2_phy_probe(struct platform_device *pdev)
 		or->hsdisc_trim.override = true;
 	}
 
-	pm_runtime_set_active(dev);
-	pm_runtime_enable(dev);
+	dev_set_drvdata(dev, qphy);
+
 	/*
-	 * Prevent runtime pm from being ON by default. Users can enable
-	 * it using power/control in sysfs.
+	 * Enable runtime PM support, but forbid it by default.
+	 * Users can allow it again via the power/control attribute in sysfs.
 	 */
+	pm_runtime_set_active(dev);
 	pm_runtime_forbid(dev);
+	ret = devm_pm_runtime_enable(dev);
+	if (ret)
+		return ret;
 
 	generic_phy = devm_phy_create(dev, NULL, &qusb2_phy_gen_ops);
 	if (IS_ERR(generic_phy)) {
 		ret = PTR_ERR(generic_phy);
 		dev_err(dev, "failed to create phy, %d\n", ret);
-		pm_runtime_disable(dev);
 		return ret;
 	}
 	qphy->phy = generic_phy;
 
-	dev_set_drvdata(dev, qphy);
 	phy_set_drvdata(generic_phy, qphy);
 
 	phy_provider = devm_of_phy_provider_register(dev, of_phy_simple_xlate);
-	if (IS_ERR(phy_provider))
-		pm_runtime_disable(dev);
 
 	return PTR_ERR_OR_ZERO(phy_provider);
 }
-- 
2.51.0



