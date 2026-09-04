Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7F68378838;
	Fri,  4 Sep 2026 06:02:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788501759; cv=none; b=IR+2TKOOq+j2kTpYAbAi8Mcu77hGGP7994zAecbTZoDzm1X+NHP1zBkujvM4tAkQ5/Q2p5YV5o81hsUuju2uh7prLuIniMDBQC65C5TRU59ijzXLWTjDYVdE0y0yn7R/UH+NuoTRfkJd87/SKmnoomp1xyGi1S7oFT6d0eQUGGs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788501759; c=relaxed/simple;
	bh=5uNl1gUhHyoY8UI9WWe7uFTUrHGlihIp7htACsnGgIU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Gckq4gVhdWvx5ymK9SWPgMAi92aIUPDNSetHtaiM+B5XOW91Jo55VwU5drBuVi9nR24fqQh9RlCay2N8OQCHeX9HRvbUJ2uNyTOFjSYH/5+3jDF9Tnd2J57GKcUUQH0fE8nRhU1QfA9cvbeTOVVnDQtB+pjiFzVEj3ghX4iuvP0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y33GVzZP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y33GVzZP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 452481F00A3D;
	Fri,  4 Sep 2026 06:02:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788501757;
	bh=QTwDFu+fjrfBk3pbADOczSdlMtfxjM1OpPrsEeJdNQA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Y33GVzZP1UEs8d9YoB0xT7GSKLzkGgyZ8C8u4Bpe0SEmX4ayu21tMvZOLQOGHGwGb
	 l+I9GmM5KI/GCt5qJL+Y3UC9RHVrjK1qfFuBP1saYLOfaNMH4schdq9ERcddrnGsxg
	 wm3g6lp/UjY4E1zlyKZXMP83bWVbYumJ0C0OyPoI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Li <Frank.Li@nxp.com>,
	Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>,
	Tommaso Merciai <tommaso.merciai.xr@bp.renesas.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>
Subject: [PATCH 6.18 521/552] i3c: renesas: Reconfigure the DATBAS register on re-attach
Date: Fri,  4 Sep 2026 07:01:18 +0200
Message-ID: <20260904045802.440286742@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045747.813364717@linuxfoundation.org>
References: <20260904045747.813364717@linuxfoundation.org>
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

From: Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>

commit 1364afd3e2e76e007a2c07ec95704d56980226f0 upstream.

During re-attach, the device may change its position in the i3c->addrs[]
array. As a result, it may use a different Device Address Table Basic
Register (DATBAS), which needs to be reconfigured.

Reconfigure the DATBAS register on re-attach. Along with it update
software caches.

Fixes: d028219a9f14 ("i3c: master: Add basic driver for the Renesas I3C controller")
Cc: stable@vger.kernel.org
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>
Tested-by: Tommaso Merciai <tommaso.merciai.xr@bp.renesas.com>
Link: https://patch.msgid.link/20260713130545.568657-5-claudiu.beznea+renesas@tuxon.dev
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/i3c/master/renesas-i3c.c |   16 ++++++++++++++++
 1 file changed, 16 insertions(+)

--- a/drivers/i3c/master/renesas-i3c.c
+++ b/drivers/i3c/master/renesas-i3c.c
@@ -893,10 +893,26 @@ static int renesas_i3c_reattach_i3c_dev(
 	struct i3c_master_controller *m = i3c_dev_get_master(dev);
 	struct renesas_i3c *i3c = to_renesas_i3c(m);
 	struct renesas_i3c_i2c_dev_data *data = i3c_dev_get_master_data(dev);
+	int pos;
+
+	pos = renesas_i3c_get_free_pos(i3c);
+
+	if (data->index > pos && pos >= 0) {
+		renesas_writel(i3c->regs, DATBAS(data->index), 0);
+		i3c->addrs[data->index] = 0;
+		i3c->free_pos |= BIT(data->index);
+
+		data->index = pos;
+		i3c->free_pos &= ~BIT(data->index);
+	}
 
 	i3c->addrs[data->index] = dev->info.dyn_addr ? dev->info.dyn_addr :
 							dev->info.static_addr;
 
+	renesas_writel(i3c->regs, DATBAS(data->index),
+		       DATBAS_DVSTAD(dev->info.static_addr) |
+		       datbas_dvdyad_with_parity(i3c->addrs[data->index]));
+
 	return 0;
 }
 


