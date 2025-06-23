Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 465CC3FB1B;
	Mon, 23 Jun 2025 21:57:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750715856; cv=none; b=V9eqPZtByeqiMnr7klER3NYsaEuZvLmdZDSeWvUbDpWsYbkWUTJH9A+lPYM7ma1qI/PCYjlbNT0biPQe8s2fCEyezeXei83iiU69diP8QkGSPDtVRdFNvvcuGySf6jXBEW/9IW8YAMeKf9gZzY73Qx6e8fIyFHBmPSLlUnOcprY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750715856; c=relaxed/simple;
	bh=s2bhXbp9T4zIubjWFg99eFT1+MGX4O8bEkoiLYXwqK0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IAoSUpadLXLQvOAlwCjrk3SxJJm+J5vW0Vt+DXagLetAHw9wAnOvPsUjFQYHgykLlmUUJBeZ5Ss0Z4fieYUXTvVBrb3c1vVqOfbZ/rPqrR50hnnKdnUvlN7IylNOZMTNFT7TcnxgrFMiKRXqKPQwRJy6CouFzyP0HE61ZcF2Ufw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZK8liZsD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZK8liZsD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF1AFC4CEEA;
	Mon, 23 Jun 2025 21:57:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750715856;
	bh=s2bhXbp9T4zIubjWFg99eFT1+MGX4O8bEkoiLYXwqK0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZK8liZsDdmbmq3d5h1I+lBHtDq3vWACMLaqxHwHzSD5axG5HskzJrBQvNi7JQD8wC
	 sPcg3SAGXLe72GMJgmN2aSpvFXjLHitEwUZOAl/V1c5vWu0h3iLnerkjk2UznGwPsT
	 BMDuqf6TIIlMZfKC80cUYAqaELnuDNmnReyJfmeQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jason Xing <kernelxing@tencent.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 233/414] net: mlx4: add SOF_TIMESTAMPING_TX_SOFTWARE flag when getting ts info
Date: Mon, 23 Jun 2025 15:06:10 +0200
Message-ID: <20250623130647.864332596@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130642.015559452@linuxfoundation.org>
References: <20250623130642.015559452@linuxfoundation.org>
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
index cd17a3f4faf83..a68cd3f0304c6 100644
--- a/drivers/net/ethernet/mellanox/mlx4/en_ethtool.c
+++ b/drivers/net/ethernet/mellanox/mlx4/en_ethtool.c
@@ -1897,6 +1897,7 @@ static int mlx4_en_get_ts_info(struct net_device *dev,
 	if (mdev->dev->caps.flags2 & MLX4_DEV_CAP_FLAG2_TS) {
 		info->so_timestamping |=
 			SOF_TIMESTAMPING_TX_HARDWARE |
+			SOF_TIMESTAMPING_TX_SOFTWARE |
 			SOF_TIMESTAMPING_RX_HARDWARE |
 			SOF_TIMESTAMPING_RAW_HARDWARE;
 
-- 
2.39.5



