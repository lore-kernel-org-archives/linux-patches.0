Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E95CC22A4E6;
	Mon,  2 Jun 2025 14:33:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748874828; cv=none; b=VK76FEHVaXnuSuH23FSBPZw3vaBni/qnfZN7iHv6+deIUNnJ9YgNzDl4aTvqQr9FZ3LN9ZZWsZEszSnRYjWqTrulta/vJSgMOIsktk37pv9tqpePO9UFZEr6uXrT3N3ueO5wVpZBijeWRAKvJTSJt/RJzKZvt0gZ9wmw0wR+dz4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748874828; c=relaxed/simple;
	bh=sFlzN8Cvgg0ebF3qIdMmHaOCnD8AsoJsGUhHig4kWeo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b3cTYF8nIiE02zciwSx43d59dsYbiZHBQ214bnFBQdOzyhINCiGG1lmcBpMpsp88X6XBYrlEtuYagKNwOm4Jtb38EmydN9+q7IeEC6PUvreeak6PLAvkDOv52U7bK/i7Hdobr0NtgrgbySGKLDuPIasbcnE16U0rGpfUexCG2bA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pwcHMjOq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pwcHMjOq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51911C4CEEB;
	Mon,  2 Jun 2025 14:33:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748874827;
	bh=sFlzN8Cvgg0ebF3qIdMmHaOCnD8AsoJsGUhHig4kWeo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pwcHMjOqyzCK4LwWcSQRpcyPa8ekQyHpHZdnd1LbGNxJd8FDPiTTnKJ8iE/eW9Ugb
	 y1UGWAOV0kY2XhWxRYvhXwQYk8JU+7tQEUpArRN5YmOKiiLlFs4FzppVHO9j8WunkF
	 AvOb0x2z0dca5pZ0s44KQeveTE8rpNFq7AN32kOM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexei Lazar <alazar@nvidia.com>,
	Dragos Tatulea <dtatulea@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 149/204] net/mlx5: Extend Ethtool loopback selftest to support non-linear SKB
Date: Mon,  2 Jun 2025 15:48:02 +0200
Message-ID: <20250602134301.504625974@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134255.449974357@linuxfoundation.org>
References: <20250602134255.449974357@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index bbff8d8ded767..abb88a61e4d98 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_selftest.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_selftest.c
@@ -189,6 +189,9 @@ mlx5e_test_loopback_validate(struct sk_buff *skb,
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



