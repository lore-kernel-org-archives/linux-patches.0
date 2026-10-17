Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD710356A12;
	Sat, 17 Oct 2026 17:16:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792257401; cv=none; b=U+ZEryp0w/GH7d5B0xU++j3JB41p6Z6hwYZm1FOWuPmkCNaKTVELR7PMyiSaBZNag4Kh/TMDgoPAsy6dFJeGeSDB/OCDXPPWtmIPOFBy8ESEXx+0H7sd8rwIfejyHlp3g8dLg74LMZYow4bq98QjU22pbEyZDLhve3MMIkWxu3s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792257401; c=relaxed/simple;
	bh=wVyXS4S2Cq5Y48UFM05h5xhva8olHB9uG0PQsd+/aSg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=r/0ETWsSR7vMX08fI6pbswa2aG+9Uuh6YcOzcp+FwjN13UVIImO10uRfvIGsFupYQyLv3WJnRSOGNfVrzRItTuwqETEoY/+jC23Dld3dr46WtWMM8R7N60dY9bO+LLqi6DHJX5oXlD2GBF8b5MRflD7a88FHhmN1mQ5X9hFjxuw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S+fDlFdl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S+fDlFdl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 353C81F000C5;
	Sat, 17 Oct 2026 17:16:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792257398;
	bh=k6ZJROi3NhoyuOpJ0RZCFUpdN4nJkfXWZcHuQidGUgA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=S+fDlFdlt9DAewDoIwTo9Gp0M6F0GumoiJI6fpMp0WUjFOy0NbmPadzR5mEMyLvQC
	 dPkRM1Vag0lRDJ6fp/ztwr03Pw8t4RTQ9TUOiGuB7iA5JiNJMSsd2S+jFtqzHO56dh
	 xCggHhyW4JPH0nnQ8//TmPciUTVZ9BXUE6i8WTBg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Alvin=20=C5=A0ipraga?= <alvin.sipraga@analog.com>,
	=?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0547/1674] ASoC: adau1372: allow sleepy powerdown GPIOs
Date: Sat, 17 Oct 2026 17:46:59 +0200
Message-ID: <20261017160445.138154718@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



