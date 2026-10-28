Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793215346;
	b=BGfEeS6BBvDLzTqOOlFC2PBvKhdlBabhftB9b0KVROowbcR++0T1YsUqmu5muyyyalt+
	 SXsykyqhrdXWYL9sTx1YGRGyAx2wktw5HRVTynh1RWuciXg/0Lwbqtlgatfpnt7vLv0TJ
	 Ky3MlPhmXceyA8HDaEQNpUTk0M+4gtIexBrZSG/HVIW1DDciYUyInAzrEbBFdanHu2hYA
	 SptVQUpLtMCRigsUm2mnx02E4oE3xowv4gickSY+due+HlND1wMLFiMQoQhNUf20I0tF9
	 EkkuIyJz6M0vqosJ4PivbQrmqEWvX9aeiFSjN6RakBw90qcU47lm5jyFksvI0sX107Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793215346;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=PZG+iZGsmPA2M7w9lWpBwA6mT6GtyjRfeCIUHIPhBGw=;
	b=MC7Qk4cI4/b+qQz5MWTYC4iQxUyggfsTK/gBzpQLTi2d8UffNg3SvGCdvSmSb0BRfSGc
	 xWMom/QY1Opc0DNRvnbNeXtyhnP0XJ5cHNqh2qznjLRxYrX73OrBizHPFt0vd26bMFjuz
	 o0/HPRwilUG/70E5fngHeSGOU575ku4prR58BMl3+HG1FM8uorw0Btjcfb7/BF9PID1fy
	 O767I+FGQvnL7Xff7AB2z5pSCTcupDXEhygy46+ATb5NIPSV6FHLAeOEiF/Di9+mbFG/8
	 iOK8uLInUDNjN/awNSgb1QHR4Jj191rhvwuMEDLpNKxe3xBiSGWY8oRo4hZgYxJ5khg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xNvlaB3V;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91773606A31F;
	Wed, 28 Oct 2026 19:22:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xNvlaB3V
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEF7B1F01825;
	Wed, 28 Oct 2026 19:22:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793215346;
	bh=PZG+iZGsmPA2M7w9lWpBwA6mT6GtyjRfeCIUHIPhBGw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xNvlaB3Vwx0/+UTLDt83Ckk4A/57CZcYd9bkmirsCw1aWi7v1MArUFRc49WNSrfBo
	 lXyrvQEEkYhO4PbXUoI02rhZpEpCcAO6e6c8Qz8pTA6TPJRySGdTaxrsumCdJK9GzM
	 Vu6GOhdXadTQNd7J+PrgWRMSWtdW9qS1jCJpzFk4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gal Pressman <gal@nvidia.com>,
	Alex Lazar <alazar@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1177/1887] net/mlx5: Fix MCIA register buffer overflow on 32 dword reads
Date: Wed, 28 Oct 2026 17:54:33 +0100
Message-ID: <20261028170526.190656729@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gal Pressman <gal@nvidia.com>

[ Upstream commit 11c057d23465c7a5817a7284c896d19d54c0b616 ]

The MCIA register can return up to 32 dwords (128 bytes) when the device
advertises the mcia_32dwords capability, but struct
mlx5_ifc_mcia_reg_bits only defines dword_0..11, leaving room for just
12 dwords (48 bytes) of data.

mlx5_query_mcia() clamps the read size to mlx5_mcia_max_bytes() and then
memcpy()s that many bytes out of the register, potentially reading past
the end of the 'out' buffer. On kernels built with FORTIFY_SOURCE this
is caught as a buffer overflow while reading the module EEPROM via
ethtool:

  detected buffer overflow in memcpy
  kernel BUG at lib/string_helpers.c:1048!
  RIP: 0010:fortify_panic+0x13/0x20
  Call Trace:
   mlx5_query_mcia.isra.0+0x200/0x210 [mlx5_core]
   mlx5_query_module_eeprom_by_page+0x4a/0xa0 [mlx5_core]
   mlx5e_get_module_eeprom_by_page+0xbb/0x120 [mlx5_core]
   eeprom_prepare_data+0xf3/0x170
   ethnl_default_doit+0xf1/0x3b0

Extend the mcia_reg layout to 32 dwords.

Fixes: 271907ee2f29 ("net/mlx5: Query the maximum MCIA register read size from firmware")
Signed-off-by: Gal Pressman <gal@nvidia.com>
Reviewed-by: Alex Lazar <alazar@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Link: https://patch.msgid.link/20260717072338.1240582-1-tariqt@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/port.c |  4 ++--
 include/linux/mlx5/mlx5_ifc.h                  | 13 +------------
 2 files changed, 3 insertions(+), 14 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/port.c b/drivers/net/ethernet/mellanox/mlx5/core/port.c
index 28ec31722ec2f..4493ee0cb8ea2 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/port.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/port.c
@@ -316,7 +316,7 @@ static int mlx5_query_module_id(struct mlx5_core_dev *dev, int module_num,
 			      status);
 		return -EIO;
 	}
-	ptr = MLX5_ADDR_OF(mcia_reg, out, dword_0);
+	ptr = MLX5_ADDR_OF(mcia_reg, out, dwords);
 
 	*module_id = ptr[0];
 
@@ -401,7 +401,7 @@ static int mlx5_query_mcia(struct mlx5_core_dev *dev,
 		return -EIO;
 	}
 
-	ptr = MLX5_ADDR_OF(mcia_reg, out, dword_0);
+	ptr = MLX5_ADDR_OF(mcia_reg, out, dwords);
 	memcpy(data, ptr, size);
 
 	return size;
diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index 9610b325f2b61..6021e8de4e87f 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -11017,18 +11017,7 @@ struct mlx5_ifc_mcia_reg_bits {
 
 	u8         reserved_at_60[0x20];
 
-	u8         dword_0[0x20];
-	u8         dword_1[0x20];
-	u8         dword_2[0x20];
-	u8         dword_3[0x20];
-	u8         dword_4[0x20];
-	u8         dword_5[0x20];
-	u8         dword_6[0x20];
-	u8         dword_7[0x20];
-	u8         dword_8[0x20];
-	u8         dword_9[0x20];
-	u8         dword_10[0x20];
-	u8         dword_11[0x20];
+	u8         dwords[0x400];
 };
 
 struct mlx5_ifc_dcbx_param_bits {
-- 
2.53.0



