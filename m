Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 999BF402453;
	Tue, 21 Jul 2026 17:18:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784654342; cv=none; b=m2BYHhxownBywYB5v7Wbs3ts6awyXDLVNE4XBfjOPPIsgMyTHNGGdzsmh4Ncu357ovMcWv0ClBYkIeNRrHahkaxKl6Y5ntqdQn/F/lwwymqvxhQV5eJJtAUCCEhORiAocRugUq2KrY3u6D09ynbYVIYKii5qUTiNAN8mxhvDH9E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784654342; c=relaxed/simple;
	bh=m4THy4cDQWWJ22FQPirdBvCmNkJ11PTJ2BUDhYM0L8k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tqY7wFezySPgMR9YXEYdp8JiQ8zrqO91y4Heh1WTQtaIayfknTum5rW1y88eWNmbB5p1midHkENBO2pwMRws5IPzherMVLjxO7DyGGj6zHQvJO//IqamOl7jSghymeK+kdPzJcTh6cPQWqvHeMfu8oPeiAb4MZzsO2y2EvHngbI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=R3oMvc9t; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R3oMvc9t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 068631F00AC4;
	Tue, 21 Jul 2026 17:18:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784654338;
	bh=mgbgvLZ4NPIVLFIvgjSDgdqNuM/oidhX1J01B8iOYRQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=R3oMvc9tp8U/F1g7BgGScyXsD6lp/HyWAxRTE3KwL0Tub/jxvuUAjihEHmCLn5el+
	 Csg173zoZ6jablD5HhZrfe2KQNEnyrY1076VvbGaTPSm6GVH9pLQxdz4R4gu5bcghP
	 P9PiOTji4KumtoQE2V+EXyaBdj4x9P3H5PyZgAJ8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH 7.1 1660/2077] pinctrl: renesas: rzg2l: Use -ENOTSUPP instead of -EOPNOTSUPP
Date: Tue, 21 Jul 2026 17:22:13 +0200
Message-ID: <20260721152631.899314967@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>

commit c1492da3939c89372929e062d731f328f7693f1e upstream.

The pinctrl and GPIO core code make exceptions for the -ENOTSUPP error
code.  One such example is gpio_set_config_with_argument_optional(),
which returns success when gpio_set_config_with_argument() returns
-ENOTSUPP, but reports failure for all other error codes.

Returning -EOPNOTSUPP from the pinctrl driver on the unsupported pinctrl
operation may lead to boot failures when pinctrl drivers implements
struct gpio_chip::set_config, the system uses GPIO hogs, and the
struct gpio_chip::set_config implementation returns -EOPNOTSUPP for the
unsupported operations.

Return -ENOTSUPP for the unsupported pinctrl operation.

Fixes: 560c633d378a ("pinctrl: renesas: rzg2l: Drop oen_read and oen_write callbacks")
Fixes: c4c4637eb57f ("pinctrl: renesas: Add RZ/G2L pin and gpio controller driver")
Cc: stable@vger.kernel.org
Signed-off-by: Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>
Reviewed-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Tested-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://patch.msgid.link/20260515124008.2947838-2-claudiu.beznea@kernel.org
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pinctrl/renesas/pinctrl-rzg2l.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/pinctrl/renesas/pinctrl-rzg2l.c
+++ b/drivers/pinctrl/renesas/pinctrl-rzg2l.c
@@ -1103,7 +1103,7 @@ static int rzg2l_read_oen(struct rzg2l_p
 	int bit;
 
 	if (!pctrl->data->pin_to_oen_bit)
-		return -EOPNOTSUPP;
+		return -ENOTSUPP;
 
 	bit = pctrl->data->pin_to_oen_bit(pctrl, _pin);
 	if (bit < 0)
@@ -1145,7 +1145,7 @@ static int rzg2l_write_oen(struct rzg2l_
 	u8 val;
 
 	if (!pctrl->data->pin_to_oen_bit)
-		return -EOPNOTSUPP;
+		return -ENOTSUPP;
 
 	bit = pctrl->data->pin_to_oen_bit(pctrl, _pin);
 	if (bit < 0)
@@ -1576,7 +1576,7 @@ static int rzg2l_pinctrl_pinconf_set(str
 			break;
 
 		default:
-			return -EOPNOTSUPP;
+			return -ENOTSUPP;
 		}
 	}
 
@@ -1658,7 +1658,7 @@ static int rzg2l_pinctrl_pinconf_group_g
 
 		/* Check config matching between to pin  */
 		if (i && prev_config != *config)
-			return -EOPNOTSUPP;
+			return -ENOTSUPP;
 
 		prev_config = *config;
 	}


