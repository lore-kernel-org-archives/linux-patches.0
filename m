Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 377731EABC6;
	Tue, 15 Oct 2024 12:12:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728994335; cv=none; b=e17uATcZAoD5ab0myCRgtj5eEiBcG3/DvMBbpfD0SyC/fwx//bqv4O4ICkYgb7TVYNXvE2guilLtWzmzsyIEvXjTBsN7tUYiagqASx2Bon8gDMj8gZ12mV4/4NqUdOz5SguOY1cQ55OJOxwro/+JAnH/z1L8iRXE/+Dk3km8X90=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728994335; c=relaxed/simple;
	bh=Hc77NIV585iDtZIptCj87X4ntI1x9MsC46YfmC5cCMQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EGt6wgWHeVLD62uFfzos4Y7jemykoi/8rJ/bPQrYbuKNonedcTpgeJuSmai9hsPgik22BwYNAmwU6NYDYrLd1bncvQxMkyB79IFNsXGuOjkJfvAviMV36IHQuEuRghIBBtjfkY8/lqtYLDO2qmvbCI7CfZH5RFHdihf9hLzzsF4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sTLqWUqh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sTLqWUqh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A25E1C4CEC6;
	Tue, 15 Oct 2024 12:12:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728994335;
	bh=Hc77NIV585iDtZIptCj87X4ntI1x9MsC46YfmC5cCMQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sTLqWUqhaxvSpmD0bfQAGWL42uW9gDwW15NIbD+NxnLIAAUWuAf1nCAF6v4eKYY6f
	 8j9y7+6imsuitTVscLbzrF9XsKt/M1yf79NUpFrIaT5BUJHJ5LILZITotl1QnWAYV3
	 8qwnD77J3QjAOSorcLcYIw+PbG0iFfshtCXrjTHg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anatolij Gustschin <agust@denx.de>,
	Alexander Sverdlin <alexander.sverdlin@siemens.com>,
	Vladimir Oltean <olteanv@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.15 675/691] net: dsa: lan9303: ensure chip reset and wait for READY status
Date: Tue, 15 Oct 2024 13:30:23 +0200
Message-ID: <20241015112507.113150192@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Anatolij Gustschin <agust@denx.de>

commit 5c14e51d2d7df49fe0d4e64a12c58d2542f452ff upstream.

Accessing device registers seems to be not reliable, the chip
revision is sometimes detected wrongly (0 instead of expected 1).

Ensure that the chip reset is performed via reset GPIO and then
wait for 'Device Ready' status in HW_CFG register before doing
any register initializations.

Cc: stable@vger.kernel.org
Fixes: a1292595e006 ("net: dsa: add new DSA switch driver for the SMSC-LAN9303")
Signed-off-by: Anatolij Gustschin <agust@denx.de>
[alex: reworked using read_poll_timeout()]
Signed-off-by: Alexander Sverdlin <alexander.sverdlin@siemens.com>
Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
Link: https://patch.msgid.link/20241004113655.3436296-1-alexander.sverdlin@siemens.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/dsa/lan9303-core.c |   29 +++++++++++++++++++++++++++++
 1 file changed, 29 insertions(+)

--- a/drivers/net/dsa/lan9303-core.c
+++ b/drivers/net/dsa/lan9303-core.c
@@ -6,6 +6,7 @@
 #include <linux/module.h>
 #include <linux/gpio/consumer.h>
 #include <linux/regmap.h>
+#include <linux/iopoll.h>
 #include <linux/mutex.h>
 #include <linux/mii.h>
 #include <linux/phy.h>
@@ -820,6 +821,8 @@ static void lan9303_handle_reset(struct
 	if (!chip->reset_gpio)
 		return;
 
+	gpiod_set_value_cansleep(chip->reset_gpio, 1);
+
 	if (chip->reset_duration != 0)
 		msleep(chip->reset_duration);
 
@@ -845,8 +848,34 @@ static int lan9303_disable_processing(st
 static int lan9303_check_device(struct lan9303 *chip)
 {
 	int ret;
+	int err;
 	u32 reg;
 
+	/* In I2C-managed configurations this polling loop will clash with
+	 * switch's reading of EEPROM right after reset and this behaviour is
+	 * not configurable. While lan9303_read() already has quite long retry
+	 * timeout, seems not all cases are being detected as arbitration error.
+	 *
+	 * According to datasheet, EEPROM loader has 30ms timeout (in case of
+	 * missing EEPROM).
+	 *
+	 * Loading of the largest supported EEPROM is expected to take at least
+	 * 5.9s.
+	 */
+	err = read_poll_timeout(lan9303_read, ret,
+				!ret && reg & LAN9303_HW_CFG_READY,
+				20000, 6000000, false,
+				chip->regmap, LAN9303_HW_CFG, &reg);
+	if (ret) {
+		dev_err(chip->dev, "failed to read HW_CFG reg: %pe\n",
+			ERR_PTR(ret));
+		return ret;
+	}
+	if (err) {
+		dev_err(chip->dev, "HW_CFG not ready: 0x%08x\n", reg);
+		return err;
+	}
+
 	ret = lan9303_read(chip->regmap, LAN9303_CHIP_REV, &reg);
 	if (ret) {
 		dev_err(chip->dev, "failed to read chip revision register: %d\n",


