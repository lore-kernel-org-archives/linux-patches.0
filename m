Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EFCE1E0B74;
	Tue,  8 Oct 2024 13:25:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728393947; cv=none; b=c/sZfU1v+8F7qZbdG46H/etsrya/l5Jw7enb41DdtCOGypXk/GHGz8sGVuUUDUbndUikM+TTaxTroOsfKfb7qnMSo6uXVa+PKTqce6QJw+jVLR26ygV5RU2uWrH235MDOiJlsYTwbZ6jzQvQzfJlXbmn5gu9wpr3z85oylIpnGk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728393947; c=relaxed/simple;
	bh=S94sKypRdz79xvAq7P17loEMu/2HcPX+y8+a9x5kfG8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MIuHdrGeIrog4AeWw7RjhrSMxi9qbzDKlDp/hcVKRprBql/VRaPjqO6KkIOTMiQPcQbfJLJfA75nE+MoSn8Nx/gDEso6dfIiQv/2lTXijROqE7d5/i5e9++poGhRUephDkUdmlnUZwSyJb0H1aEyHOIdUiKGOlvIUlIkcvMDRh0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TX6O7XII; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TX6O7XII"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2C90C4CEC7;
	Tue,  8 Oct 2024 13:25:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728393947;
	bh=S94sKypRdz79xvAq7P17loEMu/2HcPX+y8+a9x5kfG8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TX6O7XIIkTeHRDYo8mERbUQY7LjcSS0NQqKCzo4MZSCvN7o/w69GHa6AcF6U9kb20
	 32nuRo/+uScUg2iNMNc/TbbjsBj4v+RgpPZJW+OgcLGyvYU3jN8t9oFDLZKtj4f/6z
	 NrSaInS1djt3ORO4rMQBiBelljqCMMHLFzPaMGYc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>
Subject: [PATCH 6.6 302/386] rtc: at91sam9: fix OF node leak in probe() error path
Date: Tue,  8 Oct 2024 14:09:07 +0200
Message-ID: <20241008115641.271353577@linuxfoundation.org>
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


