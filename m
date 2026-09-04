Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A00E94137B2;
	Fri,  4 Sep 2026 05:36:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788500161; cv=none; b=hogIsc/quRU4oFPBR3Qqbr4rJtlIibGONMnzSoXCUhzUCLTJ7yklUSbfJ6QGtMOAF8u0rstI0sXx7kCuemVT5jzG4c6jPotys/AjCgvVfWhcfe6qcr6bNHVxHSqNezrGHPpEQtuo31PGQgSI9FpsF9VTn3Y37fbS90d8XwbHtjI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788500161; c=relaxed/simple;
	bh=e5OOO+rDHvc5ta1l0I0IeqcTU1rmX9s9V0JwIi0ACHM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qy0qHOQAd6/5TrFfXcQ9C0fhC8WYSuJ2Cf4wxVt/GOmCDKXz11xEfNfHwQl8EsL0BpzYHlLMHtA6P9ORuADWkUSigXO8zDZi6AeOHwV0K9F2LHhNjI3017CbeE61HVZDkTCv3QJ0xxItaeFBhvU6CNW/TrHdUyY2SXc30uP5XoY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MMRgW1yl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MMRgW1yl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 038651F00A3D;
	Fri,  4 Sep 2026 05:35:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788500160;
	bh=UjHR5qM4jQeemKIUQSU0PzoWcuI0nm4IvJihx2o0ZjY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MMRgW1ylrTe786lQydPCAXChBBefcY1MBq4PkNNVxT5lNfzq82AlcAY1wERG96dT9
	 aGTJGq2xyvRopcZuWZdZeRptL7GTeEoSkcBJEPA/g7sZ8KkT5y9BI6gSPOcmBfAQPc
	 xVLOYfNfHH9ZDniW+CYxABIsdEegFlLfmjNo0rTg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Li <Frank.Li@nxp.com>,
	Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>,
	Tommaso Merciai <tommaso.merciai.xr@bp.renesas.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>
Subject: [PATCH 7.2 671/713] i3c: renesas: Reconfigure the DATBAS register on re-attach
Date: Fri,  4 Sep 2026 07:00:39 +0200
Message-ID: <20260904045818.877064446@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
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
@@ -911,10 +911,26 @@ static int renesas_i3c_reattach_i3c_dev(
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
 


