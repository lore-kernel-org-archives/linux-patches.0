Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1AEB332628
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:53:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301231; cv=none; b=aOJmoRp2eT1rdb1WR4mEscPkgbQ7ABjD7MFMXUwZ7//H7Nv544DPmt00fes33tVxD4qiaaDxaBxk5j63ofaHNcnYNHBffPeoyXFTeEjtytVFpWSu905nCijdOnnx+VIwKPxMSS0S5+ALPruWynT3AydF2ZtYtlBHL+vRGJFKIwc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301231; c=relaxed/simple;
	bh=pUCiQnWyxC0p8wloLakDOX3hNyutKCYZb/R46N5Q2zc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UEImj9cmLFB0mnEi/DZqZjnK0oBSDvdJRDKJtFgHQVn6Qxo5HDUwgjNI/krBI5bIc2+CFAJavPSbwfkbLZhqvhStn5BW3TC54nN0MeRJ46snrA4k1o+Vup1vvxctIA9TL+Kw5X5fVoCVlITCyPFgiaEo+VdBHm7JcY6pdHoE2gQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ggzN7QS6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ggzN7QS6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DC11C19424;
	Sat, 28 Feb 2026 17:53:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301230;
	bh=pUCiQnWyxC0p8wloLakDOX3hNyutKCYZb/R46N5Q2zc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ggzN7QS6av2eKmPdy+Wz0o3hBuQ/qZq9/0E5lGWAbiZySwDgQiFUwGhg5PV9W9+sK
	 N4ctl3lJwoJ/7W+yr9/WZ/EP8FZoyjyemdFdDnFCm/3S5clhG4CgljdTLPIAeL2Xem
	 WKuRDbCDfjd2YUPj1o1QKFtU39OOHPHhWDxssZC3Jm9VHfsMoRHjqLdbrOUsyqNFqi
	 HYMf89Dhj06OuWtnoGNsalUrv2INP8naOuSnrTv1NgtQuKFeZdmdnjoXWhXwNeJ8Yd
	 UYdrP8uPEZZ63szjvok2ctB4kVjUijoKaYsjEct4uquQ56NNTJvSbkepmkjkrMGs3H
	 rJ00bJ8nmwHNQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Linus Walleij <linusw@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 409/752] net: ethernet: xscale: Check for PTP support properly
Date: Sat, 28 Feb 2026 12:42:00 -0500
Message-ID: <20260228174750.1542406-409-sashal@kernel.org>
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

From: Linus Walleij <linusw@kernel.org>

[ Upstream commit 594163ea88a03bdb412063af50fc7177ef3cbeae ]

In ixp4xx_get_ts_info() ixp46x_ptp_find() is called
unconditionally despite this feature only existing on
ixp46x, leading to the following splat from tcpdump:

root@OpenWrt:~# tcpdump -vv -X -i eth0
(...)
Unable to handle kernel NULL pointer dereference at virtual address
  00000238 when read
(...)
Call trace:
 ptp_clock_index from ixp46x_ptp_find+0x1c/0x38
 ixp46x_ptp_find from ixp4xx_get_ts_info+0x4c/0x64
 ixp4xx_get_ts_info from __ethtool_get_ts_info+0x90/0x108
 __ethtool_get_ts_info from __dev_ethtool+0xa00/0x2648
 __dev_ethtool from dev_ethtool+0x160/0x234
 dev_ethtool from dev_ioctl+0x2cc/0x460
 dev_ioctl from sock_ioctl+0x1ec/0x524
 sock_ioctl from sys_ioctl+0x51c/0xa94
 sys_ioctl from ret_fast_syscall+0x0/0x44
 (...)
Segmentation fault

Check for ixp46x in ixp46x_ptp_find() before trying to set up
PTP to avoid this.

To avoid altering the returned error code from ixp4xx_hwtstamp_set()
which before this patch was -EOPNOTSUPP, we return -EOPNOTSUPP
from ixp4xx_hwtstamp_set() if ixp46x_ptp_find() fails no matter
the error code. The helper function ixp46x_ptp_find() helper
returns -ENODEV.

Fixes: 9055a2f59162 ("ixp4xx_eth: make ptp support a platform driver")
Signed-off-by: Linus Walleij <linusw@kernel.org>
Link: https://patch.msgid.link/20260219-ixp4xx-fix-ethernet-v3-1-f235ccc3cd46@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/xscale/ixp4xx_eth.c | 5 +----
 drivers/net/ethernet/xscale/ptp_ixp46x.c | 3 +++
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/xscale/ixp4xx_eth.c b/drivers/net/ethernet/xscale/ixp4xx_eth.c
index e1e7f65553e76..b0faa0f1780d0 100644
--- a/drivers/net/ethernet/xscale/ixp4xx_eth.c
+++ b/drivers/net/ethernet/xscale/ixp4xx_eth.c
@@ -403,15 +403,12 @@ static int ixp4xx_hwtstamp_set(struct net_device *netdev,
 	int ret;
 	int ch;
 
-	if (!cpu_is_ixp46x())
-		return -EOPNOTSUPP;
-
 	if (!netif_running(netdev))
 		return -EINVAL;
 
 	ret = ixp46x_ptp_find(&port->timesync_regs, &port->phc_index);
 	if (ret)
-		return ret;
+		return -EOPNOTSUPP;
 
 	ch = PORT2CHANNEL(port);
 	regs = port->timesync_regs;
diff --git a/drivers/net/ethernet/xscale/ptp_ixp46x.c b/drivers/net/ethernet/xscale/ptp_ixp46x.c
index 94203eb46e6b0..93c64db22a696 100644
--- a/drivers/net/ethernet/xscale/ptp_ixp46x.c
+++ b/drivers/net/ethernet/xscale/ptp_ixp46x.c
@@ -232,6 +232,9 @@ static struct ixp_clock ixp_clock;
 
 int ixp46x_ptp_find(struct ixp46x_ts_regs *__iomem *regs, int *phc_index)
 {
+	if (!cpu_is_ixp46x())
+		return -ENODEV;
+
 	*regs = ixp_clock.regs;
 	*phc_index = ptp_clock_index(ixp_clock.ptp_clock);
 
-- 
2.51.0

