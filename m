Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E77F549890A;
	Wed,  9 Sep 2026 13:57:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788962227; cv=none; b=V2xIAtyZeG/FPjD/FZA7wKToCQabIFBiWNHQHpvM4NA9bEezM8getVfZNuWqS6AD6UibwDs5uj7M7EgDCyI3+Z9hN/P9SBCc3NGY4jHbhKJdYGjdONivbjV5bL/VHGskyIH1clQdsk5mGgZO83WRjaD/FidqyAndAZtSCEnBw7Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788962227; c=relaxed/simple;
	bh=wCslgg647Z2524kqWLw/P74RA9USLqKYNLi3aDz5ShU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KJ7WDduvoFq6KBGPWO9lGe02PuaCX7BS03zebuL4s6Kjo1uxTorG4q6X1DAVBHsi647Tfk9J5SCVSYL8Gdz2gQPPWdUQviwMTigPsAXsTOU6YqIBHSsM6rFLHHl04ZvKmTI7vmbl23ehzx/KicU9CrJIhcQwczwWdDm9C8WqoJ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hI9kPZUq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hI9kPZUq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C5411F00A3A;
	Wed,  9 Sep 2026 13:57:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788962225;
	bh=nZQPEIFyJ9JF16NNF9Gr4byMcJ2XtTisoGnm91ysk8Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hI9kPZUqYcEhZgD8OP4R2JD8sPQXwaxX9Sx//pcqVMplAH+BUDbay019UozldsK6l
	 Sn7gbT6+3ADtfA2jwI6c0Bop1ERVTjm15o70D6elhSoea57M/I1mKjCOUWziArvAhg
	 NQFEGsnJwC6lBq2bfiBDB7OP09nkkSgVMV+Fnxko=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pedro Kopper <pedro.kopper@microchip.com>,
	Conor Dooley <conor.dooley@microchip.com>,
	Stephen Boyd <sboyd@kernel.org>
Subject: [PATCH 7.2 210/556] clk: microchip: mpfs: fix regmap_update_bits() mask/val order
Date: Wed,  9 Sep 2026 15:38:10 +0200
Message-ID: <20260909134237.775160816@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134230.441546314@linuxfoundation.org>
References: <20260909134230.441546314@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pedro Kopper <pedro.kopper@microchip.com>

commit fbfa013eeac299ecc015cb14fa40e382a23fb489 upstream.

mpfs_cfg_clk_set_rate() passes the mask and value arguments to
regmap_update_bits() in the wrong order. The resulting write becomes
reg = orig_reg | val, causing bits to not be cleared if the clock
divider changes.

Pass the arguments in the correct order so the divider field is updated
as intended.

Fixes: c6f2dddfa7f9 ("clk: microchip: mpfs: use regmap for clocks")
Signed-off-by: Pedro Kopper <pedro.kopper@microchip.com>
Reviewed-by: Conor Dooley <conor.dooley@microchip.com>
Cc: stable@vger.kernel.org
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/clk/microchip/clk-mpfs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/clk/microchip/clk-mpfs.c
+++ b/drivers/clk/microchip/clk-mpfs.c
@@ -285,7 +285,7 @@ static int mpfs_cfg_clk_set_rate(struct
 
 	mask = clk_div_mask(cfg->width) << cfg->shift;
 	val = divider_setting << cfg->shift;
-	regmap_update_bits(cfg->map, cfg->map_offset, val, mask);
+	regmap_update_bits(cfg->map, cfg->map_offset, mask, val);
 
 	return 0;
 }


