Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A95DE31D366;
	Wed, 30 Sep 2026 18:06:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790791574; cv=none; b=s8JAIVNn0jx5n2UzCx2mpOywFW14t+L6//0y7Jgk9LBtooEEBqMSgpsk0GMdMSy0YYjmdbOvxtmLFm3wcOtsqKv34sa/Z15GYpVI31G9GwlKMA+8zgbBvzYsZh9HO9LOLSjx3oXT0i+bxz5gidc7ItCUTwmoXw/rDvHsCy/S61E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790791574; c=relaxed/simple;
	bh=quxQf83fTBfiY6JNe7rAHrz4VIzeaJW1XN+a/rV9TEE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=on1YapGOJ1pGIy4kTaj/aBu0awMmXhYzh5DuEUOM5SoHEvGOVXmBwQdaFwnSPe20uYbtC00k8TreAd4DZOqPRxZbPw3gKRGF2TycJhSAIxy125ybf6Mha9NwGOxGC2EvSxY5A0ItNukOZ9TGExNeqWfUTKkPbhXO4nQWVXN3i1k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NZ036Iv0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NZ036Iv0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F8781F000FF;
	Wed, 30 Sep 2026 18:06:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790791573;
	bh=EO392t9mvQieZ0H2QYQp6JFbSKFcd1WWdq//j5reApo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NZ036Iv07RynDoqxkajFK7sCTsdIXUPHHvLf/dF4hgzMieqoiIThSaB3KlOyGRgDo
	 B++hrXLds5JOwX1oh3Kz5qjt3O+doSsuzQ8rbN0lt2J3dcxvmuby1ffWtMOcdtVHo2
	 fbUhg2zxkKTk11aUNEXaxfBTMmCjQcJE9JrTvMNA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>,
	Maxime Chevallier <maxime.chevallier@bootlin.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 349/752] net: stmmac: initialize ptp_lock at probe time
Date: Wed, 30 Sep 2026 17:23:39 +0200
Message-ID: <20260930152405.840276537@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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
index 496889d498832..73510737196f4 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -7221,6 +7221,7 @@ int stmmac_dvr_probe(struct device *device,
 	stmmac_napi_add(ndev);
 
 	mutex_init(&priv->lock);
+	rwlock_init(&priv->ptp_lock);
 
 	/* If a specific clk_csr value is passed from the platform
 	 * this means that the CSR Clock Range selection cannot be
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_ptp.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_ptp.c
index 0ab5fca50b7bb..dd16755c216e0 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_ptp.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_ptp.c
@@ -302,7 +302,6 @@ void stmmac_ptp_register(struct stmmac_priv *priv)
 	stmmac_ptp_clock_ops.n_per_out = priv->dma_cap.pps_out_num;
 	stmmac_ptp_clock_ops.n_ext_ts = priv->dma_cap.aux_snapshot_n;
 
-	rwlock_init(&priv->ptp_lock);
 	mutex_init(&priv->aux_ts_lock);
 	priv->ptp_clock_ops = stmmac_ptp_clock_ops;
 
-- 
2.53.0



