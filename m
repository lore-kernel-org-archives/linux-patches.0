Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDB7A1DEFDD;
	Tue,  8 Oct 2024 13:12:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728393123; cv=none; b=FQJ34w/dBqCVYG08wRWpDWjvQKJCmM0OIM0s8ttjaymUYDWE6z2RoQZdG9qxQ/2p25i1J+TFRE/cysx39npn/F4pTdVI1dsXl3VF0ZeNRShaABfLF4Xn5eoCrICsa+NPvTbo6BlTlb10woMK/3lQQDXm6TUUVd+xXE77hYrJ2RU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728393123; c=relaxed/simple;
	bh=PcTpdx+vZ80T1iV5uS4yjsWGqd9JxDNPT0ifAWjAzlA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RPHzzS2vwqbg9mDURoeXZu4Id8oWKjrSJD4H8mdvuBli722IUqNhxWICvv28XKJaErjkEvXWguZgNNR7g4uRyZsEDYMUbg00iNyYkDwt74xmzAR3z69XAjrbXPnkrzlmav2hX+LFlzq+6Fa5vxOUskNImRjDa1Cw3/ZoX6qizDs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JRVutkwB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JRVutkwB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52118C4CECE;
	Tue,  8 Oct 2024 13:12:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728393123;
	bh=PcTpdx+vZ80T1iV5uS4yjsWGqd9JxDNPT0ifAWjAzlA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JRVutkwBu6J2U2UPqjsLAwC9LA1VLl16QJyChoS3EsDHnm6Yz2Xk5zceZfYbRZrfY
	 7MiRSlwUDKV3tZaDoKiNxuBX8jGO5tZdvZ8HUrMjx49sa5bB7suS54g0RwPHfbV0CY
	 qBeU0LZqlHC0XTBEMlJSIuxKqG7+ER1IeSWis8jE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Cs=C3=B3k=C3=A1s,
	=20Bence?= <csokas.bence@prolan.hu>,
	Wei Fang <wei.fang@nxp.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 029/386] net: fec: Reload PTP registers after link-state change
Date: Tue,  8 Oct 2024 14:04:34 +0200
Message-ID: <20241008115630.625329077@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115629.309157387@linuxfoundation.org>
References: <20241008115629.309157387@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index cb58696ec03b2..733af928caffc 100644
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



