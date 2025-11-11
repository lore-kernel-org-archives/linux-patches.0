Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFACA2DECB0;
	Tue, 11 Nov 2025 01:31:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762824712; cv=none; b=KF9Tt2/2DWHfvdP8yBD9rjoXrBLTUHx4nef45VUnw4TEfrO3YmpIklKkjpTWRJ1iVbdO1/ixuqG1g4gQtz53kq63s8D80LNWxlN72f6QFwxOUgu++aV75uC3Jzx3p/8i55cyNM0MHuFiUxgs2bW/0+iNLhvr/XC9zbLfMgUd6Hg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762824712; c=relaxed/simple;
	bh=8xE8asWKcU2j6EaDS4TPo9GWW+6nKdUkw/JG9G0DaN4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QqgDQoI6eVykHZaxFnYUmV0oMlnDEiTpLNYxTTeSmgnEbfScoRDeeU3huz7o57aTJuZ9I2N4zUELUIPI4uzUgQdz5U1lx1N84jFBI7uNxidn/mmW8jOnQVrcyW4ivMWn5ImtNR/mBgnFwXpLfTMFr71XSLxupGHGUsAQ9iNn6ME=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Qm/AMgVj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Qm/AMgVj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F6ACC4CEFB;
	Tue, 11 Nov 2025 01:31:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762824711;
	bh=8xE8asWKcU2j6EaDS4TPo9GWW+6nKdUkw/JG9G0DaN4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Qm/AMgVj8P8rIZxivS78p+IoPGheOLMMnAUmyV30yu7KrzD+E4Nsd4DCkGoOovYde
	 J6z17F0AvIWGuntE1OnULTimxw43SVt8++5p8762FDaEum/AdvhlvKWS/HXrwCqgcE
	 VSvBHLc60gueNjyCyknAjerL6mwAfCmEHsFihwF0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jack Kao <jack.kao@mediatek.com>,
	Ming Yen Hsieh <mingyen.hsieh@mediatek.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 537/849] wifi: mt76: mt7925: add pci restore for hibernate
Date: Tue, 11 Nov 2025 09:41:47 +0900
Message-ID: <20251111004549.398434980@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

From: Jack Kao <jack.kao@mediatek.com>

[ Upstream commit d54424fbc53b4d6be00f90a8b529cd368f20d357 ]

Due to hibernation causing a power off and power on,
this modification adds mt7925_pci_restore callback function for kernel.
When hibernation resumes, it calls mt7925_pci_restore to reset the device,
allowing it to return to the state it was in before the power off.

Signed-off-by: Jack Kao <jack.kao@mediatek.com>
Signed-off-by: Ming Yen Hsieh <mingyen.hsieh@mediatek.com>
Link: https://patch.msgid.link/20250901073200.230033-1-mingyen.hsieh@mediatek.com
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/wireless/mediatek/mt76/mt7925/pci.c   | 26 ++++++++++++++++---
 1 file changed, 23 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/pci.c b/drivers/net/wireless/mediatek/mt76/mt7925/pci.c
index 89dc30f7c6b7a..8eb1fe1082d15 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/pci.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/pci.c
@@ -529,7 +529,7 @@ static int mt7925_pci_suspend(struct device *device)
 	return err;
 }
 
-static int mt7925_pci_resume(struct device *device)
+static int _mt7925_pci_resume(struct device *device, bool restore)
 {
 	struct pci_dev *pdev = to_pci_dev(device);
 	struct mt76_dev *mdev = pci_get_drvdata(pdev);
@@ -569,6 +569,9 @@ static int mt7925_pci_resume(struct device *device)
 	napi_schedule(&mdev->tx_napi);
 	local_bh_enable();
 
+	if (restore)
+		goto failed;
+
 	mt76_connac_mcu_set_hif_suspend(mdev, false, false);
 	ret = wait_event_timeout(dev->wait,
 				 dev->hif_resumed, 3 * HZ);
@@ -585,7 +588,7 @@ static int mt7925_pci_resume(struct device *device)
 failed:
 	pm->suspended = false;
 
-	if (err < 0)
+	if (err < 0 || restore)
 		mt792x_reset(&dev->mt76);
 
 	return err;
@@ -596,7 +599,24 @@ static void mt7925_pci_shutdown(struct pci_dev *pdev)
 	mt7925_pci_remove(pdev);
 }
 
-static DEFINE_SIMPLE_DEV_PM_OPS(mt7925_pm_ops, mt7925_pci_suspend, mt7925_pci_resume);
+static int mt7925_pci_resume(struct device *device)
+{
+	return _mt7925_pci_resume(device, false);
+}
+
+static int mt7925_pci_restore(struct device *device)
+{
+	return _mt7925_pci_resume(device, true);
+}
+
+static const struct dev_pm_ops mt7925_pm_ops = {
+	.suspend = pm_sleep_ptr(mt7925_pci_suspend),
+	.resume  = pm_sleep_ptr(mt7925_pci_resume),
+	.freeze = pm_sleep_ptr(mt7925_pci_suspend),
+	.thaw = pm_sleep_ptr(mt7925_pci_resume),
+	.poweroff = pm_sleep_ptr(mt7925_pci_suspend),
+	.restore = pm_sleep_ptr(mt7925_pci_restore),
+};
 
 static struct pci_driver mt7925_pci_driver = {
 	.name		= KBUILD_MODNAME,
-- 
2.51.0



