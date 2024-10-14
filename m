Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FB251798C;
	Mon, 14 Oct 2024 15:05:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728918309; cv=none; b=TjBCIxtU81azruRfxv/9ReTsWcUnCKZKCKYGKV4FomC1KmUHXjEyu/Ce9sKWoFSzQMY3W8bwhXRGj7YGa1naKQsGacpPqJhOJMZztZcDnxnFzBSoPDXQCYqCu9hJfbEw8BDiN4Ofx9Linu2ADGreR8ApMBexejAwryOrYl02pGs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728918309; c=relaxed/simple;
	bh=WESBwAJARjF6YKlDfUNuOCcG0yCmjmhJxePUbII4Dhc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RxjiBCMuFA8Ug4hOHnvuSEFcz5SQBawHEK34hPNFj6gIBjhKO6yEJLi1YLOuoLiYhgWxEhr9ygrLf6m47Sdhp1GKvVz7YCOtzG7mKyHyMOQfGu1G/ZPkxU4MQ3bk960rh01QPzq9Ab1gfcEfEk7vrjJ5tN43JxsYrZ6lDpZjKDg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ndGaWGwh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ndGaWGwh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F1DAC4CEC3;
	Mon, 14 Oct 2024 15:05:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728918308;
	bh=WESBwAJARjF6YKlDfUNuOCcG0yCmjmhJxePUbII4Dhc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ndGaWGwh3Mb/sBRejyhZ922+JqEN9zmy7ZLzGWVZlBJd2OUzc4I3yf9xYnyRSrjhK
	 CbKFHk1SM3wsAIicMZjDl1TgbnEd0HGCqIDfuSryTdsi/qz4SK1yGlgcfL8w2M0/k/
	 tXz9FOAzfANUgopb148dpyw85jLXi2Rfmk2tuL8M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ma Ke <make24@iscas.ac.cn>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.1 284/798] ASoC: rt5682: Return devm_of_clk_add_hw_provider to transfer the error
Date: Mon, 14 Oct 2024 16:13:58 +0200
Message-ID: <20241014141229.104304499@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2899,8 +2899,10 @@ int rt5682_register_dai_clks(struct rt56
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


