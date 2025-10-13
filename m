Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28A383148B6;
	Mon, 13 Oct 2025 15:41:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760370109; cv=none; b=uk/cVXpv30h4rJwudQED8b6D84Mi4yqmyt9eAvLVozks8WTAv5MsyLPHlhn8TOFB8/9qe6YnCjakLz+aG4/kJcSbJXv7wFevEnEqk+ELCmzBJnAb+H3wFSAqLyfvFbdl+EA/7Mxhud/W8tSqxt59qE0skJO+x/axBzs7w14WQbE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760370109; c=relaxed/simple;
	bh=ucrYWGSCAjUKGJnVPFRBLj7bVtiivLJ/LGMgUBXpn5g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aKbm3GYy7e2lCmiK27N+KYfyZEcC3IZR0u4r3H5ISF6eNzGjfLplnJCs7aDrFZ0Hq+vujURaam0WEa4lbAOTGH0a3/5g56TevncWYfeL2x3vvaWuk3s+07GVIadjeHtYMHnZzoO2f3bTQgEwiT8O9JJJtCkTKKSwvPp+RUqRWXs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dypwhthj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dypwhthj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB5B1C4CEE7;
	Mon, 13 Oct 2025 15:41:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760370109;
	bh=ucrYWGSCAjUKGJnVPFRBLj7bVtiivLJ/LGMgUBXpn5g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dypwhthjXPpn/ihFuIb8jdcL6Suk1aNqL1njmdAxINoiTSDAkaXPkgiCLfr1D7Qbu
	 /cjCOmkSDDTZTB3Y6Oq/YqRCwdFprhx6+e7Wd+KmOVjlk0CXdmjtfxyQfy7RcfiPoN
	 TA31wbFR+YD1YXCYy6Ix+sDs9zz5A/m9C4eoRv8o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wei Fang <wei.fang@nxp.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 480/563] net: enetc: initialize SW PIR and CIR based HW PIR and CIR values
Date: Mon, 13 Oct 2025 16:45:41 +0200
Message-ID: <20251013144428.674957542@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wei Fang <wei.fang@nxp.com>

[ Upstream commit 2aff4420efc2910e905ee5b000e04e87422aebc4 ]

Software can only initialize the PIR and CIR of the command BD ring after
a FLR, and these two registers can only be set to 0. But the reset values
of these two registers are 0, so software does not need to update them.
If there is no a FLR and PIR and CIR are not 0, resetting them to 0 or
other values by software will cause the command BD ring to work
abnormally. This is because of an internal context in the ring prefetch
logic that will retain the state from the first incarnation of the ring
and continue prefetching from the stale location when the ring is
reinitialized. The internal context can only be reset by the FLR.

In addition, there is a logic error in the implementation, next_to_clean
indicates the software CIR and next_to_use indicates the software PIR.
But the current driver uses next_to_clean to set PIR and use next_to_use
to set CIR. This does not cause a problem in actual use, because the
current command BD ring is only initialized after FLR, and the initial
values of next_to_use and next_to_clean are both 0.

Therefore, this patch removes the initialization of PIR and CIR. Instead,
next_to_use and next_to_clean are initialized by reading the values of
PIR and CIR.

Fixes: 4701073c3deb ("net: enetc: add initial netc-lib driver to support NTMP")
Signed-off-by: Wei Fang <wei.fang@nxp.com>
Link: https://patch.msgid.link/20250926013954.2003456-1-wei.fang@nxp.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/freescale/enetc/ntmp.c | 15 +++++----------
 1 file changed, 5 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/freescale/enetc/ntmp.c b/drivers/net/ethernet/freescale/enetc/ntmp.c
index ba32c1bbd9e18..0c1d343253bfb 100644
--- a/drivers/net/ethernet/freescale/enetc/ntmp.c
+++ b/drivers/net/ethernet/freescale/enetc/ntmp.c
@@ -52,24 +52,19 @@ int ntmp_init_cbdr(struct netc_cbdr *cbdr, struct device *dev,
 	cbdr->addr_base_align = PTR_ALIGN(cbdr->addr_base,
 					  NTMP_BASE_ADDR_ALIGN);
 
-	cbdr->next_to_clean = 0;
-	cbdr->next_to_use = 0;
 	spin_lock_init(&cbdr->ring_lock);
 
+	cbdr->next_to_use = netc_read(cbdr->regs.pir);
+	cbdr->next_to_clean = netc_read(cbdr->regs.cir);
+
 	/* Step 1: Configure the base address of the Control BD Ring */
 	netc_write(cbdr->regs.bar0, lower_32_bits(cbdr->dma_base_align));
 	netc_write(cbdr->regs.bar1, upper_32_bits(cbdr->dma_base_align));
 
-	/* Step 2: Configure the producer index register */
-	netc_write(cbdr->regs.pir, cbdr->next_to_clean);
-
-	/* Step 3: Configure the consumer index register */
-	netc_write(cbdr->regs.cir, cbdr->next_to_use);
-
-	/* Step4: Configure the number of BDs of the Control BD Ring */
+	/* Step 2: Configure the number of BDs of the Control BD Ring */
 	netc_write(cbdr->regs.lenr, cbdr->bd_num);
 
-	/* Step 5: Enable the Control BD Ring */
+	/* Step 3: Enable the Control BD Ring */
 	netc_write(cbdr->regs.mr, NETC_CBDR_MR_EN);
 
 	return 0;
-- 
2.51.0



