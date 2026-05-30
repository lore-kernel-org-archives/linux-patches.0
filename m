Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41DED23392B;
	Sat, 30 May 2026 18:02:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780164121; cv=none; b=k46AYGMrUC5XaHwn+X8qjJnvDsJ0gIDgK8hI96cgmp2QB/n5KfNVBCEdUMbD1gjRlEPukMWpOqEjhSZY1XcugJgfqh1ziwveHwFjAae8bUyGPZhi5DyyD6QDlo1s1ma87SZnDJFe7QcMddk4htwpfOlNMZIuylMg8Fro4Aw/LT4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780164121; c=relaxed/simple;
	bh=ysZmQVUEBH7ERh/XrmS+uwpOoYtaaqRk8/Dn5xVMiUA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GbEROxybPRU0GvGL2XaBWYaep2+QfPJjQTFNW4C10Ma81961a/9VEv7pspiCK2m46WVSHIxHL1WoKwEzRLcNhnr9FRvcnJdzDv3QF+CzsdDR5mta5TRyJrLLQelDSByDGpj8HZ4hQ7BS1c6F3FIIznm6aMgWdLUZ68SvkZ+xxP4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IcZqlwrb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IcZqlwrb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 856651F00893;
	Sat, 30 May 2026 18:01:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780164120;
	bh=VbNf0q8EHb1RO3XqN/5HxttXoTymyf7r19FJEZs8YDk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IcZqlwrbVHs/BaP0Z1/qB0ULyE0fKsN9Xm9TwO9DBXqPqzJ++E2u4zVrO/jj7pvlY
	 DGJnyfDnc8PNBEG8DBwi4R7EBQCmOTuQqtoM/5CJyBZQnFeh1IetBtz6t2dEwEEcNo
	 3O1hAFKeVVTbbnohqitlkzZzqTi51CbOZKudMeBU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sander Vanheule <sander@svanheule.net>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 431/776] ASoC: sti: Return errors from regmap_field_alloc()
Date: Sat, 30 May 2026 18:02:25 +0200
Message-ID: <20260530160251.576874423@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
References: <20260530160240.228940103@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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



