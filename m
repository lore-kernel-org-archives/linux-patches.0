Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEDAF198A20;
	Thu,  6 Jun 2024 14:10:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683056; cv=none; b=GeRlyId8eWQ1AVbk1MCO6TRZ7ijafL1uj9l10l27BHVIW6PxEKDfqZUx6CoVsEQCbm0pdyulXQFvCaj/Jh7ZcaJ0sYg95vdZu0TI0Xcg4pFLMU48N4H3vkN0/pfdjCd6f3pzjqD40pHCLOkdQzzPp0kEOlejJFiQJW6Z9L0g3LA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683056; c=relaxed/simple;
	bh=x7LHFzmQf8mTF6mCEMBxgXjlAl5SvvTYF+H78De0GGc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PLaPLMaEUTbhLLB0BXBiTb+4f1HhMX62V9awQhMdYiMUcG4xNoml4HH/SkqtMYq5XGD9KlkxMaVJxQyQQBbJRmI4zX3r/1Xib2kQd5BH47qGY8HsKyVr8iK/x+seZfrAllEa4tZ1ZNBRHIiAoY8jYCrtzBICNzgs3t5wPSyvFig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KxlbhaSZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KxlbhaSZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD00AC4AF07;
	Thu,  6 Jun 2024 14:10:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683055;
	bh=x7LHFzmQf8mTF6mCEMBxgXjlAl5SvvTYF+H78De0GGc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KxlbhaSZEG73y7LG1DNKKqWvfJbb7oMb+6oVU8p+F+g8m3zaV8bC365ItV7PwjMJw
	 NcCg8cKjYX+9erFMx0CuiHNe9X7BFck0mSVXSuixAHNLVOKJGbHpHJiH34XhdEafF4
	 1702de6YPCX1A3FSdozeBmRAbcL8M/FTx+eT5R7c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rahul Rameshbabu <rrameshbabu@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Simon Horman <horms@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 300/374] net/mlx5e: Fix IPsec tunnel mode offload feature check
Date: Thu,  6 Jun 2024 16:04:39 +0200
Message-ID: <20240606131701.909333603@linuxfoundation.org>
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
index 82064614846f5..359050f0b54dd 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_rxtx.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_rxtx.h
@@ -97,18 +97,11 @@ mlx5e_ipsec_feature_check(struct sk_buff *skb, netdev_features_t features)
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



