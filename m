Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B238E27ECC
	for <patches@lists.linux.dev>; Mon, 16 Oct 2023 14:48:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N7QVUQBp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF76EC433C7;
	Mon, 16 Oct 2023 14:48:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1697467711;
	bh=Dsc3jO118eFQtiQEvsgm7lGU1Oqc2DRQTzYIozth+Tg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=N7QVUQBpclTDbiMtNMTt0eCekktQ2rMq5HMNPmueakTndLLw34CaMZhAkGIe62suM
	 DQQjQMNymyIkwOMkGO6srCDswf/mkU7oISOJR5kpyb9oLTiFW4rro80fTqpw+bN0ON
	 QSY2tOl5XQ1s1TJS7bd7ySBpjqzrQp5rpYkCfn68=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Radu Pirea (NXP OSS)" <radu-nicolae.pirea@oss.nxp.com>,
	Sabrina Dubroca <sd@queasysnail.net>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 074/191] net/mlx5e: macsec: use update_pn flag instead of PN comparation
Date: Mon, 16 Oct 2023 10:40:59 +0200
Message-ID: <20231016084017.133893408@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231016084015.400031271@linuxfoundation.org>
References: <20231016084015.400031271@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Radu Pirea (NXP OSS) <radu-nicolae.pirea@oss.nxp.com>

[ Upstream commit fde2f2d7f23d39f2fc699ba6d91ac3f4a2e637ca ]

When updating the SA, use the new update_pn flags instead of comparing the
new PN with the initial one.

Comparing the initial PN value with the new value will allow the user
to update the SA using the initial PN value as a parameter like this:
$ ip macsec add macsec0 tx sa 0 pn 1 on key 00 \
ead3664f508eb06c40ac7104cdae4ce5
$ ip macsec set macsec0 tx sa 0 pn 1 off

Fixes: 8ff0ac5be144 ("net/mlx5: Add MACsec offload Tx command support")
Fixes: aae3454e4d4c ("net/mlx5e: Add MACsec offload Rx command support")
Signed-off-by: Radu Pirea (NXP OSS) <radu-nicolae.pirea@oss.nxp.com>
Reviewed-by: Sabrina Dubroca <sd@queasysnail.net>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c
index 592b165530ffa..6bce55978aa72 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec.c
@@ -612,7 +612,7 @@ static int mlx5e_macsec_upd_txsa(struct macsec_context *ctx)
 		goto out;
 	}
 
-	if (tx_sa->next_pn != ctx_tx_sa->next_pn_halves.lower) {
+	if (ctx->sa.update_pn) {
 		netdev_err(netdev, "MACsec offload: update TX sa %d PN isn't supported\n",
 			   assoc_num);
 		err = -EINVAL;
@@ -1017,7 +1017,7 @@ static int mlx5e_macsec_upd_rxsa(struct macsec_context *ctx)
 		goto out;
 	}
 
-	if (rx_sa->next_pn != ctx_rx_sa->next_pn_halves.lower) {
+	if (ctx->sa.update_pn) {
 		netdev_err(ctx->netdev,
 			   "MACsec offload update RX sa %d PN isn't supported\n",
 			   assoc_num);
-- 
2.40.1



