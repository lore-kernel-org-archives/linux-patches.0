Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BEEA432E94;
	Thu, 30 Jul 2026 14:59:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785423576; cv=none; b=YkreIRrsbZXofEFUqhOJPno08KefGAoNCNBqcSbzbFWlvjEbe86cllECG/hOz8SfyjVsUV5yMT8MJ+6orIYyVPUc/CtJ7TQcKIw/HRYk3Qm5pq8JsTYsIFX+Q+qk1xmOUVQlhBgLk7a8uLhiY5REimJwP340aVUb2Nm+ovyTNHg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785423576; c=relaxed/simple;
	bh=/XUyiUxqsbK3T0DVwm9R9KHHRQ62Yt5zN2UMCrlmLDo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jLeqE2yYGXh2IK9IdY5H6h58cYKgQLoJd9338gyp03XVINWIWdZUvA2y2FrA+Rft+KZgL36E8Gk+fQhJma6CmoRnixXrpsTuW8Sau+iO5/DDenJXJAkGG6bM/Yo++vYLwZOUyBhlOMV4PCLBfeS/5UYd66FTgHkQumcKDfbhNZ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=V8gR95Zm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V8gR95Zm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FFE41F000E9;
	Thu, 30 Jul 2026 14:59:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785423574;
	bh=IRmHB4ywvQ/qUTeJ/v5PfrhiaieBooHRdNRe2fZNODE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=V8gR95ZmkYRIvgk2pslIa+JVPAVKwzMuM/eQXkMJyrNLOIUWoP7Fjv169TYJ37ZQd
	 7/mPh3XZThtng+l9NclukaX0JCSathL2XyIOWG+GgwSfEkLJvJhEVAD9c63+qE6XxR
	 JRJpMk1VNR5FBduv5qtB3PHJYkt2ccKfU6qURVR8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Uday Khare <udaykhare77@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 093/675] ASoC: tas2562: fix deprecated shut-down GPIO always cleared after lookup
Date: Thu, 30 Jul 2026 16:07:03 +0200
Message-ID: <20260730141447.105745214@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 8e00dcc09d0c28..795c66cb47134e 100644
--- a/sound/soc/codecs/tas2562.c
+++ b/sound/soc/codecs/tas2562.c
@@ -675,11 +675,12 @@ static int tas2562_parse_dt(struct tas2562_data *tas2562)
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



