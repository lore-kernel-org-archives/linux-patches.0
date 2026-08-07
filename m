Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A73030E0F2;
	Fri,  7 Aug 2026 15:37:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786117040; cv=none; b=ANjpF8G1jZRWjd3xLfhzvuPHerzgpwA2b6Ytr6y0uom58C+gaXq1k+9znQSMgYNhAzgRWJUTVzG13rQg6PfgrCo02a3wv2HMyPBkVaYmevA4EVNqXqv2WzigUKUpUokW2sLn+WXQpamNNwDn7yepYVdBsVeIY3tyGLiokyjvOdw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786117040; c=relaxed/simple;
	bh=BN1C3fr0eIsRNGWwozvaA+eGOFFzm+xTQZxVa5iDjUk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=noP8KzmQk2iqixlPoNnBI8qsvI3AtsECTputje4N7zbIfbvNJRWEwJj23IM9F5SQW5ov8MYkHvOFAi1bZy+72JpHgNVbF4S/OtMAWH94A1trGuAhl2Pd/vBiGI6BAPYqib3NkQGNCdrDvVcwKknOINmPla4AxRq158LHuPw4UWQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nZnIP1Uu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nZnIP1Uu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C74DE1F000E9;
	Fri,  7 Aug 2026 15:37:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786117039;
	bh=OSPuP73eHrgx12nvcgYJabdY8Sc37nVM8t9L4ADpFSI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nZnIP1UugIG0wFWroN24frV+Mk5JvMFEhKWBZ1aQ00DLddQb00SkP9gwbSPuOdHw8
	 /251F6dAYDvmwCCZ/mEatD5EGQJIY7w/3xFDEhnWXt0sddISslaq1WXl/xv2L8Iyi7
	 F7fpgTH6evadKFf+Px3WpUV3iZb6zUDxt5us7KvA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Wei Fang <wei.fang@nxp.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 180/438] ptp: netc: fix potential interrupt storm caused by incorrect unbind order
Date: Fri,  7 Aug 2026 16:36:16 +0200
Message-ID: <20260807143431.870952773@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143428.008222056@linuxfoundation.org>
References: <20260807143428.008222056@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wei Fang <wei.fang@nxp.com>

[ Upstream commit 54ad7ea45d63146a8e3c57375f8a269d4cf7ecea ]

In netc_timer_remove(), hardware interrupts are disabled by clearing
TMR_TEMASK before ptp_clock_unregister() is called. This may cause a
race condition during driver unbind that could leave hardware interrupts
active. For example, a concurrent PTP_CLK_REQ_EXTTS ioctl can re-enable
TMR_TEMASK after it has been cleared, leaving a pending hardware
interrupt when the driver unbinds.

Since the NETC Timer does not support PCIe FLR, hardware state is not
reset during probe. When the driver is rebound and the IRQ is registered,
the pending interrupt fires immediately. At that point priv->tmr_emask
is still zero, so netc_timer_isr() does not clear the interrupt status
and unconditionally returns IRQ_HANDLED, resulting in an uninterruptible
infinite interrupt storm.

Fix this in several ways. First, request the IRQ with IRQF_NO_AUTOEN so
it is not enabled when request_irq() runs, and clear TMR_TEMASK in
netc_timer_init() before enabling it. The IRQ is only enabled at the end
of probe once the timer has been reprogrammed and the PTP clock has been
registered. This ensures a stale pending interrupt from a previous unbind
or an unclean shutdown cannot be delivered before the driver is fully
initialized.

Second, in netc_timer_remove() call disable_irq() before
ptp_clock_unregister() and move the TMR_TEMASK/TMR_CTRL clearing after
it. disable_irq() masks the line and waits for any in-flight
netc_timer_isr() to finish, so no ISR can dereference priv->clock after
ptp_clock_unregister() has freed it. Unregistering the PTP clock before
clearing the mask also guarantees that no in-flight or concurrent ioctl
can re-enable hardware interrupts.

Finally, return IRQ_NONE from netc_timer_isr() when the masked event
status is zero, so the kernel's spurious interrupt detection can disable
a stuck line instead of looping forever.

Fixes: 671e266835b8 ("ptp: netc: add periodic pulse output support")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://sashiko.dev/#/patchset/20260720012508.23227-1-wei.fang%40oss.nxp.com
Signed-off-by: Wei Fang <wei.fang@nxp.com>
Link: https://patch.msgid.link/20260727060348.1887464-1-wei.fang@oss.nxp.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ptp/ptp_netc.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/drivers/ptp/ptp_netc.c b/drivers/ptp/ptp_netc.c
index 5e381c354d746..1c20d7efab929 100644
--- a/drivers/ptp/ptp_netc.c
+++ b/drivers/ptp/ptp_netc.c
@@ -769,6 +769,7 @@ static void netc_timer_init(struct netc_timer *priv)
 		   TMR_CTRL_TE | TMR_CTRL_FS;
 	netc_timer_wr(priv, NETC_TMR_CTRL, tmr_ctrl);
 	netc_timer_wr(priv, NETC_TMR_PRSC, priv->oclk_prsc);
+	netc_timer_wr(priv, NETC_TMR_TEMASK, 0);
 
 	/* Disable FIPER by default */
 	fiper_ctrl = netc_timer_rd(priv, NETC_TMR_FIPER_CTRL);
@@ -901,6 +902,11 @@ static irqreturn_t netc_timer_isr(int irq, void *data)
 	/* Clear interrupts status */
 	netc_timer_wr(priv, NETC_TMR_TEVENT, tmr_event);
 
+	if (!tmr_event) {
+		spin_unlock(&priv->lock);
+		return IRQ_NONE;
+	}
+
 	if (tmr_event & TMR_TEVENT_ALMEN(0))
 		netc_timer_alarm_write(priv, NETC_TMR_DEFAULT_ALARM, 0);
 
@@ -936,7 +942,8 @@ static int netc_timer_init_msix_irq(struct netc_timer *priv)
 	}
 
 	priv->irq = pci_irq_vector(pdev, 0);
-	err = request_irq(priv->irq, netc_timer_isr, 0, priv->irq_name, priv);
+	err = request_irq(priv->irq, netc_timer_isr, IRQF_NO_AUTOEN,
+			  priv->irq_name, priv);
 	if (err) {
 		dev_err(&pdev->dev, "request_irq() failed\n");
 		pci_free_irq_vectors(pdev);
@@ -951,7 +958,6 @@ static void netc_timer_free_msix_irq(struct netc_timer *priv)
 {
 	struct pci_dev *pdev = priv->pdev;
 
-	disable_irq(priv->irq);
 	free_irq(priv->irq, priv);
 	pci_free_irq_vectors(pdev);
 }
@@ -1005,6 +1011,8 @@ static int netc_timer_probe(struct pci_dev *pdev,
 		goto free_msix_irq;
 	}
 
+	enable_irq(priv->irq);
+
 	return 0;
 
 free_msix_irq:
@@ -1019,9 +1027,10 @@ static void netc_timer_remove(struct pci_dev *pdev)
 {
 	struct netc_timer *priv = pci_get_drvdata(pdev);
 
+	disable_irq(priv->irq);
+	ptp_clock_unregister(priv->clock);
 	netc_timer_wr(priv, NETC_TMR_TEMASK, 0);
 	netc_timer_wr(priv, NETC_TMR_CTRL, 0);
-	ptp_clock_unregister(priv->clock);
 	netc_timer_free_msix_irq(priv);
 	netc_timer_pci_remove(pdev);
 }
-- 
2.53.0



