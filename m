Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C36AA34403E
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:03:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301838; cv=none; b=BzXJM6eUNpdaKnPwxH1hzWBaZBh+gk7TbWLs28BY8jxnUbdv81Env09+IY/Rn+8sFao4BVyXA3+f9Kfpe6o3/exm9q6haZhsQklew0x4TZ/fQmQNbu1ucqJnM6+CRyh+uk3ysweNxUoyJaNPJhjlIUTIZKiReIJeR4YAGOMlOG4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301838; c=relaxed/simple;
	bh=OlUH0PI4B9p/J7S5Gm+/pfjm3CPCoPeNUJiK76/JvDg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Dmbm6PmPzi7IJRxa+TQ+qrzdkdkfsF5LRpweaU8D36gsZ9RHkD8lkcIPVdBJMlnwJ/4ZEpcBVXLZmInK2hUkOnbeZaETg+pHiS/ypBb/eJOezwXHr/sXGiujXIGUlr7jKqw74W2dtTQZgavH1+2ssOxkTjxazDsN7WsMDL7st40=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=P+ZeYTgY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="P+ZeYTgY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C74FC19423;
	Sat, 28 Feb 2026 18:03:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301838;
	bh=OlUH0PI4B9p/J7S5Gm+/pfjm3CPCoPeNUJiK76/JvDg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=P+ZeYTgYPu2jwUprfpfM7gwk1ZOnT8ViwBEPD1BHhkzDYcp/xf8SJTJwyObLyBX18
	 eUvECTs9Kh9/RB5u20Fti67kS3lzhJ8jkNhXCdaTEHM5b1q0ROZQTc3gffKMhjSG8Q
	 DKX3ZsACEgvbwQIM0iTXVCOavskfgfMQuhxbaLjn4s9Diralcwz/M19ozNqVhexQp7
	 UDT15gEfu8brCipE2uK8HUe+dDlycVWlyuhRGRPJKtGxwIy9ceDzTd2Vx8f1AXwdyb
	 hbhVWXwjXtR1Xka9rXIpvENuHZprbkE0flhFl3qKWyKRKbW0iYciTcQiRyBacCuoLP
	 0jJfUM5QtG/DA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Waqar Hameed <waqar.hameed@axis.com>,
	Nikita Travkin <nikita@trvn.ru>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 257/385] power: supply: pm8916_lbc: Fix use-after-free in power_supply_changed()
Date: Sat, 28 Feb 2026 12:57:59 -0500
Message-ID: <20260228180011.1568201-257-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180011.1568201-1-sashal@kernel.org>
References: <20260228180011.1568201-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Waqar Hameed <waqar.hameed@axis.com>

[ Upstream commit b7508129978ae1e2ed9b0410396abc05def9c4eb ]

Using the `devm_` variant for requesting IRQ _before_ the `devm_`
variant for allocating/registering the `power_supply` handle, means that
the `power_supply` handle will be deallocated/unregistered _before_ the
interrupt handler (since `devm_` naturally deallocates in reverse
allocation order). This means that during removal, there is a race
condition where an interrupt can fire just _after_ the `power_supply`
handle has been freed, *but* just _before_ the corresponding
unregistration of the IRQ handler has run.

This will lead to the IRQ handler calling `power_supply_changed()` with
a freed `power_supply` handle. Which usually crashes the system or
otherwise silently corrupts the memory...

Note that there is a similar situation which can also happen during
`probe()`; the possibility of an interrupt firing _before_ registering
the `power_supply` handle. This would then lead to the nasty situation
of using the `power_supply` handle *uninitialized* in
`power_supply_changed()`.

Fix this racy use-after-free by making sure the IRQ is requested _after_
the registration of the `power_supply` handle.

Fixes: f8d7a3d21160 ("power: supply: Add driver for pm8916 lbc")
Signed-off-by: Waqar Hameed <waqar.hameed@axis.com>
Reviewed-by: Nikita Travkin <nikita@trvn.ru>
Link: https://patch.msgid.link/64d8dd3675a4e59fa32c3e0ef451f12d1f7ed18f.1766268280.git.waqar.hameed@axis.com
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/pm8916_lbc.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/power/supply/pm8916_lbc.c b/drivers/power/supply/pm8916_lbc.c
index 6d92e98cbecc6..ab324ce3b8721 100644
--- a/drivers/power/supply/pm8916_lbc.c
+++ b/drivers/power/supply/pm8916_lbc.c
@@ -274,15 +274,6 @@ static int pm8916_lbc_charger_probe(struct platform_device *pdev)
 		return dev_err_probe(dev, -EINVAL,
 				     "Wrong amount of reg values: %d (4 expected)\n", len);
 
-	irq = platform_get_irq_byname(pdev, "usb_vbus");
-	if (irq < 0)
-		return irq;
-
-	ret = devm_request_threaded_irq(dev, irq, NULL, pm8916_lbc_charger_state_changed_irq,
-					IRQF_ONESHOT, "pm8916_lbc", chg);
-	if (ret)
-		return ret;
-
 	ret = device_property_read_u32_array(dev, "reg", chg->reg, len);
 	if (ret)
 		return ret;
@@ -332,6 +323,15 @@ static int pm8916_lbc_charger_probe(struct platform_device *pdev)
 	if (ret)
 		return dev_err_probe(dev, ret, "Unable to get battery info\n");
 
+	irq = platform_get_irq_byname(pdev, "usb_vbus");
+	if (irq < 0)
+		return irq;
+
+	ret = devm_request_threaded_irq(dev, irq, NULL, pm8916_lbc_charger_state_changed_irq,
+					IRQF_ONESHOT, "pm8916_lbc", chg);
+	if (ret)
+		return ret;
+
 	chg->edev = devm_extcon_dev_allocate(dev, pm8916_lbc_charger_cable);
 	if (IS_ERR(chg->edev))
 		return PTR_ERR(chg->edev);
-- 
2.51.0

