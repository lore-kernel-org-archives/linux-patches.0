Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C76F19B3FF;
	Tue, 15 Oct 2024 11:51:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728993090; cv=none; b=DpqUAtn/JQZmqdQUHcp7Gp73EFPNsXDJXEIy68e3xGKwN7qPKAWK3vOEEk6tEBKAUbOhcOkXCeVztoMrogo88kKw3mByCvqhyNzWVrMQQm5UOJ3fB5PTN4xd4WLQfVplJzY9ZVuN1mXzrlmEO2pO5zFBnxS/NOg3MxbMlgX1twA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728993090; c=relaxed/simple;
	bh=movDxoyT/lOVWPpuC7RfeZYSdT7Pi2qFXM3AJChUUjo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FFQluSRWLgcZmPsxUfp8xe0/CGu/a4hBcWEk19ewm2vk3RsUIEIsmdd9KBJPsvcxL5QH9ATzoiJusf1Gtch3K/ySRjBJ53m5GgxvAzs8NKSyzDXWQIvzDCUJg2fxEFwSvUklenB38BwRqiM0qJ6+2tYfMoFP4E8luiJJzT3j8ek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kD11BDLO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kD11BDLO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EAB4C4CEC6;
	Tue, 15 Oct 2024 11:51:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728993089;
	bh=movDxoyT/lOVWPpuC7RfeZYSdT7Pi2qFXM3AJChUUjo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kD11BDLOmc+nuvBo+scAMUtPr5jUBG/+uGwjrNbkDf0LTckBuHZJbPvJk2EG4D7ia
	 tb/CweDAkEZ6rl53dj5RCUxgqZB3fsVDDlkvAVRswY9Q6J6fr7UAEmo+dtAevPRQFl
	 p43DNXuNLlK3N+2APf98ePN1kt8W+RAyhs9/3J2I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ma Ke <make24@iscas.ac.cn>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.15 307/691] ASoC: rt5682: Return devm_of_clk_add_hw_provider to transfer the error
Date: Tue, 15 Oct 2024 13:24:15 +0200
Message-ID: <20241015112452.525779901@linuxfoundation.org>
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
@@ -2893,8 +2893,10 @@ int rt5682_register_dai_clks(struct rt56
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


