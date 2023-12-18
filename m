Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA7B25BFAB;
	Mon, 18 Dec 2023 14:00:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iY5XMsFO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F099C433C7;
	Mon, 18 Dec 2023 14:00:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702908026;
	bh=glOm1kl6N0SGVqbL8mvaXk6P9OJfasUL8Cq00QEqrSA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iY5XMsFOHb2dMTcfq1W3tA4T8gttDfW2kKYqUHeuuxiaWr0migtVPXWtbciWzepMB
	 suFo3L9GtGBG1+QZ6Jo7cLpU7ex10RFUgLdX4nBKkAR+q7FLxRKKi1yt0ZAyFjQv2C
	 MT3Tv/oZ6eVt8K3DQRVq+bXmaaF+3MD4/Z5yZWaA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leon Romanovsky <leonro@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 008/166] net/mlx5e: Ensure that IPsec sequence packet number starts from 1
Date: Mon, 18 Dec 2023 14:49:34 +0100
Message-ID: <20231218135105.333958326@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231218135104.927894164@linuxfoundation.org>
References: <20231218135104.927894164@linuxfoundation.org>
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

From: Leon Romanovsky <leonro@nvidia.com>

[ Upstream commit 3d42c8cc67a8fcbff0181f9ed6d03d353edcee07 ]

According to RFC4303, section "3.3.3. Sequence Number Generation",
the first packet sent using a given SA will contain a sequence
number of 1.

However if user didn't set seq/oseq, the HW used zero as first sequence
packet number. Such misconfiguration causes to drop of first packet
if replay window protection was enabled in SA.

To fix it, set sequence number to be at least 1.

Fixes: 7db21ef4566e ("net/mlx5e: Set IPsec replay sequence numbers")
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
index 65678e89aea62..0d4b8aef6adda 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
@@ -121,7 +121,14 @@ static bool mlx5e_ipsec_update_esn_state(struct mlx5e_ipsec_sa_entry *sa_entry)
 	if (x->xso.type == XFRM_DEV_OFFLOAD_CRYPTO)
 		esn_msb = xfrm_replay_seqhi(x, htonl(seq_bottom));
 
-	sa_entry->esn_state.esn = esn;
+	if (sa_entry->esn_state.esn_msb)
+		sa_entry->esn_state.esn = esn;
+	else
+		/* According to RFC4303, section "3.3.3. Sequence Number Generation",
+		 * the first packet sent using a given SA will contain a sequence
+		 * number of 1.
+		 */
+		sa_entry->esn_state.esn = max_t(u32, esn, 1);
 	sa_entry->esn_state.esn_msb = esn_msb;
 
 	if (unlikely(overlap && seq_bottom < MLX5E_IPSEC_ESN_SCOPE_MID)) {
-- 
2.43.0



