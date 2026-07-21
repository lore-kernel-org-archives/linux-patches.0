Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81F2543F8A1;
	Tue, 21 Jul 2026 22:17:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784672241; cv=none; b=dVTXVRqZK+5hUtCV9mMn5pwILaq9WF9g1ZC4AQYN+Zl3fMVb7/60hX5lfG9j4P4EpfZ/SFeBy4YFVAX4KKjLfr9LdAjITisy1yx2Fgv0XrDbnqEYTfo8ykQAvM0T1azum57IdwZiTz/6nCI1q8zV2BoMKx3MbkJi7daZC2zwuNw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784672241; c=relaxed/simple;
	bh=ijv1Fdgz1qfC45Ysvi0K2hzSM5TKkAbvqOIZ8HzB/IA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qMVEOghK82ohPO4bd2y50gMfO0tjFLdqapm31dimSuQRIApzeNChfs2kcDEXDjzD1GCSHNB/nsi/y0Di7aqEVUv0EEw2qqDYxQjcAF1Tuor5dy0mVzFKTwQmPNF8ldqc8cro3kmgGfQ24cZg0qUFC0uFO1vgRe9qaktwDXVkk80=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PDlWHyem; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PDlWHyem"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFA3D1F000E9;
	Tue, 21 Jul 2026 22:17:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784672240;
	bh=toVxP371HAop9+ac2MIHb7apGXeYbA0AjR+XPGHaH5E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PDlWHyemG3iRLpXGPbmU7taLVfpJHpqg1ilv1vBQSVhn/5u5uHYWTRp4/4fgEJCNr
	 MzvVMaOoEq3bjU8yanAjulfLkjy9k7Oni0YUaG8iXEcUhsM/Xpd20F4LO9nRYbHD0N
	 oOPcvmqv74xmwHoeOG77PJfcuJzGolJcAtC+UA8Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li RongQing <lirongqing@baidu.com>,
	Simon Horman <horms@kernel.org>,
	Tariq Toukan <tariqt@nvidia.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 551/843] net/mlx5: Fix L3 tunnel entropy refcount leak
Date: Tue, 21 Jul 2026 17:23:06 +0200
Message-ID: <20260721152418.440992158@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index e042e092407939..1642ff7915ff84 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lib/port_tun.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/port_tun.c
@@ -177,7 +177,8 @@ void mlx5_tun_entropy_refcount_dec(struct mlx5_tun_entropy *tun_entropy,
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



