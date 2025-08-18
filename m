Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4F2A335BA3;
	Mon, 18 Aug 2025 13:48:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755524905; cv=none; b=PlubFnpGuWvmCQEtwXiuYIXeDrJNfx/xO+lZ6iGjhpn9r6resxtbynYlqD13jL8+R/tFrKnnsEQBG4jX62hCHi19I2gn8p8+wTPpA1q5g37gl7y8GQyJi/NO4iqs4N9wTL3CcNbA28BdUVyLQlwt7xpFlVVlSFv0XHg5PRGrBkU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755524905; c=relaxed/simple;
	bh=7l2YmgdZzMKz9Ikult+SzNwdm/OL2tUYjcL1SagTgkI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bTngAH87pQkvLpl9bSWZXIEygJAEDSig/OmH2EvX3yHDka07z3OX0nxJnqTa8my4zWd5f3tsk6Rn0pBUd+BU4v8dZdz9/9GD514Lk/jkwzGdArGR0GcVNYhP93oM8mdOuhMNgwM8GFuiJEBAjrEW7WplSSx6iKrEFdpbj4Vcn5M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FpUnoLHP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FpUnoLHP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4488BC4CEEB;
	Mon, 18 Aug 2025 13:48:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755524905;
	bh=7l2YmgdZzMKz9Ikult+SzNwdm/OL2tUYjcL1SagTgkI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FpUnoLHPm6r/aR3W8AOAnkCpMAsMrBAky9aQRN1X/3NnqiqVy32R26xiiwj03H/sM
	 Chn7w6U+XAQ6RlaKumeC5zZsodGaOM2oNuyXo9ivX8Y2Fq8lQYKII29TP8tnK2AMO/
	 +f5sU5JMUQhPCDBKQq966JUiZYI5Bhuh6GLQunSo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jijie Shao <shaojijie@huawei.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 067/570] net: hibmcge: fix rtnl deadlock issue
Date: Mon, 18 Aug 2025 14:40:54 +0200
Message-ID: <20250818124508.394288263@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124505.781598737@linuxfoundation.org>
References: <20250818124505.781598737@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jijie Shao <shaojijie@huawei.com>

[ Upstream commit c875503a9b9082928d7d3fc60b5400d16fbfae4e ]

Currently, the hibmcge netdev acquires the rtnl_lock in
pci_error_handlers.reset_prepare() and releases it in
pci_error_handlers.reset_done().

However, in the PCI framework:
pci_reset_bus - __pci_reset_slot - pci_slot_save_and_disable_locked -
 pci_dev_save_and_disable - err_handler->reset_prepare(dev);

In pci_slot_save_and_disable_locked():
	list_for_each_entry(dev, &slot->bus->devices, bus_list) {
		if (!dev->slot || dev->slot!= slot)
			continue;
		pci_dev_save_and_disable(dev);
		if (dev->subordinate)
			pci_bus_save_and_disable_locked(dev->subordinate);
	}

This will iterate through all devices under the current bus and execute
err_handler->reset_prepare(), causing two devices of the hibmcge driver
to sequentially request the rtnl_lock, leading to a deadlock.

Since the driver now executes netif_device_detach()
before the reset process, it will not concurrently with
other netdev APIs, so there is no need to hold the rtnl_lock now.

Therefore, this patch removes the rtnl_lock during the reset process and
adjusts the position of HBG_NIC_STATE_RESETTING to ensure
that multiple resets are not executed concurrently.

Fixes: 3f5a61f6d504f ("net: hibmcge: Add reset supported in this module")
Signed-off-by: Jijie Shao <shaojijie@huawei.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/hisilicon/hibmcge/hbg_err.c | 14 +++++---------
 1 file changed, 5 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hibmcge/hbg_err.c b/drivers/net/ethernet/hisilicon/hibmcge/hbg_err.c
index ff3295b60a69..dee1e8681157 100644
--- a/drivers/net/ethernet/hisilicon/hibmcge/hbg_err.c
+++ b/drivers/net/ethernet/hisilicon/hibmcge/hbg_err.c
@@ -53,9 +53,11 @@ static int hbg_reset_prepare(struct hbg_priv *priv, enum hbg_reset_type type)
 {
 	int ret;
 
-	ASSERT_RTNL();
+	if (test_and_set_bit(HBG_NIC_STATE_RESETTING, &priv->state))
+		return -EBUSY;
 
 	if (netif_running(priv->netdev)) {
+		clear_bit(HBG_NIC_STATE_RESETTING, &priv->state);
 		dev_warn(&priv->pdev->dev,
 			 "failed to reset because port is up\n");
 		return -EBUSY;
@@ -64,7 +66,6 @@ static int hbg_reset_prepare(struct hbg_priv *priv, enum hbg_reset_type type)
 	netif_device_detach(priv->netdev);
 
 	priv->reset_type = type;
-	set_bit(HBG_NIC_STATE_RESETTING, &priv->state);
 	clear_bit(HBG_NIC_STATE_RESET_FAIL, &priv->state);
 	ret = hbg_hw_event_notify(priv, HBG_HW_EVENT_RESET);
 	if (ret) {
@@ -83,28 +84,25 @@ static int hbg_reset_done(struct hbg_priv *priv, enum hbg_reset_type type)
 	    type != priv->reset_type)
 		return 0;
 
-	ASSERT_RTNL();
-
-	clear_bit(HBG_NIC_STATE_RESETTING, &priv->state);
 	ret = hbg_rebuild(priv);
 	if (ret) {
 		set_bit(HBG_NIC_STATE_RESET_FAIL, &priv->state);
+		clear_bit(HBG_NIC_STATE_RESETTING, &priv->state);
 		dev_err(&priv->pdev->dev, "failed to rebuild after reset\n");
 		return ret;
 	}
 
 	netif_device_attach(priv->netdev);
+	clear_bit(HBG_NIC_STATE_RESETTING, &priv->state);
 
 	dev_info(&priv->pdev->dev, "reset done\n");
 	return ret;
 }
 
-/* must be protected by rtnl lock */
 int hbg_reset(struct hbg_priv *priv)
 {
 	int ret;
 
-	ASSERT_RTNL();
 	ret = hbg_reset_prepare(priv, HBG_RESET_TYPE_FUNCTION);
 	if (ret)
 		return ret;
@@ -169,7 +167,6 @@ static void hbg_pci_err_reset_prepare(struct pci_dev *pdev)
 	struct net_device *netdev = pci_get_drvdata(pdev);
 	struct hbg_priv *priv = netdev_priv(netdev);
 
-	rtnl_lock();
 	hbg_reset_prepare(priv, HBG_RESET_TYPE_FLR);
 }
 
@@ -179,7 +176,6 @@ static void hbg_pci_err_reset_done(struct pci_dev *pdev)
 	struct hbg_priv *priv = netdev_priv(netdev);
 
 	hbg_reset_done(priv, HBG_RESET_TYPE_FLR);
-	rtnl_unlock();
 }
 
 static const struct pci_error_handlers hbg_pci_err_handler = {
-- 
2.50.1



