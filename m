Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60DAE43AA9;
	Mon, 14 Oct 2024 15:13:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728918789; cv=none; b=eNuQDvLY3kDKyu2QoSITikm/zN3Q18bzYpAep5zVX4L6eGSGSQ/MskPJFhfVVHB5tzS5owyDA/Y/JpL6FoPTwkE5B1PAndHBsKCM5p9b3lBZ7QNhu4d3wqaeeEGY4jZnkI4GM7xNRVolTdzE2/F35TDygClEjx5MVKlBhxgUQFE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728918789; c=relaxed/simple;
	bh=1mI1/63XVpXx4d5l3P0R12l/wRpIik8gYYWxfNdE+TY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hlQjOrgRFuMyTZ3/tMq4JK1GBV2VnrCQt6Yq8mOeflHHlg/s9PwEoUdy/Ubh/bFtkQuykPg0Z+hh8i5n0TeJLfaZr53RvyqwSG+8e8SIbMmZBHJoQinN3i6F1Rvmkf2OrNtnw+85BWZjSN6erf9Kvi7VBC2BYjfA/0JwrMmSSaE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l/DUvu6H; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l/DUvu6H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50309C4CEC3;
	Mon, 14 Oct 2024 15:13:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728918789;
	bh=1mI1/63XVpXx4d5l3P0R12l/wRpIik8gYYWxfNdE+TY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=l/DUvu6HPnmJ2wwpjEqIG69Pkc/GZCAwJ++n5BHMb9azWVoOK4SrSTl5f4gJjt/hH
	 aPUCHG0lODMmG09oUSDEKHJUg2lt1UXdLZlMMp2alPcI4Repqb8G/NqSSzPXvNkhkE
	 /pV5X4cc8O9T6NUkY11J18LAy+IeLVe3gKKvkL/I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 423/798] net: hisilicon: hip04: fix OF node leak in probe()
Date: Mon, 14 Oct 2024 16:16:17 +0200
Message-ID: <20241014141234.566848034@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

[ Upstream commit 17555297dbd5bccc93a01516117547e26a61caf1 ]

Driver is leaking OF node reference from
of_parse_phandle_with_fixed_args() in probe().

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20240827144421.52852-2-krzysztof.kozlowski@linaro.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/hisilicon/hip04_eth.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/hisilicon/hip04_eth.c b/drivers/net/ethernet/hisilicon/hip04_eth.c
index 50c3f5d6611f0..2abdb5d986914 100644
--- a/drivers/net/ethernet/hisilicon/hip04_eth.c
+++ b/drivers/net/ethernet/hisilicon/hip04_eth.c
@@ -947,6 +947,7 @@ static int hip04_mac_probe(struct platform_device *pdev)
 	priv->tx_coalesce_timer.function = tx_done;
 
 	priv->map = syscon_node_to_regmap(arg.np);
+	of_node_put(arg.np);
 	if (IS_ERR(priv->map)) {
 		dev_warn(d, "no syscon hisilicon,hip04-ppe\n");
 		ret = PTR_ERR(priv->map);
-- 
2.43.0



