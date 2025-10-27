Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14BA032143F;
	Mon, 27 Oct 2025 19:26:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761593185; cv=none; b=V1eTE6oQ9a13Y1htUpjFyQVfgPFJq/0tb3wkweoEX/rhjrtxH79HM0T6JCyI7yoTvX5e38uSlEoxy3Qj1TLhfMV3DwE2Y64ypnHe2cFbtBZGdpDPFh3OuZr4Bzv+o4h7edH0kN225acz5LL5th2Xo2Wk6axlKAoE7RaLPa3LS6Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761593185; c=relaxed/simple;
	bh=5j1XGXYNcLjsvCpUPTe6RB0m02qeJrSgb4mLttW0ofA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jajBqczPy/dNTKJ6ofnsv9XkdOhLNgHfQKQHlEcZhuxAT3aDtD6z96gNXTNz/0kzhFRp4XcC162bvgNkfgj6KH1een1K6Q9eaSQIs7Sl5bUQfppAGPsCojeh9XZ2Gr5hl3en08eFPq0SpBs1M6eQhSr/vAypzJe5lV/8DJY4pAs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kMGx0/LW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kMGx0/LW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 974FDC4CEF1;
	Mon, 27 Oct 2025 19:26:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761593184;
	bh=5j1XGXYNcLjsvCpUPTe6RB0m02qeJrSgb4mLttW0ofA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kMGx0/LWl3ikPiQVFCnSs3n84riPPNGPeljUsQXjhdn3pFe59oKUOgCEa2gw4HaON
	 9kMO/Dhwd4F9hw5SpapKH1Q+22253hnrJMIFxvSbTHzCwPTsRipb0zvWbBatR5KRrj
	 IC8RLbgLqaydwN4bVPPc8X2pQucrHd4ohw3m21vo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dragos Tatulea <dtatulea@nvidia.com>,
	Amery Hung <ameryhung@gmail.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 046/184] net/mlx5e: RX, Fix generating skb from non-linear xdp_buff for legacy RQ
Date: Mon, 27 Oct 2025 19:35:28 +0100
Message-ID: <20251027183516.145243707@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183514.934710872@linuxfoundation.org>
References: <20251027183514.934710872@linuxfoundation.org>
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

From: Amery Hung <ameryhung@gmail.com>

[ Upstream commit afd5ba577c10639f62e8120df67dc70ea4b61176 ]

XDP programs can release xdp_buff fragments when calling
bpf_xdp_adjust_tail(). The driver currently assumes the number of
fragments to be unchanged and may generate skb with wrong truesize or
containing invalid frags. Fix the bug by generating skb according to
xdp_buff after the XDP program runs.

Fixes: ea5d49bdae8b ("net/mlx5e: Add XDP multi buffer support to the non-linear legacy RQ")
Reviewed-by: Dragos Tatulea <dtatulea@nvidia.com>
Signed-off-by: Amery Hung <ameryhung@gmail.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Link: https://patch.msgid.link/1760644540-899148-2-git-send-email-tariqt@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/mellanox/mlx5/core/en_rx.c   | 25 ++++++++++++++-----
 1 file changed, 19 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
index b8c609d91d11b..25d993ded314a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
@@ -1773,14 +1773,27 @@ mlx5e_skb_from_cqe_nonlinear(struct mlx5e_rq *rq, struct mlx5e_wqe_frag_info *wi
 	}
 
 	prog = rcu_dereference(rq->xdp_prog);
-	if (prog && mlx5e_xdp_handle(rq, prog, mxbuf)) {
-		if (__test_and_clear_bit(MLX5E_RQ_FLAG_XDP_XMIT, rq->flags)) {
-			struct mlx5e_wqe_frag_info *pwi;
+	if (prog) {
+		u8 nr_frags_free, old_nr_frags = sinfo->nr_frags;
+
+		if (mlx5e_xdp_handle(rq, prog, mxbuf)) {
+			if (__test_and_clear_bit(MLX5E_RQ_FLAG_XDP_XMIT,
+						 rq->flags)) {
+				struct mlx5e_wqe_frag_info *pwi;
+
+				wi -= old_nr_frags - sinfo->nr_frags;
+
+				for (pwi = head_wi; pwi < wi; pwi++)
+					pwi->frag_page->frags++;
+			}
+			return NULL; /* page/packet was consumed by XDP */
+		}
 
-			for (pwi = head_wi; pwi < wi; pwi++)
-				pwi->frag_page->frags++;
+		nr_frags_free = old_nr_frags - sinfo->nr_frags;
+		if (unlikely(nr_frags_free)) {
+			wi -= nr_frags_free;
+			truesize -= nr_frags_free * frag_info->frag_stride;
 		}
-		return NULL; /* page/packet was consumed by XDP */
 	}
 
 	skb = mlx5e_build_linear_skb(
-- 
2.51.0



