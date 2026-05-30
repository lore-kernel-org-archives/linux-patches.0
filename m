Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19B263148DA;
	Sat, 30 May 2026 17:09:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780160990; cv=none; b=ZKfQB4Yc99jpisVf1GzhgOPdxM9lgBriYlVF/nmAO6Srlyyi5rrmVnp8VPt7G0THqguLvcoiJC6vKUdeoSJ6NPLQSE7jKFDn6lUXIvuxzFIU4WiTX6WMIZdmGcfi7kBAimjgbLu9khjibldSkGJlIIUGXti8U/9VKfNFqhGTXnI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780160990; c=relaxed/simple;
	bh=Nv7l32NXuXpCZEd3H78D7ogcGYkv9DGgnc9ylgRg1kQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G3g0s7+GS2XIsiPOOrsTM6smvZoz2gyVD7afwx+SgHL0qM1p9o5knMspcwgA/gH83fxQdM/sr8yC63uiEFZgOKbJ4D8diJxiKddlr2BxyK/kcLWOkZrq2azx8pduW1n8a1mq4QSOY6bvfGMRw1QA1kQ+b6AMVMnateJ7v5PBkjs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KqbrJsfb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KqbrJsfb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F1291F00893;
	Sat, 30 May 2026 17:09:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780160989;
	bh=UOA+hDUY9ePQKqzzfW20QnZ3DtXTQzYJbS7V4c8zQd8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KqbrJsfbJXodVKfggnkt8vHbHGdKPXTQ2MMn/1qq2VicUpmPr1qOx/OSfHaSr2TZE
	 7tlt5Ktn/h0xDOwf9bP6JDYX0b2do/M+HXJh01GUOv6iuJxla5j1qZJGh9ytQSYxJU
	 deWAJoj9sc9mLrqDZ5FXF+kAUajrSd6ucMcGwgnA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sander Vanheule <sander@svanheule.net>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 493/969] ASoC: sti: Return errors from regmap_field_alloc()
Date: Sat, 30 May 2026 18:00:17 +0200
Message-ID: <20260530160313.931764219@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

From: Sander Vanheule <sander@svanheule.net>

[ Upstream commit 272aabef50bc3fe58edd26de000f4cdd41bdbe60 ]

When regmap_field_alloc() fails, it can return an error. Specifically,
it will return PTR_ERR(-ENOMEM) when the allocation returns a NULL
pointer. The code then uses these allocations with a simple NULL check:

    if (player->clk_sel) {
        // May dereference invalid pointer (-ENOMEM)
        err = regmap_field_write(player->clk_sel, ...);
    }

Ensure initialization fails by forwarding the errors from
regmap_field_alloc(), thus avoiding the use of the invalid pointers.

Fixes: 76c2145ded6b ("ASoC: sti: Add CPU DAI driver for playback")
Signed-off-by: Sander Vanheule <sander@svanheule.net>
Link: https://patch.msgid.link/20260220152634.480766-2-sander@svanheule.net
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sti/uniperif_player.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/sound/soc/sti/uniperif_player.c b/sound/soc/sti/uniperif_player.c
index dd9013c476649..e5c4e5245b255 100644
--- a/sound/soc/sti/uniperif_player.c
+++ b/sound/soc/sti/uniperif_player.c
@@ -1029,7 +1029,12 @@ static int uni_player_parse_dt_audio_glue(struct platform_device *pdev,
 	}
 
 	player->clk_sel = regmap_field_alloc(regmap, regfield[0]);
+	if (IS_ERR(player->clk_sel))
+		return PTR_ERR(player->clk_sel);
+
 	player->valid_sel = regmap_field_alloc(regmap, regfield[1]);
+	if (IS_ERR(player->valid_sel))
+		return PTR_ERR(player->valid_sel);
 
 	return 0;
 }
-- 
2.53.0



