Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 206325BF9C;
	Mon, 18 Dec 2023 14:00:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oSTFRTjN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C64EC433CA;
	Mon, 18 Dec 2023 14:00:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702908024;
	bh=rAakvA5da6SHqSseVpTgM4hi+0pUBSielg3bm+V+69M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oSTFRTjNForlGDf1TXzH7qtju0xDkCn1W0UWMbhNbcsZADwPcKjEnSJ/KEwy13LUU
	 SZeLRHS5kW/jxb7dlbk5UqS4/+tJ0UPKfUwK859dUJSb6mhEiMMnm+B5tdjbqhizdH
	 wY0HI7oKovXnvHqorBSQoYOb4UEFTzVswIDRy6fk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Patrisious Haddad <phaddad@nvidia.com>,
	Leon Romanovsky <leonro@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 007/166] net/mlx5e: Honor user choice of IPsec replay window size
Date: Mon, 18 Dec 2023 14:49:33 +0100
Message-ID: <20231218135105.284549473@linuxfoundation.org>
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

[ Upstream commit a5e400a985df8041ed4659ed1462aa9134318130 ]

Users can configure IPsec replay window size, but mlx5 driver didn't
honor their choice and set always 32bits. Fix assignment logic to
configure right size from the beginning.

Fixes: 7db21ef4566e ("net/mlx5e: Set IPsec replay sequence numbers")
Reviewed-by: Patrisious Haddad <phaddad@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../mellanox/mlx5/core/en_accel/ipsec.c       | 21 +++++++++++++++++++
 .../mlx5/core/en_accel/ipsec_offload.c        |  2 +-
 include/linux/mlx5/mlx5_ifc.h                 |  7 +++++++
 3 files changed, 29 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
index 7d4ceb9b9c16f..65678e89aea62 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
@@ -335,6 +335,27 @@ void mlx5e_ipsec_build_accel_xfrm_attrs(struct mlx5e_ipsec_sa_entry *sa_entry,
 		attrs->replay_esn.esn = sa_entry->esn_state.esn;
 		attrs->replay_esn.esn_msb = sa_entry->esn_state.esn_msb;
 		attrs->replay_esn.overlap = sa_entry->esn_state.overlap;
+		switch (x->replay_esn->replay_window) {
+		case 32:
+			attrs->replay_esn.replay_window =
+				MLX5_IPSEC_ASO_REPLAY_WIN_32BIT;
+			break;
+		case 64:
+			attrs->replay_esn.replay_window =
+				MLX5_IPSEC_ASO_REPLAY_WIN_64BIT;
+			break;
+		case 128:
+			attrs->replay_esn.replay_window =
+				MLX5_IPSEC_ASO_REPLAY_WIN_128BIT;
+			break;
+		case 256:
+			attrs->replay_esn.replay_window =
+				MLX5_IPSEC_ASO_REPLAY_WIN_256BIT;
+			break;
+		default:
+			WARN_ON(true);
+			return;
+		}
 	}
 
 	attrs->dir = x->xso.dir;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_offload.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_offload.c
index 3245d1c9d5392..55b11d8cba532 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_offload.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_offload.c
@@ -94,7 +94,7 @@ static void mlx5e_ipsec_packet_setup(void *obj, u32 pdn,
 
 		if (attrs->dir == XFRM_DEV_OFFLOAD_IN) {
 			MLX5_SET(ipsec_aso, aso_ctx, window_sz,
-				 attrs->replay_esn.replay_window / 64);
+				 attrs->replay_esn.replay_window);
 			MLX5_SET(ipsec_aso, aso_ctx, mode,
 				 MLX5_IPSEC_ASO_REPLAY_PROTECTION);
 		}
diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index fc3db401f8a28..f08cd13031458 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -11936,6 +11936,13 @@ enum {
 	MLX5_IPSEC_ASO_INC_SN            = 0x2,
 };
 
+enum {
+	MLX5_IPSEC_ASO_REPLAY_WIN_32BIT  = 0x0,
+	MLX5_IPSEC_ASO_REPLAY_WIN_64BIT  = 0x1,
+	MLX5_IPSEC_ASO_REPLAY_WIN_128BIT = 0x2,
+	MLX5_IPSEC_ASO_REPLAY_WIN_256BIT = 0x3,
+};
+
 struct mlx5_ifc_ipsec_aso_bits {
 	u8         valid[0x1];
 	u8         reserved_at_201[0x1];
-- 
2.43.0



