Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A40812EA14E;
	Tue, 17 Jun 2025 16:03:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750176219; cv=none; b=uz7RZ66/L1QUP9kIpeEnSfg7C9GWbGNWx0lwYOCWZVpO1AoVbynWJyRzS4xv+NUjhMS6LjZpfQcKXzxjArfzcQb3VpeFJgEVA5m752wU9LwSrepFvr8e8uw9NOdOWNj9uen5DN/YtTaGB83kOqg0rv9gqQvEiRH0ggx5CcsEFJ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750176219; c=relaxed/simple;
	bh=1RevyJ5EXpXvP21XP7opYpHn03lcPj3wRmLD2ZaKY0M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NX4wlcwxKXg6DKq1ZCTiC1JVQVWzMgrgUTcyQjl4pDlL7uPaW8lj3xu6cmFLTVxouD34/GGMdfrAXx7LLlIo+lX1zsehAiddAtyIXkCO4ayGKbWYaumJoBb/vEJxjgEmh6NW1Th5tQElIP5hzAwVGgvxhlphwhB/G9WVHLt1bc4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=G9wJTLiw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="G9wJTLiw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15950C4CEE3;
	Tue, 17 Jun 2025 16:03:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750176219;
	bh=1RevyJ5EXpXvP21XP7opYpHn03lcPj3wRmLD2ZaKY0M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=G9wJTLiwXpw91VUgTwuf53VbWsQ5JU5dCdjKo9W9LH1/u46YLhTpzMnZUzdfBjtJm
	 Xm+naK0i9PpoYALjB1cRdz/o/NqiKeXQstuH8KNwDn9iNr/AT8rI9jPi3sMmTrzQWs
	 +XiOz/nfoIqtjOuNG4ITDnLUMeQlMe1L8tLFd3T8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Alexis=20Lothor=C3=A9?= <alexis.lothore@bootlin.com>,
	Yanteng Si <si.yanteng@linux.dev>,
	Maxime Chevallier <maxime.chevallier@bootlin.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 256/356] net: stmmac: make sure that ptp_rate is not 0 before configuring timestamping
Date: Tue, 17 Jun 2025 17:26:11 +0200
Message-ID: <20250617152348.513356935@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152338.212798615@linuxfoundation.org>
References: <20250617152338.212798615@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexis Lothoré <alexis.lothore@bootlin.com>

[ Upstream commit 030ce919e114a111e83b7976ecb3597cefd33f26 ]

The stmmac platform drivers that do not open-code the clk_ptp_rate value
after having retrieved the default one from the device-tree can end up
with 0 in clk_ptp_rate (as clk_get_rate can return 0). It will
eventually propagate up to PTP initialization when bringing up the
interface, leading to a divide by 0:

 Division by zero in kernel.
 CPU: 1 UID: 0 PID: 1 Comm: swapper/0 Not tainted 6.12.30-00001-g48313bd5768a #22
 Hardware name: STM32 (Device Tree Support)
 Call trace:
  unwind_backtrace from show_stack+0x18/0x1c
  show_stack from dump_stack_lvl+0x6c/0x8c
  dump_stack_lvl from Ldiv0_64+0x8/0x18
  Ldiv0_64 from stmmac_init_tstamp_counter+0x190/0x1a4
  stmmac_init_tstamp_counter from stmmac_hw_setup+0xc1c/0x111c
  stmmac_hw_setup from __stmmac_open+0x18c/0x434
  __stmmac_open from stmmac_open+0x3c/0xbc
  stmmac_open from __dev_open+0xf4/0x1ac
  __dev_open from __dev_change_flags+0x1cc/0x224
  __dev_change_flags from dev_change_flags+0x24/0x60
  dev_change_flags from ip_auto_config+0x2e8/0x11a0
  ip_auto_config from do_one_initcall+0x84/0x33c
  do_one_initcall from kernel_init_freeable+0x1b8/0x214
  kernel_init_freeable from kernel_init+0x24/0x140
  kernel_init from ret_from_fork+0x14/0x28
 Exception stack(0xe0815fb0 to 0xe0815ff8)

Prevent this division by 0 by adding an explicit check and error log
about the actual issue. While at it, remove the same check from
stmmac_ptp_register, which then becomes duplicate

Fixes: 19d857c9038e ("stmmac: Fix calculations for ptp counters when clock input = 50Mhz.")
Signed-off-by: Alexis Lothoré <alexis.lothore@bootlin.com>
Reviewed-by: Yanteng Si <si.yanteng@linux.dev>
Reviewed-by: Maxime Chevallier <maxime.chevallier@bootlin.com>
Link: https://patch.msgid.link/20250529-stmmac_tstamp_div-v4-1-d73340a794d5@bootlin.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 5 +++++
 drivers/net/ethernet/stmicro/stmmac/stmmac_ptp.c  | 2 +-
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index d3d5c01f6dcba..615d25a0e46be 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -842,6 +842,11 @@ int stmmac_init_tstamp_counter(struct stmmac_priv *priv, u32 systime_flags)
 	if (!(priv->dma_cap.time_stamp || priv->dma_cap.atime_stamp))
 		return -EOPNOTSUPP;
 
+	if (!priv->plat->clk_ptp_rate) {
+		netdev_err(priv->dev, "Invalid PTP clock rate");
+		return -EINVAL;
+	}
+
 	stmmac_config_hw_tstamping(priv, priv->ptpaddr, systime_flags);
 	priv->systime_flags = systime_flags;
 
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_ptp.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_ptp.c
index a04bb2e42c4ee..80ecbd73333d9 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_ptp.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_ptp.c
@@ -295,7 +295,7 @@ void stmmac_ptp_register(struct stmmac_priv *priv)
 
 	/* Calculate the clock domain crossing (CDC) error if necessary */
 	priv->plat->cdc_error_adj = 0;
-	if (priv->plat->has_gmac4 && priv->plat->clk_ptp_rate)
+	if (priv->plat->has_gmac4)
 		priv->plat->cdc_error_adj = (2 * NSEC_PER_SEC) / priv->plat->clk_ptp_rate;
 
 	stmmac_ptp_clock_ops.n_per_out = priv->dma_cap.pps_out_num;
-- 
2.39.5



