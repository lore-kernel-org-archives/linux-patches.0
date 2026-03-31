Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03FD8426EC3;
	Tue, 31 Mar 2026 16:51:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774975912; cv=none; b=tLD2yet6SUPhNrs8GUeMDn8yFOnmfos0vH5NmujkXZIeJoxDpgu3UFSsoQbhTzvE9b7vJX8KKTme815B0eVSG33SfLDmGLbjqXHmJ2jhvByHiBybC65JGhWzr/nSrIjh8f/soImeZtVOySRtFAcSPwkIkGsE3/VwOdNze24Yj6I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774975912; c=relaxed/simple;
	bh=WtlmNsSBYg8FAt1GhDjVgb62o/snQedXZn7gF3q44qs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mlACGZomul4subTIwaW+FtkiHJ8KrS0nDtje2wkfr0BnCoAgZmmXHaNdYdKNQmA/s3asFLwybUCWZHZN6hC40SH1nrWU5+XcxsCVSr33pWPJNMU8F3riJu2xUOyp6PW13N0RfVhM3s+IoKC/BXNZMgyJjlL7sfjn1SUADyc9MF0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=m8iBvzfr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m8iBvzfr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E770C2BCB2;
	Tue, 31 Mar 2026 16:51:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774975911;
	bh=WtlmNsSBYg8FAt1GhDjVgb62o/snQedXZn7gF3q44qs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m8iBvzfryXirARrUcshrw7R8zBespKs5KGRSCUoefOhiWfV5hlkdolSGLwyIVeMg4
	 RHs7jVgMc9eECKYqWx6XS2PqcOCpNuSrj3JCR2pKxX3rHnrhdn4gbOg9phwIRfkL0u
	 YyFVvjCfwaGNCcgqT87AzUVyl1Kdl5sGzd+rT+zM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jihed Chaibi <jihed.chaibi.dev@gmail.com>,
	=?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 133/244] ASoC: adau1372: Fix clock leak on PLL lock failure
Date: Tue, 31 Mar 2026 18:21:23 +0200
Message-ID: <20260331161746.565895126@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161741.651718120@linuxfoundation.org>
References: <20260331161741.651718120@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jihed Chaibi <jihed.chaibi.dev@gmail.com>

[ Upstream commit bfe6a264effcb6fe99ad7ceaf9e8c7439fc9555b ]

adau1372_enable_pll() was a void function that logged a dev_err() on
PLL lock timeout but did not propagate the error. As a result,
adau1372_set_power() would continue with adau1372->enabled set to true
despite the PLL being unlocked, and the mclk left enabled with no
corresponding disable on the error path.

Convert adau1372_enable_pll() to return int, using -ETIMEDOUT on lock
timeout and propagating regmap errors directly. In adau1372_set_power(),
check the return value and unwind in reverse order: restore regcache to
cache-only mode, reassert GPIO power-down, and disable the clock before
returning the error.

Signed-off-by: Jihed Chaibi <jihed.chaibi.dev@gmail.com>
Fixes: 6cd4c6459e47 ("ASoC: Add ADAU1372 audio CODEC support")
Reviewed-by: Nuno Sá <nuno.sa@analog.com>
Link: https://patch.msgid.link/20260325210704.76847-3-jihed.chaibi.dev@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/adau1372.c | 17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

diff --git a/sound/soc/codecs/adau1372.c b/sound/soc/codecs/adau1372.c
index f629be6c297df..25f123110b5be 100644
--- a/sound/soc/codecs/adau1372.c
+++ b/sound/soc/codecs/adau1372.c
@@ -761,7 +761,7 @@ static int adau1372_startup(struct snd_pcm_substream *substream, struct snd_soc_
 	return 0;
 }
 
-static void adau1372_enable_pll(struct adau1372 *adau1372)
+static int adau1372_enable_pll(struct adau1372 *adau1372)
 {
 	unsigned int val, timeout = 0;
 	int ret;
@@ -777,8 +777,12 @@ static void adau1372_enable_pll(struct adau1372 *adau1372)
 		timeout++;
 	} while (!(val & 1) && timeout < 3);
 
-	if (ret < 0 || !(val & 1))
+	if (ret < 0 || !(val & 1)) {
 		dev_err(adau1372->dev, "Failed to lock PLL\n");
+		return ret < 0 ? ret : -ETIMEDOUT;
+	}
+
+	return 0;
 }
 
 static int adau1372_set_power(struct adau1372 *adau1372, bool enable)
@@ -806,7 +810,14 @@ static int adau1372_set_power(struct adau1372 *adau1372, bool enable)
 		 * accessed.
 		 */
 		if (adau1372->use_pll) {
-			adau1372_enable_pll(adau1372);
+			ret = adau1372_enable_pll(adau1372);
+			if (ret) {
+				regcache_cache_only(adau1372->regmap, true);
+				if (adau1372->pd_gpio)
+					gpiod_set_value(adau1372->pd_gpio, 1);
+				clk_disable_unprepare(adau1372->mclk);
+				return ret;
+			}
 			clk_ctrl |= ADAU1372_CLK_CTRL_CLKSRC;
 		}
 
-- 
2.53.0



