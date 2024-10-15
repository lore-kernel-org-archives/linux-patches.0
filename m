Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F4B31D4154;
	Tue, 15 Oct 2024 11:57:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728993441; cv=none; b=B9o4+JnYImSEAOShlWPoTtOJ6AHxvDjWJsHqezV88+jnFupafaNQ/57kdZm9LF3efJ7zy6I5jCmyrNUVLDiQZfhPWgNWA5/wx+MC41mBXvHcMys21J22jQCCZaZ9ZD45uzM5rloGwvKVi3EyOyl931+iP8U7nrDZ06RDUGCVrOM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728993441; c=relaxed/simple;
	bh=yT02X16XopagKaoJgiYt1vFUAThQF/4SU0KKGDC58xo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IoNOaEu66K6JrjST9KgmsYlDVtU7eEZAVtakD36UG+09ZpLgCmidyRBEtvFq3o1AwMmwDO74LReKtJWc9pHuHv4afxunYv0L1qclWnru+IxtCJcKTHyv4gU1gpfrgWPDlpSmmFskgEsuBucVTUzMBdBfXHRniDCAd5Gr2C/6YCM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ORlq3Q15; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ORlq3Q15"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 830EDC4CEC6;
	Tue, 15 Oct 2024 11:57:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728993441;
	bh=yT02X16XopagKaoJgiYt1vFUAThQF/4SU0KKGDC58xo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ORlq3Q15ZT+Sd8ADGJ2rcDDgv430i4QIgaQMNhSC/Cn9tKzBh/d+UWvLFdmeYKdRl
	 mnCNAXNK/G6yNcL/cFpG7OjcyGqRbq5ECa55B6PYXdnaVIEVrdrHPyedb89NRv0tOg
	 fJ9pdZhGIip0CV7crMj+9m9G8089Mq4fUCWzy3z4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 411/691] net: hisilicon: hip04: fix OF node leak in probe()
Date: Tue, 15 Oct 2024 13:25:59 +0200
Message-ID: <20241015112456.657003027@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 37b605fed32c3..2bda229651954 100644
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



