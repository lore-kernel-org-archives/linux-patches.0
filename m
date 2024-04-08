Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A67E67C6D5;
	Mon,  8 Apr 2024 13:11:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712581899; cv=none; b=WtmAYFP2d9MVSnxEvhYguQDuVrsBtw2PulaZd8Oz86RCd6dgVQN/wyltYS5HuT4V15F1+pQD9gXuLX0BGp+CiClQf3uOxF4nMiJScJ/4m0/cYm9+/tCAFs2rIhY09RF4R/9XgznNlnPIwPhPsc60nNMgppIne1scVlBbrwhDb90=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712581899; c=relaxed/simple;
	bh=neHzhRHBGuHZY8rzfJal3IhPN5qafXoXS0X5xe5mSQY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GqsqvKQ0AsFm5Hwiv9zS1KKZkJA+D+bJGm0Xjw1KUNaBN8raCkZp+wOSMLC3kCp7EpB1Z0Nf+1XKNGKulOgL8bgw0Ba3Apap2s+kfAfaA5zEDKKVbalCN9+FFOw3XAd2YV7BDvVPp0w43DIuLymRhGM1yBf0MwniEJalgrJ4+rE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cudjrpfW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cudjrpfW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC883C433F1;
	Mon,  8 Apr 2024 13:11:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712581899;
	bh=neHzhRHBGuHZY8rzfJal3IhPN5qafXoXS0X5xe5mSQY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cudjrpfWTrQ+hROcs3t+8Aw8traTVzNXPzGQHZr+9slhkuwtr9uo1yW+mM7aggPI2
	 wROLtZd+b+aUKacDK9G8ExojFQp1YyKfGbgqVS0LaF/nXCTjo0HBfzG9c93YxRPS2S
	 rIYP0kdnLmOUQ6X+iS2GjtQEOaaWbfa1mPqShRRA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Anderson <sean.anderson@linux.dev>,
	Camelia Groza <camelia.groza@nxp.com>,
	Vladimir Oltean <vladimir.oltean@nxp.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 091/690] soc: fsl: qbman: Always disable interrupts when taking cgr_lock
Date: Mon,  8 Apr 2024 14:49:17 +0200
Message-ID: <20240408125402.783422077@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125359.506372836@linuxfoundation.org>
References: <20240408125359.506372836@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Sean Anderson <sean.anderson@linux.dev>

[ Upstream commit 584c2a9184a33a40fceee838f856de3cffa19be3 ]

smp_call_function_single disables IRQs when executing the callback. To
prevent deadlocks, we must disable IRQs when taking cgr_lock elsewhere.
This is already done by qman_update_cgr and qman_delete_cgr; fix the
other lockers.

Fixes: 96f413f47677 ("soc/fsl/qbman: fix issue in qman_delete_cgr_safe()")
CC: stable@vger.kernel.org
Signed-off-by: Sean Anderson <sean.anderson@linux.dev>
Reviewed-by: Camelia Groza <camelia.groza@nxp.com>
Tested-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/fsl/qbman/qman.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/soc/fsl/qbman/qman.c b/drivers/soc/fsl/qbman/qman.c
index fde4edd83c14c..d04a1a39dc286 100644
--- a/drivers/soc/fsl/qbman/qman.c
+++ b/drivers/soc/fsl/qbman/qman.c
@@ -1456,11 +1456,11 @@ static void qm_congestion_task(struct work_struct *work)
 	union qm_mc_result *mcr;
 	struct qman_cgr *cgr;
 
-	spin_lock(&p->cgr_lock);
+	spin_lock_irq(&p->cgr_lock);
 	qm_mc_start(&p->p);
 	qm_mc_commit(&p->p, QM_MCC_VERB_QUERYCONGESTION);
 	if (!qm_mc_result_timeout(&p->p, &mcr)) {
-		spin_unlock(&p->cgr_lock);
+		spin_unlock_irq(&p->cgr_lock);
 		dev_crit(p->config->dev, "QUERYCONGESTION timeout\n");
 		qman_p_irqsource_add(p, QM_PIRQ_CSCI);
 		return;
@@ -1476,7 +1476,7 @@ static void qm_congestion_task(struct work_struct *work)
 	list_for_each_entry(cgr, &p->cgr_cbs, node)
 		if (cgr->cb && qman_cgrs_get(&c, cgr->cgrid))
 			cgr->cb(p, cgr, qman_cgrs_get(&rr, cgr->cgrid));
-	spin_unlock(&p->cgr_lock);
+	spin_unlock_irq(&p->cgr_lock);
 	qman_p_irqsource_add(p, QM_PIRQ_CSCI);
 }
 
@@ -2440,7 +2440,7 @@ int qman_create_cgr(struct qman_cgr *cgr, u32 flags,
 	preempt_enable();
 
 	cgr->chan = p->config->channel;
-	spin_lock(&p->cgr_lock);
+	spin_lock_irq(&p->cgr_lock);
 
 	if (opts) {
 		struct qm_mcc_initcgr local_opts = *opts;
@@ -2477,7 +2477,7 @@ int qman_create_cgr(struct qman_cgr *cgr, u32 flags,
 	    qman_cgrs_get(&p->cgrs[1], cgr->cgrid))
 		cgr->cb(p, cgr, 1);
 out:
-	spin_unlock(&p->cgr_lock);
+	spin_unlock_irq(&p->cgr_lock);
 	put_affine_portal();
 	return ret;
 }
-- 
2.43.0



