Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062822;
	b=1nAlWwo+770Vf98asi1H62IwSqhGimSDNsnz+kOcmK0vpEPke3JJbnjY6pAztdFEENP1
	 eRh2Aci4276MU8P20+tPY/0In7MuMDo/tMSRJX+iCBpzOofv8cDLab40EwmbotXsLV2qK
	 KDBEw2DbNyklN+/e/+xTL2bgsOGjI99PaQHw6n8oC2mrxJIH7Y1J+JpM7ciSUfH02YCsE
	 Gx8RJVwnGp8IXI8f/6fEl9UZ30OJYi8xmY/mobx6lHhC/NFx2kIBZwmEOEMffSutBLvKq
	 FuoVbDsFXgzUqqeuUFzlcCv9k9yblRQJnzG0MUIYDWyNt36gd+atIWaEOTelrkMsNZA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062822;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=57QiWycvUPmtcigzWDEdXTm0VAO0T/30egl6p0mMY9w=;
	b=KE+ouT4GLcqih6QFAzdgbZmNRj67EZrhGo8no3V+6St01Tn5o07UMhW3/HfcpMaBSt/f
	 gVOX0kQG0MTuFUSEq9Xs8XwcHdKqadFgb/IS/Abf7DXfNO1LfSlMSkOg7kb4FnpEpAK6F
	 Crc5H1FsmFX+PV0Az6EkGqS6Ydg44IPiRmyXXZzxGlIKiuZLehrEFQskgmEuJ+BVIb5xJ
	 9rNst8gedP2PHXeXoMygijV80Lmz010Ao0vSQa4LMHR9/tt6ZNttK02mFyezsXirT8V97
	 lJ3Nkcdfh+1uK57eoHsP4RqxDFhuoZeSfVO3DDMDeuPZhOhdbmhdnPKCJ18Weilh+nA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="pBoGCA7/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B6DC606A336;
	Sat,  7 Nov 2026 14:47:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pBoGCA7/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 361401F0089F;
	Sat,  7 Nov 2026 14:47:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062822;
	bh=57QiWycvUPmtcigzWDEdXTm0VAO0T/30egl6p0mMY9w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pBoGCA7/GC0xsDDuWtx/h5uiNaDBJC4FBTzwNNNGoMJOTq9LVi1MnEaEKr7OtYyI3
	 vvPBNwbnxFVvTIicRb9w3EFL7cK6PsFziMq0vFtZwG30/kZQDtCOIcsVe6adG0Qo3w
	 CgtJBPLRFna5g3yRukZJI5U6hZ552UxNOtIovwU8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Song Li <songl@zju.edu.cn>,
	Fan Wu <fanwu01@zju.edu.cn>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 119/869] power: supply: bq27xxx: Ensure poll work is cancelled on remove
Date: Sat,  7 Nov 2026 08:46:41 -0500
Message-ID: <20261107134856.567374849@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/bq27xxx_battery.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/power/supply/bq27xxx_battery.c b/drivers/power/supply/bq27xxx_battery.c
index 4d4809a70b622..cd30993b8a89e 100644
--- a/drivers/power/supply/bq27xxx_battery.c
+++ b/drivers/power/supply/bq27xxx_battery.c
@@ -43,6 +43,7 @@
  */
 
 #include <linux/device.h>
+#include <linux/devm-helpers.h>
 #include <linux/module.h>
 #include <linux/mutex.h>
 #include <linux/param.h>
@@ -2234,7 +2235,6 @@ int bq27xxx_battery_setup(struct bq27xxx_device_info *di)
 	};
 	int ret;
 
-	INIT_DELAYED_WORK(&di->work, bq27xxx_battery_poll);
 	ret = devm_mutex_init(di->dev, &di->lock);
 	if (ret)
 		return ret;
@@ -2255,6 +2255,12 @@ int bq27xxx_battery_setup(struct bq27xxx_device_info *di)
 	psy_desc->get_property = bq27xxx_battery_get_property;
 	psy_desc->external_power_changed = bq27xxx_external_power_changed;
 
+	/* Cancel the poll work after the power_supply is unregistered. */
+	ret = devm_delayed_work_autocancel(di->dev, &di->work,
+					   bq27xxx_battery_poll);
+	if (ret)
+		return ret;
+
 	di->bat = devm_power_supply_register(di->dev, psy_desc, &psy_cfg);
 	if (IS_ERR(di->bat))
 		return dev_err_probe(di->dev, PTR_ERR(di->bat),
@@ -2281,8 +2287,6 @@ void bq27xxx_battery_teardown(struct bq27xxx_device_info *di)
 	mutex_lock(&di->lock);
 	di->removed = true;
 	mutex_unlock(&di->lock);
-
-	cancel_delayed_work_sync(&di->work);
 }
 EXPORT_SYMBOL_GPL(bq27xxx_battery_teardown);
 
-- 
2.53.0



