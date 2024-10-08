Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3217165F08;
	Tue,  8 Oct 2024 12:15:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728389745; cv=none; b=ZjIHM/ulCLg6ckHfQUpIQheJ2rwLbSDD58JHse1tH9GVwH/tZvqEZfD0eRXHeP3jMqo0GnMe7SKiMsy2xEjZIi2+WjG1qPZecxU2ONuBWsfIhKoz/l8+sIy7QmSjxNk6VEZCknXUMgCv6EfhCI8RtoeT5+yEyAyCP3AZ5WYYhik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728389745; c=relaxed/simple;
	bh=M8NlstOVvPswHaLO8MH38EsIo3jk84IaZHvgeR2za20=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iJOIcF04A4nY5lo1pnnAENN9b6D+AK7iqJbuEWmtV6CScJWrcqrdYMu1zNAB8e5ktKDVhvys7okJ1E4W+5OsuJvNoPN34tibkQVKsvmEHtbUtpfkWOM3WUjcNPMQ6xwxAbuPpywMQoED+QLTOsc1aicHPk861df8JKj4mksagI4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VzljyzM4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VzljyzM4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2217FC4CEC7;
	Tue,  8 Oct 2024 12:15:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728389744;
	bh=M8NlstOVvPswHaLO8MH38EsIo3jk84IaZHvgeR2za20=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VzljyzM4GqXQIarjd4Ag0l9iPpKnH/sw7ktEMeVDTVZivR3i8Xqx36mwDBTJDHGGb
	 diIPMx10xw5n7QosrwhLPFEaoMm8cjHtwiSm9KjHzdiNzROzIutOCpq6I61gNoVMsx
	 OQXYgLhVZxpwVGPTrthu3giX926y0S7Q8jjI0L6E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 082/482] net: hisilicon: hip04: fix OF node leak in probe()
Date: Tue,  8 Oct 2024 14:02:25 +0200
Message-ID: <20241008115651.533528806@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115648.280954295@linuxfoundation.org>
References: <20241008115648.280954295@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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
index b91e7a06b97f7..beb815e5289b1 100644
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



