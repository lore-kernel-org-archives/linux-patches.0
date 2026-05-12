Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B86A34B410;
	Tue, 12 May 2026 18:09:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778609373; cv=none; b=f2zHFeZXBka5n9RfDONLrURLpvsP3yK278S8T7M43ZC8DRDp+MsLNb/RGUdIjhBb/mXqzKeizjpp1EOp/D7hD6jxHD5aHNtn0VoQmOCVOVMgvVKkzwXu61LeU0umBHEgCq3IgQrUITOeL2LCUxyQLhQ2KMopL9pw6DBoQa1nEEQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778609373; c=relaxed/simple;
	bh=c6eT2qoOx/u44DQliTUtlmmRxyzQC7YJ/kOwSNJIDvw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fELmaQBhj76AeeblZ13veiPA285E6KdaqUDu+bM8Kmab6gK2Zigo1sSezYmQGcrHj46BNdQOyup8lB0813MptmVv1cVWY3sxc8jehchPIMYGZawfZauoaA5tqmhAT+BMj5lNgIfJXsB6DXf0qjoG0khmAu3M9ZZ6dUip0rQOUI8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AhMSTOcX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AhMSTOcX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4B5CC2BCB0;
	Tue, 12 May 2026 18:09:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778609373;
	bh=c6eT2qoOx/u44DQliTUtlmmRxyzQC7YJ/kOwSNJIDvw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AhMSTOcXCTHAdi/3+n/nza9TEtR4AmjhodP63WR9eHGvvhBMBu0awI85xCBKXABN8
	 wYXJdg1evIZlG59dFF5myCSHv0OW0OobYErFjlBE2qmj1ssPNy1AE0WupwajBZA5Hj
	 SkH7x9XcYRtXBSgSHKeH2FgkIWZpVl4hGKygzMw8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?C=C3=A1ssio=20Gabriel?= <cassiogabrielcontato@gmail.com>,
	Cezary Rojewski <cezary.rojewski@intel.com>,
	Hans de Goede <johannes.goede@oss.qualcomm.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 7.0 171/307] ASoC: Intel: bytcr_wm5102: Fix MCLK leak on platform_clock_control error
Date: Tue, 12 May 2026 19:39:26 +0200
Message-ID: <20260512173943.727685781@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173940.117428952@linuxfoundation.org>
References: <20260512173940.117428952@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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
@@ -170,6 +170,7 @@ static int platform_clock_control(struct
 		ret = byt_wm5102_prepare_and_enable_pll1(codec_dai, 48000);
 		if (ret) {
 			dev_err(card->dev, "Error setting codec sysclk: %d\n", ret);
+			clk_disable_unprepare(priv->mclk);
 			return ret;
 		}
 	} else {


