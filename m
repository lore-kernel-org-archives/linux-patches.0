Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9BB33F789B;
	Wed, 20 May 2026 18:06:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779300399; cv=none; b=u69UgZKB9hx+rB4jdVOKRR7fpWZ7TjTsQpyHQQMzzx+IOJWEHprYrIbrE215AdsSTSSB+MDp3jJPlhDRPceVw853xXSrvbQnlqAQl0r8qIGN/GD96H3wKtyQ8Rgw0MuyflK/HDhTVt0HWbInXtcZGvuwZjuOLjAhJ8L+unARCJE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779300399; c=relaxed/simple;
	bh=dcxWux29KvfBdshv6Ozi9DaLvloDrr3B+CyrpsLzQKI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DOZ/WJrBol/Aqk/ZzCQxQbLf6Gjh7+TK9apB9sNXg7iJrYaDl2bKx/HmrnMiinSOXE0W5oKx1gsAeI8yeRXAhW/MyVnoYpMtDDS5SWDGkBvabf4M/eZxfzVsl7UYDkLfhF8sd+4quZ8huyStZN55lb+4Pby2b8y++WN2GGCDtaE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MB4+ZrgU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MB4+ZrgU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 217E11F000E9;
	Wed, 20 May 2026 18:06:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779300398;
	bh=lJ8NKq0ULcRLdW4QI9AQTqlPRQiDdQZ/J90yJoHv1ZA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MB4+ZrgU0bJQP2LH3XxMnmFprbAA8kuOZYDtYVBibyOh321d2+ldbYMGuXDzBi//7
	 82wql2DDqH3R/QlPVFFAdzioK17XoWXxqTzE0dVdJIjoSM8fwTM4yKjpbJ2Qtu9AP+
	 Olse1tjMqPCBnhmQsv4e/Y/lSbjlIc4pTLtwnSEg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sander Vanheule <sander@svanheule.net>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 123/666] ASoC: sti: Return errors from regmap_field_alloc()
Date: Wed, 20 May 2026 18:15:34 +0200
Message-ID: <20260520162113.882920618@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162111.222830634@linuxfoundation.org>
References: <20260520162111.222830634@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 6d1ce030963c6..f1b7e76f97b58 100644
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



