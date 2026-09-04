Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58C703ECBCF;
	Fri,  4 Sep 2026 05:36:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788500167; cv=none; b=esQ8y1Y5wlMVbrqBMfkOqKeKa3r0vZ2W5abCwrL1tCrU3FV2qbX9zQJYA2g+BMQnqYD+u3HTyNAHiAOhAli8rLDnlytaG5Y1A6B8UKxeMFwTVX+7tkdUPP3Pej0FYtYoLxo2Iy5987zEkziwdSbJ4UPZYl+N8pZGmms5j7g50VQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788500167; c=relaxed/simple;
	bh=Cv68RtNkodPbvmLvEGdt3IDFKBuz5I9f8nsLLdXDCPY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gvEyhlJJeyr9+r/p5LZhRiBRwZMIxNuMKFUAF+xAbfO40pCYpVD2JrZjeSnFvydX6v/WP+pe8Bpt83Is3lVulDCwL4cOA0ddnCxZptVi4AoaWvHVenNHMmK2vtS8W0Dz6N3jUZ7rXnAoytiUcdnwwbz93CveWb7VYjpS3BLoCu0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nFo8Kara; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nFo8Kara"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B244C1F00A3D;
	Fri,  4 Sep 2026 05:36:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788500166;
	bh=m14aFnNDkoTAiGbGUmjeUvWprF1D8gEgZbevHm9krE4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nFo8KaraCyKExIWg5al7yzYly+dTKE+h11ROuiBFW9DnDetkXGO2mSdgl+FQdx0fa
	 GKwpNklmgsyq79vd73kiCnt/ayOdpN+RPhXd46tVS7hVqMOxJf51Akl0IR51ckWUN2
	 WW/dczcITxrYhdQ70qBSVSFM1hbyW2KlOBUVktKM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Li <Frank.Li@nxp.com>,
	Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>,
	Tommaso Merciai <tommaso.merciai.xr@bp.renesas.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>
Subject: [PATCH 7.2 672/713] i3c: renesas: Reset the controller on resume
Date: Fri,  4 Sep 2026 07:00:40 +0200
Message-ID: <20260904045818.898776265@linuxfoundation.org>
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

commit 27cf0ad162f1a4526a86fc2ec24d84a4a98ac1dd upstream.

Reset the controller on resume after enabling the clocks to follow the
same sequence as in probe and avoid potential ordering related failures.

With it, renesas_i3c_reset() was updated to use read_poll_timeout_atomic(),
as the driver's resume callback is executed during the noirq phase of
resume, where interrupts are disabled.

Fixes: e7218986319b ("i3c: renesas: Add suspend/resume support")
Cc: stable@vger.kernel.org
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>
Tested-by: Tommaso Merciai <tommaso.merciai.xr@bp.renesas.com>
Link: https://patch.msgid.link/20260713130545.568657-6-claudiu.beznea+renesas@tuxon.dev
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/i3c/master/renesas-i3c.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

--- a/drivers/i3c/master/renesas-i3c.c
+++ b/drivers/i3c/master/renesas-i3c.c
@@ -494,8 +494,8 @@ static int renesas_i3c_reset(struct rene
 	renesas_writel(i3c->regs, BCTL, 0);
 	renesas_set_bit(i3c->regs, RSTCTL, RSTCTL_RI3CRST);
 
-	return read_poll_timeout(renesas_readl, val, !(val & RSTCTL_RI3CRST),
-				 0, 1000, false, i3c->regs, RSTCTL);
+	return read_poll_timeout_atomic(renesas_readl, val, !(val & RSTCTL_RI3CRST),
+					0, 1000, false, i3c->regs, RSTCTL);
 }
 
 static void renesas_i3c_hw_init(struct renesas_i3c *i3c)
@@ -1489,6 +1489,10 @@ static int renesas_i3c_resume_noirq(stru
 	if (ret)
 		goto err_presetn;
 
+	ret = renesas_i3c_reset(i3c);
+	if (ret)
+		goto err_clks_disable;
+
 	/* Re-store I3C registers value. */
 	renesas_writel(i3c->regs, REFCKCTL,
 		       REFCKCTL_IREFCKS(i3c->refclk_div));
@@ -1506,6 +1510,8 @@ static int renesas_i3c_resume_noirq(stru
 
 	return 0;
 
+err_clks_disable:
+	clk_bulk_disable(i3c->num_clks, i3c->clks);
 err_presetn:
 	reset_control_assert(i3c->presetn);
 err_tresetn:


