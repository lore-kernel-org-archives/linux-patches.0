Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 272023587BE;
	Wed,  3 Dec 2025 16:35:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764779759; cv=none; b=vC3fQ+s3pDllVHDDSe3T2+Y7QWGGw/4xp8e3mFhk1ZnUyg1I2OIqrUjeJU0eSqDeQiJYVXAeWhXpd+7844EEugVCsv10lkixY6P9/SCty1WSx3xuSGmRtH+z5GtGoKsf8K2FelUXocDekMG1toWqQ/tXgdzPmOsz3/v/WS38re8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764779759; c=relaxed/simple;
	bh=n7yaF3NSGndnBee4C3Z/TbwZjCsIkNFoPdn1zUox0Uc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rGDAOTV1M5vkqcjlx2KZREURkcau1DV1ECgV0mR7HuSpa1hgpGEFRBin1gHPOtRTMcyzMfp6u2jn4pLSac1Mb8poTpuMfHdem5sOXBsgUFyC7zBSQqZ6RgJobI+ugqC9aqE3x0dn3TJbCEfyhz9BL+Jg7/fPVk+FtqjMYZmx9Qo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eZ6Eye3D; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eZ6Eye3D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F0D8C4CEF5;
	Wed,  3 Dec 2025 16:35:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764779758;
	bh=n7yaF3NSGndnBee4C3Z/TbwZjCsIkNFoPdn1zUox0Uc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eZ6Eye3DpDR2XjmnV+EeKUcdSBNVail5mVR6hLECerMITmsLpJgpu7gnoCij/9Fii
	 aIkjNGTLJULR97VTZ9tV/Pu+qwJ9mGlFLd9fQzfCrEEuNxmsiMFeVt49exRZ7sJKbA
	 4XV9eXih9ydbDk+q5en9W6uQ/3pYzVecOBPpBDCY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dragos Tatulea <dtatulea@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 320/568] net/mlx5e: SHAMPO, Fix skb size check for 64K pages
Date: Wed,  3 Dec 2025 16:25:22 +0100
Message-ID: <20251203152452.432509531@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152440.645416925@linuxfoundation.org>
References: <20251203152440.645416925@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dragos Tatulea <dtatulea@nvidia.com>

[ Upstream commit bacd8d80181ebe34b599a39aa26bf73a44c91e55 ]

mlx5e_hw_gro_skb_has_enough_space() uses a formula to check if there is
enough space in the skb frags to store more data. This formula is
incorrect for 64K page sizes and it triggers early GRO session
termination because the first fragment will blow up beyond
GRO_LEGACY_MAX_SIZE.

This patch adds a special case for page sizes >= GRO_LEGACY_MAX_SIZE
(64K) which uses the skb->len instead. Within this context,
the check is safe from fragment overflow because the hardware
will continuously fill the data up to the reservation size of 64K
and the driver will coalesce all data from the same page to the same
fragment. This means that the data will span one fragment or at most
two for such a large page size.

It is expected that the if statement will be optimized out as the
check is done with constants.

Fixes: 92552d3abd32 ("net/mlx5e: HW_GRO cqe handler implementation")
Signed-off-by: Dragos Tatulea <dtatulea@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/1762238915-1027590-3-git-send-email-tariqt@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
index 2768eab89eada..75934d0f144cc 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
@@ -2056,7 +2056,10 @@ mlx5e_hw_gro_skb_has_enough_space(struct sk_buff *skb, u16 data_bcnt)
 {
 	int nr_frags = skb_shinfo(skb)->nr_frags;
 
-	return PAGE_SIZE * nr_frags + data_bcnt <= GRO_LEGACY_MAX_SIZE;
+	if (PAGE_SIZE >= GRO_LEGACY_MAX_SIZE)
+		return skb->len + data_bcnt <= GRO_LEGACY_MAX_SIZE;
+	else
+		return PAGE_SIZE * nr_frags + data_bcnt <= GRO_LEGACY_MAX_SIZE;
 }
 
 static void
-- 
2.51.0



