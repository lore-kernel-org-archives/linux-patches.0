Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F2E61C4A16;
	Tue, 15 Oct 2024 13:18:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728998304; cv=none; b=IiseH+AnWakk4LR9Q+r7V5soCvdCikJBr0Oe1n7bn36o7nz6Qhnm+wmJqA8TmcEB6uClr9ZTr5sSgB5ctV3UGkzIf7u1gEn8OUrHNOpCnaQ3J2IfCz/vD3SxEKL96T4YP0DYFCu6kDZJVGuobBu0rZtBMYpVY/4L5Jn09Cck9ug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728998304; c=relaxed/simple;
	bh=/aN8q6+DAU5w87ONDVo4ZshJKLTnLdEKXIO746p8i1Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=obXTiFZ849cDlTi5DZ7hEZl2aeBJILzxjl+L51sqAC3kt8DaFrp06jsLwJXifSSJ1aafWgf4xUhfsxzVKg6cQ0gbJHuQ1JO811H5ywppsrlfJtMGf3ujMfWz/cLK0uAOgD/IaWYEXD1AHNtS0cQ3LXU6V6UZy8GQw6G/g1oa7W0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Igq/lJ4U; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Igq/lJ4U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A4DDC4CEC6;
	Tue, 15 Oct 2024 13:18:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728998304;
	bh=/aN8q6+DAU5w87ONDVo4ZshJKLTnLdEKXIO746p8i1Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Igq/lJ4UpUQYbwaE8P5rvRM9onUczWKWNo2+mtz12Zs73KzAl2E73YJSWw1VVO+FD
	 Q1FJjBp2wclYLd/ylFokzqiVLKfukWNjfSFfEVgul/RXoNIN9URp4e1eujKY7UEuKw
	 JSpEldAMdM+QLBETE7sXi2ctiDXZSfYkY6qsCVPo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>
Subject: [PATCH 5.10 408/518] rtc: at91sam9: fix OF node leak in probe() error path
Date: Tue, 15 Oct 2024 14:45:12 +0200
Message-ID: <20241015123932.730742630@linuxfoundation.org>
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

commit 73580e2ee6adfb40276bd420da3bb1abae204e10 upstream.

Driver is leaking an OF node reference obtained from
of_parse_phandle_with_fixed_args().

Fixes: 43e112bb3dea ("rtc: at91sam9: make use of syscon/regmap to access GPBR registers")
Cc: stable@vger.kernel.org
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Link: https://lore.kernel.org/r/20240825183103.102904-1-krzysztof.kozlowski@linaro.org
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/rtc/rtc-at91sam9.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/rtc/rtc-at91sam9.c
+++ b/drivers/rtc/rtc-at91sam9.c
@@ -368,6 +368,7 @@ static int at91_rtc_probe(struct platfor
 		return ret;
 
 	rtc->gpbr = syscon_node_to_regmap(args.np);
+	of_node_put(args.np);
 	rtc->gpbr_offset = args.args[0];
 	if (IS_ERR(rtc->gpbr)) {
 		dev_err(&pdev->dev, "failed to retrieve gpbr regmap, aborting.\n");


