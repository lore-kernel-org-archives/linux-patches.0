Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE8594E4C24;
	Thu, 17 Sep 2026 15:45:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789659909; cv=none; b=fZ+J41+H543ohkQgZpf0HBOIIBeYyDytZt2720A1mjNyvl9IIuAdBxtXvwuwXpJ5g/jqQ5oOdkg0m6XQ4C6vEykrh7oliPSyai5TNKubxpM+qPZp9AGFizHv3DxyK0CkNJ/V9mO3pWIuyXQUSZ/E6jUwqYvuJh+O1X1s/o5xVmE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789659909; c=relaxed/simple;
	bh=OSlT3W7LrnOCZOUYbDK+uRlrnBj+aWirYHKhAgJmF1Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s2TaZjHvqcfk14B2UavMsVD9J4NmYY5iwuGGQSB0YSEiJhsXqkidDn6WTF6nS5zD8idutxz9tMvORYCdZwax/x/VYu5cQW8iAQRUqKFHLMA0VOoOTkdhTOW9U54L0et04XZz7IptEKaT+aqCzTHKx+1N385tW6cSLqvEOnTKxjk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Mp5FquwE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Mp5FquwE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EECD1F000FF;
	Thu, 17 Sep 2026 15:44:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789659896;
	bh=HBHL3DDLCtSsRiK6/Npyq3v6fFEvM2F7AXkN7CFCXVc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Mp5FquwEQzl0MXxefzt6h04UewjIl48YOxp70EIwvOOzf1fCDsG327m1XjplpMiDM
	 D9xkEbKTUCMRw9TtzaQM57bceu4MY7Gjgzkb3H7wEaOCG6MGhqEm0gFVZPjE6RfjKF
	 whxmvX9yaoq9cYSLbl2E7BrAu02WEuaC4ZKaVCcc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>,
	Maxime Chevallier <maxime.chevallier@bootlin.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 408/733] net: stmmac: initialize ptp_lock at probe time
Date: Thu, 17 Sep 2026 16:11:56 +0100
Message-ID: <20260917151401.928368340@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index 1e88575fdddbb..aa05160c22e35 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -8032,6 +8032,7 @@ static int __stmmac_dvr_probe(struct device *device,
 	stmmac_napi_add(ndev);
 
 	mutex_init(&priv->lock);
+	rwlock_init(&priv->ptp_lock);
 
 	stmmac_fpe_init(priv);
 
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_ptp.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_ptp.c
index 960249960004c..3bfcc9760dce7 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_ptp.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_ptp.c
@@ -365,7 +365,6 @@ void stmmac_ptp_register(struct stmmac_priv *priv)
 	if (priv->plat->crosststamp)
 		priv->ptp_clock_ops.getcrosststamp = stmmac_getcrosststamp;
 
-	rwlock_init(&priv->ptp_lock);
 	mutex_init(&priv->aux_ts_lock);
 
 	priv->ptp_clock = ptp_clock_register(&priv->ptp_clock_ops,
-- 
2.53.0



