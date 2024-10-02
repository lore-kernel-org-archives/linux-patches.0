Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 471301CFEB3;
	Wed,  2 Oct 2024 13:46:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727876797; cv=none; b=NW1cSlWKbWXhMXVnR/dAM+moY3b0RfIfv1/IbPNke2YpvIJFAqw9L+SQi6bT26Z9u4Ki4RGvmzayL4NOa63/LoAI3seiVZmkZUVVYqM18AWj3S2qPRH1qrutfM8+jzHcaU4NUlPEou7v149/koAgERUKWhOQLp1vl8dlu8AoINo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727876797; c=relaxed/simple;
	bh=hmLgh7O2zyf2Cnyg14k+LmkDuBs8oOj1ook2TFc9RuQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P+mw+xZpxuzx+uJZluP6LRjSr2wIsthBR/Ri2J6IsGvYNoRMoXQbvs1KZb/Uw+wCKwd6intIOfaINFAkfnM3+CSl33Co9jGqg5OEiuPH5G4XfEJpEtLkKUin7utWQM6BpY1iCW1ebp1TkZ4fI5jOUrKGTjA707FW1FyuQlaa4Vs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=s626GSzD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="s626GSzD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E25AC4CEC2;
	Wed,  2 Oct 2024 13:46:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727876796;
	bh=hmLgh7O2zyf2Cnyg14k+LmkDuBs8oOj1ook2TFc9RuQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=s626GSzDTb1O+unXnaDlNXv/7/Em4VYHpcOPvar1OjvE/a9ylP3pjtVlwD689iymz
	 iWAnLJmlIcJ/NcRGLjeQmU2XImoDVUox2dAqS8aYeAIZh1pwBT3PiE/npd75TsGSP9
	 Hno2WsHXVt4c6xvFxjwZNjefWQIHOFgorZfpq/7E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ma Ke <make24@iscas.ac.cn>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.11 523/695] ASoC: rt5682: Return devm_of_clk_add_hw_provider to transfer the error
Date: Wed,  2 Oct 2024 14:58:41 +0200
Message-ID: <20241002125843.360646965@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ma Ke <make24@iscas.ac.cn>

commit fcca6d05ef49d5650514ea1dcfd12e4ae3ff2be6 upstream.

Return devm_of_clk_add_hw_provider() in order to transfer the error, if it
fails due to resource allocation failure or device tree clock provider
registration failure.

Cc: stable@vger.kernel.org
Fixes: ebbfabc16d23 ("ASoC: rt5682: Add CCF usage for providing I2S clks")
Signed-off-by: Ma Ke <make24@iscas.ac.cn>
Link: https://patch.msgid.link/20240830143154.3448004-1-make24@iscas.ac.cn
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/codecs/rt5682.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/sound/soc/codecs/rt5682.c
+++ b/sound/soc/codecs/rt5682.c
@@ -2903,8 +2903,10 @@ int rt5682_register_dai_clks(struct rt56
 		}
 
 		if (dev->of_node) {
-			devm_of_clk_add_hw_provider(dev, of_clk_hw_simple_get,
+			ret = devm_of_clk_add_hw_provider(dev, of_clk_hw_simple_get,
 						    dai_clk_hw);
+			if (ret)
+				return ret;
 		} else {
 			ret = devm_clk_hw_register_clkdev(dev, dai_clk_hw,
 							  init.name,


