Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C544443B4A2;
	Tue, 21 Jul 2026 20:49:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784666974; cv=none; b=ZKz0sfbjXyXAJFfEs0zC8zichcgMBSk3TTx4II54Mad4q6j9opsy/cnU8ekn+jJ0Zw0w/5bZv48V4QCVs8Gaf44STJf9SEPATMFcsxg0KTxYfRVUpeslWtPCJREtXvQ4x/xpyV1qIlYrrcl/9kEP1FtjYTsEIXpoRDwixZMh710=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784666974; c=relaxed/simple;
	bh=rovW+s5RcEqx4u4I8PzbxRmMc0JJIZaR2WrNGNpRBVs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=odp6rpQ/mn/e5SVlzXzm0zZY3WO8UxbzLXQZdeGOXuR54aAYHsBUPSqIJHKEMYTLHqkC8nBv4aQ2ohekkLN/y5AL3yBkG6JaHNBf+rAt5NkHpWepGqFOsdr708RqE6thh1WT/QjaTQGtQuhdp8F35mxl+an5nyzZMnAcLdwu44s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pQ8Z81+d; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pQ8Z81+d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF7AA1F00A3A;
	Tue, 21 Jul 2026 20:49:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784666972;
	bh=AiLrczxQW8gKjWU2KEKVta7Ky8zcEgU1ExkCfymi5k0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pQ8Z81+dS4ogVsRCzYLRn42+jo0ps2nHYU7Cl9PZFxZJX+7lkR48Vv5fS2HUYB8Rr
	 jPwm2s5QLv0E4GtjK4AoE27jAcD9FppmGY4x6ZyRAA4dKRIFIUfFV2rQDRkBN1r8ZN
	 s0o0WVjdmedhnZeyahl7COY2PlZ7J/wA8OZpQFAM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li RongQing <lirongqing@baidu.com>,
	Simon Horman <horms@kernel.org>,
	Tariq Toukan <tariqt@nvidia.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0886/1266] net/mlx5: Fix L3 tunnel entropy refcount leak
Date: Tue, 21 Jul 2026 17:22:03 +0200
Message-ID: <20260721152501.675899736@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Li RongQing <lirongqing@baidu.com>

[ Upstream commit c914307e1d41c2cb7bcdcbfde4cd2f214f6aa027 ]

mlx5_tun_entropy_refcount_inc() counts both VXLAN and L2-to-L3
tunnel reformat entries as entropy-enabling users. The matching
decrement path only handled VXLAN, leaving L2-to-L3 tunnel entries
counted after release.

Handle MLX5_REFORMAT_TYPE_L2_TO_L3_TUNNEL in
mlx5_tun_entropy_refcount_dec() as well so the enabling entry
refcount remains balanced.

Fixes: f828ca6a2fb6 ("net/mlx5e: Add support for hw encapsulation of MPLS over UDP")
Signed-off-by: Li RongQing <lirongqing@baidu.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Link: https://patch.msgid.link/20260703141423.1723-1-lirongqing@baidu.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/lib/port_tun.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/port_tun.c b/drivers/net/ethernet/mellanox/mlx5/core/lib/port_tun.c
index 4571c56ec3c9b2..97f6097d4c705f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lib/port_tun.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/port_tun.c
@@ -176,7 +176,8 @@ void mlx5_tun_entropy_refcount_dec(struct mlx5_tun_entropy *tun_entropy,
 				   int reformat_type)
 {
 	mutex_lock(&tun_entropy->lock);
-	if (reformat_type == MLX5_REFORMAT_TYPE_L2_TO_VXLAN)
+	if (reformat_type == MLX5_REFORMAT_TYPE_L2_TO_VXLAN ||
+	    reformat_type == MLX5_REFORMAT_TYPE_L2_TO_L3_TUNNEL)
 		tun_entropy->num_enabling_entries--;
 	else if (reformat_type == MLX5_REFORMAT_TYPE_L2_TO_NVGRE &&
 		 --tun_entropy->num_disabling_entries == 0)
-- 
2.53.0



