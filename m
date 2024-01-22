Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68E1B64AB3;
	Tue, 23 Jan 2024 01:57:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705975058; cv=none; b=mQXqzKoFKtYl/JJtDezdSX6DgkOXBpmZM3HapASDX3TXI3nNakSJMLTciPl7l29nW0U/jYyN+c/r8YC+ySqwuggKTAPlbusYXcI2ypHnKuMh/fcSN43j8pYlYKLFElSUV3bEntW4dEbP8nyyJGRRdjiY2ltUASaOKz8+U0N7Zmc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705975058; c=relaxed/simple;
	bh=xkOsfdas6XjH1JDLq9j49UWoauPUijiLcmm9I+70yto=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sRf6hWCmoT2x/M82viKqXofJrz0EMiRZ1zSqLj3gaeCEE0Zr48vi037EfcGfW8NnZWUqDPeUHM8+O9JIw+/het6wgCpIxkZagXIJgvUYlEuLyz5OQthJ/HrWiJ9ZFYUiOF9DExkAOGDOzlPxuuVUsQYe6sFB2d+R45TfPqBGwlk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=y1EUlLlC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="y1EUlLlC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30238C43399;
	Tue, 23 Jan 2024 01:57:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705975058;
	bh=xkOsfdas6XjH1JDLq9j49UWoauPUijiLcmm9I+70yto=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=y1EUlLlC1rhHUF84OJVOZ/Df1sWnw0Jf4/aeWIgisnx4EDNP/jqjBT7mb3x/Q0WG0
	 DYP93OvcnKUsuwALJrnmXQTUuwjop/1UWllcK5DFaygFzFT2dqcy59wGGgCnpQfKLk
	 wzrgNej33bGUOVP/LZEBpJ+NUIeHTxn6I43QlbJY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Thompson <davthompson@nvidia.com>,
	Asmaa Mnebhi <asmaa@nvidia.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 217/583] mlxbf_gige: Fix intermittent no ip issue
Date: Mon, 22 Jan 2024 15:54:28 -0800
Message-ID: <20240122235818.649854197@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235812.238724226@linuxfoundation.org>
References: <20240122235812.238724226@linuxfoundation.org>
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

From: Asmaa Mnebhi <asmaa@nvidia.com>

[ Upstream commit ef210ef85d5cb543ce34a57803ed856d0c8c08c2 ]

Although the link is up, there is no ip assigned on setups with high background
traffic. Nothing is transmitted nor received. The RX error count keeps on
increasing. After several minutes, the RX error count stagnates and the
GigE interface finally gets an ip.

The issue is that mlxbf_gige_rx_init() is called before phy_start().
As soon as the RX DMA is enabled in mlxbf_gige_rx_init(), the RX CI reaches the max
of 128, and becomes equal to RX PI. RX CI doesn't decrease since the code hasn't
ran phy_start yet.
Bring the PHY up before starting the RX.

Fixes: f92e1869d74e ("Add Mellanox BlueField Gigabit Ethernet driver")
Reviewed-by: David Thompson <davthompson@nvidia.com>
Signed-off-by: Asmaa Mnebhi <asmaa@nvidia.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../ethernet/mellanox/mlxbf_gige/mlxbf_gige_main.c | 14 +++++++-------
 .../ethernet/mellanox/mlxbf_gige/mlxbf_gige_rx.c   |  6 +++---
 2 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_main.c b/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_main.c
index 694de9513b9f..7d132a132a29 100644
--- a/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_main.c
+++ b/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_main.c
@@ -147,14 +147,14 @@ static int mlxbf_gige_open(struct net_device *netdev)
 	 */
 	priv->valid_polarity = 0;
 
-	err = mlxbf_gige_rx_init(priv);
+	phy_start(phydev);
+
+	err = mlxbf_gige_tx_init(priv);
 	if (err)
 		goto free_irqs;
-	err = mlxbf_gige_tx_init(priv);
+	err = mlxbf_gige_rx_init(priv);
 	if (err)
-		goto rx_deinit;
-
-	phy_start(phydev);
+		goto tx_deinit;
 
 	netif_napi_add(netdev, &priv->napi, mlxbf_gige_poll);
 	napi_enable(&priv->napi);
@@ -176,8 +176,8 @@ static int mlxbf_gige_open(struct net_device *netdev)
 
 	return 0;
 
-rx_deinit:
-	mlxbf_gige_rx_deinit(priv);
+tx_deinit:
+	mlxbf_gige_tx_deinit(priv);
 
 free_irqs:
 	mlxbf_gige_free_irqs(priv);
diff --git a/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_rx.c b/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_rx.c
index 227d01cace3f..699984358493 100644
--- a/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_rx.c
+++ b/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_rx.c
@@ -142,6 +142,9 @@ int mlxbf_gige_rx_init(struct mlxbf_gige *priv)
 	writeq(MLXBF_GIGE_RX_MAC_FILTER_COUNT_PASS_EN,
 	       priv->base + MLXBF_GIGE_RX_MAC_FILTER_COUNT_PASS);
 
+	writeq(ilog2(priv->rx_q_entries),
+	       priv->base + MLXBF_GIGE_RX_WQE_SIZE_LOG2);
+
 	/* Clear MLXBF_GIGE_INT_MASK 'receive pkt' bit to
 	 * indicate readiness to receive interrupts
 	 */
@@ -154,9 +157,6 @@ int mlxbf_gige_rx_init(struct mlxbf_gige *priv)
 	data |= MLXBF_GIGE_RX_DMA_EN;
 	writeq(data, priv->base + MLXBF_GIGE_RX_DMA);
 
-	writeq(ilog2(priv->rx_q_entries),
-	       priv->base + MLXBF_GIGE_RX_WQE_SIZE_LOG2);
-
 	return 0;
 
 free_wqe_and_skb:
-- 
2.43.0



