Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3ED2198A2A;
	Thu,  6 Jun 2024 14:10:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683057; cv=none; b=XHUidsu7zgEPEJsyCwbOXgp5/pAxkIgGOff7dXzcni3KqC1KWw4jteVsCWNVvioOPmEua2oM4AGJmfXUO1skzhkFGCpvyx8snPt3zunhZxjAReyBkRkKv4TURx4F9UJgD6MMpnBSJ9zkCpeORG6fEv4rvpekzIEWvnyi9mKcUZg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683057; c=relaxed/simple;
	bh=aAfJ1iphCBPe3qJJrMvTyU32TvXdIG5Ofiwqsl/oUG0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=txkjye4Dziujd2Em4FEiptOqcIO82o09HruPYS/tB/jbvTWi2NwWkhU5fu21Np9ZxEyxugS7TW+BfmWSLFOzj9BbUNCWjaJA0NOP87nNeuS77hTa0QAjtPG4n6ykfVO4b4wBsWDKS1/qL31VJjcRjKB/HNI0QH7aG1V8aEBho/Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kL/Y3dQH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kL/Y3dQH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3EADC32782;
	Thu,  6 Jun 2024 14:10:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683056;
	bh=aAfJ1iphCBPe3qJJrMvTyU32TvXdIG5Ofiwqsl/oUG0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kL/Y3dQH0ZnVt35+XIVPEbvjuCvaIrv8DkMswPLwWYSVkh4yDn9bW4bqw6M8nSkbQ
	 DmV40rqTe1gdRUw2bN0QRI+W5k8BC12iaQ0Cf5magCrrkQOgGwRKSwxjzle+vwgEoX
	 NvL1fMULchW14bL75I149UfhDUpDQkVr8PJLJY9M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jason Baron <jbaron@akamai.com>,
	Gal Pressman <gal@nvidia.com>,
	Dragos Tatulea <dtatulea@nvidia.com>,
	Boris Pismenny <borisp@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Simon Horman <horms@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 302/374] net/mlx5e: Fix UDP GSO for encapsulated packets
Date: Thu,  6 Jun 2024 16:04:41 +0200
Message-ID: <20240606131701.971255117@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131651.683718371@linuxfoundation.org>
References: <20240606131651.683718371@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gal Pressman <gal@nvidia.com>

[ Upstream commit 83fea49f2711fc90c0d115b0ed04046b45155b65 ]

When the skb is encapsulated, adjust the inner UDP header instead of the
outer one, and account for UDP header (instead of TCP) in the inline
header size calculation.

Fixes: 689adf0d4892 ("net/mlx5e: Add UDP GSO support")
Reported-by: Jason Baron <jbaron@akamai.com>
Closes: https://lore.kernel.org/netdev/c42961cb-50b9-4a9a-bd43-87fe48d88d29@akamai.com/
Signed-off-by: Gal Pressman <gal@nvidia.com>
Reviewed-by: Dragos Tatulea <dtatulea@nvidia.com>
Reviewed-by: Boris Pismenny <borisp@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/mellanox/mlx5/core/en_accel/en_accel.h   | 8 +++++++-
 drivers/net/ethernet/mellanox/mlx5/core/en_tx.c           | 6 +++++-
 2 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/en_accel.h b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/en_accel.h
index caa34b9c161e5..33e32584b07f5 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/en_accel.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/en_accel.h
@@ -102,8 +102,14 @@ static inline void
 mlx5e_udp_gso_handle_tx_skb(struct sk_buff *skb)
 {
 	int payload_len = skb_shinfo(skb)->gso_size + sizeof(struct udphdr);
+	struct udphdr *udphdr;
 
-	udp_hdr(skb)->len = htons(payload_len);
+	if (skb->encapsulation)
+		udphdr = (struct udphdr *)skb_inner_transport_header(skb);
+	else
+		udphdr = udp_hdr(skb);
+
+	udphdr->len = htons(payload_len);
 }
 
 struct mlx5e_accel_tx_state {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
index e21a3b4128ce8..0964b16ca5619 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
@@ -153,7 +153,11 @@ mlx5e_tx_get_gso_ihs(struct mlx5e_txqsq *sq, struct sk_buff *skb, int *hopbyhop)
 
 	*hopbyhop = 0;
 	if (skb->encapsulation) {
-		ihs = skb_inner_tcp_all_headers(skb);
+		if (skb_shinfo(skb)->gso_type & SKB_GSO_UDP_L4)
+			ihs = skb_inner_transport_offset(skb) +
+			      sizeof(struct udphdr);
+		else
+			ihs = skb_inner_tcp_all_headers(skb);
 		stats->tso_inner_packets++;
 		stats->tso_inner_bytes += skb->len - ihs;
 	} else {
-- 
2.43.0



