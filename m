Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1359225A47;
	Mon, 23 Jun 2025 22:05:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750716331; cv=none; b=dot91yF06erR9BlaiUU62/Su7yCgfOzp+hMIPYxnoLrCpkzAh5gyoRicAPuTScVuv2MZUoTQMunMfaFjHq+saU2qVg3QmUl+AC/eTO98UsUfFCGVb50ho/pJ0mX75SnO07rC53WHAlmy0Nk7+yaUghpnjFqoARua4n87CMypw7g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750716331; c=relaxed/simple;
	bh=XyHsGRMgJmJ2vZILpww6jTPodltodJVqnpDFZ94lipY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g2gKI1hQarGNMkd2S0o+p+Wvg86nEi1seiK6VSRrl0wjqSufbXl3qGINXNey7K4+T5riv8qvUs1QyiWbkWUyyHZKt5eOtmQKWWrQ8vb6THSoeD0nbsN3+h8l9P5Tstmj70Hbu2AwU37uG958gH9YLSdjvQb8xhA4u+OKuAw7wgU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rdkA1IU5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rdkA1IU5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AB14C4CEEA;
	Mon, 23 Jun 2025 22:05:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750716330;
	bh=XyHsGRMgJmJ2vZILpww6jTPodltodJVqnpDFZ94lipY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rdkA1IU5jMYmrwmUz85OwlEvm03mi4XwcQOx18HxgKwwGBjltpoa3lTEpyWLx7Q+q
	 h3L0gfLT6/naJSV+hbti6tTVSTPjJs/MIfujKvLMUtBk9Z0kQ7wOFsV7IGhh027h5T
	 3f/J07ndnSHwbMJK5QyMcYtgIW/Gloa3osHy3GC0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jason Xing <kernelxing@tencent.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 322/411] net: mlx4: add SOF_TIMESTAMPING_TX_SOFTWARE flag when getting ts info
Date: Mon, 23 Jun 2025 15:07:46 +0200
Message-ID: <20250623130641.742664285@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130632.993849527@linuxfoundation.org>
References: <20250623130632.993849527@linuxfoundation.org>
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
index c3cffb32fb067..d8c1a52d54c67 100644
--- a/drivers/net/ethernet/mellanox/mlx4/en_ethtool.c
+++ b/drivers/net/ethernet/mellanox/mlx4/en_ethtool.c
@@ -1909,6 +1909,7 @@ static int mlx4_en_get_ts_info(struct net_device *dev,
 	if (mdev->dev->caps.flags2 & MLX4_DEV_CAP_FLAG2_TS) {
 		info->so_timestamping |=
 			SOF_TIMESTAMPING_TX_HARDWARE |
+			SOF_TIMESTAMPING_TX_SOFTWARE |
 			SOF_TIMESTAMPING_RX_HARDWARE |
 			SOF_TIMESTAMPING_RAW_HARDWARE;
 
-- 
2.39.5



