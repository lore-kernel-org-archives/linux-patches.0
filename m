Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 813E91DF98F;
	Tue, 13 Oct 2026 12:53:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791896020; cv=none; b=uOrVX7OkaEbHzzEUSedvGqK+f94DV9xlKc4v+ISe3sjFNCqskNj1A5/QQXN0+7xxCfCyaOaOSZDgCy4bfgs11lpvwVyYq7LihcwlAYRd5RdSPS4nGNdlwfLVFeiQJftjSG5RNyOtJbU5VA2ATVpU2wj9eUJU71vEqNaIfwsnCuo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791896020; c=relaxed/simple;
	bh=6+ANGzGs4PIsiRv89Yxy9xYF8xmAY5rRNyVg9X2VJ9Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QF4vMnqWfVQxKecg360U9FFcOLerKgtn8BVbRT+UAo3WNoqsZoNOCVHg4pvxUY/QP/BCsCu4Rtr5qhSFBcS9xBr+vulpDxzdoJSZHb6Lj057J1s8F4QJ+nroUfOz22ltRcDm62pIg1p1o3eFhNlDoZmiczJ6VVx5HH6xnEpgXIo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Uwb73Uzp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Uwb73Uzp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D365E1F000FF;
	Tue, 13 Oct 2026 12:53:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791896018;
	bh=08fy15s0/HNJcqlw//r26i7ep/oSPzjFjvZDB7t+1sk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Uwb73UzpVPfW80INP09EEqGwwZWeUDp4411iYEQPlxmP7Q4mxjRBtKLw/z5VWU3Q1
	 oUJCf01uS2uiNAtRWnuS8NpJ4V7sf9Xwd+3BbZn/8LpissDeDgBZuIQSyKUczGyVCv
	 5vqgHKdyZXgArnpf216gnAL84jX6VeLw80AaGUJk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Alvin=20=C5=A0ipraga?= <alvin.sipraga@analog.com>,
	=?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 471/497] ASoC: adau1372: allow sleepy powerdown GPIOs
Date: Tue, 13 Oct 2026 13:40:38 +0200
Message-ID: <20261013112919.059584781@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112907.864180619@linuxfoundation.org>
References: <20261013112907.864180619@linuxfoundation.org>
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

From: Alvin Šipraga <alvin.sipraga@analog.com>

[ Upstream commit 64dd172bbffe6135d79a06ddad53dd2da4d8bd62 ]

gpiod_set_value() emits a WARN when the GPIO provider indicates that it
can sleep, as is typical for I2C controlled GPIO expanders. Since the
powerdown GPIO is only manipulated in process context, use the _cansleep
variant instead. This lets the driver use sleepy GPIOs to power off the
chip.

Fixes: 6cd4c6459e47 ("ASoC: Add ADAU1372 audio CODEC support")
Signed-off-by: Alvin Šipraga <alvin.sipraga@analog.com>
Acked-by: Nuno Sá <nuno.sa@analog.com>
Link: https://patch.msgid.link/20261006-asoc-adau1372-fixes-v1-1-599cc17fb5f6@analog.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/adau1372.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/sound/soc/codecs/adau1372.c b/sound/soc/codecs/adau1372.c
index 7dc0b5c79e399..b758213471ec0 100644
--- a/sound/soc/codecs/adau1372.c
+++ b/sound/soc/codecs/adau1372.c
@@ -798,7 +798,7 @@ static int adau1372_set_power(struct adau1372 *adau1372, bool enable)
 		if (ret)
 			return ret;
 		if (adau1372->pd_gpio)
-			gpiod_set_value(adau1372->pd_gpio, 0);
+			gpiod_set_value_cansleep(adau1372->pd_gpio, 0);
 
 		if (adau1372->switch_mode)
 			adau1372->switch_mode(adau1372->dev);
@@ -818,8 +818,7 @@ static int adau1372_set_power(struct adau1372 *adau1372, bool enable)
 							   ADAU1372_CLK_CTRL_PLL_EN,
 							   0);
 				regcache_cache_only(adau1372->regmap, true);
-				if (adau1372->pd_gpio)
-					gpiod_set_value(adau1372->pd_gpio, 1);
+				gpiod_set_value_cansleep(adau1372->pd_gpio, 1);
 				clk_disable_unprepare(adau1372->mclk);
 				return ret;
 			}
@@ -836,7 +835,7 @@ static int adau1372_set_power(struct adau1372 *adau1372, bool enable)
 			 * map. No need to do any register writes to manually
 			 * turn things off.
 			 */
-			gpiod_set_value(adau1372->pd_gpio, 1);
+			gpiod_set_value_cansleep(adau1372->pd_gpio, 1);
 			regcache_mark_dirty(adau1372->regmap);
 		} else {
 			regmap_update_bits(adau1372->regmap, ADAU1372_REG_CLK_CTRL,
-- 
2.53.0



