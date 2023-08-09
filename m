Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 908D0847D
	for <patches@lists.linux.dev>; Wed,  9 Aug 2023 10:52:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 137C3C433C7;
	Wed,  9 Aug 2023 10:52:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691578343;
	bh=HKwoXg/T2iLRfYfAhZ2dTMwwPm0v6Q6aWeA9eOkxd3E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lQXc8+8CyQ/9k0UIN39h3UZorG0QWRdvJ3R4X5hq/U6F5vri0LW1rZEMM2tbdbyeF
	 YkL+DV27pTy46uk9kWVWPIcaXIyBOekOIfLtQ2Y1Brrz18ZEnvCtHs6nlsBcZwzUd4
	 /M1ucW+EX4nFRdI6ivy6sMElGLX22TUryJAt2P7w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuanjun Gong <ruc_gongyuanjun@163.com>,
	Leon Romanovsky <leonro@nvidia.com>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 025/127] net/mlx5e: fix return value check in mlx5e_ipsec_remove_trailer()
Date: Wed,  9 Aug 2023 12:40:12 +0200
Message-ID: <20230809103637.475664445@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230809103636.615294317@linuxfoundation.org>
References: <20230809103636.615294317@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Yuanjun Gong <ruc_gongyuanjun@163.com>

[ Upstream commit e5bcb7564d3bd0c88613c76963c5349be9c511c5 ]

mlx5e_ipsec_remove_trailer() should return an error code if function
pskb_trim() returns an unexpected value.

Fixes: 2ac9cfe78223 ("net/mlx5e: IPSec, Add Innova IPSec offload TX data path")
Signed-off-by: Yuanjun Gong <ruc_gongyuanjun@163.com>
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_rxtx.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_rxtx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_rxtx.c
index 6859f1c1a8319..c4a84f0a3b733 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_rxtx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_rxtx.c
@@ -58,7 +58,9 @@ static int mlx5e_ipsec_remove_trailer(struct sk_buff *skb, struct xfrm_state *x)
 
 	trailer_len = alen + plen + 2;
 
-	pskb_trim(skb, skb->len - trailer_len);
+	ret = pskb_trim(skb, skb->len - trailer_len);
+	if (unlikely(ret))
+		return ret;
 	if (skb->protocol == htons(ETH_P_IP)) {
 		ipv4hdr->tot_len = htons(ntohs(ipv4hdr->tot_len) - trailer_len);
 		ip_send_check(ipv4hdr);
-- 
2.40.1



