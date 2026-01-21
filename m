Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A23D392B76;
	Wed, 21 Jan 2026 18:19:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769019596; cv=none; b=iUD4QM5l9UI1fy3nkLRpMvVbYaaZBuTYWPoZ2RrRaEQtmGItLGukfgsry014SLOWSysM7QgKzrwCEBube8BuFvY37+QlJn326NMNGOFC9v4p5Nk/2yNj/MHN10WtQTuBpmDtkL5x3NiKUQD9u6Ye6427568Dala84fD5bpl/EG0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769019596; c=relaxed/simple;
	bh=85CgaT3WX6Vs8EWWliOREordy/c3+TQY2EVMAGbQzdE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LE0iKRTHHW2H4FXJnkvA/IRgT3QMjDNtLgFPwYwtnG6BPHX4KDpTiErzxXG6AH5wO5+baqKcB3Cknt+HtnJYvTVnH/X5xelxbCXQcehK4w1HRp+P60dz1dPY6ExsjQxeziQLMCuMir1OodHw5pLySibcvl4itEjzaN2yOQIbyRQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NLJ4qtKV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NLJ4qtKV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20FAFC4CEF1;
	Wed, 21 Jan 2026 18:19:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769019595;
	bh=85CgaT3WX6Vs8EWWliOREordy/c3+TQY2EVMAGbQzdE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NLJ4qtKVY793ehh9SauKZyB94zPE/qgkNXX+wyOq1cOsWzm25gilWVPUBSQl2VrCG
	 HPg8DSKK2naGV9nD0/zx7s1MsMPz/Lba8odLTMD1QExMEdWSVH+mwnh8b1Yp5W0nDW
	 4DZYj+NbKEaPHu+NBLtrJ3LFLSFZNAb5l3o4FI5A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Loic Poulain <loic.poulain@oss.qualcomm.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Abel Vesa <abel.vesa@oss.qualcomm.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 050/139] phy: qcom-qusb2: Fix NULL pointer dereference on early suspend
Date: Wed, 21 Jan 2026 19:14:58 +0100
Message-ID: <20260121181413.255330937@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260121181411.452263583@linuxfoundation.org>
References: <20260121181411.452263583@linuxfoundation.org>
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



