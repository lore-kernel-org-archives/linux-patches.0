Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BF021F9A83;
	Wed,  6 Nov 2024 13:05:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730898313; cv=none; b=AwkI6RlhI9n5b9ODP2i+D6yZ1NxyNgHyfSl62367BKFrZl67T6ENcQfE2RGi3SI9lvcgTz0p41eTptBpjwwPKkH+B+NB/msj0ziioZ9+yODAOVvhuD4Dst+1W+y1O1FVmGy4qHpwN7Ai2p1trgD+D+JSpkqHB9bp/uLXdMaa8sY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730898313; c=relaxed/simple;
	bh=YdekU1DT7K6X3MBZo5Cs9znTFVkqt1U3gOrxBq1CwwI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gDEBL3xCSuMX4dJB5e8lmYkIYgg5AZZgEW37+FcBzDMlhD2NDHnyIZzImASjinQs3+jmEOjJ3aYv/pAeo9BYxq5qcTuk7yX6IBMYuMjt/kjubESiTC3Y2orVY0ErObuZgKpgVrI4TPOoismA2tUX36VkovK75s9QL6kDNOtv/o8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ttqWT5c+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ttqWT5c+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E28F7C4CECD;
	Wed,  6 Nov 2024 13:05:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730898313;
	bh=YdekU1DT7K6X3MBZo5Cs9znTFVkqt1U3gOrxBq1CwwI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ttqWT5c+EHa+4nJo7VgUWEw+t/h62BvEudgPgpQ0WPI5io+yi0OS69MaRs9sqNPjv
	 C9fFBy7BbPwS221Asaz/XQfGgrziZhknZqLVUjXHTJoIyWv7u3TQlI3g7owwBPKQcg
	 5g0llTHXOHW1tdhxzZZ1O8niiD2YMz5YJRE20Aos=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 197/462] net: hisilicon: hip04: fix OF node leak in probe()
Date: Wed,  6 Nov 2024 13:01:30 +0100
Message-ID: <20241106120336.382439215@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120331.497003148@linuxfoundation.org>
References: <20241106120331.497003148@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index b5eae06dd8705..00ca5183f9c3e 100644
--- a/drivers/net/ethernet/hisilicon/hip04_eth.c
+++ b/drivers/net/ethernet/hisilicon/hip04_eth.c
@@ -955,6 +955,7 @@ static int hip04_mac_probe(struct platform_device *pdev)
 	priv->tx_coalesce_timer.function = tx_done;
 
 	priv->map = syscon_node_to_regmap(arg.np);
+	of_node_put(arg.np);
 	if (IS_ERR(priv->map)) {
 		dev_warn(d, "no syscon hisilicon,hip04-ppe\n");
 		ret = PTR_ERR(priv->map);
-- 
2.43.0



