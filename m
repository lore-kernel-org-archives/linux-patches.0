Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71D56384;
	Thu, 13 Jun 2024 12:42:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718282542; cv=none; b=GkI+Ox1gYD9ZfWvR/6IfzTYyOxPup3AffE9bAiYaYwwNfILzboP5yY3svzG/gACssS4LLYD5WivbPhS6iswUzWT/osZ9UPrNbNKKZhReGLoLfjnwP+NpzDh+x9NLoI8uetPm9xuooMjfPAF0580CsJqiMI5ulcGKFvVPvk/tO9s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718282542; c=relaxed/simple;
	bh=EopPKw5Y+sHmq9S7IdIdGwFHLaldZEoMIrp7ENFrPBw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=osY7QP5HyN9At6KaSPopFnoIjaGqWO6D1tfJbPMoAw73vi644Gxo7hY4jVAjZMmR3+O3AfUVeBIsJBMPnqM6+h7VOxpLRpgVOR1yBNxI09NAXtgaOiK/iUTviv5UvjG9MogPhd1tj1Fm90/XozzSyGG2SMXTG33aLWhFCx7CaJY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=da17+e0G; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="da17+e0G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9D10C4AF1A;
	Thu, 13 Jun 2024 12:42:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718282542;
	bh=EopPKw5Y+sHmq9S7IdIdGwFHLaldZEoMIrp7ENFrPBw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=da17+e0GU6F+lFrS+AP/qZh6YyuBjUcaaz2wDNonUbdSvvEROzBEQagX23wtrwhzi
	 RtzOWQ1Y6d64Fhq0ij6i3tyhDpBYQKlW4fsB8XbKn4VZXgk7skRJQWU1KU2/+N5paw
	 s2z8y4+g6/rwh2Qscnq0h5g/7a3sNqE2ByLrZvhg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rahul Rameshbabu <rrameshbabu@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Simon Horman <horms@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 311/402] net/mlx5e: Fix IPsec tunnel mode offload feature check
Date: Thu, 13 Jun 2024 13:34:28 +0200
Message-ID: <20240613113314.274504428@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113302.116811394@linuxfoundation.org>
References: <20240613113302.116811394@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rahul Rameshbabu <rrameshbabu@nvidia.com>

[ Upstream commit 9a52f6d44f4521773b4699b4ed34b8e21d5a175c ]

Remove faulty check disabling checksum offload and GSO for offload of
simple IPsec tunnel L4 traffic. Comment previously describing the deleted
code incorrectly claimed the check prevented double tunnel (or three layers
of ip headers).

Fixes: f1267798c980 ("net/mlx5: Fix checksum issue of VXLAN and IPsec crypto offload")
Signed-off-by: Rahul Rameshbabu <rrameshbabu@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../mellanox/mlx5/core/en_accel/ipsec_rxtx.h    | 17 +++++------------
 1 file changed, 5 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_rxtx.h b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_rxtx.h
index 428881e0adcbe..6621f6cd43151 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_rxtx.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_rxtx.h
@@ -105,18 +105,11 @@ mlx5e_ipsec_feature_check(struct sk_buff *skb, netdev_features_t features)
 		if (!x || !x->xso.offload_handle)
 			goto out_disable;
 
-		if (xo->inner_ipproto) {
-			/* Cannot support tunnel packet over IPsec tunnel mode
-			 * because we cannot offload three IP header csum
-			 */
-			if (x->props.mode == XFRM_MODE_TUNNEL)
-				goto out_disable;
-
-			/* Only support UDP or TCP L4 checksum */
-			if (xo->inner_ipproto != IPPROTO_UDP &&
-			    xo->inner_ipproto != IPPROTO_TCP)
-				goto out_disable;
-		}
+		/* Only support UDP or TCP L4 checksum */
+		if (xo->inner_ipproto &&
+		    xo->inner_ipproto != IPPROTO_UDP &&
+		    xo->inner_ipproto != IPPROTO_TCP)
+			goto out_disable;
 
 		return features;
 
-- 
2.43.0



