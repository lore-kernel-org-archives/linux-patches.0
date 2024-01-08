Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 962244C3BE;
	Mon,  8 Jan 2024 15:39:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LW57fYWU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF99DC433C8;
	Mon,  8 Jan 2024 15:39:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1704728371;
	bh=tETF7LMfpt9T1rQxZSox6Ys6R3MD5tlPRj1xxIMRiEA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LW57fYWU48NXz4btEVRTSkuy06L72otbvTGrLRh1qZgdL4sRKC+QyxrrVIHEVnPcP
	 0Q5qP5fdeWHMsWXhtnsUdQUsWsd2wYZKWyFnqIjxAOJuqbr0h8eZ5no+2ZC0e08EUM
	 sr8hid4unQqyXfhijdhLsB/JNw0TU/9dDJ4ER8IM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Asmaa Mnebhi <asmaa@nvidia.com>,
	David Thompson <davthompson@nvidia.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 027/150] mlxbf_gige: fix receive packet race condition
Date: Mon,  8 Jan 2024 16:34:38 +0100
Message-ID: <20240108153512.508272844@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240108153511.214254205@linuxfoundation.org>
References: <20240108153511.214254205@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Thompson <davthompson@nvidia.com>

[ Upstream commit dcea1bd45e6d111cc8fc1aaefa7e31694089bda3 ]

Under heavy traffic, the BlueField Gigabit interface can
become unresponsive. This is due to a possible race condition
in the mlxbf_gige_rx_packet function, where the function exits
with producer and consumer indices equal but there are remaining
packet(s) to be processed. In order to prevent this situation,
read receive consumer index *before* the HW replenish so that
the mlxbf_gige_rx_packet function returns an accurate return
value even if a packet is received into just-replenished buffer
prior to exiting this routine. If the just-replenished buffer
is received and occupies the last RX ring entry, the interface
would not recover and instead would encounter RX packet drops
related to internal buffer shortages since the driver RX logic
is not being triggered to drain the RX ring. This patch will
address and prevent this "ring full" condition.

Fixes: f92e1869d74e ("Add Mellanox BlueField Gigabit Ethernet driver")
Reviewed-by: Asmaa Mnebhi <asmaa@nvidia.com>
Signed-off-by: David Thompson <davthompson@nvidia.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_rx.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_rx.c b/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_rx.c
index 0d5a41a2ae010..227d01cace3f0 100644
--- a/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_rx.c
+++ b/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_rx.c
@@ -267,6 +267,13 @@ static bool mlxbf_gige_rx_packet(struct mlxbf_gige *priv, int *rx_pkts)
 		priv->stats.rx_truncate_errors++;
 	}
 
+	/* Read receive consumer index before replenish so that this routine
+	 * returns accurate return value even if packet is received into
+	 * just-replenished buffer prior to exiting this routine.
+	 */
+	rx_ci = readq(priv->base + MLXBF_GIGE_RX_CQE_PACKET_CI);
+	rx_ci_rem = rx_ci % priv->rx_q_entries;
+
 	/* Let hardware know we've replenished one buffer */
 	rx_pi++;
 
@@ -279,8 +286,6 @@ static bool mlxbf_gige_rx_packet(struct mlxbf_gige *priv, int *rx_pkts)
 	rx_pi_rem = rx_pi % priv->rx_q_entries;
 	if (rx_pi_rem == 0)
 		priv->valid_polarity ^= 1;
-	rx_ci = readq(priv->base + MLXBF_GIGE_RX_CQE_PACKET_CI);
-	rx_ci_rem = rx_ci % priv->rx_q_entries;
 
 	if (skb)
 		netif_receive_skb(skb);
-- 
2.43.0



