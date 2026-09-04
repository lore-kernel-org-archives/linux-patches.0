Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 848C33BCD0A;
	Fri,  4 Sep 2026 05:55:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788501324; cv=none; b=XUp2jsI4ekwetgbVVlx0ROk1Lu5SJMHb6yFCrpii7qDP471BDR4ZxOOoPWIObh267Udivz4bVq8ioXdoRoilDo57fkRMvf+I+5RLJkwWF17QjfEpacDFGS+ZItzr6YO8T9nOTgdxYN27H9jJldT4WwFnuzj5YsiYvKesCWuktCo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788501324; c=relaxed/simple;
	bh=ZRFlbKbYve4P3ryuORhCUXbNun633IH0YfJHgNeXtvw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kz33uIFeJPS0xHJwoI7kv08CM8VU/En7R+s7BMNlV4RueR4anjyWNbnBOmiz16F6ZWGGDtb1XL1MGbny2tDEs3ETlPvbpp5CugGhV1kY2uHsjC8HygL+0dSFUa49zJ1DslFhQlpqFgKH0aiOtynKJrOFIPD/aTuOn9fyvawv1RU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IyRFFd4s; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IyRFFd4s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D37DC1F00A3D;
	Fri,  4 Sep 2026 05:55:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788501322;
	bh=bMsrcvA72HeAnBeXq5AokkPlf003R0BS0Uia+NGkvSo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IyRFFd4sjH0uld4pdZ0osJLlc9dqMEbUMzhfqxymHYaqoxH/TXrYjBV795r/PQ9OF
	 83KgDCO3pOBrEgxA4L+TodmbfVccIBo3IgDmj6XwteLR1vewH6KOJO6zFDQUyhDX3k
	 AHIo8YYc9irv2GpEH49iXhKYnKd3Vv5dd9HznGwc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fan Wu <fanwu01@zju.edu.cn>,
	Sebastian Reichel <sebastian.reichel@collabora.com>
Subject: [PATCH 6.18 369/552] power: supply: charger-manager: register regulators before exposing sysfs
Date: Fri,  4 Sep 2026 06:58:46 +0200
Message-ID: <20260904045758.592507135@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045747.813364717@linuxfoundation.org>
References: <20260904045747.813364717@linuxfoundation.org>
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

From: Fan Wu <fanwu01@zju.edu.cn>

commit c57cb36f76eb7ced45f57af1a890d8f3a6d76342 upstream.

charger_manager_remove() and the err_reg_extcon probe error path free each
charger regulator with regulator_put() before tearing down the power_supply
sysfs entries (power_supply_unregister()). charger_manager_remove() also
calls try_charger_enable(cm, false) after the regulator_put() loop. A
concurrent write to a charger's externally_control sysfs attribute that
lands between regulator_put() and power_supply_unregister() can run
charger_externally_control_store() and call try_charger_enable(), which,
when charging is enabled, dereferences the already-freed consumer handle.
When charging is enabled, try_charger_enable(cm, false) in .remove() also
dereferences the freed handles directly. Both leave use-after-free windows.
Symmetrically, probe registers the sysfs entries (power_supply_register)
before acquiring the regulators (regulator_get, inside
charger_manager_register_extcon), so userspace can reach externally_control
before the regulators are available.

Split charger_manager_register_extcon() on the sync/async boundary:
charger_manager_get_regulators() (regulator_get only, no async producer)
now runs before power_supply_register() so sysfs is not live before
regulators are available, and charger_manager_register_extcon() keeps only
the extcon notifier/work setup, still after power_supply_register() so a
power_supply_register() failure cannot reach extcon setup. This keeps the
sysfs setup/teardown ordering symmetric without introducing an asynchronous
producer on the earlier probe-error path.

Move power_supply_unregister() and try_charger_enable(cm, false) ahead of
the regulator_put() loop on both teardown paths, and adjust err_reg_extcon
(power_supply_unregister() then fall through err_regulator for
regulator_put(); get_regulators self-rolls back on its own failure).

This does not address the separate extcon-notifier-driven deref of the same
handles, which needs its own synchronization design.

Found by an in-house static analysis tool.

