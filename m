Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 490337B3C3;
	Mon,  4 Mar 2024 21:26:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709587615; cv=none; b=qewXpjKmSGvhRsMxYsSxESIuSekFFoHMMnLpyz5ptZBAm3P9Ecyd5xtUcxgmYBHJ032YNhSYD+3YTAGtHbyvrBmu7/maSPaWfeNUVhO6/sk1EJX8butLmPBBKQCzvBY/NBrvl1L+jVsuQZ84tTnOJbhkNAgeb2CSCwBUeTZlaUw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709587615; c=relaxed/simple;
	bh=krZckaA767xjOA0B0zP/5hKZJelyyRhc83UGw2lnKp0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AhKxkFTvB9FBUky1PAjgmophuV3PohVNSmjT0aMjZjzQB/ab+H4vijSUnQ/5tjiddVA/0P38IOCZ1IdzTkd4DnjrJm3wM7lXFrAxW2zgyPhW6aaT6HTF1jAD9bx8uk2Dr9oV5GwQkh7UYRRuY6AEDSY4mitzLwJzBv2p7rNN4f4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bSHODg1h; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bSHODg1h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8171C433C7;
	Mon,  4 Mar 2024 21:26:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709587615;
	bh=krZckaA767xjOA0B0zP/5hKZJelyyRhc83UGw2lnKp0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bSHODg1hDTvv4K0DRGQx4md3+v6ekiaRtV6sjR4jrETKqOc5baY0W0OWQYqNtwUTn
	 /GTSpE0ez4/1I3C+wCNfvvjqOl156IPHkMks6Aq9CoiI8s06n58uDLNl8q0fhBY7xN
	 p4ABW5VVd8icll/uoJpYPXnvddpaJB/14CA87ZHM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jakub Raczynski <j.raczynski@samsung.com>,
	Jiri Pirko <jiri@nvidia.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 024/162] stmmac: Clear variable when destroying workqueue
Date: Mon,  4 Mar 2024 21:21:29 +0000
Message-ID: <20240304211552.604099475@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240304211551.833500257@linuxfoundation.org>
References: <20240304211551.833500257@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jakub Raczynski <j.raczynski@samsung.com>

[ Upstream commit 8af411bbba1f457c33734795f024d0ef26d0963f ]

Currently when suspending driver and stopping workqueue it is checked whether
workqueue is not NULL and if so, it is destroyed.
Function destroy_workqueue() does drain queue and does clear variable, but
it does not set workqueue variable to NULL. This can cause kernel/module
panic if code attempts to clear workqueue that was not initialized.

This scenario is possible when resuming suspended driver in stmmac_resume(),
because there is no handling for failed stmmac_hw_setup(),
which can fail and return if DMA engine has failed to initialize,
and workqueue is initialized after DMA engine.
Should DMA engine fail to initialize, resume will proceed normally,
but interface won't work and TX queue will eventually timeout,
causing 'Reset adapter' error.
This then does destroy workqueue during reset process.
And since workqueue is initialized after DMA engine and can be skipped,
it will cause kernel/module panic.

To secure against this possible crash, set workqueue variable to NULL when
destroying workqueue.

Log/backtrace from crash goes as follows:
[88.031977]------------[ cut here ]------------
[88.031985]NETDEV WATCHDOG: eth0 (sxgmac): transmit queue 1 timed out
[88.032017]WARNING: CPU: 0 PID: 0 at net/sched/sch_generic.c:477 dev_watchdog+0x390/0x398
           <Skipping backtrace for watchdog timeout>
[88.032251]---[ end trace e70de432e4d5c2c0 ]---
[88.032282]sxgmac 16d88000.ethernet eth0: Reset adapter.
[88.036359]------------[ cut here ]------------
[88.036519]Call trace:
[88.036523] flush_workqueue+0x3e4/0x430
[88.036528] drain_workqueue+0xc4/0x160
[88.036533] destroy_workqueue+0x40/0x270
[88.036537] stmmac_fpe_stop_wq+0x4c/0x70
[88.036541] stmmac_release+0x278/0x280
[88.036546] __dev_close_many+0xcc/0x158
[88.036551] dev_close_many+0xbc/0x190
[88.036555] dev_close.part.0+0x70/0xc0
[88.036560] dev_close+0x24/0x30
[88.036564] stmmac_service_task+0x110/0x140
[88.036569] process_one_work+0x1d8/0x4a0
[88.036573] worker_thread+0x54/0x408
[88.036578] kthread+0x164/0x170
[88.036583] ret_from_fork+0x10/0x20
[88.036588]---[ end trace e70de432e4d5c2c1 ]---
[88.036597]Unable to handle kernel NULL pointer dereference at virtual address 0000000000000004

Fixes: 5a5586112b929 ("net: stmmac: support FPE link partner hand-shaking procedure")
Signed-off-by: Jakub Raczynski <j.raczynski@samsung.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index e9a1b60ebb503..de4d769195174 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -3942,8 +3942,10 @@ static void stmmac_fpe_stop_wq(struct stmmac_priv *priv)
 {
 	set_bit(__FPE_REMOVING, &priv->fpe_task_state);
 
-	if (priv->fpe_wq)
+	if (priv->fpe_wq) {
 		destroy_workqueue(priv->fpe_wq);
+		priv->fpe_wq = NULL;
+	}
 
 	netdev_info(priv->dev, "FPE workqueue stop");
 }
-- 
2.43.0



