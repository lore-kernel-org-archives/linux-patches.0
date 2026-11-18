Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795018452;
	b=d/IAuWhjVYYyqvC3wvFv5VS/zS2bzJ4mXTk7Hyr157KlgvqfonF1c4/slbecjTBV6ki/
	 RsYZhM80TqF5aaGXA1GaeBK8l5JE5AMIahchg1q/CX8DiXcP0ia1bF2Na+aoLE0R5NVxe
	 656lnZMuNRLTc8Zc6CUl93v7n/1pr9U22zFz5cQ1NhYTEJQ+b3G5N64pvamBM8v0ny/GH
	 l6/YD2GVQTYqBfcD1pFv1lN38CtnV2f5uGIEdzlXfb9LBHK4YoxagTMdOnhTKlZplg/qF
	 ngkOufPeBb8hPYryEYs51o78WCEbf4fdryjAVcDfH7OZtl71fQlffkFlMVeLhibdLGw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795018452;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=IaTHOvscojuyrnsdqu1GVmJpLhneYbnuXnyzh+xHv9M=;
	b=cpcrOKnON7ft76KiKDYIr2oMq6zZE3ecGdkBZIcwB6QuTPALncE7wZAMiD+PepSU1SyQ
	 tzDsoz9GY4rYvWM3ia2s8A9+wl73/sig/ogIcOoO0bI3qZ0a4lvaPWExhk4pQK55zk/ar
	 heg1izRGuVzU7x15mdnij2sMVe0kr2PhwFyAauGosEab7r+71a7r4o9B2iPNAeCMeBd1u
	 3wacz+cR93ojhzR64Wj2ynWTnsbvCwAnyPeI60984/S+SuFas6ujZL3eMnd68xMVgjWT5
	 jyvSoze81nDuBKYDHCIvK1CHsMncMkwMcpbsmqt/dBAHJkrDrfaXrF0uhReGW9WL/Pg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HqOQN9uy;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17030606A32C;
	Wed, 18 Nov 2026 16:14:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HqOQN9uy
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6491C1F000C4;
	Wed, 18 Nov 2026 16:14:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795018451;
	bh=IaTHOvscojuyrnsdqu1GVmJpLhneYbnuXnyzh+xHv9M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HqOQN9uyvO9U8vQst3Ztfy8o8d7w4tg9+o5gJn7CqMa91TeEOqNXSKjI3CHXapqBe
	 94UkDVtb5TUMGM46Iv8BNi7oeoljHR2HrupciBzb2XmBySPKGlPPncLDo3wp1MxqBM
	 lHatfj+4rvCQHc7PZJ5cSSyQAK976tMJsGNIf9cE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ryan Brue <ryanbrue.dev@gmail.com>,
	Hans de Goede <johannes.goede@oss.qualcomm.com>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1245/2651] power: supply: bq24190_charger: dont reset registers across system suspend
Date: Wed, 18 Nov 2026 15:41:25 +0100
Message-ID: <20261118150332.812180933@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ryan Brue <ryanbrue.dev@gmail.com>

[ Upstream commit e0844bd22a9f97885882bde3c4a441710e895240 ]

bq24190_pm_suspend() calls bq24190_register_reset(), which returns every
register to its power-on default, and bq24190_pm_resume() does it again
before re-applying the probe-time configuration. On any board that wires
the charger's interrupt this makes system suspend unusable.

