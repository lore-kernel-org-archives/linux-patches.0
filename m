Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B33C328B44;
	Mon, 27 Oct 2025 19:22:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761592943; cv=none; b=LQivP5hPVnfJHyU0hUnaVlJUi/Yzddb9uv82FHrGC0g7LoeqPN6HLXrcLKxcQa6z4WkGh/UBzKlFgKONv1eNax6HcHfmb3v69jEWWyoJbHI17TB9zlGb6zHX43c4f2HcXRJOfhiRmLUT3LGiZyKdm2uBq3XCxj6fHMA4peFr+nU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761592943; c=relaxed/simple;
	bh=O3fpc/EQqg0bOriA79bPiN1H1lozyVHlgZ+0NmpKW24=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RXQoU5RKfc5dhhPvFD0A7MQQYdm2UOlb76EE2/4Cede83o2ielcuAA4LwApg4t6YIA2sE5ZQlOH6oBXTOZIDOIfADRVVUHNQ2olyLEO8SQ5XdvwDgjtAl5a+JdNmVIkhu7U6Karrp/gmLH8sxUfYAbDnT8V8bUF7VBcFPQf3q5M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kFkpEsd4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kFkpEsd4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90405C4CEF1;
	Mon, 27 Oct 2025 19:22:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761592942;
	bh=O3fpc/EQqg0bOriA79bPiN1H1lozyVHlgZ+0NmpKW24=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kFkpEsd4VQsrnvItfxZPH3geLUPJwvDXC0bg0KkwAu8q9kEg7/+RJhYEsT5IvEsZh
	 BYrbU0v5ZDCoKCXY8IkvjdrHyKttkgTIbxmWsKzalYTxpxrKhEh22kx5MI2R8YpMeC
	 AXCHgH6LOfHikWuuz0HVW7H0luGloYzbhaKjlnlE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dragos Tatulea <dtatulea@nvidia.com>,
	Amery Hung <ameryhung@gmail.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 035/117] net/mlx5e: RX, Fix generating skb from non-linear xdp_buff for legacy RQ
Date: Mon, 27 Oct 2025 19:36:01 +0100
Message-ID: <20251027183454.926233067@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183453.919157109@linuxfoundation.org>
References: <20251027183453.919157109@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index f072b21eb610d..5cacb25a763e4 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
@@ -1768,14 +1768,27 @@ mlx5e_skb_from_cqe_nonlinear(struct mlx5e_rq *rq, struct mlx5e_wqe_frag_info *wi
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



