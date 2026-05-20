Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C17E53F39D1;
	Wed, 20 May 2026 17:24:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779297873; cv=none; b=KzVbUaswVVp75svouD5aB9bMy3onDLbVy/iC10sxOOFTWfDli+7vRB2/ukT8wn9SU1aouSI2EJiuB3k9Ner0bdAUYUCsj/5V5/tz3BX64JfcQYOerX4Jiv22uvTwv1J3EZ2gYiRCVVBKGXwDHZ2Xo5sNibxRDeAjBanVxdPqbcg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779297873; c=relaxed/simple;
	bh=c0f2kAH5M/WBn7T5Ns4Nht7SIiO7E6TJEdWLWbtdFIQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kniqOCYfOuM4zUgwWjRrBp9HSLO3g+CxMfSJRDGw4B0bITVFWplbMDn/TVyrHf/FlFUOvt8zUg/twqUiozyuRaXFB1IEAuDCrTl3fZWTp2kN7MPkZ20ccdX3caAPc7pm1NeQFF24Hh4hpeEGAHwbOHSKjMgOrcf92BS3qSW2FIg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tmffejLA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tmffejLA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 340D91F000E9;
	Wed, 20 May 2026 17:24:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779297872;
	bh=0b7W+KSzb7WzkTqq2zJV6yvoBPzvvHb29DagiT6iDuI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tmffejLAOPdQQjoDub8ES+z1CAIOjr/8AsS3GOonKYmveVpQu/cKenistDgJDEBJl
	 kIfwVQy/WByTeyuWPbVaMEYgDvwzN2s2tKrNorXKkaoN1//PaSEzQhGIzI19co4uv8
	 8e/kA4TFS4CLLhxMBR59awZo+PMowy3wTwOsTmL4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sander Vanheule <sander@svanheule.net>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 196/957] ASoC: sti: Return errors from regmap_field_alloc()
Date: Wed, 20 May 2026 18:11:19 +0200
Message-ID: <20260520162138.801018536@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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



