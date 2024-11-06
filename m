Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2004D1D416E;
	Wed,  6 Nov 2024 12:13:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730895232; cv=none; b=SX7t/EG0bTgmqM3QmhJ0DvrQ/pX+DWh59/fLGMmanMjW/kS1NM+Axu2zDdPEDrfjOblP2BmmC/MaBPxc7N60o7k/KmGcpMDC93uH23+PmUY7U+OXCCkiTSi5IZrW2J4ZoFHJQ8DQe5+6TUbdSmGIwTTaqKyWY54m/zQtcDPAg4g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730895232; c=relaxed/simple;
	bh=8ttL/0hMF7frzRob5yQp5co49YR5eIOUXgxgh/WAajI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uC3woghAMtQWHcgcE6s7sZZbVIY1VQL51FWDd51sYJ0r/g/jKvaMC0CZbsZOQT+Nxw+5nt6uHMJsvzZNscKPcO52gGlC1PibLpn1Rax5it8cPDSv9IlcUdlXDy/nNLAqI0ucRVWSKlaRH8Ogzoz2qBRZ7aTNpfSzTNxtM2bUuMI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MIyRP8io; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MIyRP8io"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99704C4CECD;
	Wed,  6 Nov 2024 12:13:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730895232;
	bh=8ttL/0hMF7frzRob5yQp5co49YR5eIOUXgxgh/WAajI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MIyRP8ioDe8EUz3US5wCvCxikk+FQf30iBfgGFHHlD9WLmYRryfX0ibGxNmjbCZ5L
	 MNT+Lls3kHFwhK2ulWJo5ayQ+ci7tWARUT76hBG6+HRjHy2m+6ltnM7q8igcFBrRiW
	 BkO8dtMtmjxYuNeRcOyJUdNd4T25cHJOxFrSlHPs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 148/350] net: hisilicon: hip04: fix OF node leak in probe()
Date: Wed,  6 Nov 2024 13:01:16 +0100
Message-ID: <20241106120324.570418281@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120320.865793091@linuxfoundation.org>
References: <20241106120320.865793091@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
index 718afa4be2a06..c0ca12dd5f153 100644
--- a/drivers/net/ethernet/hisilicon/hip04_eth.c
+++ b/drivers/net/ethernet/hisilicon/hip04_eth.c
@@ -861,6 +861,7 @@ static int hip04_mac_probe(struct platform_device *pdev)
 	priv->tx_coalesce_timer.function = tx_done;
 
 	priv->map = syscon_node_to_regmap(arg.np);
+	of_node_put(arg.np);
 	if (IS_ERR(priv->map)) {
 		dev_warn(d, "no syscon hisilicon,hip04-ppe\n");
 		ret = PTR_ERR(priv->map);
-- 
2.43.0



