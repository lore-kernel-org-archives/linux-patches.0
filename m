Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67CDC1D0B84;
	Wed,  2 Oct 2024 14:18:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727878705; cv=none; b=h5FgXgql7fK0t+CRE/KOitISi2oNg9Dtfz+bKK0iPuZXuL9LVOAprnceUm89IU6cTHLU8NdV5Ie0zVzda+5HNTRPBO6qp4y0bAA+NA++Nl3PfpEzKO7SKkFT0McgQFgQsOS7nWQnai9XVDcek/TQM9peHPRaP5OaEmPfSU1eeQs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727878705; c=relaxed/simple;
	bh=Xf/u8CrFUQVT/X+g6so9o7k+EyD7ZRyniEUTDTrCmMY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BmdRZSzjuOORPz6vZXPKirfJ+1k1LtsYILc42oFBix8p6KeGCrDjUXtj3ppwzxJh+5OwnIAliuNO4rrfVZpHqsWRQ4TDfbkm1O4XJGHHSIK5LcBt4FKhqUcIDn5Ea0E7yp2KGAd7n6vTG2wyflHnDEEU3s1+ZhizAbt5x+gnfzM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JnPkRjNg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JnPkRjNg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A087DC4CEC2;
	Wed,  2 Oct 2024 14:18:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727878705;
	bh=Xf/u8CrFUQVT/X+g6so9o7k+EyD7ZRyniEUTDTrCmMY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JnPkRjNgnQFzzBJW5Sv3GwmYsp8lNP6OqMg4TVk2t9u5IAOfDxiXzP6EgN67PZ8QC
	 CWt8SAWK2t2/8MrBEu4N7+SQOAa3VX7W7Jsc/FefgHyPSZJ95q9CtcHPJm/E6qEcCC
	 dKu4fl2sC1qUonx8GlySsrg/CRDbgAIGEEGlt5Fg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ma Ke <make24@iscas.ac.cn>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.10 474/634] ASoC: rt5682: Return devm_of_clk_add_hw_provider to transfer the error
Date: Wed,  2 Oct 2024 14:59:34 +0200
Message-ID: <20241002125829.816532013@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125811.070689334@linuxfoundation.org>
References: <20241002125811.070689334@linuxfoundation.org>
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


