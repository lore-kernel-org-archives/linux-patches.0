Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 374B23074A0;
	Wed,  3 Dec 2025 15:44:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764776694; cv=none; b=rUIwF5T9sBjOKS32Zj+TE0UZ2Td64vGGWVCyh0ACsaNEa/6aYPLDXDg5X2GfERV+JXR2IrydYbogklN+F6cl1HyJLYvz7y8kPm4k41ODQDvDPZH5Ovvl0igLSL13O6jboFZI9NXhycqkwOqb8SzWZvVi5Uk4jAXdFf0ZcKjm7hQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764776694; c=relaxed/simple;
	bh=n5Z5bBut5ZH8xHZVrb2FxAMH96HSR+Y1HuO3fjlkCV0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FNao2TcfYDhubxZoMPUwyAzrxQgQJElywKxfmzkg/sOcLANQoHpkl5oDR1TeDvprLzoODcFMjrxSwScjQl6x2hQehzfNMdyslv2JxZUKCujYBsakRQUjN1YGyrQhp1lPsIeW7DPaP+zsAlwBQX9GtgCqgWBpUF3lDOi2l4RYQro=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q19lMm0q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q19lMm0q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7467AC4CEF5;
	Wed,  3 Dec 2025 15:44:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764776693;
	bh=n5Z5bBut5ZH8xHZVrb2FxAMH96HSR+Y1HuO3fjlkCV0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q19lMm0q3xDxMdfw24bKJFeinpOm/FI/5Fq6SfOYjlYUsq/7DiH+74RCGLWKnuV6j
	 1n5Rlnm2mXENgfStIuUlL/AcJZbifs+h323OQbZuv9t8ZwC/P/aA/ymeTEdaYakrr8
	 stJwzrChcjw/DYrjy7d1k8L81wPBbqJHbkMZUK30=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Danielle Costantino <dcostantino@meta.com>,
	Gal Pressman <gal@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 259/300] net/mlx5e: Fix validation logic in rate limiting
Date: Wed,  3 Dec 2025 16:27:43 +0100
Message-ID: <20251203152410.233568000@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152400.447697997@linuxfoundation.org>
References: <20251203152400.447697997@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Danielle Costantino <dcostantino@meta.com>

[ Upstream commit d2099d9f16dbfa1c5266d4230ff7860047bb0b68 ]

The rate limiting validation condition currently checks the output
variable max_bw_value[i] instead of the input value
maxrate->tc_maxrate[i]. This causes the validation to compare an
uninitialized or stale value rather than the actual requested rate.

The condition should check the input rate to properly validate against
the upper limit:

    } else if (maxrate->tc_maxrate[i] <= upper_limit_gbps) {

This aligns with the pattern used in the first branch, which correctly
checks maxrate->tc_maxrate[i] against upper_limit_mbps.

The current implementation can lead to unreliable validation behavior:

- For rates between 25.5 Gbps and 255 Gbps, if max_bw_value[i] is 0
  from initialization, the GBPS path may be taken regardless of whether
  the actual rate is within bounds

- When processing multiple TCs (i > 0), max_bw_value[i] contains the
  value computed for the previous TC, affecting the validation logic

- The overflow check for rates exceeding 255 Gbps may not trigger
  consistently depending on previous array values

This patch ensures the validation correctly examines the requested rate
value for proper bounds checking.

Fixes: 43b27d1bd88a ("net/mlx5e: Fix wraparound in rate limiting for values above 255 Gbps")
Signed-off-by: Danielle Costantino <dcostantino@meta.com>
Reviewed-by: Gal Pressman <gal@nvidia.com>
Link: https://patch.msgid.link/20251124180043.2314428-1-dcostantino@meta.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_dcbnl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_dcbnl.c b/drivers/net/ethernet/mellanox/mlx5/core/en_dcbnl.c
index 5c48a4872f35d..5d0be9703a48e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_dcbnl.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_dcbnl.c
@@ -606,7 +606,7 @@ static int mlx5e_dcbnl_ieee_setmaxrate(struct net_device *netdev,
 						  MLX5E_100MB);
 			max_bw_value[i] = max_bw_value[i] ? max_bw_value[i] : 1;
 			max_bw_unit[i]  = MLX5_100_MBPS_UNIT;
-		} else if (max_bw_value[i] <= upper_limit_gbps) {
+		} else if (maxrate->tc_maxrate[i] <= upper_limit_gbps) {
 			max_bw_value[i] = div_u64(maxrate->tc_maxrate[i],
 						  MLX5E_1GB);
 			max_bw_unit[i]  = MLX5_GBPS_UNIT;
-- 
2.51.0



