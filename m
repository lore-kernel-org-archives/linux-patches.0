Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78A621DE4CD;
	Tue,  8 Oct 2024 13:12:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728393146; cv=none; b=opc8auxIJR+JpENxLbs+yKpJ94gUu7JKFWZIFqVcZ6dne0W/ifWhgMCq9mbkpmlR7A2JjltLYEE/DUn42oSbrKwPhiGyNn/MRlXojgjdb4h9ZrZqXObpdgr3hH4/XHaCu8c2HWssoacDYcdXSgb2+jH/Yq/un0qdzk5+4VG+9MY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728393146; c=relaxed/simple;
	bh=7E+fN1vL+Q6xiIadVaw8MgTaMPwUL7MtUCzeNBC+ycs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uiSN/BcLWYG5jcg+v5w+SJVktbsJ9DjKJk7/l47fTvdajYDXQJVjqWMpBBolqzzgYtdYNJ6pMdjU58g5cLpqXwC855tH4d+sGRcDGSkmceNMeBEsJPxRwOsF0h595XEGAusiwxLWFOaee6wrsXkSsH3rzVbhmkWjqdTNK7mNIz8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vW6y9g9k; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vW6y9g9k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9075C4CECC;
	Tue,  8 Oct 2024 13:12:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728393146;
	bh=7E+fN1vL+Q6xiIadVaw8MgTaMPwUL7MtUCzeNBC+ycs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vW6y9g9kcc/7fcER4L11ak65QKZkmnfjKB+1sUQkiqUTzDkZgTtpMoIdhwD6+Q75u
	 FQn4ioED8Qh9v+f+flAY0+erB+PgQY/SyXif+HPd7D9ex9q+iFL2I+hsuiwll6sUEQ
	 YnpQe6TbaOSdHv/aPtXCyG7t7B9DvMmf+lbyeurE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 067/386] net: hisilicon: hip04: fix OF node leak in probe()
Date: Tue,  8 Oct 2024 14:05:12 +0200
Message-ID: <20241008115632.102975231@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115629.309157387@linuxfoundation.org>
References: <20241008115629.309157387@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index ecf92a5d56bbf..4b893d162e85d 100644
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



