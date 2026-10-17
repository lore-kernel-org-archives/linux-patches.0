Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49F063B42DE;
	Sat, 17 Oct 2026 17:53:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792259593; cv=none; b=gebVORaWrqaOR5tKqOFStu83FVVUtkeR1D+D3SyXxljFGbcmkpDyn/qR09LgUNfycJbUAP9cB80/eOd7LjQRsLsnu0QeB1HwCC+qqydBK4pPDUx4ofre0FyAIKpUFd1KphqLa3m8evkySUqdfCTSz3HMs+Vc0MmAlIn9fEDnYhw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792259593; c=relaxed/simple;
	bh=sTDAk37wGsDIyI6pMaOSxCU9cKKmGKtgkF3JMXIcNic=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FAlOCztxiRQ66cfiKd/7phHwOqyfYJmlwhwm/UQy/jg+8B/zIUHs+Dtf+BrtAtQYKpJ6/3BCwgW1j7Nqt7uqa/yVmKf6WIkWxTWmD60pZb6Y1x2JNqMqdpGRplWu1P4jP3eel31+lDOFRanB1DKLzElyV2vCopuiAzqFVm4tK5E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GPsBVag4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GPsBVag4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FF5C1F000C4;
	Sat, 17 Oct 2026 17:53:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792259592;
	bh=7/m6RXqStknkrcFPjpvHEg+JOAYxh+G7HvH39098wtY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GPsBVag4ZnVLYQ8p/YJ5lDin9UGsjZD6fL3VH3/dsytA7brOIKU+Nvb1aZCc/d6Er
	 fBT05uSQdStom+QaOa3syehaV6uSc/fBmA7nbCCs1Le49Avk0q3KChI7YmANvgmTWR
	 TMQaTtNnwSRYZ+yfbPWGwLGvbGVHl5cTbReqyRCw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xuanqiang Luo <luoxuanqiang@kylinos.cn>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1264/1674] net: ravb: serialize PTP clock teardown
Date: Sat, 17 Oct 2026 17:58:56 +0200
Message-ID: <20261017160503.585645278@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xuanqiang Luo <luoxuanqiang@kylinos.cn>

[ Upstream commit 1cb9663789c5b7a12fcd419fcca6d6254c398252 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/renesas/ravb_ptp.c | 37 +++++++++++++++++++------
 1 file changed, 29 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/renesas/ravb_ptp.c b/drivers/net/ethernet/renesas/ravb_ptp.c
index fd674f1210865..5806db5d57d56 100644
--- a/drivers/net/ethernet/renesas/ravb_ptp.c
+++ b/drivers/net/ethernet/renesas/ravb_ptp.c
@@ -299,16 +299,17 @@ static const struct ptp_clock_info ravb_ptp_info = {
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
@@ -344,19 +345,39 @@ void ravb_ptp_init(struct net_device *ndev, struct platform_device *pdev)
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
+		synchronize_irq(priv->erra_irq);
+		synchronize_irq(priv->mgmta_irq);
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
-- 
2.53.0



