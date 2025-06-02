Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97D16221727;
	Mon,  2 Jun 2025 14:16:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748873785; cv=none; b=FH8pNLTxtU6LInJFPLeWggFa40zl9Z3r/oUSIZzhsDD4mD9n3rP87NOK94mprzy1l1TavwRYzApZb3wmyv8VUEyRcHvxKMdq4gWIF7ZP1jnoRw/kE1lDHWjCgUrUFT5pmtM3zsYGLgbAi9uXHnQKnYkVedFtgyOfUXoNYfQyF30=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748873785; c=relaxed/simple;
	bh=PsdTrBpEC02SySoWH85+WyuXa3wz0lsuvn4mPPnDGWU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FBToywxEP7WJKBtn0opAQDZ4ZcY1PsxRHxw2aLx91FwvrBO+uq3h5DQKZ9MfgiNHdh37K0G3oWInoN6TLOSY/Jjz1C3QNXhw7aCoIizyVDPZ9O7+4SkFpybZyAIEBRacQzHSmpkLY0kRNjTZ+0eEf84tlUY/vDa1hQ7F0ChBGZA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SbfQbcWy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SbfQbcWy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07AADC4CEEB;
	Mon,  2 Jun 2025 14:16:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748873785;
	bh=PsdTrBpEC02SySoWH85+WyuXa3wz0lsuvn4mPPnDGWU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SbfQbcWyqaj1kRT61JeIU25qoXo8xArZk/zQ/+AsyG4732PbwDhfxP3hoG182dX1b
	 MLFH3v5RGlEnHHu8TfBNlAKiAbPDaPZyUROv6S5nscgw1+ErM5r5hQ0VsGOzYHf41m
	 sfaJsPWuGzRgMWFCW1lUgiCGfzYiUGy/dxZVKjtw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexei Lazar <alazar@nvidia.com>,
	Dragos Tatulea <dtatulea@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 252/444] net/mlx5: Extend Ethtool loopback selftest to support non-linear SKB
Date: Mon,  2 Jun 2025 15:45:16 +0200
Message-ID: <20250602134351.151201945@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134340.906731340@linuxfoundation.org>
References: <20250602134340.906731340@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 08a75654f5f18..c170503b3aace 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_selftest.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_selftest.c
@@ -165,6 +165,9 @@ mlx5e_test_loopback_validate(struct sk_buff *skb,
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



