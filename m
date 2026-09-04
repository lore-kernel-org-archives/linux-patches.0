Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B300D4CCDC7;
	Fri,  4 Sep 2026 06:20:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788502829; cv=none; b=HI62f0mO94VZlaa4YQ59ga/4DJx+lHU7mR7BYhB5CHYhGp/DJe8PXalz/jfyhodaqWpS4cQh4KsfQbnhR8x1BiXjd60AQvtb+2Y+uMNSGT0cbckzs1Gj8qghoS3NJcvnIJzshUd6zscSnvGLuf8hP0JQ1OeMOg6AQbvnBt5o8/4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788502829; c=relaxed/simple;
	bh=6JFbYwijatl7KtQgl7Fcjgdx0c26XaCwWWOfySVZc/Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R3FCSVP46taeEfppivAZsVE6Tycm6RNB+bOPnS4Zrakvc05TnRIqbOnHFrogA8TF7vURIM1RGGS2SF2DN+UhkeG2JgIvF30OLOr7aJhrQDzVP70ui9ekyj5fbn/KxtMfFpm5fgAoI/BCksI5oB1MaGmU1j0uv3gNCKq0ApEnF3A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PxbbAjRn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PxbbAjRn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 104211F00A3D;
	Fri,  4 Sep 2026 06:20:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788502827;
	bh=345sfZZGaUMTyLTUZta0rN9ZU2JKgwyFJszAkdwRqQQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PxbbAjRnvCX+FpFMnwH/HMDEzPJoZ7ALIgG0ABxW1rszlxTMqRWDZGkI3rkOWVaLJ
	 vWZ+PIn5v9JmAIVRSrch/lgz3+MQE0n27tBMp+nmcoN9eOGzaQ8YC7a2pa7GOBwc5b
	 NzQXwCMOq5HgMzFcgkNJfMUHyaLSDs+E2IRm2mV8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xuanqiang Luo <luoxuanqiang@kylinos.cn>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.12 344/403] net: ravb: serialize PTP clock teardown
Date: Fri,  4 Sep 2026 07:02:27 +0200
Message-ID: <20260904045742.640879721@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045734.806166532@linuxfoundation.org>
References: <20260904045734.806166532@linuxfoundation.org>
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

From: Xuanqiang Luo <luoxuanqiang@kylinos.cn>

commit 1cb9663789c5b7a12fcd419fcca6d6254c398252 upstream.

ravb_ptp_interrupt() can race with ravb_ptp_stop() and pass the clock to
ptp_clock_event() while ptp_clock_unregister() is freeing it. This can
lead to a use-after-free.

Use READ_ONCE() and WRITE_ONCE() for lockless access to the clock pointer.
Atomically detach it with xchg() before disabling PTP interrupts, then
synchronize all IRQs which can invoke ravb_ptp_interrupt() before
unregistering the detached clock.

A handler which read the old pointer completes before the clock is
unregistered, while later handlers read NULL and skip the event.

Fixes: a0d2f20650e8 ("Renesas Ethernet AVB PTP clock driver")
Cc: stable@vger.kernel.org
Signed-off-by: Xuanqiang Luo <luoxuanqiang@kylinos.cn>
Link: https://patch.msgid.link/20260811103733.62599-3-xuanqiang.luo@linux.dev
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/renesas/ravb.h      |    2 +
 drivers/net/ethernet/renesas/ravb_main.c |    6 +++--
 drivers/net/ethernet/renesas/ravb_ptp.c  |   37 ++++++++++++++++++++++++-------
 3 files changed, 35 insertions(+), 10 deletions(-)

--- a/drivers/net/ethernet/renesas/ravb.h
+++ b/drivers/net/ethernet/renesas/ravb.h
@@ -1128,6 +1128,8 @@ struct ravb_private {
 	int msg_enable;
 	int speed;
 	int emac_irq;
+	int err_irq;
+	int mgmt_irq;
 
 	unsigned no_avb_link:1;
 	unsigned avb_link_active_low:1;
--- a/drivers/net/ethernet/renesas/ravb_main.c
+++ b/drivers/net/ethernet/renesas/ravb_main.c
@@ -2887,11 +2887,13 @@ static int ravb_setup_irqs(struct ravb_p
 		return error;
 
 	if (info->err_mgmt_irqs) {
-		error = ravb_setup_irq(priv, "err_a", "err_a", NULL, ravb_multi_interrupt);
+		error = ravb_setup_irq(priv, "err_a", "err_a", &priv->err_irq,
+				       ravb_multi_interrupt);
 		if (error)
 			return error;
 
-		error = ravb_setup_irq(priv, "mgmt_a", "mgmt_a", NULL, ravb_multi_interrupt);
+		error = ravb_setup_irq(priv, "mgmt_a", "mgmt_a", &priv->mgmt_irq,
+				       ravb_multi_interrupt);
 		if (error)
 			return error;
 	}
--- a/drivers/net/ethernet/renesas/ravb_ptp.c
+++ b/drivers/net/ethernet/renesas/ravb_ptp.c
@@ -299,16 +299,17 @@ static const struct ptp_clock_info ravb_
 void ravb_ptp_interrupt(struct net_device *ndev)
 {
 	struct ravb_private *priv = netdev_priv(ndev);
+	struct ptp_clock *clock = READ_ONCE(priv->ptp.clock);
 	u32 gis = ravb_read(ndev, GIS);
 
 	gis &= ravb_read(ndev, GIC);
-	if (gis & GIS_PTCF) {
+	if ((gis & GIS_PTCF) && clock) {
 		struct ptp_clock_event event;
 
 		event.type = PTP_CLOCK_EXTTS;
 		event.index = 0;
 		event.timestamp = ravb_read(ndev, GCPT);
-		ptp_clock_event(priv->ptp.clock, &event);
+		ptp_clock_event(clock, &event);
 	}
 	if (gis & GIS_PTMF) {
 		struct ravb_ptp_perout *perout = priv->ptp.perout;
@@ -344,19 +345,39 @@ void ravb_ptp_init(struct net_device *nd
 		clock = NULL;
 	}
 
-	priv->ptp.clock = clock;
+	WRITE_ONCE(priv->ptp.clock, clock);
 	if (clock)
 		WRITE_ONCE(priv->ptp.phc_index, ptp_clock_index(clock));
 }
 
-void ravb_ptp_stop(struct net_device *ndev)
+static void ravb_ptp_disable(struct net_device *ndev)
 {
-	struct ravb_private *priv = netdev_priv(ndev);
-
 	ravb_write(ndev, 0, GIC);
 	ravb_write(ndev, 0, GIS);
+}
+
+static void ravb_ptp_sync_irqs(struct net_device *ndev)
+{
+	struct ravb_private *priv = netdev_priv(ndev);
+
+	synchronize_irq(ndev->irq);
+	if (priv->info->err_mgmt_irqs) {
+		synchronize_irq(priv->err_irq);
+		synchronize_irq(priv->mgmt_irq);
+	}
+}
+
+void ravb_ptp_stop(struct net_device *ndev)
+{
+	struct ravb_private *priv = netdev_priv(ndev);
+	struct ptp_clock *clock;
 
 	WRITE_ONCE(priv->ptp.phc_index, -1);
-	if (priv->ptp.clock)
-		ptp_clock_unregister(priv->ptp.clock);
+	clock = xchg(&priv->ptp.clock, NULL);
+
+	ravb_ptp_disable(ndev);
+	ravb_ptp_sync_irqs(ndev);
+
+	if (clock)
+		ptp_clock_unregister(clock);
 }