The reset re-arms the chip's 40 s i2c watchdog. bq24190_set_config() turns
that watchdog off at probe, deliberately: as the comment there explains,
the same write also takes the part out of default mode into host mode.
Nothing pets it while the system is asleep, so it expires, resets the
registers again and pulses INT. The charger interrupt is a system wake
source -- armed unconditionally in probe since commit f385e6e2a153 ("power:
bq24190_charger: Use PM runtime autosuspend"), and still enabled by default
after the conversion to the wake irq API [1] -- so the pulse wakes the
machine.

Measured on an MT8173 board (Amazon Fire HD 10 2017, BQ24297) by swapping
only this driver between builds with and without this change, asking for
a 150 s suspend each time:

  on charger, with the reset:     41-43 s, 7 runs of 7
  on charger, without the reset:  150 s,   3 runs of 3
  on battery, with the reset:     40-41 s, 3 runs of 3
  on battery, without the reset:  150 s,   3 runs of 3

It is not a charging-only problem. The watchdog runs from VBUS or from
the battery, so an unplugged tablet loses suspend in the same way.

ftrace names the wake source. Across the resume, the first device
interrupt after the machine comes back is the charger:

  1270.760799: suspend_resume: machine_suspend[3] end
  1270.775683: irq_handler_entry: irq=25 name=bq24190-charger
  1270.776156: irq_handler_entry: irq=250 name=11010000.i2c

Everything between is IPI and arch_timer from bringing the secondary CPUs
back up, and no RTC interrupt appears anywhere in the trace -- the 150 s
wake alarm never fired. The cause leaves nothing behind for userspace to
find, because WATCHDOG_FAULT is in the latch-on-read fault register and
the driver's own interrupt handler has already consumed it.

The reset also discards host configuration that nothing restores. Resume
calls bq24190_set_config(), which writes only the watchdog, SYS_MIN,
IPRECHG, ITERM, ICHG and VREG, so:

 - IINLIM returns to its power-on default. Boards without a charger-type
   detector set the input limit from userspace; measured here, one ordinary
   suspend/resume silently took input_current_limit from 1500 mA to 500 mA,
   and to 100 mA when running from the battery, where the default differs.

 - EN_HIZ is cleared, so a charger the host put into high-impedance mode
   starts drawing from VBUS again the moment the system sleeps.

There is no way to have both. Default mode is what the reset is for, and on
this part default mode and a disarmed watchdog are mutually exclusive: a
write to any register moves the chip into host mode, and it only returns to
default mode when the watchdog times out. Parking it in default mode for
the sleep therefore always leaves a timer armed that will fire, and on any
board that wires INT that firing is a wake. A per-board opt-out would not
be choosing between two workable configurations, only between a working
suspend and a broken one.

Resetting in suspend buys nothing worth this. The part is in host mode with
its watchdog off; it charges on its own, switching from constant current to
constant voltage and terminating when the battery is full, and nothing in
it can expire or change while the host sleeps. Resetting on resume is
weaker
still: the host is awake and about to reconfigure the chip, so the reset
only guarantees the loss.

The one thing the reset does guard against is a host that never comes back:
a chip in host mode keeps whatever it was last told, where default mode
would revert to the power-on values. But that is the state the driver
leaves it in for all of normal runtime operation already, so sleep is not
special, and the part still makes its own constant-current to
constant-voltage transition and terminates when the battery is full.

So drop it in both directions. The suspend callback has nothing left to do
and goes away. Resume re-applies the probe-time configuration, which is
idempotent and also recovers a part that did somehow fall back to default
mode, since bq24190_set_config() starts by turning the watchdog off.

This has been proposed before. Hans de Goede sent the same change in 2017
[2] and Sebastian Reichel agreed with the reasoning [3], but v6 kept the
reset on by default and added the "disable-reset" device property instead
[4]. That property cannot answer this: it is set only from x86 platform
code -- i2c-cht-wc and x86-android-tablets -- and is not in bq24190.yaml,
so no DT board can reach it. Every in-tree DT user of this driver
(tegra124-xiaomi-mocha, qcom-msm8974-lge-nexus5-hammerhead,
qcom-msm8974pro-oneplus-bacon, rk3188-bqedison2qc) wires the charger
interrupt and so has the same wake armed, with no way to opt out. If some
board does want the reset, it would be better expressed the other way
round.

The vendor kernel for this board does not reset across suspend either: its
driver, drivers/power/mt81xx/bq24297.c, only masks the charger interrupt on
suspend and unmasks it on resume.

Reproduced on a BQ24297. The reasoning applies to the family, but the other
parts were not available to test.

[1] https://lore.kernel.org/all/20260908-rbrue-suez-upstreaming-bq24190_charger-use-wake-irq-api-v1-1-c3f10ae2a34a@gmail.com/
[2] https://lore.kernel.org/all/20170322145536.30570-5-hdegoede@redhat.com/
[3] https://lore.kernel.org/all/20170323112052.ukyazi4pnji7n6st@earth/
[4] https://lore.kernel.org/all/20170414165233.4532-1-hdegoede@redhat.com/

Fixes: d7bf353fd0aa ("bq24190_charger: Add support for TI BQ24190 Battery Charger")
Assisted-by: LLM
Signed-off-by: Ryan Brue <ryanbrue.dev@gmail.com>
Reviewed-by: Hans de Goede <johannes.goede@oss.qualcomm.com>
Link: https://patch.msgid.link/20260928-rbrue-suez-upstreaming-bq24190_charger-no-reset-regs-sys-suspend-v1-1-9a7689f12c05@gmail.com
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/bq24190_charger.c | 30 ++++++++------------------
 1 file changed, 9 insertions(+), 21 deletions(-)

diff --git a/drivers/power/supply/bq24190_charger.c b/drivers/power/supply/bq24190_charger.c
index 376b0b06a096a..a24e433fce1af 100644
--- a/drivers/power/supply/bq24190_charger.c
+++ b/drivers/power/supply/bq24190_charger.c
@@ -2249,25 +2249,6 @@ static __maybe_unused int bq24190_runtime_resume(struct device *dev)
 	return 0;
 }
 
