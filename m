Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11B7F2798E6;
	Tue, 27 May 2025 17:05:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748365535; cv=none; b=jjRwj0uhGp4tuAov9wvkNnTADZXQgIgiATGPxPYwmR4NwgbYh1LgEgLJFixUS+xsT47FR3swnW5Nwakp+00Hc4OiNZJAto5YiT71aUPGb0rAr90PqRYRjwC7EF/tte6K5ZJDVxxP0i5DXvLkCMThP/Cza1ZIjjzkWcG7/1OXk4I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748365535; c=relaxed/simple;
	bh=GbNWntq2Wta7G1Xak5rIz+HMP5a6QPb3V5SLz27t1GQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O3MO9ybvSK/OnPGEqqnV1+rkn9UwsEkVw1ainI5T/61br4vr1zvtgDG6dG6RIXNkuXy3eizg4QUaaTobel4eB69GcUvlKnNcihOc7Sew/yBER9qmqw72MMSywH9T9gl1dbclegwuYxLJdYJqtlFw3pJHkVax73pLD0K4PVXWXMU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=STbCo0dF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="STbCo0dF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95CB6C4CEE9;
	Tue, 27 May 2025 17:05:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748365534;
	bh=GbNWntq2Wta7G1Xak5rIz+HMP5a6QPb3V5SLz27t1GQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=STbCo0dFkFINsHTKiXfcbRJPdoqaPvpvx/WhsAiRxG0yhVYZQUPBkv94Du551ojCU
	 vG0+tPp2ApTqiU/B5u1hGigP4+BvzuLep0rHMcM+r2pOQHYY54KoZm4C/4K4B3H5Ov
	 mPbuckOLxPGkyfFdbxyuMovcG+4rYq+fVNk22y44=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexei Lazar <alazar@nvidia.com>,
	Dragos Tatulea <dtatulea@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 406/626] net/mlx5: Extend Ethtool loopback selftest to support non-linear SKB
Date: Tue, 27 May 2025 18:24:59 +0200
Message-ID: <20250527162501.511587915@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162445.028718347@linuxfoundation.org>
References: <20250527162445.028718347@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Alexei Lazar <alazar@nvidia.com>

[ Upstream commit 95b9606b15bb3ce1198d28d2393dd0e1f0a5f3e9 ]

Current loopback test validation ignores non-linear SKB case in
the SKB access, which can lead to failures in scenarios such as
when HW GRO is enabled.
Linearize the SKB so both cases will be handled.

Signed-off-by: Alexei Lazar <alazar@nvidia.com>
Reviewed-by: Dragos Tatulea <dtatulea@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Link: https://patch.msgid.link/20250209101716.112774-15-tariqt@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_selftest.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_selftest.c b/drivers/net/ethernet/mellanox/mlx5/core/en_selftest.c
index 1d60465cc2ca4..2f7a543feca62 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_selftest.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_selftest.c
@@ -166,6 +166,9 @@ mlx5e_test_loopback_validate(struct sk_buff *skb,
 	struct udphdr *udph;
 	struct iphdr *iph;
 
+	if (skb_linearize(skb))
+		goto out;
+
 	/* We are only going to peek, no need to clone the SKB */
 	if (MLX5E_TEST_PKT_SIZE - ETH_HLEN > skb_headlen(skb))
 		goto out;
-- 
2.39.5



