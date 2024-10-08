Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5097B1DE3AF;
	Tue,  8 Oct 2024 12:13:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728389591; cv=none; b=ocqp5PltQFmlUCMs6e3v9C3DUyX1duUv3W73oAisN8C5Ry0yHwNin/juGJ1AFagaQv58rQPkIEEaE9Pkz/qyLk4cA5vCcpMXU25liQZ35DboNCLbQ7Oxaa7xqL4fbgsiEWSXNb2uNNDoCSF+AOOMhT0PtrxNlnlTRbUq3OuPPBw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728389591; c=relaxed/simple;
	bh=OX22ILeTOzDLJvsWRlVyMs+MannIPgKaQ1pI2zmPpp4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tethW63QnwoYcsd/QHPCybTjCGqAygXsdX/+GzzZDRpBvu5s2xvJ1Vp6l3J0O3t0M5g4/qQnRJ3eQyrTEvyTaNiF403PsFc9ATC7T1SufErGFV8MIggEdwl2F/XrW0L8lXMxXpRa6juc0f7RcRNG4wlnDUA2cNyofrG7JHtHH24=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xH5/Ea7Q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xH5/Ea7Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B47BBC4CECC;
	Tue,  8 Oct 2024 12:13:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728389591;
	bh=OX22ILeTOzDLJvsWRlVyMs+MannIPgKaQ1pI2zmPpp4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xH5/Ea7Q54gBsBz9oHvcx006Ka1GfQLnCyRFzRX+ggxxgQedoSGVoC1kRkQUOYX1e
	 rJ/j1hD0ou2u3Cmn13Amj47uB2jdi/fvwiPSNBYZBQbV1S0KnH/bX5/42gVxVK1cVb
	 mw92Xv9J5WOaiIpVosgZ5oJoWjwZU8gsqt0cRQng=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Cs=C3=B3k=C3=A1s,
	=20Bence?= <csokas.bence@prolan.hu>,
	Wei Fang <wei.fang@nxp.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 038/482] net: fec: Reload PTP registers after link-state change
Date: Tue,  8 Oct 2024 14:01:41 +0200
Message-ID: <20241008115649.802831648@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115648.280954295@linuxfoundation.org>
References: <20241008115648.280954295@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Csókás, Bence <csokas.bence@prolan.hu>

[ Upstream commit d9335d0232d2da605585eea1518ac6733518f938 ]

On link-state change, the controller gets reset,
which clears all PTP registers, including PHC time,
calibrated clock correction values etc. For correct
IEEE 1588 operation we need to restore these after
the reset.

Fixes: 6605b730c061 ("FEC: Add time stamping code and a PTP hardware clock")
Signed-off-by: Csókás, Bence <csokas.bence@prolan.hu>
Reviewed-by: Wei Fang <wei.fang@nxp.com>
Link: https://patch.msgid.link/20240924093705.2897329-2-csokas.bence@prolan.hu
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/freescale/fec.h     |  3 +++
 drivers/net/ethernet/freescale/fec_ptp.c | 20 ++++++++++++++++++++
 2 files changed, 23 insertions(+)

diff --git a/drivers/net/ethernet/freescale/fec.h b/drivers/net/ethernet/freescale/fec.h
index 0552317a2554b..1cca0425d4939 100644
--- a/drivers/net/ethernet/freescale/fec.h
+++ b/drivers/net/ethernet/freescale/fec.h
@@ -693,6 +693,9 @@ struct fec_enet_private {
 
 	struct {
 		int pps_enable;
+		u64 ns_sys, ns_phc;
+		u32 at_corr;
+		u8 at_inc_corr;
 	} ptp_saved_state;
 
 	u64 ethtool_stats[];
diff --git a/drivers/net/ethernet/freescale/fec_ptp.c b/drivers/net/ethernet/freescale/fec_ptp.c
index 8027b532de078..5e8fac50f945d 100644
--- a/drivers/net/ethernet/freescale/fec_ptp.c
+++ b/drivers/net/ethernet/freescale/fec_ptp.c
@@ -773,24 +773,44 @@ void fec_ptp_init(struct platform_device *pdev, int irq_idx)
 void fec_ptp_save_state(struct fec_enet_private *fep)
 {
 	unsigned long flags;
+	u32 atime_inc_corr;
 
 	spin_lock_irqsave(&fep->tmreg_lock, flags);
 
 	fep->ptp_saved_state.pps_enable = fep->pps_enable;
 
+	fep->ptp_saved_state.ns_phc = timecounter_read(&fep->tc);
+	fep->ptp_saved_state.ns_sys = ktime_get_ns();
+
+	fep->ptp_saved_state.at_corr = readl(fep->hwp + FEC_ATIME_CORR);
+	atime_inc_corr = readl(fep->hwp + FEC_ATIME_INC) & FEC_T_INC_CORR_MASK;
+	fep->ptp_saved_state.at_inc_corr = (u8)(atime_inc_corr >> FEC_T_INC_CORR_OFFSET);
+
 	spin_unlock_irqrestore(&fep->tmreg_lock, flags);
 }
 
 /* Restore PTP functionality after a reset */
 void fec_ptp_restore_state(struct fec_enet_private *fep)
 {
+	u32 atime_inc = readl(fep->hwp + FEC_ATIME_INC) & FEC_T_INC_MASK;
 	unsigned long flags;
+	u32 counter;
+	u64 ns;
 
 	spin_lock_irqsave(&fep->tmreg_lock, flags);
 
 	/* Reset turned it off, so adjust our status flag */
 	fep->pps_enable = 0;
 
+	writel(fep->ptp_saved_state.at_corr, fep->hwp + FEC_ATIME_CORR);
+	atime_inc |= ((u32)fep->ptp_saved_state.at_inc_corr) << FEC_T_INC_CORR_OFFSET;
+	writel(atime_inc, fep->hwp + FEC_ATIME_INC);
+
+	ns = ktime_get_ns() - fep->ptp_saved_state.ns_sys + fep->ptp_saved_state.ns_phc;
+	counter = ns & fep->cc.mask;
+	writel(counter, fep->hwp + FEC_ATIME);
+	timecounter_init(&fep->tc, &fep->cc, ns);
+
 	spin_unlock_irqrestore(&fep->tmreg_lock, flags);
 
 	/* Restart PPS if needed */
-- 
2.43.0