-static __maybe_unused int bq24190_pm_suspend(struct device *dev)
-{
-	struct i2c_client *client = to_i2c_client(dev);
-	struct bq24190_dev_info *bdi = i2c_get_clientdata(client);
-	int error;
-
-	error = pm_runtime_resume_and_get(bdi->dev);
-	if (error < 0)
-		dev_warn(bdi->dev, "pm_runtime_get failed: %i\n", error);
-
-	bq24190_register_reset(bdi);
-
-	if (error >= 0) {
-		pm_runtime_put_autosuspend(bdi->dev);
-	}
-
-	return 0;
-}
-
 static __maybe_unused int bq24190_pm_resume(struct device *dev)
 {
 	struct i2c_client *client = to_i2c_client(dev);
@@ -2281,7 +2262,14 @@ static __maybe_unused int bq24190_pm_resume(struct device *dev)
 	if (error < 0)
 		dev_warn(bdi->dev, "pm_runtime_get failed: %i\n", error);
 
-	bq24190_register_reset(bdi);
+	/*
+	 * The chip kept its configuration through the sleep: it is in host
+	 * mode with the i2c watchdog off, so nothing expired and nothing was
+	 * reset. Do not reset it here either -- a userspace setting such as
+	 * EN_HIZ or IINLIM would otherwise be silently lost on every resume.
+	 * Re-applying the probe-time configuration is idempotent and cheap,
+	 * and covers a part that did somehow fall back to default mode.
+	 */
 	bq24190_set_config(bdi);
 	bq24190_read(bdi, BQ24190_REG_SS, &bdi->ss_reg);
 
@@ -2300,7 +2288,7 @@ static __maybe_unused int bq24190_pm_resume(struct device *dev)
 static const struct dev_pm_ops bq24190_pm_ops = {
 	SET_RUNTIME_PM_OPS(bq24190_runtime_suspend, bq24190_runtime_resume,
 			   NULL)
-	SET_SYSTEM_SLEEP_PM_OPS(bq24190_pm_suspend, bq24190_pm_resume)
+	SET_SYSTEM_SLEEP_PM_OPS(NULL, bq24190_pm_resume)
 };
 
 static const struct i2c_device_id bq24190_i2c_ids[] = {
-- 
2.53.0



