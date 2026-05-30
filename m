Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E4A83438AE;
	Sat, 30 May 2026 17:41:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780162886; cv=none; b=aOHehUQO9MEO3z7+GSZmnamatnaWYgBP5ah5l9fVIi2FXca8+NcpVYm6IOyen6nfQrOIHwl+ARC+8sKQL2ZBKeyOAIAvY77r95YBxtEVow/u5B4e/JAklgMg/eQexTII+fE3zE1XgvANYMW/D1QlkOrBVtxhleW8DGzgKtO8VgQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780162886; c=relaxed/simple;
	bh=vArbN1xDBfvbv+9qCV6GVIGoVBxYSuCiqzdIrFOs0Rk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hgEyNravsVDwznXsIU4+UoLjXr8CjiqQOVsMOhfHhjg/99s6PcC0Lr8AUz60ewyt9dRo31VeTp4MUzFl18eND33EETV/AyPdYJPavWepVd9v29bFwVmHngW2HHavcrMi+dUANzclbnu2StAWV+HdoME6kTN7woirHRS/gAo91f0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=llo3RArd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="llo3RArd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70DFD1F00893;
	Sat, 30 May 2026 17:41:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780162885;
	bh=WEgjBI9uL7G/WvZmz3A9tKH3Dk9servo1xItgF9HYpc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=llo3RArdBK1Ky/LNGE0YfEFYHJxbDHNOpAIIrAzKkygSIktCk8fiSHallKKzMpqb4
	 9ledODgBMVzZGk3OtFAhUn+3AdvRJJyu6aGqobZkrkrH/WpgrO0J9tDY6P4zz89RQT
	 lTMWvuTEU8CDgvRPHbWA8nzwkVAQKnIkK8fR9dww=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 092/776] Revert "net: ethernet: xscale: Check for PTP support properly"
Date: Sat, 30 May 2026 17:56:46 +0200
Message-ID: <20260530160242.715035022@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
References: <20260530160240.228940103@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

This reverts commit 144dde3146985b25fa84d4e4b7c3d11e0f5fc5a4.

Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/xscale/ixp4xx_eth.c | 5 ++++-
 drivers/net/ethernet/xscale/ptp_ixp46x.c | 3 ---
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/xscale/ixp4xx_eth.c b/drivers/net/ethernet/xscale/ixp4xx_eth.c
index ad6384a1e6b21..9951006f1bc77 100644
--- a/drivers/net/ethernet/xscale/ixp4xx_eth.c
+++ b/drivers/net/ethernet/xscale/ixp4xx_eth.c
@@ -380,6 +380,9 @@ static int ixp4xx_hwtstamp_set(struct net_device *netdev,
 	int ret;
 	int ch;
 
+	if (!cpu_is_ixp46x())
+		return -EOPNOTSUPP;
+
 	if (!netif_running(netdev))
 		return -EINVAL;
 
@@ -388,7 +391,7 @@ static int ixp4xx_hwtstamp_set(struct net_device *netdev,
 
 	ret = ixp46x_ptp_find(&port->timesync_regs, &port->phc_index);
 	if (ret)
-		return -EOPNOTSUPP;
+		return ret;
 
 	ch = PORT2CHANNEL(port);
 	regs = port->timesync_regs;
diff --git a/drivers/net/ethernet/xscale/ptp_ixp46x.c b/drivers/net/ethernet/xscale/ptp_ixp46x.c
index 422946c1e65b7..20f6aa508003b 100644
--- a/drivers/net/ethernet/xscale/ptp_ixp46x.c
+++ b/drivers/net/ethernet/xscale/ptp_ixp46x.c
@@ -244,9 +244,6 @@ static struct ixp_clock ixp_clock;
 
 int ixp46x_ptp_find(struct ixp46x_ts_regs *__iomem *regs, int *phc_index)
 {
-	if (!cpu_is_ixp46x())
-		return -ENODEV;
-
 	*regs = ixp_clock.regs;
 	*phc_index = ptp_clock_index(ixp_clock.ptp_clock);
 
-- 
2.53.0



