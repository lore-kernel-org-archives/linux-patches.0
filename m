Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FBA2314D34;
	Tue, 21 Jul 2026 17:04:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784653468; cv=none; b=RXU+SADThnU1qlGA5EvP6jC6bCpEtePPAI/sabqARmMkrGaN483WrxO+HVAzlviVhRhOlWcTsAia+EocE/ceyRgUWwAVxg7zqasZKKBUls5nKmiKAkYTMvd4vRSkRYhik7jLc97NoD6o1zzHNJ6zizXjaeGrnf/Uen65eBg/nB4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784653468; c=relaxed/simple;
	bh=vRdHcqtYTPAqdEPkAZjLGa+XbLFUtYy5V5VDB+WZVuo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bLIvA1VSqnSzY/yn0h+9CgUbEOX9kPZx3XlMMML5CzpQ2XiLWUEwn4oAVI6FEktpChaN+pkBv+n4+57v0CC/60XuICE6Nd8fnfE1Oiz9+ozp+Fqb6/f4gb5yqS+aWg5ygDL5Hfjh7T2/L3VgOuf0zB7v6m912LBmMqMCo2Tr5s0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QhmIniu3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QhmIniu3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF9691F000E9;
	Tue, 21 Jul 2026 17:04:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784653467;
	bh=7Pn9Y9+C6HjPUiJzFn+1d5Fuy/Y7gie6Tee4gwO5BlQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QhmIniu30oyXUsLs4olIKky7n/SvyYnpNPP0hC1V8j/d/jncY+T1/L5QFBNZT8fWL
	 9aWva0k4bk9gTPpR3VipF1Vu4c395o6e/qkF7RNVPPFCTKG91sFH5J5WcLEdRAbkdI
	 7sYDHphNp8mZCm4foUcniUlcf09j7zJS7FUEy3G4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wei Fang <wei.fang@nxp.com>,
	Maxime Chevallier <maxime.chevallier@bootlin.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 1294/2077] net: enetc: fix potential divide-by-zero when num_vsi is zero
Date: Tue, 21 Jul 2026 17:16:07 +0200
Message-ID: <20260721152623.342734114@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

[ Upstream commit 5da65537792b68b6052ffcab65e04c27aea6dfe4 ]

For i.MX94 series, all the standalone ENETCs do not support SR-IOV, so
pf->caps.num_vsi is zero. This leads to a divide-by-zero in
enetc4_default_rings_allocation() when distributing rings among PF and
VFs.

Division by zero is undefined behavior in C. On ARM64, the UDIV/SDIV
instructions silently return zero rather than raising an exception, so
the issue does not cause a visible crash. However, relying on this
behavior is incorrect and poses a cross-platform compatibility risk.

Add an explicit check for num_vsi == 0 and return early after the PF's
rings have been configured.

Fixes: 2d673b0e2f8d ("net: enetc: add standalone ENETC support for i.MX94")
Signed-off-by: Wei Fang <wei.fang@nxp.com>
Reviewed-by: Maxime Chevallier <maxime.chevallier@bootlin.com>
Link: https://patch.msgid.link/20260624072726.1238903-1-wei.fang@oss.nxp.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/freescale/enetc/enetc4_pf.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc4_pf.c b/drivers/net/ethernet/freescale/enetc/enetc4_pf.c
index 56899f2254aaa2..71866d240b40c7 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc4_pf.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc4_pf.c
@@ -326,6 +326,9 @@ static void enetc4_default_rings_allocation(struct enetc_pf *pf)
 	val = enetc4_psicfgr0_val_construct(false, num_tx_bdr, num_rx_bdr);
 	enetc_port_wr(hw, ENETC4_PSICFGR0(0), val);
 
+	if (!pf->caps.num_vsi)
+		return;
+
 	num_rx_bdr = pf->caps.num_rx_bdr - num_rx_bdr;
 	rx_rem = num_rx_bdr % pf->caps.num_vsi;
 	num_rx_bdr = num_rx_bdr / pf->caps.num_vsi;
-- 
2.53.0



