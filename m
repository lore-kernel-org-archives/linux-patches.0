Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1ED431DE2AD;
	Tue,  8 Oct 2024 12:41:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728391302; cv=none; b=R2ZJy21MQmhTwLECB1LSastEmi2IBgkAiHax9zqF/Nw8bdxlIFfDVO7O/ifAhEf2PLGy3IuzUysieli4DSVg9uetcytMk3JT4qVrQySxa/Ha5qDBO/OHA9c6vJLzGmxgZinuJ/LkBpuqJqKqFHvn6O3UwjC3irWKPFjJHmCbWPM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728391302; c=relaxed/simple;
	bh=3vIG+G5h9tU+v6THAs2N3TPzPCgqJ+hgLDYoPtFMNaw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XlNpW47Bl//PWh5P7Ki7wK/YuTkAgKI3SGgtZPJ4Mla4OaCD2SQpsA6+wAPK5Sc9csSfGk1r24Ycy/W3hV4b/AyOl0zhz8uDwgFmzBfuSGE49JcidAs+CBsDs0DCYAV3eu4UfmUh22jpeKECSNEsxvoJSDcnn4PMIO3BP5reFJ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=faP43Y2s; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="faP43Y2s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9400EC4CEC7;
	Tue,  8 Oct 2024 12:41:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728391302;
	bh=3vIG+G5h9tU+v6THAs2N3TPzPCgqJ+hgLDYoPtFMNaw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=faP43Y2sb/4PyiWFfqYul/TqBNhAS9ySf/h44e8W0NCj+LnDItoK38xXysQRZYVCp
	 PG91FlvUrKWXySX0f5PH9j/CniDXtlZVb0WMdut4K6jJXgVHTtZG8KfwvS4791xgCN
	 5/u7iXfrrG1XmGuQIaYUlN/pbH/pjbhWta+DoH8o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Cs=C3=B3k=C3=A1s,
	=20Bence?= <csokas.bence@prolan.hu>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 040/558] net: fec: Restart PPS after link state change
Date: Tue,  8 Oct 2024 14:01:10 +0200
Message-ID: <20241008115703.801148899@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115702.214071228@linuxfoundation.org>
References: <20241008115702.214071228@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Csókás, Bence <csokas.bence@prolan.hu>

[ Upstream commit a1477dc87dc4996dcf65a4893d4e2c3a6b593002 ]

On link state change, the controller gets reset,
causing PPS to drop out. Re-enable PPS if it was
enabled before the controller reset.

Fixes: 6605b730c061 ("FEC: Add time stamping code and a PTP hardware clock")
Signed-off-by: Csókás, Bence <csokas.bence@prolan.hu>
Link: https://patch.msgid.link/20240924093705.2897329-1-csokas.bence@prolan.hu
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/freescale/fec.h      |  6 +++++
 drivers/net/ethernet/freescale/fec_main.c | 11 ++++++++-
 drivers/net/ethernet/freescale/fec_ptp.c  | 30 +++++++++++++++++++++++
 3 files changed, 46 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/freescale/fec.h b/drivers/net/ethernet/freescale/fec.h
index a19cb2a786fd2..0552317a2554b 100644
--- a/drivers/net/ethernet/freescale/fec.h
+++ b/drivers/net/ethernet/freescale/fec.h
@@ -691,10 +691,16 @@ struct fec_enet_private {
 	/* XDP BPF Program */
 	struct bpf_prog *xdp_prog;
 
+	struct {
+		int pps_enable;
+	} ptp_saved_state;
+
 	u64 ethtool_stats[];
 };
 
 void fec_ptp_init(struct platform_device *pdev, int irq_idx);
+void fec_ptp_restore_state(struct fec_enet_private *fep);
+void fec_ptp_save_state(struct fec_enet_private *fep);
 void fec_ptp_stop(struct platform_device *pdev);
 void fec_ptp_start_cyclecounter(struct net_device *ndev);
 int fec_ptp_set(struct net_device *ndev, struct kernel_hwtstamp_config *config,
diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
index a923cb95cdc62..570f8a14d975b 100644
--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -1077,6 +1077,8 @@ fec_restart(struct net_device *ndev)
 	u32 rcntl = OPT_FRAME_SIZE | 0x04;
 	u32 ecntl = FEC_ECR_ETHEREN;
 
+	fec_ptp_save_state(fep);
+
 	/* Whack a reset.  We should wait for this.
 	 * For i.MX6SX SOC, enet use AXI bus, we use disable MAC
 	 * instead of reset MAC itself.
@@ -1244,8 +1246,10 @@ fec_restart(struct net_device *ndev)
 	writel(ecntl, fep->hwp + FEC_ECNTRL);
 	fec_enet_active_rxring(ndev);
 
-	if (fep->bufdesc_ex)
+	if (fep->bufdesc_ex) {
 		fec_ptp_start_cyclecounter(ndev);
+		fec_ptp_restore_state(fep);
+	}
 
 	/* Enable interrupts we wish to service */
 	if (fep->link)
@@ -1336,6 +1340,8 @@ fec_stop(struct net_device *ndev)
 			netdev_err(ndev, "Graceful transmit stop did not complete!\n");
 	}
 
+	fec_ptp_save_state(fep);
+
 	/* Whack a reset.  We should wait for this.
 	 * For i.MX6SX SOC, enet use AXI bus, we use disable MAC
 	 * instead of reset MAC itself.
@@ -1366,6 +1372,9 @@ fec_stop(struct net_device *ndev)
 		val = readl(fep->hwp + FEC_ECNTRL);
 		val |= FEC_ECR_EN1588;
 		writel(val, fep->hwp + FEC_ECNTRL);
+
+		fec_ptp_start_cyclecounter(ndev);
+		fec_ptp_restore_state(fep);
 	}
 }
 
diff --git a/drivers/net/ethernet/freescale/fec_ptp.c b/drivers/net/ethernet/freescale/fec_ptp.c
index 2e4f3e1782a25..8027b532de078 100644
--- a/drivers/net/ethernet/freescale/fec_ptp.c
+++ b/drivers/net/ethernet/freescale/fec_ptp.c
@@ -770,6 +770,36 @@ void fec_ptp_init(struct platform_device *pdev, int irq_idx)
 	schedule_delayed_work(&fep->time_keep, HZ);
 }
 
+void fec_ptp_save_state(struct fec_enet_private *fep)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&fep->tmreg_lock, flags);
+
+	fep->ptp_saved_state.pps_enable = fep->pps_enable;
+
+	spin_unlock_irqrestore(&fep->tmreg_lock, flags);
+}
+
+/* Restore PTP functionality after a reset */
+void fec_ptp_restore_state(struct fec_enet_private *fep)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&fep->tmreg_lock, flags);
+
+	/* Reset turned it off, so adjust our status flag */
+	fep->pps_enable = 0;
+
+	spin_unlock_irqrestore(&fep->tmreg_lock, flags);
+
+	/* Restart PPS if needed */
+	if (fep->ptp_saved_state.pps_enable) {
+		/* Re-enable PPS */
+		fec_ptp_enable_pps(fep, 1);
+	}
+}
+
 void fec_ptp_stop(struct platform_device *pdev)
 {
 	struct net_device *ndev = platform_get_drvdata(pdev);
-- 
2.43.0



