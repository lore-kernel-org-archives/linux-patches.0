Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F4482FA62A;
	Tue, 17 Jun 2025 16:48:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750178909; cv=none; b=DGGMXg/skLhlNfC9ArST716PoJqam3aH1E6M1V6r+jUehsVlWK/czVcT5w85Lap050IrFK3CeolbAadzwo9p9+oZOrTFEOIYunGmx3k/hS8mu+89cvHaW2PMPF5rYWN1Fx5xMo38xnRy7RdrxSimqMkUsYWyC1kt1cWQZHpDKCA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750178909; c=relaxed/simple;
	bh=IYhLTnyA+ZuYjbNwKnXLX9PRkeJdW5LJQ9CJZp5Oels=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OsVUjXropIhUOiI5KSM4NxQLsShNUH1OdqisvMTRbXxISiDujYvKdT8PvLnMpjYfLAIKZtXCWIqGJ0+/pqOmUZncKILKT55F6lDUyWMVu+g5F9bImVgV+XzIeF/nQijQxAtDDwjagDtd688jBzzFngNWKZB/AbotJzFwDxNnj0k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=N28fWyQl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N28fWyQl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D336FC4CEE3;
	Tue, 17 Jun 2025 16:48:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750178909;
	bh=IYhLTnyA+ZuYjbNwKnXLX9PRkeJdW5LJQ9CJZp5Oels=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=N28fWyQl9u9nTRfBF6jglxoeNIt8hWL+SQaEbmABFnfz7zNBsIO0dNYQwLOaLBpcR
	 WRB3PT07+Qcg0wK39XE2DQQi9N7ZTUT1ZBz6xiNnfOs/rW4tCQnk8qYSFwbLxNW6sB
	 SLIjS8DSezzrf/WcHbJc9Gc7jz0xtAFwkWKN34To=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 590/780] net: airoha: Add the capability to allocate hfwd descriptors in SRAM
Date: Tue, 17 Jun 2025 17:24:58 +0200
Message-ID: <20250617152515.502777425@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lorenzo Bianconi <lorenzo@kernel.org>

[ Upstream commit c683e378c0907e66cee939145edf936c254ff1e3 ]

In order to improve packet processing and packet forwarding
performances, EN7581 SoC supports consuming SRAM instead of DRAM for
hw forwarding descriptors queue.
For downlink hw accelerated traffic request to consume SRAM memory
for hw forwarding descriptors queue.

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20250521-airopha-desc-sram-v3-4-a6e9b085b4f0@kernel.org
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Stable-dep-of: a869d3a5eb01 ("net: airoha: Initialize PPE UPDMEM source-mac table")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/airoha/airoha_eth.c | 11 +----------
 drivers/net/ethernet/airoha/airoha_eth.h |  9 +++++++++
 drivers/net/ethernet/airoha/airoha_ppe.c |  6 ++++++
 3 files changed, 16 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/airoha/airoha_eth.c b/drivers/net/ethernet/airoha/airoha_eth.c
index c169b8b411b4f..c8664840f3fc2 100644
--- a/drivers/net/ethernet/airoha/airoha_eth.c
+++ b/drivers/net/ethernet/airoha/airoha_eth.c
@@ -67,15 +67,6 @@ static void airoha_qdma_irq_disable(struct airoha_qdma *qdma, int index,
 	airoha_qdma_set_irqmask(qdma, index, mask, 0);
 }
 
-static bool airhoa_is_lan_gdm_port(struct airoha_gdm_port *port)
-{
-	/* GDM1 port on EN7581 SoC is connected to the lan dsa switch.
-	 * GDM{2,3,4} can be used as wan port connected to an external
-	 * phy module.
-	 */
-	return port->id == 1;
-}
-
 static void airoha_set_macaddr(struct airoha_gdm_port *port, const u8 *addr)
 {
 	struct airoha_eth *eth = port->qdma->eth;
@@ -1068,7 +1059,7 @@ static int airoha_qdma_init_hfwd_queues(struct airoha_qdma *qdma)
 			LMGR_INIT_START | LMGR_SRAM_MODE_MASK |
 			HW_FWD_DESC_NUM_MASK,
 			FIELD_PREP(HW_FWD_DESC_NUM_MASK, HW_DSCP_NUM) |
-			LMGR_INIT_START);
+			LMGR_INIT_START | LMGR_SRAM_MODE_MASK);
 
 	return read_poll_timeout(airoha_qdma_rr, status,
 				 !(status & LMGR_INIT_START), USEC_PER_MSEC,
diff --git a/drivers/net/ethernet/airoha/airoha_eth.h b/drivers/net/ethernet/airoha/airoha_eth.h
index ec8908f904c61..0204ea030c31a 100644
--- a/drivers/net/ethernet/airoha/airoha_eth.h
+++ b/drivers/net/ethernet/airoha/airoha_eth.h
@@ -532,6 +532,15 @@ u32 airoha_rmw(void __iomem *base, u32 offset, u32 mask, u32 val);
 #define airoha_qdma_clear(qdma, offset, val)			\
 	airoha_rmw((qdma)->regs, (offset), (val), 0)
 
+static inline bool airhoa_is_lan_gdm_port(struct airoha_gdm_port *port)
+{
+	/* GDM1 port on EN7581 SoC is connected to the lan dsa switch.
+	 * GDM{2,3,4} can be used as wan port connected to an external
+	 * phy module.
+	 */
+	return port->id == 1;
+}
+
 bool airoha_is_valid_gdm_port(struct airoha_eth *eth,
 			      struct airoha_gdm_port *port);
 
diff --git a/drivers/net/ethernet/airoha/airoha_ppe.c b/drivers/net/ethernet/airoha/airoha_ppe.c
index f10dab935cab6..843fe7bd1446e 100644
--- a/drivers/net/ethernet/airoha/airoha_ppe.c
+++ b/drivers/net/ethernet/airoha/airoha_ppe.c
@@ -234,6 +234,12 @@ static int airoha_ppe_foe_entry_prepare(struct airoha_eth *eth,
 		else
 			pse_port = 2; /* uplink relies on GDM2 loopback */
 		val |= FIELD_PREP(AIROHA_FOE_IB2_PSE_PORT, pse_port);
+
+		/* For downlink traffic consume SRAM memory for hw forwarding
+		 * descriptors queue.
+		 */
+		if (airhoa_is_lan_gdm_port(port))
+			val |= AIROHA_FOE_IB2_FAST_PATH;
 	}
 
 	if (is_multicast_ether_addr(data->eth.h_dest))
-- 
2.39.5



