Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795054119;
	b=rs4+fecuIpUNbWt95xoEY/aeEpcarpjbjlCLWvd3WfiF+3YU54dC4HaJUF6N+sj58sFC
	 RTccdQP/h9eXjDLvDvrShr8YsUIjWTSRT4sPqX9jf8A/KjHHIp2jrOEzJKR77W3Y0eIyZ
	 D6YEYvSshvP6p8tUMeyb0TrI+/C48Iz0ADWJILmN3AJAGAmnCosJbz3d+z9GoEaxkm7iJ
	 uw4leqknS+a4zhh7yOOFnldFBYhFC69KiVHjYidxBEILqg9NaGApj5HUkfFgziIGqoDIa
	 UoR5/220oGmLa1/ZVStH6w7TMJno89NQyyDcFhmGd+HtffbVLd4d7IrdNdMHc9Bufeg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795054119;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=HGyodgBkDK3y7VRMA3ocG36bu5CI46VRlJLyZFVgrKw=;
	b=Qj9i4hl8ktPLI2HXxGeS09pubNNAFGo3gYfteLvQ8coyE4C9kxB8SnFr6FBe71WSVrMy
	 f9iHaJfLi/VrgayewuBrf02n9YIoqw6zepJgaH/D02ZBHB6C1xKcGIsQn3OZT2J84j1dp
	 83LGrbRAwjf6Pd5fitjY4YNVxtjQULjhhxfhKMHuAYxN9NhGRvHhL8wIgdmEgaqeDX3IT
	 VTfRhw02E0p9XMuGCjSKq+QaI5CtaUV8HlYc7W3kgxOQ9SfufOUV/hDu+Ec2fZ/0/mO79
	 qXC9iiqleprZ800tvXEQ+bn5z7RktV/B02oYAZBGkNyArjvUX3XeikNuNoZZlLBsUFw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Qwj0hUCa;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91CCC606A325;
	Thu, 19 Nov 2026 02:08:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Qwj0hUCa
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2D301F000C4;
	Thu, 19 Nov 2026 02:08:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795054119;
	bh=HGyodgBkDK3y7VRMA3ocG36bu5CI46VRlJLyZFVgrKw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Qwj0hUCadZUZ/AhsvcH2H8iNG15zHWEymj9smi1bG1WEfxuISsOPQG/IMQc63yn/R
	 CEulVQW9x1qF5GEnWwYKXVxCaqJmOXdopYjnRHd4MHSydWpyeYRCB6FEZJd60SpCs2
	 yHWYcFseiArCnnsqkTzexr43doF36AAh66r+dnu4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Song Li <songl@zju.edu.cn>,
	Fan Wu <fanwu01@zju.edu.cn>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1118/2214] power: supply: bq27xxx: Ensure poll work is cancelled on remove
Date: Wed, 18 Nov 2026 15:46:34 +0100
Message-ID: <20261118150056.834069458@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fan Wu <fanwu01@zju.edu.cn>

[ Upstream commit db560f4b1c5253853f978385db066220e0c218dc ]

The di->work poll work is queued from the poll callback itself and from
bq27xxx_external_power_changed(). The cancel_delayed_work_sync() in
bq27xxx_battery_teardown() runs while the power_supply is still
registered, so external_power_changed() can re-arm the work after the
cancel, and it runs after the driver data has been freed.

Register a devm_delayed_work_autocancel() before
devm_power_supply_register(), so on unwind the power_supply is
unregistered first, after which no new external_power_changed()
callback can be dispatched, and the poll work is cancelled only then.
Drop the now-redundant cancel from bq27xxx_battery_teardown().

This issue was found by an in-house static analysis tool.

Fixes: 740b755a3b34 ("bq27x00: Poll battery state")
Cc: stable@vger.kernel.org
Assisted-by: Codex:gpt-5.6
Co-developed-by: Song Li <songl@zju.edu.cn>
Signed-off-by: Song Li <songl@zju.edu.cn>
Signed-off-by: Fan Wu <fanwu01@zju.edu.cn>
Link: https://patch.msgid.link/20260903081312.225535-1-fanwu01@zju.edu.cn
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
[ sashal: added devm_mutex_init() with error handling to replace manual mutex setup and teardown ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/bq27xxx_battery.c | 16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/drivers/power/supply/bq27xxx_battery.c b/drivers/power/supply/bq27xxx_battery.c
index d4c694045209f..6486a039951e5 100644
--- a/drivers/power/supply/bq27xxx_battery.c
+++ b/drivers/power/supply/bq27xxx_battery.c
@@ -43,6 +43,7 @@
  */
 
 #include <linux/device.h>
+#include <linux/devm-helpers.h>
 #include <linux/module.h>
 #include <linux/mutex.h>
 #include <linux/param.h>
@@ -2141,9 +2142,11 @@ int bq27xxx_battery_setup(struct bq27xxx_device_info *di)
 		.of_node = di->dev->of_node,
 		.drv_data = di,
 	};
+	int ret;
 
-	INIT_DELAYED_WORK(&di->work, bq27xxx_battery_poll);
-	mutex_init(&di->lock);
+	ret = devm_mutex_init(di->dev, &di->lock);
+	if (ret)
+		return ret;
 
 	di->regs       = bq27xxx_chip_data[di->chip].regs;
 	di->unseal_key = bq27xxx_chip_data[di->chip].unseal_key;
@@ -2161,6 +2164,12 @@ int bq27xxx_battery_setup(struct bq27xxx_device_info *di)
 	psy_desc->get_property = bq27xxx_battery_get_property;
 	psy_desc->external_power_changed = bq27xxx_external_power_changed;
 
+	/* Cancel the poll work after the power_supply is unregistered. */
+	ret = devm_delayed_work_autocancel(di->dev, &di->work,
+					   bq27xxx_battery_poll);
+	if (ret)
+		return ret;
+
 	di->bat = power_supply_register_no_ws(di->dev, psy_desc, &psy_cfg);
 	if (IS_ERR(di->bat))
 		return dev_err_probe(di->dev, PTR_ERR(di->bat),
@@ -2188,10 +2197,7 @@ void bq27xxx_battery_teardown(struct bq27xxx_device_info *di)
 	di->removed = true;
 	mutex_unlock(&di->lock);
 
-	cancel_delayed_work_sync(&di->work);
-
 	power_supply_unregister(di->bat);
-	mutex_destroy(&di->lock);
 }
 EXPORT_SYMBOL_GPL(bq27xxx_battery_teardown);
 
-- 
2.53.0



