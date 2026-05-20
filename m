Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A73AE272E56;
	Wed, 20 May 2026 18:32:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779301970; cv=none; b=NxurkvPRLag8AgL2wTiho+qCoxQtVXbApvSxccOT8TIJ3wCShI10cr0l2WhRLxJxcNaTMcE54tABEGQEoVSiIkEgsojg0vev14ttY45MQB8ceAE0/fVcFqDoI0WPuXyq8hXaZcqDGsYSpvGt8Dmwwg80IwqKc0t4BVq2LjcC9EI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779301970; c=relaxed/simple;
	bh=PQKMkKoAls6cuIZVkycCL9bCmnz/WsuvFZdMcPwhtXE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Gk/Jhkh3+yC7FN3INnf359FXqK9rn02u0sHp0lXTl9PiQZQDIggZph3ukdhJup+PdGXud9Fd98Hw/SD+vngsaio+2qj0rGURbzKXS8qkAQhJqbzTe6ki3pIeU0s1MKRyrwlLZ4WfSxOaz7sRmqSZuxfhvN1TwpwF2LNq8x0GZu0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JiJgPn0M; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JiJgPn0M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 199C01F000E9;
	Wed, 20 May 2026 18:32:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779301969;
	bh=vhvlbx4P4XMuXVyt8EwP5nB6WQE9Mdg+i9AQ/c4VrCg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JiJgPn0MhKc2T+ga51TiCu/7NNkuuMdMSEJqV+m4pK4ls/SuTKQMhvIGAkLdmaHHC
	 jAW3jaO9hhGpMr6M8S/SxWfR4QmeKnoyH2PV2c8jAPMGNqtsy6yr0Rx7+kx9rU7MJr
	 sfdegF68jbRLokdz6NZqEHFJrHGiCly9npxJDluo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sander Vanheule <sander@svanheule.net>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 090/508] ASoC: sti: use managed regmap_field allocations
Date: Wed, 20 May 2026 18:18:33 +0200
Message-ID: <20260520162100.565802204@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162058.573354582@linuxfoundation.org>
References: <20260520162058.573354582@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index f1b7e76f97b58..45d35b887e4eb 100644
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



