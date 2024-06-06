Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AAC3197521;
	Thu,  6 Jun 2024 14:20:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683651; cv=none; b=mAMRgJMBwE1YY1v9UVirnKi6vb/TEG9ziD9JYR7UzqYjnmHkb+9S0GOPFNp1E1H2q+KTrpKzejCCrQUtdZvYUPAOW7zeEH4nmY9M/r2P/EjRzwxkX2dx54IZy/0QObaRmnn4ZEsilImqlzTr0sRsamNm/eK1ywPGxMomhAxUctk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683651; c=relaxed/simple;
	bh=necSJkYwQmfHwm4qrhZ4OUrGePWV90jjfYYLxQjxJxo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dSJwWOQzyru9DN6o0fBgyMpO6RckJR0aOFR9kiPqPZgE12KHrsh2uwtPtnXrToWAge/2IELspwzmrnbdq2aZ+dYM0Bq1POoPuIvgO+MdpSXXbhAgzOYEXPctywe9OMqvpkcGTonqB04/aD6WtkRz6ab6fIiwh2SD6YKrP73mqB8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xhiBF7xW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xhiBF7xW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E06AC2BD10;
	Thu,  6 Jun 2024 14:20:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683651;
	bh=necSJkYwQmfHwm4qrhZ4OUrGePWV90jjfYYLxQjxJxo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xhiBF7xW9CIbQa9fFDtrt5duPHPl8iXmuAbjVcjqx4xTzNTnqWo4WBShXxEOogThb
	 iyYYnmCnLUTvBL9B5g19Z+l2zKbTEaIqtp/z3J5zVGEixD/Mkvo253wZPc1GBKRL3I
	 QpjgnlRGtKg13X3eWTnXCsY+IY1U/K0dmdERoH1Y=
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
Subject: [PATCH 6.1 441/473] net/mlx5e: Fix UDP GSO for encapsulated packets
Date: Thu,  6 Jun 2024 16:06:10 +0200
Message-ID: <20240606131714.302772005@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131659.786180261@linuxfoundation.org>
References: <20240606131659.786180261@linuxfoundation.org>
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
index 07187028f0d35..1445a9a46baea 100644
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
index a6d7e2cfcd0e1..e6e792a38a640 100644
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



