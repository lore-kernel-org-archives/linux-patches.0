Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 969D5175A6B;
	Mon, 17 Aug 2026 15:02:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786978950; cv=none; b=b4jGvJMqO9pBD9K4JU/JypuFyP0qyKaj4ssm7oXo3bNjItv58nHsDQTEWdY8mV5K2zTxRGB63BLjtOb8dIO8nkr3suGdO13gNs5L0nt5yg6aXtcpVOtK/vM8r9GCO3k4cgy6E8ytiTGiYH6qguBo/87kbTxm/G3Le8K2yT8Kdgo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786978950; c=relaxed/simple;
	bh=KbKyvFrBxc40jjJ0MvhmuZE2Nm4n9xWpOGB/Fpki8nM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=neheg3EgA4LpYdVaIZJyY/nzWpXyS408GYO/pRpT8CLNFxRctE5OrH6kP1qUj07tfwCz8h9yVHJMwNYs8S3lHwnfUFKOOa88/xtpHYXLhaJqH9XNKUwmHoiGGRqd1idXtpde6EO5byGRZP3bFdDNZQPto3QKvrWiGkkNnASO+KY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=njJiwlXk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="njJiwlXk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE0031F000E9;
	Mon, 17 Aug 2026 15:02:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786978949;
	bh=qkmTH+IRx3W0GKqZ9vdFDRbVHQsd+jpjs+FhWHX7fjg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=njJiwlXkKh47L+kU7Fv7cneZOtsrMrKJIkhK0T4DBXuDn7GZMy5Qtb1jtkDtHJROR
	 taQkEr5BjoNHFTIuOuZi6yhla1V3vkqI/5+WrBdPxJbD9wZELWjNgUOwywnSiB3x4j
	 BbgT6Dkz/XjZHYl+D5Clr3tLQllQK3mWdgBuQ2Y0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Uday Khare <udaykhare77@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 055/609] ASoC: tas2562: fix deprecated shut-down GPIO always cleared after lookup
Date: Mon, 17 Aug 2026 15:25:51 +0200
Message-ID: <20260817132545.279415278@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132543.039278408@linuxfoundation.org>
References: <20260817132543.039278408@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index b486d0bd86c991..6d06b95f1c0137 100644
--- a/sound/soc/codecs/tas2562.c
+++ b/sound/soc/codecs/tas2562.c
@@ -685,11 +685,12 @@ static int tas2562_parse_dt(struct tas2562_data *tas2562)
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



