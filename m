Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95CD517552;
	Mon,  1 Apr 2024 15:57:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711987034; cv=none; b=n9q2AQGS7+el82V2VegNKyBjSOmAWRqeUHJfsJ+5w8aT4XcjEX+JEVujBewha4jcFYB2AsrXyLX5TiGlry9OikX3RWVF5wO5RyHWu6HiZ6hOnN0l2jHrxKWhOxK4fTqKTRgV7QFYq/T9njPKR4aevt6/uJJ6cNRFKxLXGnupaTg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711987034; c=relaxed/simple;
	bh=Y50rPgOxuDm4N4L0R3ZOXbCGBvMYr5hwMjwtaTNhYss=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ty3Xz8by4z3Dclxnd5kfjVxFuYCJ9xIcTxVFoXLkXz1X5hwOn52g2+j+iDyZw3BLWS2/Mefi+wPdv+LZVWBL7aMrEt026DUI8gJgIrMsTlWVBo7twRDL1Wn36pRrs8tp0s5iOvd+UPdt6Tca4WtfzUK6HJ11e0DcoWGlf7nEfJ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LYl45zbm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LYl45zbm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BA9AC43390;
	Mon,  1 Apr 2024 15:57:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711987034;
	bh=Y50rPgOxuDm4N4L0R3ZOXbCGBvMYr5hwMjwtaTNhYss=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LYl45zbmyEKW1ws9krhci2CM6k2KIEaPFYjXhw/GGX2OqeJ4ibA2ZGyo0OY1MF/BC
	 QJS7MirAM3HC3c6gLR5l7jhPHXnU2cUZnnED6344Px7w8n3JA7QVxcoL9BH/0tgxgn
	 V9chPp0wHc+M87AsI9Iw0y8A0VYn4+9ckoZZbOw4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Anderson <sean.anderson@linux.dev>,
	Camelia Groza <camelia.groza@nxp.com>,
	Vladimir Oltean <vladimir.oltean@nxp.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 162/399] soc: fsl: qbman: Always disable interrupts when taking cgr_lock
Date: Mon,  1 Apr 2024 17:42:08 +0200
Message-ID: <20240401152554.018061598@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152549.131030308@linuxfoundation.org>
References: <20240401152549.131030308@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

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
index 739e4eee6b75c..1bf1f1ea67f00 100644
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



