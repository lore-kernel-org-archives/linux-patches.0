Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6E9E221DA8;
	Mon, 23 Jun 2025 21:34:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750714494; cv=none; b=utSgoKYAw1OdKcbCun1SVDehrEQ3O4CO73Tc273EbYpAL7uLuCZ9QyQoXf5E5Nd4Tsg58ZeUuzDMDV4+tLnLWnLG2zQ0pC6v8NNTpwVecga2/7MFEvpUVbv6rycMuz+zeHtqFl9Ht/MLVnqgAi7QZQhgLb/n2R2/F3vB6DrGMow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750714494; c=relaxed/simple;
	bh=R5vgOLPJJramIBCWOrkSVb6bFOztdwoyv1rp1/jDh3g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mnAEAcXbwNblxZcoGPYAv/4u7s4ArYB+GsPpCeUVOLWBjbs2qsBqQgkhExz29eMA+7LDeZDYPvYjjoiMd0TjjOR35ICvfuCvzA7M6RZL25pdBWqSUnHZR7MLTk3BP1ISuFvNBMPbR1Z/CsigpVKOurGGEtRJIJDorVlawRLMrvI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AvKCakzK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AvKCakzK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11870C4CEEA;
	Mon, 23 Jun 2025 21:34:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750714492;
	bh=R5vgOLPJJramIBCWOrkSVb6bFOztdwoyv1rp1/jDh3g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AvKCakzKq3FifFQWd9/JSuu/n8uYT5UkE8Z/168MX36RcRLo8FopahfgKr2VX/gdF
	 5vFhmKYJN5Ezd4IgaXRE8V1CW81SnvQ7W56uFLd4+y9GL3QBaJRN9rnzgmA3V1ED26
	 jzgN/tnXN920WsSiKrzK8oD+3mK/PBRqOdQ0IX30=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jason Xing <kernelxing@tencent.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 161/290] net: mlx4: add SOF_TIMESTAMPING_TX_SOFTWARE flag when getting ts info
Date: Mon, 23 Jun 2025 15:07:02 +0200
Message-ID: <20250623130631.740360382@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130626.910356556@linuxfoundation.org>
References: <20250623130626.910356556@linuxfoundation.org>
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

From: Jason Xing <kernelxing@tencent.com>

[ Upstream commit b86bcfee30576b752302c55693fff97242b35dfd ]

As mlx4 has implemented skb_tx_timestamp() in mlx4_en_xmit(), the
SOFTWARE flag is surely needed when users are trying to get timestamp
information.

Signed-off-by: Jason Xing <kernelxing@tencent.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Link: https://patch.msgid.link/20250510093442.79711-1-kerneljasonxing@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx4/en_ethtool.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/mellanox/mlx4/en_ethtool.c b/drivers/net/ethernet/mellanox/mlx4/en_ethtool.c
index 164a13272faa2..07dced3c2b1c0 100644
--- a/drivers/net/ethernet/mellanox/mlx4/en_ethtool.c
+++ b/drivers/net/ethernet/mellanox/mlx4/en_ethtool.c
@@ -1916,6 +1916,7 @@ static int mlx4_en_get_ts_info(struct net_device *dev,
 	if (mdev->dev->caps.flags2 & MLX4_DEV_CAP_FLAG2_TS) {
 		info->so_timestamping |=
 			SOF_TIMESTAMPING_TX_HARDWARE |
+			SOF_TIMESTAMPING_TX_SOFTWARE |
 			SOF_TIMESTAMPING_RX_HARDWARE |
 			SOF_TIMESTAMPING_RAW_HARDWARE;
 
-- 
2.39.5



