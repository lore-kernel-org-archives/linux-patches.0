Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C15663EB7F8;
	Mon, 17 Aug 2026 14:06:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786975562; cv=none; b=TwyhJdNB7qJLTzAary4YbPFF+O1PlmF4330rW6NLiEezkqbB76uoMJ2ZYyj9QEGYksSDvlRxwEsk5v/xbPzfhlNPKLQRzIPpi8jaQbFF2nZZnj/LRy+fWo60YmIdMX45TYdKODAYnWhptmPSPMQTKRIpCtZ4/mKN/BCYk5q0gj4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786975562; c=relaxed/simple;
	bh=ysAo2WVdyii1atFyVjRz+YM9SF+cWOgEQk0lU7wuUTU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=npr083/yLc/9X71llYoMBItyxABj1VdzfsrX8rQAcyb0c1vdEP79j1MHsqR+wH8bV1AFTi0jWC5CvUXlAAaimSOt0KJHg1JOliq7e44eZZlxcOLvdTqrUodSo51sDEhbUuyLPlc6bimJhMp9TomPweMeKKdYWtfIbaLxwPMFC6I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dLAbSYOo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dLAbSYOo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 250A11F000E9;
	Mon, 17 Aug 2026 14:06:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786975561;
	bh=ZPMvt4oznhTlOEJx46+3BiFV+RIVCaqV9yChuetNBV8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dLAbSYOonxmxbd3f18J78g9lVMnfb9mCn2C+iZvq535c5wnUa8ChylZXYVbS6eeoP
	 SeGX7N04t4TqgMlAB52mvx8VJ35ulLuqxEw9p0ALmnLX6m57SDdMEFIs5T1kW4jg6S
	 65P/78xqrnnmeRxxFop+0NpPtPF1Xl1SDnmLf4xE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Uday Khare <udaykhare77@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 030/389] ASoC: tas2562: fix deprecated shut-down GPIO always cleared after lookup
Date: Mon, 17 Aug 2026 15:27:49 +0200
Message-ID: <20260817132540.123001454@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132538.796021292@linuxfoundation.org>
References: <20260817132538.796021292@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Uday Khare <udaykhare77@gmail.com>

[ Upstream commit 3238c634725afbb2a137fdda762208510828f71d ]

In tas2562_parse_dt(), the fallback lookup for the deprecated
"shut-down" GPIO property is broken due to a missing pair of braces.

The code intends to reset sdz_gpio to NULL only when the lookup
returns an error that is not -EPROBE_DEFER (so the driver gracefully
continues without a GPIO). However, without braces the statement:

    tas2562->sdz_gpio = NULL;

falls outside the IS_ERR() check and is executed unconditionally
for every path through the if block, including a successful GPIO
lookup.

This means any device using the deprecated 'shut-down' DT property
will always have sdz_gpio == NULL after probe, making the GPIO
completely non-functional.

Fix this by adding the missing braces to scope the NULL assignment
inside the IS_ERR() branch, matching the pattern already used for
the primary 'shutdown' GPIO lookup above.

Fixes: f78a97003b8b ("ASoC: tas2562: Update shutdown GPIO property")
Signed-off-by: Uday Khare <udaykhare77@gmail.com>
Link: https://patch.msgid.link/20260706153109.10953-1-udaykhare77@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/tas2562.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/sound/soc/codecs/tas2562.c b/sound/soc/codecs/tas2562.c
index f1ff204e3ad052..a2ddb692b8f697 100644
--- a/sound/soc/codecs/tas2562.c
+++ b/sound/soc/codecs/tas2562.c
@@ -720,11 +720,12 @@ static int tas2562_parse_dt(struct tas2562_data *tas2562)
 	if (tas2562->sdz_gpio == NULL) {
 		tas2562->sdz_gpio = devm_gpiod_get_optional(dev, "shut-down",
 							      GPIOD_OUT_HIGH);
-		if (IS_ERR(tas2562->sdz_gpio))
+		if (IS_ERR(tas2562->sdz_gpio)) {
 			if (PTR_ERR(tas2562->sdz_gpio) == -EPROBE_DEFER)
 				return -EPROBE_DEFER;
 
-		tas2562->sdz_gpio = NULL;
+			tas2562->sdz_gpio = NULL;
+		}
 	}
 
 	if (tas2562->model_id == TAS2110)
-- 
2.53.0



