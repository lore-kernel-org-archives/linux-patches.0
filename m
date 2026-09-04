Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46F6B351C04;
	Fri,  4 Sep 2026 05:29:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788499792; cv=none; b=n2a6roMPIpkYGQ70MmcgdbK+nuFF3NGrNxCLzhrfmjKjTmCtWMOJLUqS3DkFHOjE7Y+9ly2OQm+bs3hjInerkZy7BDha4lkDSUgRpaqCmBo74nxJ1OVz1FfUo84esHHOitnhSlbeLlqMJi33GlyOMQCuJfyf6gMqY5ICz5kMVuI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788499792; c=relaxed/simple;
	bh=3ayhD3I6J1/SlqhazK7KbPA8EzotQW9AjxNnTbnrxO8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f4jsWlcfN+zA0HzSAznwkb0ZsrZ+DdHPFbB0Mm3qbnpVk6vVNKJ8XJKhnaadM1qznJdNBLEvbaMv4pxy93cHouymRh5Zv/v3awyh77tiG95RSyVf8yepUaPUbM+gc78HC+Lh40A6o4mZuiQilsYPjdDnTIqSIGLx4ozqHfvi43g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jS9J7m4w; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jS9J7m4w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C0381F00A3D;
	Fri,  4 Sep 2026 05:29:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788499790;
	bh=awyFo2RO+rPh14mLgnnlaM1o7SCrx5uu39agBcJwSPU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jS9J7m4wVs1Qe3gXlfjpjRASyZWJgabMkjeodXW15YoBoIrNWp5uyfXGLG7vJ+dqq
	 QaodUrQG+GSL6N7EbqTbhnpi/k4SnBNzbg160erYgAiYgXLB7FkGqI7akY4I3Oh5nc
	 KsYms3reFHAxf82hL8fgfswLHGczudnYihGttNDc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fan Wu <fanwu01@zju.edu.cn>,
	Sebastian Reichel <sebastian.reichel@collabora.com>
Subject: [PATCH 7.2 499/713] power: supply: bq256xx: drain usb_work before freeing the charger
Date: Fri,  4 Sep 2026 06:57:47 +0200
Message-ID: <20260904045815.011520693@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fan Wu <fanwu01@zju.edu.cn>

commit 2dd6cd823777bea6d9a880a12a92a73ec76aee0b upstream.

The USB-PHY notifier queues usb_work, whose handler calls
power_supply_changed(bq->charger). The reset devm action only unregisters
the notifier and was registered before the power supplies, so devm frees
bq->charger on unwind before the action runs; a usb_work still queued can
then dereference it.

Register the reset action after the power supplies, so it unregisters
the notifiers and drains usb_work before the supplies are released.
Initialize usb_work and obtain the PHY references before registering
the notifiers, so the worker cannot run before the supplies exist.

Found by static analysis.

Fixes: 32e4978bb920 ("power: supply: bq256xx: Introduce the BQ256XX charger driver")
Cc: stable@vger.kernel.org
Assisted-by: Codex:gpt-5.6
Signed-off-by: Fan Wu <fanwu01@zju.edu.cn>
Link: https://patch.msgid.link/20260804145511.103470-1-fanwu01@zju.edu.cn
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/power/supply/bq256xx_charger.c |   29 +++++++++++++++--------------
 1 file changed, 15 insertions(+), 14 deletions(-)

--- a/drivers/power/supply/bq256xx_charger.c
+++ b/drivers/power/supply/bq256xx_charger.c
@@ -896,6 +896,8 @@ static void bq256xx_charger_reset(void *
 
 	if (!IS_ERR_OR_NULL(bq->usb3_phy))
 		usb_unregister_notifier(bq->usb3_phy, &bq->usb_nb);
+
+	cancel_work_sync(&bq->usb_work);
 }
 
 static int bq256xx_set_charger_property(struct power_supply *psy,
@@ -1721,24 +1723,12 @@ static int bq256xx_probe(struct i2c_clie
 		return ret;
 	}
 
-	ret = devm_add_action_or_reset(dev, bq256xx_charger_reset, bq);
-	if (ret)
-		return ret;
+	INIT_WORK(&bq->usb_work, bq256xx_usb_work);
+	bq->usb_nb.notifier_call = bq256xx_usb_notifier;
 
 	/* OTG reporting */
 	bq->usb2_phy = devm_usb_get_phy(dev, USB_PHY_TYPE_USB2);
-	if (!IS_ERR_OR_NULL(bq->usb2_phy)) {
-		INIT_WORK(&bq->usb_work, bq256xx_usb_work);
-		bq->usb_nb.notifier_call = bq256xx_usb_notifier;
-		usb_register_notifier(bq->usb2_phy, &bq->usb_nb);
-	}
-
 	bq->usb3_phy = devm_usb_get_phy(dev, USB_PHY_TYPE_USB3);
-	if (!IS_ERR_OR_NULL(bq->usb3_phy)) {
-		INIT_WORK(&bq->usb_work, bq256xx_usb_work);
-		bq->usb_nb.notifier_call = bq256xx_usb_notifier;
-		usb_register_notifier(bq->usb3_phy, &bq->usb_nb);
-	}
 
 	ret = bq256xx_power_supply_init(bq, &psy_cfg, dev);
 	if (ret) {
@@ -1746,6 +1736,17 @@ static int bq256xx_probe(struct i2c_clie
 		return ret;
 	}
 
+	/* Register after the power supplies so devm runs it first. */
+	ret = devm_add_action_or_reset(dev, bq256xx_charger_reset, bq);
+	if (ret)
+		return ret;
+
+	if (!IS_ERR_OR_NULL(bq->usb2_phy))
+		usb_register_notifier(bq->usb2_phy, &bq->usb_nb);
+
+	if (!IS_ERR_OR_NULL(bq->usb3_phy))
+		usb_register_notifier(bq->usb3_phy, &bq->usb_nb);
+
 	if (client->irq) {
 		ret = devm_request_threaded_irq(dev, client->irq, NULL,
 						bq256xx_irq_handler_thread,


