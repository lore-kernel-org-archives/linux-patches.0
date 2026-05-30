Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A995133AD99;
	Sat, 30 May 2026 18:39:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780166355; cv=none; b=qtaW9/WXgI62zfaarOsl+WrXjnT3hhun9iXjNYPQ54TNfIAAoBniFlIgiyWrp1B3h1Ss7DLGLYhMQzy4zAweNDx9Z6w6YAQfseor/r4AGDaTi+Rname0vW51gnKWPAM/E5m4ypu0QWz0JSy6ZxckX8TIpsQ8bFy7KwD/8PEe07o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780166355; c=relaxed/simple;
	bh=JLXpJUKM9zOYrccB4LqZwpiYQuQPPuhrZOoc/l/p0sU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aqhyvM+WZ+yVsCNWysy6PPCOfsqeL1Go40lx4gYby0WJALxcJ1b8Gt9oRRiED7nPX676sMNU1VRBJeLfrXAgFWdn1JPjCb7xw6DC2zsko/uouJcnuoOgNk3Iab7fGF7MvxAZHOjEytqfSM8BrVuFdn5aWPd3qek1G5ZeHobF5ik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=in3N79sF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="in3N79sF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8571E1F00893;
	Sat, 30 May 2026 18:39:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780166354;
	bh=G3cg3rC4s9+zA5XnTqd82L9cQb0MEAWoZOAG7JAkhTk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=in3N79sFHBONAAr49msiFVUDRJjfIq+YX02LUJbPGtcIjfHmhT2G7PAvEOHzl7quQ
	 qLlE8S1MnK5H96n1yM72Rm/0ylm/br20oofvuAjiCvQUrgsOKfyKZEghbUoTeg8Hph
	 Bi7L/Dsza3sIxmrvwbq2r2PYSQ/dLm+jZ9O2oJ3U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sander Vanheule <sander@svanheule.net>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 321/589] ASoC: sti: use managed regmap_field allocations
Date: Sat, 30 May 2026 18:03:22 +0200
Message-ID: <20260530160233.367957226@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160224.570625122@linuxfoundation.org>
References: <20260530160224.570625122@linuxfoundation.org>
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

From: Sander Vanheule <sander@svanheule.net>

[ Upstream commit 1696fad8b259a2d46e51cd6e17e4bcdbe02279fa ]

The regmap_field objects allocated at player init are never freed and
may leak resources if the driver is removed.

Switch to devm_regmap_field_alloc() to automatically limit the lifetime
of the allocations the lifetime of the device.

Fixes: 76c2145ded6b ("ASoC: sti: Add CPU DAI driver for playback")
Signed-off-by: Sander Vanheule <sander@svanheule.net>
Link: https://patch.msgid.link/20260220152634.480766-3-sander@svanheule.net
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sti/uniperif_player.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/soc/sti/uniperif_player.c b/sound/soc/sti/uniperif_player.c
index e5c4e5245b255..da07f825f3c5f 100644
--- a/sound/soc/sti/uniperif_player.c
+++ b/sound/soc/sti/uniperif_player.c
@@ -1028,11 +1028,11 @@ static int uni_player_parse_dt_audio_glue(struct platform_device *pdev,
 		return PTR_ERR(regmap);
 	}
 
-	player->clk_sel = regmap_field_alloc(regmap, regfield[0]);
+	player->clk_sel = devm_regmap_field_alloc(&pdev->dev, regmap, regfield[0]);
 	if (IS_ERR(player->clk_sel))
 		return PTR_ERR(player->clk_sel);
 
-	player->valid_sel = regmap_field_alloc(regmap, regfield[1]);
+	player->valid_sel = devm_regmap_field_alloc(&pdev->dev, regmap, regfield[1]);
 	if (IS_ERR(player->valid_sel))
 		return PTR_ERR(player->valid_sel);
 
-- 
2.53.0



