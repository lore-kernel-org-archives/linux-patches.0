Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD79C1C07FF;
	Tue, 15 Oct 2024 13:10:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728997829; cv=none; b=vEKQDx0TDgoHxFPbb8ng2FuGggRVjSOAluc8A2rTUt3aCgdbPYYIeClYIsB4Nn8y1IG+78zlh2XXjxeV4l3PNwpmvDYVamfUWwyhdVH1KdlGAUjzQB+IBbfzwrDDROmYB/Xqj7xOOhRBlxgpuJzTzCmXdpXPRMfQax9XzDeS0Hc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728997829; c=relaxed/simple;
	bh=At86qnb16MfR2m1FRHmu44WlZ4QPLl6GukOjNQRFqvk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Hj+EeUxm1YqPBlOHc6tG/huweyAOtnsjJYCO1aGYOndOBfop7GvwGsBUjngFm1q559N1DZwbgo8Z7j0DopZxJVWOz65+venZPe4TM8wjl/BGnk+qLZhqV7n1AnKc3Uc+6bJGPtadGXxl2Nf1ylRWDsoYyvc9Mb2KHqIjvP/yVZ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=R8Xd2lPu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R8Xd2lPu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23FF9C4CEC6;
	Tue, 15 Oct 2024 13:10:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728997829;
	bh=At86qnb16MfR2m1FRHmu44WlZ4QPLl6GukOjNQRFqvk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=R8Xd2lPu3NWtwEoLGEKxDqS1An1DJm6uKb1Tg6A8fr+Vx3wKsEmdPvgwtZtoEQEql
	 IkE0kU+UUG9IY3inBKJ+mschh4RJM4OM6hnZgBD25iVYjh1aFjx54nQn9iVYywjTCU
	 hcZDOoYGRRC5Eu/4bOdRgkJfSHrkoK49jm2MsEFw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 298/518] net: hisilicon: hip04: fix OF node leak in probe()
Date: Tue, 15 Oct 2024 14:43:22 +0200
Message-ID: <20241015123928.491040724@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015123916.821186887@linuxfoundation.org>
References: <20241015123916.821186887@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index e53512f6878af..09acd839a72c1 100644
--- a/drivers/net/ethernet/hisilicon/hip04_eth.c
+++ b/drivers/net/ethernet/hisilicon/hip04_eth.c
@@ -943,6 +943,7 @@ static int hip04_mac_probe(struct platform_device *pdev)
 	priv->tx_coalesce_timer.function = tx_done;
 
 	priv->map = syscon_node_to_regmap(arg.np);
+	of_node_put(arg.np);
 	if (IS_ERR(priv->map)) {
 		dev_warn(d, "no syscon hisilicon,hip04-ppe\n");
 		ret = PTR_ERR(priv->map);
-- 
2.43.0



