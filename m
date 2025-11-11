Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D155DDAB;
	Tue, 11 Nov 2025 01:34:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762824846; cv=none; b=s/WbvW5dPs3t+t/8Zeox20xyedPKBba3pOwtvRWS6zmuxjy/O1Ul5m5hEnQbwGfUcDYAKa8jJTjV4P9rX2YrJ/wHuUylmISUJp5nBwITzvsLkOxwmBOkPcHFrI2R/VKD8TP9wmqUYOy9/AoFnFu/PA5iIU3NBmRuDKzSWzjRD4E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762824846; c=relaxed/simple;
	bh=MDbvjf1s2NlpDgCeseuCjN8PwdPrQICdl6KqJJCGR4k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XnE89CpbbIYv+FiD74Shoku+NgkwhuGfHZsTqeR6+KdNfA5PTfQoJMKx2B1RQC1jQR64j5CjzESv8RnQ5jbbO/U3Y3Jiw+iGlTHglW0sl6uC5VrqRcxR1N2cdtQ9y8fi9yTtmz7bbtd1xBG7rv7emQhh2h61AwipOa81Pj5YBZo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jklicebB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jklicebB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E3C7C116D0;
	Tue, 11 Nov 2025 01:34:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762824846;
	bh=MDbvjf1s2NlpDgCeseuCjN8PwdPrQICdl6KqJJCGR4k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jklicebBcMbwL7UwDzw6fPo+WtSfjjDVfkHQQaHxe2WodqyqcCnk5hiHFCxFiot/P
	 Hxtl8YzxCgPHE9BYU/COZ5pg+T/eYcoyqb0bvg8pXNx7zSCtroLxyR928JpRptbKy5
	 7ITXA01lAnFIPEndF0rwrs4ydzZU8+FyKRzlAWig=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dragos Tatulea <dtatulea@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 536/565] net/mlx5e: SHAMPO, Fix skb size check for 64K pages
Date: Tue, 11 Nov 2025 09:46:32 +0900
Message-ID: <20251111004539.031314269@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 59aa10f1a9d95..4eb1150e71547 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
@@ -2316,7 +2316,10 @@ mlx5e_hw_gro_skb_has_enough_space(struct sk_buff *skb, u16 data_bcnt)
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



