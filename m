Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFBBB34104B;
	Sat, 30 May 2026 17:02:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780160570; cv=none; b=q1rzM2pJzZYp6zS4gqIHNoqlkd/UvHTac08K7HNWcJI1Zp5h6+StcsrX9tGb3RmEg/0U4NI222S9aCfPp6V180plpqSwsFTw4CBNsUnYFxJ0rBF/HYYR4VowD+JMt5azx/7W8CyXQwa7ZrAG1OrRg4y8PG5NavDZ6SPOyho7hDw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780160570; c=relaxed/simple;
	bh=ePEDMs0uckC2hZ/U7Fr1e5Omdlb6WHiWem5CRNMLKyA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DF9iGtB7dlF354JENGlJ/ES6VXCDu7UH5LZ8DcN3mwooD2p5Of538Upfoe9OpQGpR0MKqEOPNOYgHDNRA8+zRRzCG2Lws7xoQqbVm04CT72hi/0tY0AtFKhQwRxz4kXOpA0lsnXY2Q6pnHebcH5iI68CnWd0XAnxEtbLnQVB+A4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cpZ/RWAc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cpZ/RWAc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5CF71F00893;
	Sat, 30 May 2026 17:02:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780160569;
	bh=paNJrmx5B3ifxnVrR3Q4xOCa1qmUS+jdArCwtLNB3zw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cpZ/RWAc1k/c1G1MO4KzbBnSv8GWHfDez89EeBy4QJ/7HRS8b7/ZAjc2TeGuR62cc
	 Jw5HhOEKQV0mfA9oPA8VabId8V97TlG7k9loewRzZeN7740S5nZ/XMUOv15p58yk8S
	 pCggH3vgd8HajcEd8G1+axwUrKAe25w+oom4mc9o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?C=C3=A1ssio=20Gabriel?= <cassiogabrielcontato@gmail.com>,
	Cezary Rojewski <cezary.rojewski@intel.com>,
	Hans de Goede <johannes.goede@oss.qualcomm.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.1 344/969] ASoC: Intel: bytcr_wm5102: Fix MCLK leak on platform_clock_control error
Date: Sat, 30 May 2026 17:57:48 +0200
Message-ID: <20260530160309.865959430@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cássio Gabriel <cassiogabrielcontato@gmail.com>

commit 13d30682e8dee191ac04e93642f0372a723e8b0c upstream.

If byt_wm5102_prepare_and_enable_pll1() fails in the
SND_SOC_DAPM_EVENT_ON() path, platform_clock_control() returns after
clk_prepare_enable(priv->mclk) without disabling the clock again.

This leaks an MCLK enable reference on failed power-up attempts. Add the
missing clk_disable_unprepare() on the error path, matching the unwind
used by the other Intel platform_clock_control() implementations.

Fixes: 9a87fc1e0619 ("ASoC: Intel: bytcr_wm5102: Add machine driver for BYT/WM5102")
Cc: stable@vger.kernel.org
Signed-off-by: Cássio Gabriel <cassiogabrielcontato@gmail.com>
Reviewed-by: Cezary Rojewski <cezary.rojewski@intel.com>
Reviewed-by: Hans de Goede <johannes.goede@oss.qualcomm.com>
Link: https://patch.msgid.link/20260427-bytcr-wm5102-mclk-leak-v1-1-02b96d08e99c@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/intel/boards/bytcr_wm5102.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/soc/intel/boards/bytcr_wm5102.c
+++ b/sound/soc/intel/boards/bytcr_wm5102.c
@@ -111,6 +111,7 @@ static int platform_clock_control(struct
 		ret = byt_wm5102_prepare_and_enable_pll1(codec_dai, 48000);
 		if (ret) {
 			dev_err(card->dev, "Error setting codec sysclk: %d\n", ret);
+			clk_disable_unprepare(priv->mclk);
 			return ret;
 		}
 	} else {