Fixes: 3950c7865cd7 ("charger-manager: Add support sysfs entry for charger")
Cc: stable@vger.kernel.org
Assisted-by: Codex:gpt-5.6
Signed-off-by: Fan Wu <fanwu01@zju.edu.cn>
Link: https://patch.msgid.link/20260728030123.230202-1-fanwu01@zju.edu.cn
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/power/supply/charger-manager.c |   54 +++++++++++++++++++++++----------
 1 file changed, 39 insertions(+), 15 deletions(-)

--- a/drivers/power/supply/charger-manager.c
+++ b/drivers/power/supply/charger-manager.c
@@ -1018,6 +1018,29 @@ static int charger_extcon_init(struct ch
 	return 0;
 }
 
+static int charger_manager_get_regulators(struct charger_manager *cm)
+{
+	struct charger_desc *desc = cm->desc;
+	struct charger_regulator *charger;
+	int i, ret;
+
+	for (i = 0; i < desc->num_charger_regulators; i++) {
+		charger = &desc->charger_regulators[i];
+		charger->consumer = regulator_get(cm->dev,
+						  charger->regulator_name);
+		if (IS_ERR(charger->consumer)) {
+			dev_err(cm->dev, "Cannot find charger(%s)\n",
+				charger->regulator_name);
+			ret = PTR_ERR(charger->consumer);
+			while (i-- > 0)
+				regulator_put(desc->charger_regulators[i].consumer);
+			return ret;
+		}
+		charger->cm = cm;
+	}
+	return 0;
+}
+
 /**
  * charger_manager_register_extcon - Register extcon device to receive state
  *				     of charger cable.
@@ -1040,15 +1063,6 @@ static int charger_manager_register_extc
 	for (i = 0; i < desc->num_charger_regulators; i++) {
 		charger = &desc->charger_regulators[i];
 
-		charger->consumer = regulator_get(cm->dev,
-					charger->regulator_name);
-		if (IS_ERR(charger->consumer)) {
-			dev_err(cm->dev, "Cannot find charger(%s)\n",
-				charger->regulator_name);
-			return PTR_ERR(charger->consumer);
-		}
-		charger->cm = cm;
-
 		for (j = 0; j < charger->num_cables; j++) {
 			struct charger_cable *cable = &charger->cables[j];
 
@@ -1584,13 +1598,23 @@ static int charger_manager_probe(struct
 	}
 	psy_cfg.attr_grp = desc->sysfs_groups;
 
+	/*
+	 * Acquire charger regulators before exposing the sysfs entries, so
+	 * userspace cannot reach externally_control before the regulators
+	 * (and charger->cm) are available.  Mirrors the order in remove().
+	 */
+	ret = charger_manager_get_regulators(cm);
+	if (ret < 0)
+		return ret;
+
 	cm->charger_psy = power_supply_register(&pdev->dev,
 						&cm->charger_psy_desc,
 						&psy_cfg);
 	if (IS_ERR(cm->charger_psy)) {
 		dev_err(&pdev->dev, "Cannot register charger-manager with name \"%s\"\n",
 			cm->charger_psy_desc.name);
-		return PTR_ERR(cm->charger_psy);
+		ret = PTR_ERR(cm->charger_psy);
+		goto err_regulator;
 	}
 
 	/* Register extcon device for charger cable */
@@ -1624,11 +1648,11 @@ static int charger_manager_probe(struct
 	return 0;
 
 err_reg_extcon:
+	power_supply_unregister(cm->charger_psy);
+err_regulator:
 	for (i = 0; i < desc->num_charger_regulators; i++)
 		regulator_put(desc->charger_regulators[i].consumer);
 
-	power_supply_unregister(cm->charger_psy);
-
 	return ret;
 }
 
@@ -1646,12 +1670,12 @@ static void charger_manager_remove(struc
 	cancel_work_sync(&setup_polling);
 	cancel_delayed_work_sync(&cm_monitor_work);
 
-	for (i = 0 ; i < desc->num_charger_regulators ; i++)
-		regulator_put(desc->charger_regulators[i].consumer);
+	try_charger_enable(cm, false);
 
 	power_supply_unregister(cm->charger_psy);
 
-	try_charger_enable(cm, false);
+	for (i = 0 ; i < desc->num_charger_regulators ; i++)
+		regulator_put(desc->charger_regulators[i].consumer);
 }
 
 static const struct platform_device_id charger_manager_id[] = {


