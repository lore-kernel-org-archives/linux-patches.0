Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49E8E4F85AB;
	Tue, 13 Oct 2026 11:57:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791892647; cv=none; b=TQdp+CcU25zGu5ZhhNflo6aXH2MiTCtFnaZptAmlFROSyyqxmagxj94wM/5fixLl3rRBoLfi7XGHR3OBrVsmYSeWZVlCa8DNH6tMOcu2m6SJ4lUFEWcPYHiF5e8FeWbdPxaEYzrlNxT3L8/khQwbNpigUdNqvScdqTpp6hwdfRE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791892647; c=relaxed/simple;
	bh=KKLfAf5mW9szjv20rrBntb4jubQIgr+WUHdKl3/efJY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pmFeeFM6tymwv/7iwhN3wXcEAEPbJ+Ne+TIBRmqkxjfo5xU3CnFr8gJ6NObl/TDjurLcXCi0IqFa7hrWoAHgCon04SWwK4pMgDdUx29fv1Lc1oXU0iAociZbeD6UqthoCUxLGUcab3Ld4itzEo2BYNm0DZUlHmqrObdPE5U2gtk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lIsQbGgb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lIsQbGgb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9117A1F00893;
	Tue, 13 Oct 2026 11:57:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791892645;
	bh=/2LpH+w1OJlSUF7RYbxqNGDnmojD6D6ytCLfYWRNTks=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lIsQbGgb0NW7ZynX6RO5deW/rJGLz8vkin6BmDYm1oVggRcdfeE3tLJRWLQn0JR9d
	 J6q3pxppes0GDaddAAESD0NJLw1Dv3bOUj+ih98+duZ85wEsuu8PT8ijQX513RBJGR
	 t/IuoTg8z+67SfKXkzD04qUkel+E7QYQnfG8Yr/U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Alvin=20=C5=A0ipraga?= <alvin.sipraga@analog.com>,
	=?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 242/281] ASoC: adau1372: allow sleepy powerdown GPIOs
Date: Tue, 13 Oct 2026 13:39:18 +0200
Message-ID: <20261013112901.022247295@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112855.045212108@linuxfoundation.org>
References: <20261013112855.045212108@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index cc174ec3a1f82..b84495371b0b4 100644
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



