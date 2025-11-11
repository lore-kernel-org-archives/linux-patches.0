Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50FA62F6186;
	Tue, 11 Nov 2025 01:43:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762825417; cv=none; b=UTYigU1clp18UE1HyUfeDMiL/dc8jot7QSpsBOPNYg8YaG0q+UAfrC68PpTh3S8pA3o9sq8ptrb73DRaRKboMoB3QpLJuZkYQ/BuldDSpovzR6jACkOHTLzkReWxLyvob0edvM6awZ9pnzJOySEfeuYewgfXwDr7h3ansqgvu9M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762825417; c=relaxed/simple;
	bh=C1+fA3px3XTcqz9NOOTCyLVnRwtXVqo5R1QUYpDDyus=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Yu7fzzpB9Jw/ct1T22S1dKw/mMXHx7lCF7N5y6+yGc+cIXmT1sP2vMBo48xkDr6inC6fIahXkYbng0thmuOsHIA9QGITIS51WuF0awNfLPdYcHhHb/bpoqqp9DqSfIkwiQd3nFrOduSKkTgvM1gRO/nbbU1u3UxZLLD8m+l6Q74=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=i2ziZYFz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i2ziZYFz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1883C16AAE;
	Tue, 11 Nov 2025 01:43:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762825417;
	bh=C1+fA3px3XTcqz9NOOTCyLVnRwtXVqo5R1QUYpDDyus=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=i2ziZYFz0y2uFzuwp/C2G1y7uUf1fNR6+plQj8Ph5ZvMl+WA4xHvf3s64dRWcac6s
	 cn5cfKx+MGsvdkeXpA6gAJ+NufdvLG0F8LgneABBYlT2NDHPpoYZpfj575o0GBWe+x
	 dl5DdlSB+EE+sq7au54gkQ5Wse65vadFe45Gl0C4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dragos Tatulea <dtatulea@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 792/849] net/mlx5e: SHAMPO, Fix skb size check for 64K pages
Date: Tue, 11 Nov 2025 09:46:02 +0900
Message-ID: <20251111004555.577585127@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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
index f19e94884a52e..0dcb4d5b06c8e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
@@ -2327,7 +2327,10 @@ mlx5e_hw_gro_skb_has_enough_space(struct sk_buff *skb, u16 data_bcnt)
 {
 	int nr_frags = skb_shinfo(skb)->nr_frags;
 
-	return PAGE_SIZE * nr_frags + data_bcnt <= GRO_LEGACY_MAX_SIZE;
+	if (PAGE_SIZE >= GRO_LEGACY_MAX_SIZE)
+		return skb->len + data_bcnt <= GRO_LEGACY_MAX_SIZE;
+	else
+		return PAGE_SIZE * nr_frags + data_bcnt <= GRO_LEGACY_MAX_SIZE;
 }
 
 static void mlx5e_handle_rx_cqe_mpwrq_shampo(struct mlx5e_rq *rq, struct mlx5_cqe64 *cqe)
-- 
2.51.0



