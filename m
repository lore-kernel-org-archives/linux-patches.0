Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FA81172BAE;
	Tue, 10 Sep 2024 10:29:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725964188; cv=none; b=RqLhlCYfBrq98M1ZtQXBm5LR4dudA4nyUX3eMHv3ChkG7npkv85iemwXqyQDTFlm6ly7K/R9/+katJhbLhvtW5+5BPNdt4joa7X7ReD8YNdxn1SY7FWdC2vGULrUN0R4DjswIDOKBGTbWqMYWV/yWC9ErFv+dH/occ+MhNA46M8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725964188; c=relaxed/simple;
	bh=DF0ADDU+RV/aHVpASGbUHxsFT2gXCrosvxR2R25XWlg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rhcL+7Wv/U5RL0VqubBlU+eOiZPqxROKX9N+He0/vuVPcL7XYuUfWp1mBxo83hU7m2INhmDfUD9ZDSoEGxWjTBwOglO+D+ReRqrhQ6PmNym53bRQV5na2fm+Vt8GoAeZFwmQDXgToWLVthbKCu8EcdKbsNel76NrZ7sMKEgPf0o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EYYuNW4X; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EYYuNW4X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6ED78C4CEC3;
	Tue, 10 Sep 2024 10:29:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725964187;
	bh=DF0ADDU+RV/aHVpASGbUHxsFT2gXCrosvxR2R25XWlg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EYYuNW4X8ZkH+HaZVtf5nz3T+7Q7hOxSO3TvNpw9RLH5wIpuMG7jt1DqkhfrzAn98
	 r/ReSgskboGodAu9LZbjKG1P/8fUJ9rZd+L3lqLg/0xapPRosCFzHQ6ZuGkeZ9ff5i
	 E7P1xgmecos4M9Te5y2aEPbEDzUKuBo4+ifisB9k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 098/269] can: mcp251xfd: fix ring configuration when switching from CAN-CC to CAN-FD mode
Date: Tue, 10 Sep 2024 11:31:25 +0200
Message-ID: <20240910092611.708905907@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092608.225137854@linuxfoundation.org>
References: <20240910092608.225137854@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marc Kleine-Budde <mkl@pengutronix.de>

[ Upstream commit 50ea5449c56310d2d31c28ba91a59232116d3c1e ]

If the ring (rx, tx) and/or coalescing parameters (rx-frames-irq,
tx-frames-irq) have been configured while the interface was in CAN-CC
mode, but the interface is brought up in CAN-FD mode, the ring
parameters might be too big.

Use the default CAN-FD values in this case.

Fixes: 9263c2e92be9 ("can: mcp251xfd: ring: add support for runtime configurable RX/TX ring parameters")
Link: https://lore.kernel.org/all/20240805-mcp251xfd-fix-ringconfig-v1-1-72086f0ca5ee@pengutronix.de
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/can/spi/mcp251xfd/mcp251xfd-ram.c | 11 +++++++++-
 .../net/can/spi/mcp251xfd/mcp251xfd-ring.c    | 20 ++++++++++++++++---
 2 files changed, 27 insertions(+), 4 deletions(-)

diff --git a/drivers/net/can/spi/mcp251xfd/mcp251xfd-ram.c b/drivers/net/can/spi/mcp251xfd/mcp251xfd-ram.c
index 9e8e82cdba46..61b0d6fa52dd 100644
--- a/drivers/net/can/spi/mcp251xfd/mcp251xfd-ram.c
+++ b/drivers/net/can/spi/mcp251xfd/mcp251xfd-ram.c
@@ -97,7 +97,16 @@ void can_ram_get_layout(struct can_ram_layout *layout,
 	if (ring) {
 		u8 num_rx_coalesce = 0, num_tx_coalesce = 0;
 
-		num_rx = can_ram_rounddown_pow_of_two(config, &config->rx, 0, ring->rx_pending);
+		/* If the ring parameters have been configured in
+		 * CAN-CC mode, but and we are in CAN-FD mode now,
+		 * they might be to big. Use the default CAN-FD values
+		 * in this case.
+		 */
+		num_rx = ring->rx_pending;
+		if (num_rx > layout->max_rx)
+			num_rx = layout->default_rx;
+
+		num_rx = can_ram_rounddown_pow_of_two(config, &config->rx, 0, num_rx);
 
 		/* The ethtool doc says:
 		 * To disable coalescing, set usecs = 0 and max_frames = 1.
diff --git a/drivers/net/can/spi/mcp251xfd/mcp251xfd-ring.c b/drivers/net/can/spi/mcp251xfd/mcp251xfd-ring.c
index 4cb79a4f2461..3a941a71c78f 100644
--- a/drivers/net/can/spi/mcp251xfd/mcp251xfd-ring.c
+++ b/drivers/net/can/spi/mcp251xfd/mcp251xfd-ring.c
@@ -468,11 +468,25 @@ int mcp251xfd_ring_alloc(struct mcp251xfd_priv *priv)
 
 	/* switching from CAN-2.0 to CAN-FD mode or vice versa */
 	if (fd_mode != test_bit(MCP251XFD_FLAGS_FD_MODE, priv->flags)) {
+		const struct ethtool_ringparam ring = {
+			.rx_pending = priv->rx_obj_num,
+			.tx_pending = priv->tx->obj_num,
+		};
+		const struct ethtool_coalesce ec = {
+			.rx_coalesce_usecs_irq = priv->rx_coalesce_usecs_irq,
+			.rx_max_coalesced_frames_irq = priv->rx_obj_num_coalesce_irq,
+			.tx_coalesce_usecs_irq = priv->tx_coalesce_usecs_irq,
+			.tx_max_coalesced_frames_irq = priv->tx_obj_num_coalesce_irq,
+		};
 		struct can_ram_layout layout;
 
-		can_ram_get_layout(&layout, &mcp251xfd_ram_config, NULL, NULL, fd_mode);
-		priv->rx_obj_num = layout.default_rx;
-		tx_ring->obj_num = layout.default_tx;
+		can_ram_get_layout(&layout, &mcp251xfd_ram_config, &ring, &ec, fd_mode);
+
+		priv->rx_obj_num = layout.cur_rx;
+		priv->rx_obj_num_coalesce_irq = layout.rx_coalesce;
+
+		tx_ring->obj_num = layout.cur_tx;
+		priv->tx_obj_num_coalesce_irq = layout.tx_coalesce;
 	}
 
 	if (fd_mode) {
-- 
2.43.0



