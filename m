Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5D8F260566;
	Wed,  3 Dec 2025 16:08:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764778133; cv=none; b=c6tZGZidYtGkVZ4Iqjp8V/hEDdW/pInksD/YZvppkbPgRj4iJdDKE3vjeolEsO0eeDdqOtWf624v6+lt4aCZD1koXTG2uYgwVYo0KouikLMckjmdU3U282HWdmbz25gfAXx0rAFcqjY3XFXl0i80cTjqHXViyBYdfhY3uEqvqlo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764778133; c=relaxed/simple;
	bh=xY584R6dDQVJKISmvTndxs6XdReQZPB+tSko8cYPDyE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ORgnKkRlC5CqzL/MjQrHpxaoZdjk2p/J/LLWtTEFE4YEb6CKEi+Eqm+q4pCkYzOPn2lu81rcs5yixGavwEF1AAs9Ns0hRkhIxlnGxugSoEiIQvfUv3G9+3hKqLmSpV4oX0l+ZsOhgBxykoaZjYrExfDzmVTKH0u9atkHtug5p58=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q7F6btpf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q7F6btpf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFB17C4CEF5;
	Wed,  3 Dec 2025 16:08:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764778133;
	bh=xY584R6dDQVJKISmvTndxs6XdReQZPB+tSko8cYPDyE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q7F6btpfZ1s54066cZSeiA+AFm7zXSLBh1X/3RcMYh3P2miXSR9Vd0r7bi56QwWdE
	 vMj1TITsqeKojaLP2dlwI+xNTXkAYyJ7u6VzVVgM2vdOXKm+EGkOBp6HsaWlPZ1YHL
	 MOjPiMFfAoz/757UmevHwZA4/MjR31HLUVN1ONHw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gal Pressman <gal@nvidia.com>,
	Nimrod Oren <noren@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 254/392] net/mlx5e: Fix wraparound in rate limiting for values above 255 Gbps
Date: Wed,  3 Dec 2025 16:26:44 +0100
Message-ID: <20251203152423.516935994@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152414.082328008@linuxfoundation.org>
References: <20251203152414.082328008@linuxfoundation.org>
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

From: Gal Pressman <gal@nvidia.com>

[ Upstream commit 43b27d1bd88a4bce34ec2437d103acfae9655f9e ]

Add validation to reject rates exceeding 255 Gbps that would overflow
the 8 bits max bandwidth field.

Fixes: d8880795dabf ("net/mlx5e: Implement DCBNL IEEE max rate")
Signed-off-by: Gal Pressman <gal@nvidia.com>
Reviewed-by: Nimrod Oren <noren@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Link: https://patch.msgid.link/1762681073-1084058-5-git-send-email-tariqt@nvidia.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_dcbnl.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_dcbnl.c b/drivers/net/ethernet/mellanox/mlx5/core/en_dcbnl.c
index 51fadfcda35a5..86545554abb4e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_dcbnl.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_dcbnl.c
@@ -588,11 +588,13 @@ static int mlx5e_dcbnl_ieee_setmaxrate(struct net_device *netdev,
 	u8 max_bw_value[IEEE_8021QAZ_MAX_TCS];
 	u8 max_bw_unit[IEEE_8021QAZ_MAX_TCS];
 	__u64 upper_limit_mbps;
+	__u64 upper_limit_gbps;
 	int i;
 
 	memset(max_bw_value, 0, sizeof(max_bw_value));
 	memset(max_bw_unit, 0, sizeof(max_bw_unit));
 	upper_limit_mbps = 255 * MLX5E_100MB;
+	upper_limit_gbps = 255 * MLX5E_1GB;
 
 	for (i = 0; i <= mlx5_max_tc(mdev); i++) {
 		if (!maxrate->tc_maxrate[i]) {
@@ -604,10 +606,16 @@ static int mlx5e_dcbnl_ieee_setmaxrate(struct net_device *netdev,
 						  MLX5E_100MB);
 			max_bw_value[i] = max_bw_value[i] ? max_bw_value[i] : 1;
 			max_bw_unit[i]  = MLX5_100_MBPS_UNIT;
-		} else {
+		} else if (max_bw_value[i] <= upper_limit_gbps) {
 			max_bw_value[i] = div_u64(maxrate->tc_maxrate[i],
 						  MLX5E_1GB);
 			max_bw_unit[i]  = MLX5_GBPS_UNIT;
+		} else {
+			netdev_err(netdev,
+				   "tc_%d maxrate %llu Kbps exceeds limit %llu\n",
+				   i, maxrate->tc_maxrate[i],
+				   upper_limit_gbps);
+			return -EINVAL;
 		}
 	}
 
-- 
2.51.0



