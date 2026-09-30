Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 839804E2F09;
	Wed, 30 Sep 2026 16:22:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790785364; cv=none; b=EPbQtJWB+Fv/7e0u0kXmZE6LSkAugiV+o5J9Fc5pbRwfkMOfUvmEB1p3rbyz83Pi4tACZO7WTkx/wd9FbbSCX5N92gffgZxWFtOngegMabQUucqSOrk5lhSMKXwVhphTSY0EMivS+aYQIsxZ5xKBVJC+WAdJninXFjLY3PQYjGQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790785364; c=relaxed/simple;
	bh=VHvfU6rlxx+W6fxGIjha/rXaJoM0+5Y4Z7c2WDMctKQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mo5apAlZOxFqq9hKDXvz2ynTT72X4rzcXOjloKcdClkdhGqZV/fozjKajdWdxtC3xAgYe716hAHcoJa9YP+Kkfbm4HV+caw4Q/wxeeWzQrycDWSbK0k/HseqmwZCzqn6XzETlccwTm3S/QmJMadU1eUEdpcM2G1zcDQoPEB7UpE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IA1Fjecu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IA1Fjecu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A58AC1F00893;
	Wed, 30 Sep 2026 16:22:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790785356;
	bh=J6Mlu2/ceh9zccjmSA3QlZJmdBgpG3As/3xqeppWnRw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IA1Fjecu1zvAjHZp2E4Zaol6ad6uYma2mCykGDH9idiG+JogkiVcgquHjDt/3LIzV
	 C9WXpVks/kwt7HgpKWdv4Ewn8HGJ2YSvr4MEXRMgTna0c7+04rhj39Qud37lAURgV7
	 k1/QepZu8+2O4SCQ4Ecd1q31jmVJ4iBm88L5imek=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>,
	Maxime Chevallier <maxime.chevallier@bootlin.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 479/982] net: stmmac: initialize ptp_lock at probe time
Date: Wed, 30 Sep 2026 17:20:15 +0200
Message-ID: <20260930152427.069290077@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>

[ Upstream commit 0338c68e22abd2ee509ec2e32508a50896618c32 ]

priv->ptp_lock is only initialized in stmmac_ptp_register(), which runs
during __stmmac_open(). However, the lock is also used while the
interface is down and has never been opened: tc_taprio_configure()
invokes the PTP gettime64() callback to compute the EST base time when
offloading a TAPRIO schedule, and stmmac_get_time() takes
priv->ptp_lock. Using an uninitialized rwlock is undefined behaviour.
Move the rwlock_init() to __stmmac_dvr_probe(), together with the other
private locks, so that ptp_lock is always valid regardless of the
interface state.

Fixes: b60189e0392f ("net: stmmac: Integrate EST with TAPRIO scheduler API")
Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>
Reviewed-by: Maxime Chevallier <maxime.chevallier@bootlin.com>
Link: https://patch.msgid.link/20260904-stmmac-fix-ptp-clock-init-v1-1-df70eb1eb04d@oss.qualcomm.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 1 +
 drivers/net/ethernet/stmicro/stmmac/stmmac_ptp.c  | 1 -
 2 files changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index fb8c65c2bc0ef..5ca6157208864 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -7417,6 +7417,7 @@ int stmmac_dvr_probe(struct device *device,
 	stmmac_napi_add(ndev);
 
 	mutex_init(&priv->lock);
+	rwlock_init(&priv->ptp_lock);
 
 	/* If a specific clk_csr value is passed from the platform
 	 * this means that the CSR Clock Range selection cannot be
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_ptp.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_ptp.c
index cc223fe086484..d1ad9161de3ae 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_ptp.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_ptp.c
@@ -307,7 +307,6 @@ void stmmac_ptp_register(struct stmmac_priv *priv)
 	stmmac_ptp_clock_ops.n_per_out = priv->dma_cap.pps_out_num;
 	stmmac_ptp_clock_ops.n_ext_ts = priv->dma_cap.aux_snapshot_n;
 
-	rwlock_init(&priv->ptp_lock);
 	mutex_init(&priv->aux_ts_lock);
 	priv->ptp_clock_ops = stmmac_ptp_clock_ops;
 
-- 
2.53.0



