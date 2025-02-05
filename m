Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 385341519AF;
	Wed,  5 Feb 2025 14:31:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738765892; cv=none; b=bN/q+JDYnsdojMy5le0h6GHwLYzPdvhlOm7ABB8o3Mi3ZAftsfGUUOMmTzEOtTt1JgDrODzwQNl12/eDF88ylk4ZXrPgCvrnHp0cTQ303Xr91l+xLs16y92R4iMCa9OUS+dZ4Ed8/i0m2UAxV7JaY8hxEfUw1uZSnIkhr3iGK7M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738765892; c=relaxed/simple;
	bh=REX6rZrxC5WaJ45Xz35WnbQ6gPvB+igBgN74RNu+dBA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=oPknIjN1ziIvaIFsxw3f36+GW8FN1UQAIEEMTG5kfItA1Ggh+N0/6MXiNxWBpwSMl+eOb7NQRYXRZfH/EXQmEDC6BNcFXu0eEElVzTxUkKYafZ88nklF3xK/fXqZWPYtSeQWjpCEp0TgrRXf2rU1/i2XJKfGdOLZyLp4DBTNjnM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F5YgBDvZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F5YgBDvZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27790C4CED1;
	Wed,  5 Feb 2025 14:31:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738765890;
	bh=REX6rZrxC5WaJ45Xz35WnbQ6gPvB+igBgN74RNu+dBA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F5YgBDvZN9kgSxNi0XF5k4OHR8TPgMTXGFUXkZfdIu56P2U+FNW405KFidZ6FaFqc
	 SMqUC1HMu3DZXgGEk2MdVLXDg8Na9KW0Qd+TVjCMGbqM/GSkJqRgAHKfgeN9THQ1s6
	 r8kTT8m59mYTXvKF2DCcEJRtrALy1msWnYpNBicA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Alexis=20Lothor=C3=A9?= <alexis.lothore@bootlin.com>,
	Kalle Valo <kvalo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 223/623] wifi: wilc1000: unregister wiphy only after netdev registration
Date: Wed,  5 Feb 2025 14:39:25 +0100
Message-ID: <20250205134504.756921813@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134456.221272033@linuxfoundation.org>
References: <20250205134456.221272033@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexis Lothoré <alexis.lothore@bootlin.com>

[ Upstream commit 208dea9107e80a33dfeb029bdb93cb53eccf005d ]

wiphy_unregister()/wiphy_free() has been recently decoupled from
wilc_netdev_cleanup() to fix a faulty error path in sdio/spi probe
functions. However this change introduced a new failure when simply
loading then unloading the driver:

  $ modprobe wilc1000-sdio; modprobe -r wilc1000-sdio
  WARNING: CPU: 0 PID: 115 at net/wireless/core.c:1145 wiphy_unregister+0x904/0xc40 [cfg80211]
  Modules linked in: wilc1000_sdio(-) wilc1000 cfg80211 bluetooth ecdh_generic ecc
  CPU: 0 UID: 0 PID: 115 Comm: modprobe Not tainted 6.13.0-rc6+ #45
  Hardware name: Atmel SAMA5
  Call trace:
   unwind_backtrace from show_stack+0x18/0x1c
   show_stack from dump_stack_lvl+0x44/0x70
   dump_stack_lvl from __warn+0x118/0x27c
   __warn from warn_slowpath_fmt+0xcc/0x140
   warn_slowpath_fmt from wiphy_unregister+0x904/0xc40 [cfg80211]
   wiphy_unregister [cfg80211] from wilc_sdio_remove+0xb0/0x15c [wilc1000_sdio]
   wilc_sdio_remove [wilc1000_sdio] from sdio_bus_remove+0x104/0x3f0
   sdio_bus_remove from device_release_driver_internal+0x424/0x5dc
   device_release_driver_internal from driver_detach+0x120/0x224
   driver_detach from bus_remove_driver+0x17c/0x314
   bus_remove_driver from sys_delete_module+0x310/0x46c
   sys_delete_module from ret_fast_syscall+0x0/0x1c
  Exception stack(0xd0acbfa8 to 0xd0acbff0)
  bfa0:                   0044b210 0044b210 0044b24c 00000800 00000000 00000000
  bfc0: 0044b210 0044b210 00000000 00000081 00000000 0044b210 00000000 00000000
  bfe0: 00448e24 b6af99c4 0043ea0d aea2e12c
  irq event stamp: 0
  hardirqs last  enabled at (0): [<00000000>] 0x0
  hardirqs last disabled at (0): [<c01588f0>] copy_process+0x1c4c/0x7bec
  softirqs last  enabled at (0): [<c0158944>] copy_process+0x1ca0/0x7bec
  softirqs last disabled at (0): [<00000000>] 0x0

The warning is triggered by the fact that there is still a
wireless_device linked to the wiphy we are unregistering, due to
wiphy_unregister() now being called after net device unregister (performed
in wilc_netdev_cleanup()). Fix this warning by moving wiphy_unregister()
after wilc_netdev_cleanup() is nominal paths (ie: driver removal).
wilc_netdev_cleanup() ordering is left untouched in error paths in probe
function because net device is not registered in those paths (so the
warning can not trigger), yet the wiphy can still be registered, and we
still some cleanup steps from wilc_netdev_cleanup().

Fixes: 1be94490b6b8 ("wifi: wilc1000: unregister wiphy only if it has been registered")
Signed-off-by: Alexis Lothoré <alexis.lothore@bootlin.com>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://patch.msgid.link/20250114-wilc1000_modprobe-v1-1-ad19d46f0c07@bootlin.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/microchip/wilc1000/sdio.c | 2 +-
 drivers/net/wireless/microchip/wilc1000/spi.c  | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/microchip/wilc1000/sdio.c b/drivers/net/wireless/microchip/wilc1000/sdio.c
index 3751e2ee1ca95..af970f9991110 100644
--- a/drivers/net/wireless/microchip/wilc1000/sdio.c
+++ b/drivers/net/wireless/microchip/wilc1000/sdio.c
@@ -225,8 +225,8 @@ static void wilc_sdio_remove(struct sdio_func *func)
 	struct wilc *wilc = sdio_get_drvdata(func);
 	struct wilc_sdio *sdio_priv = wilc->bus_data;
 
-	wiphy_unregister(wilc->wiphy);
 	wilc_netdev_cleanup(wilc);
+	wiphy_unregister(wilc->wiphy);
 	wiphy_free(wilc->wiphy);
 	kfree(sdio_priv->cmd53_buf);
 	kfree(sdio_priv);
diff --git a/drivers/net/wireless/microchip/wilc1000/spi.c b/drivers/net/wireless/microchip/wilc1000/spi.c
index 31219fd0cfb3f..5bcabb7decea0 100644
--- a/drivers/net/wireless/microchip/wilc1000/spi.c
+++ b/drivers/net/wireless/microchip/wilc1000/spi.c
@@ -285,8 +285,8 @@ static void wilc_bus_remove(struct spi_device *spi)
 	struct wilc *wilc = spi_get_drvdata(spi);
 	struct wilc_spi *spi_priv = wilc->bus_data;
 
-	wiphy_unregister(wilc->wiphy);
 	wilc_netdev_cleanup(wilc);
+	wiphy_unregister(wilc->wiphy);
 	wiphy_free(wilc->wiphy);
 	kfree(spi_priv);
 }
-- 
2.39.5



