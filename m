Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F5555304B5;
	Thu, 17 Sep 2026 17:27:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789666055; cv=none; b=j57+nJrvDppVbO39+SPRx4CtwYUQ9Rj/fHcRPzYYOzO9I30pEw+OIeeMdBKuus3gdvO2Nq4k2D9mI/9LJgiN5YsjOZ7WM/FHTdBP/hHtKmbsNlLgUKezgA0/b/t6OpPiJlngo3PJ6KjvqVYH43SEyLSCqqubpDh6vFM0Xd/sQ+I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789666055; c=relaxed/simple;
	bh=cEPmcWoaMGlk6TBGd77drCVxVHwn6y/Nx3d+IIQK9qg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fIr7uyhs4pmjKsN7XGNJfQddgYbx6ZGecfOhZ/E6z2XS4Ed30RsN6JRDTbHd0XPeuhWs5/mycZeQ0cjVi/qNSOoq1ck+JPob6J6Z8EUvW0mfYb0OifwGXF73ZkV8CUem6B5o4ogtCqrBtRfwhIfrQEjmKVnuFTTmZFtPqeqvzKo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NKWqwLvr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NKWqwLvr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41A091F000FF;
	Thu, 17 Sep 2026 17:27:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789666051;
	bh=OEr6O9VT1lQ30Srvk8TVKogjcJRQ4KYM/44LRerBco4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NKWqwLvriRzInqc0dDYss53IjegHlcoRRRf34g4/2/ITlzqyqOng6irBMD+tlwt6F
	 1rDt1D/ULXWrxwFPrm5q9a0k5VDSTDRD1tvIc4Q1VhmYoxBWEkEE2BqLuKS5AQBUUl
	 KlinaYPBsVLUGhQB3xipFH1/woZJCeUfrFmu9JyE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>,
	Maxime Chevallier <maxime.chevallier@bootlin.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0909/1250] net: stmmac: initialize ptp_lock at probe time
Date: Thu, 17 Sep 2026 16:11:44 +0100
Message-ID: <20260917151616.631179846@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 3f184c91db458..253f044fa70c6 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -7647,6 +7647,7 @@ int stmmac_dvr_probe(struct device *device,
 	stmmac_napi_add(ndev);
 
 	mutex_init(&priv->lock);
+	rwlock_init(&priv->ptp_lock);
 
 	stmmac_fpe_init(priv);
 
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_ptp.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_ptp.c
index 3e30172fa1294..0e4481127dc09 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_ptp.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_ptp.c
@@ -362,7 +362,6 @@ void stmmac_ptp_register(struct stmmac_priv *priv)
 	if (priv->plat->crosststamp)
 		priv->ptp_clock_ops.getcrosststamp = stmmac_getcrosststamp;
 
-	rwlock_init(&priv->ptp_lock);
 	mutex_init(&priv->aux_ts_lock);
 
 	priv->ptp_clock = ptp_clock_register(&priv->ptp_clock_ops,
-- 
2.53.0



