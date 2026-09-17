Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 998864973B9;
	Thu, 17 Sep 2026 18:48:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789670895; cv=none; b=goEjHvYb+i7XEirGDkW9ssb8SSuqZNSVlbWvwc6h4gHMsWGDdb2ts4uqFc/2xEkEVqQrUna1CbPBNB10fs2CihgA4tKwbfm7qAQmRjwW+2QJXgjkjiL4lz29jXsBlv8TH6e//Zaod1ijcSwE5cJNVilxYWW7oy16vLz7hxaaud8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789670895; c=relaxed/simple;
	bh=7xkBvf0KogQmuGJXPYADvXwTSr4N9EaxqjjHbo5OSP0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kI3fXe9KImkJzGGvIa0YMdqQA3rAoS4/sl0LwxTkiSNezJJ3xdO4SXEpFCT/YRcC24wShqUM+GkdsHrHQMmATn3wXZTwGAX6uNghUPQZgrmA7e6tOWMEOpIdjhACf/MzHIejM+xPySZmRd7zVOIIOhXMR8MhiLbs5vMsmXTshaM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xTQzHA0J; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xTQzHA0J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E22571F000FF;
	Thu, 17 Sep 2026 18:48:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789670894;
	bh=SGrar8s07HxkGlMebjsbkohoaNru8naa5bQmCp58R5I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xTQzHA0J1kA27qHxnlYwMeJkqn6e3EsnkOVOS+qxz1cvSFaUBPwj/O32qXHsneHkf
	 FBH2RY3JKQdKdez5+Um2uhXvDXftW3t4HHx8A5yLNqJnSZ7xdHOw0cwTN+7UrAid0J
	 uWcPj1djka0VIsLdZn2JpVprBWwfK9qTUjKZBXC8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>,
	Maxime Chevallier <maxime.chevallier@bootlin.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0767/1102] net: stmmac: initialize ptp_lock at probe time
Date: Thu, 17 Sep 2026 16:11:50 +0100
Message-ID: <20260917151559.698450671@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 4dcd29e814083..f583542edd801 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -7733,6 +7733,7 @@ int stmmac_dvr_probe(struct device *device,
 	stmmac_napi_add(ndev);
 
 	mutex_init(&priv->lock);
+	rwlock_init(&priv->ptp_lock);
 
 	priv->fpe_cfg.verify_retries = STMMAC_FPE_MM_MAX_VERIFY_RETRIES;
 	priv->fpe_cfg.verify_time = STMMAC_FPE_MM_MAX_VERIFY_TIME_MS;
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_ptp.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_ptp.c
index 5c85040a1b937..4970098585c11 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_ptp.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_ptp.c
@@ -309,7 +309,6 @@ void stmmac_ptp_register(struct stmmac_priv *priv)
 	stmmac_ptp_clock_ops.n_per_out = priv->dma_cap.pps_out_num;
 	stmmac_ptp_clock_ops.n_ext_ts = priv->dma_cap.aux_snapshot_n;
 
-	rwlock_init(&priv->ptp_lock);
 	mutex_init(&priv->aux_ts_lock);
 	priv->ptp_clock_ops = stmmac_ptp_clock_ops;
 
-- 
2.53.0



