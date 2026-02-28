Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04F13301F0B;
	Sat, 28 Feb 2026 17:57:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301453; cv=none; b=MKm3pmMRhE+uYcEiAuQhvcpO+4McDjdCja8nflc86jR4/Mk9yp10gZ9LfIAi4rIbYdWpY+dQayPJrjOWTrKvE6DKKiKYQyFOFsGIrevjVb68Xr2g9xUUQLTlUff+/4Jf+ezy9kTEJs1Y2FeZG6cx9NkCWFOMhKC8mBeTgVJHjU8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301453; c=relaxed/simple;
	bh=95F7p9FHL/AywEQFx6+zZMDVlipdmfIm7nhBfH5jJKE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KQ+wMkPjj3sEeB42YQirafC1AysUYTdYQMODZeH3hdppNs5ETK9hudwtaAx+C4Kt2HA8xwpNogrR1fVamxNlI2u5ySX8/zvwL/7JXQEoHhUbotgCC8eqaSqlC10AVCFepwg+Slz4MBXbaL0ABAn676GNXTgL/YwQR8QETcd3A3w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aPQaqT3R; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aPQaqT3R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EE0BC19423;
	Sat, 28 Feb 2026 17:57:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301452;
	bh=95F7p9FHL/AywEQFx6+zZMDVlipdmfIm7nhBfH5jJKE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aPQaqT3RLZh+Wz9c2myIxTpGvbEk3PQcIm7VYgdlggvOmBpM/dl/tYkQaPaQffNUC
	 D6Or1Bb0hcAM1oHljP3twNcMWb7Cio1/GXjHpM3FPSsTHoY7EFPEzCx5NREpMDyQpa
	 Ho0ApJl55zF6/EOCMvf9aumQNazW2O9/MvE2wu+Yn8E97yec/oJU5CukAjqLB2DInR
	 DbRyqvT1Qy0awslWlmYXH9PECuJdQB05tvsDZ0AEYuEsEtvjck2e9qYbxuCDT5LH+8
	 Rrk8gDEdNJT11FbSwz5fcb0PjARWi4rNDlXe9T0jH3oLQE/rcJ0jFJgqLqX3sAUNaK
	 rELTRgmNrQgow==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Emanuele Ghidoli <emanuele.ghidoli@toradex.com>,
	stable@vger.kernel.org,
	Francesco Dolcini <francesco.dolcini@toradex.com>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 639/752] power: reset: tdx-ec-poweroff: fix restart
Date: Sat, 28 Feb 2026 12:45:50 -0500
Message-ID: <20260228174750.1542406-639-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Emanuele Ghidoli <emanuele.ghidoli@toradex.com>

[ Upstream commit 562357a6310f79e45844c3e980d410a1e8e02ce6 ]

During testing, restart occasionally failed on Toradex modules.

The issue was traced to an interaction between the EC-based reset/poweroff
handler and the PSCI restart handler. While the embedded controller is
resetting or powering off the module, the PSCI code may still be invoked,
triggering an I2C transaction to the PMIC. This can leave the PMIC I2C
in a frozen state.

Add a delay after issuing the EC reset or power-off command to give the
controller time to complete the operation and avoid falling back to another
restart/poweroff provider.

Also print an error message if sending the command to the embedded controller
fails.

Fixes: 18672fe12367 ("power: reset: add Toradex Embedded Controller")
Cc: stable@vger.kernel.org
Signed-off-by: Emanuele Ghidoli <emanuele.ghidoli@toradex.com>
Reviewed-by: Francesco Dolcini <francesco.dolcini@toradex.com>
Link: https://patch.msgid.link/20260130071208.1184239-1-ghidoliemanuele@gmail.com
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/reset/tdx-ec-poweroff.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/drivers/power/reset/tdx-ec-poweroff.c b/drivers/power/reset/tdx-ec-poweroff.c
index 3302a127fce52..8040aa03d74d4 100644
--- a/drivers/power/reset/tdx-ec-poweroff.c
+++ b/drivers/power/reset/tdx-ec-poweroff.c
@@ -8,7 +8,10 @@
  */
 
 #include <linux/array_size.h>
+#include <linux/bug.h>
+#include <linux/delay.h>
 #include <linux/device.h>
+#include <linux/dev_printk.h>
 #include <linux/err.h>
 #include <linux/i2c.h>
 #include <linux/mod_devicetable.h>
@@ -31,6 +34,8 @@
 
 #define EC_REG_MAX                      0xD0
 
+#define EC_CMD_TIMEOUT_MS             	1000
+
 static const struct regmap_range volatile_ranges[] = {
 	regmap_reg_range(EC_CMD_REG, EC_CMD_REG),
 };
@@ -75,6 +80,13 @@ static int tdx_ec_power_off(struct sys_off_data *data)
 
 	err = tdx_ec_cmd(regmap, EC_CMD_POWEROFF);
 
+	if (err) {
+		dev_err(data->dev, "Failed to send power off command\n");
+	} else {
+		mdelay(EC_CMD_TIMEOUT_MS);
+		WARN_ONCE(1, "Unable to power off system\n");
+	}
+
 	return err ? NOTIFY_BAD : NOTIFY_DONE;
 }
 
@@ -85,6 +97,13 @@ static int tdx_ec_restart(struct sys_off_data *data)
 
 	err = tdx_ec_cmd(regmap, EC_CMD_RESET);
 
+	if (err) {
+		dev_err(data->dev, "Failed to send restart command\n");
+	} else {
+		mdelay(EC_CMD_TIMEOUT_MS);
+		WARN_ONCE(1, "Unable to restart system\n");
+	}
+
 	return err ? NOTIFY_BAD : NOTIFY_DONE;
 }
 
-- 
2.51.0

