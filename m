Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 002001E3789;
	Wed,  6 Nov 2024 12:42:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730896963; cv=none; b=lwyp+CzyUwLS+VJMpQ9El3bva0z60iv6bJeax6c3qQaFrvx868gMovpgnt9xtil5toGsnRmUbR9ucWOT7mdlLwQeQ9jd0S9WSwEnqv9Re1x5J0scPOOJ6owWzx9kFVf+pFF7hpVnLYiHXx+ZbNo4RwO/Y0McTObH2QR++sd2t7o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730896963; c=relaxed/simple;
	bh=aN+Cn83LxRCxgP2lh/bU0z5t8GI93uxTd5jIZs/SiyA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r08OL1UOVmSdPjnV2QiQWvD5SbL3HqU++Q/hboerZkV+8Hp6kI1b+ucpaxqf1bBqQe+59ZH1LgvWoWB0mcO0m1j+rTNBpvHN4tzQOVkID0k2N7KXQbyoKxw33vw/kTfLK2WEOOR/ln6XnHkbbmwiynvjGOs0kEM/Njuwl7ilfZk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qxXqbByN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qxXqbByN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3864EC4CED4;
	Wed,  6 Nov 2024 12:42:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730896962;
	bh=aN+Cn83LxRCxgP2lh/bU0z5t8GI93uxTd5jIZs/SiyA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qxXqbByNQwN0GUf9VwH/U4RM/lfyyu/8A95rtwRE7Tg+E0dIYna+ULwlewxzkHdDH
	 SnY3r6BvY3iR05RF6bBzFiQGWtwfTDkZW+G3OimAjsC7hQALtoW+N0IcAP0Cw2M4Aq
	 ta5CAt6du4Eve/9JJVMYt2JWa5M6MqodZbBvNW54=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 020/126] ASoC: cs42l51: Fix some error handling paths in cs42l51_probe()
Date: Wed,  6 Nov 2024 13:03:41 +0100
Message-ID: <20241106120306.643004417@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120306.038154857@linuxfoundation.org>
References: <20241106120306.038154857@linuxfoundation.org>
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

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit d221b844ee79823ffc29b7badc4010bdb0960224 ]

If devm_gpiod_get_optional() fails, we need to disable previously enabled
regulators, as done in the other error handling path of the function.

Also, gpiod_set_value_cansleep(, 1) needs to be called to undo a
potential gpiod_set_value_cansleep(, 0).
If the "reset" gpio is not defined, this additional call is just a no-op.

This behavior is the same as the one already in the .remove() function.

Fixes: 11b9cd748e31 ("ASoC: cs42l51: add reset management")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Reviewed-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Link: https://patch.msgid.link/a5e5f4b9fb03f46abd2c93ed94b5c395972ce0d1.1729975570.git.christophe.jaillet@wanadoo.fr
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/cs42l51.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/sound/soc/codecs/cs42l51.c b/sound/soc/codecs/cs42l51.c
index 4b832d52f643f..cda6216476029 100644
--- a/sound/soc/codecs/cs42l51.c
+++ b/sound/soc/codecs/cs42l51.c
@@ -750,8 +750,10 @@ int cs42l51_probe(struct device *dev, struct regmap *regmap)
 
 	cs42l51->reset_gpio = devm_gpiod_get_optional(dev, "reset",
 						      GPIOD_OUT_LOW);
-	if (IS_ERR(cs42l51->reset_gpio))
-		return PTR_ERR(cs42l51->reset_gpio);
+	if (IS_ERR(cs42l51->reset_gpio)) {
+		ret = PTR_ERR(cs42l51->reset_gpio);
+		goto error;
+	}
 
 	if (cs42l51->reset_gpio) {
 		dev_dbg(dev, "Release reset gpio\n");
@@ -783,6 +785,7 @@ int cs42l51_probe(struct device *dev, struct regmap *regmap)
 	return 0;
 
 error:
+	gpiod_set_value_cansleep(cs42l51->reset_gpio, 1);
 	regulator_bulk_disable(ARRAY_SIZE(cs42l51->supplies),
 			       cs42l51->supplies);
 	return ret;
-- 
2.43.0



