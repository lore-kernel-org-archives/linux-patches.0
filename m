Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D390239E85;
	Mon,  2 Jun 2025 14:59:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748876370; cv=none; b=iLjpyuqnOHojReYi3lDrzkSS1NGvyWTB/eYRhdPej7sYC9RMJfjuDd/aIw0SdlDfhIZpJ3BZ8/HyyIegB/xfoVCE7/rHQ9YdtLFByXxXMOrAX8ny/UxfbeQldC7tsvVuihaGirJfEz2bF5s8eLc671mrg4P3R3wDMxrXXeKCF9o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748876370; c=relaxed/simple;
	bh=iQ/o4sikI4r4jtHMNazdOvDzl0UqS4Cer56bLZM47Ns=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fVu9d3WgXy7EZylvQrk4P0ZBL1Z8Dovxm7mL5itnqN9a3SHl9m7uZ2WTeZv+nqXGx8cqtLFjcbTN2SIm3nYJlaDh37VhYHOBvOC56dUTF8/iK18t88f+0DhBnzio+La/am/FCx+OqzQPOmo2wnHxFcy1dTb3zN+LFwrkc/axUxA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kewzYiZb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kewzYiZb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E82B1C4CEEB;
	Mon,  2 Jun 2025 14:59:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748876370;
	bh=iQ/o4sikI4r4jtHMNazdOvDzl0UqS4Cer56bLZM47Ns=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kewzYiZbLU3ncQ5QVvRp1ExbkByiyUib1Nukd/tUEwBax34b8SUhPOPsNs28dqtW5
	 IK1/EO1fp/y+hc2vCOj88pcMnVKqT2XW/Y7ziHIvWdZXqfd5qDYlURI5XvKrWBiU4O
	 cdLiht16E2lqrBBGtyqlHQcpsd2l3Gn3xYjbD5Lw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexei Lazar <alazar@nvidia.com>,
	Dragos Tatulea <dtatulea@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 125/207] net/mlx5: Extend Ethtool loopback selftest to support non-linear SKB
Date: Mon,  2 Jun 2025 15:48:17 +0200
Message-ID: <20250602134303.609481339@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134258.769974467@linuxfoundation.org>
References: <20250602134258.769974467@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index ce8ab1f018769..c380340b81665 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_selftest.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_selftest.c
@@ -188,6 +188,9 @@ mlx5e_test_loopback_validate(struct sk_buff *skb,
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



