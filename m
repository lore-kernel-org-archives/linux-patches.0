Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B496519DF2;
	Wed, 30 Sep 2026 17:20:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790788811; cv=none; b=nAD8QALArMBI0n0ZA7on0XcawkI0g6gT4nclCPjN/47VG1+aRMk59S6GI8zdz3+TZLVWR7STdAHWFbewRg6nfWayoIXR3awJITsDoselXt24W7szxyewrm+XApizJnVVU3s4/C3rCJXa54toqRqv6+FE+PzoHURbeGc8zJVyE+A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790788811; c=relaxed/simple;
	bh=oHVyqUsuc2Ns+nsY3rEs9yVPwYDSyb6hiUVdw6jNYow=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y0K+G1RIijxg36kxqTfihm4rq7VPpxE3PnHpcIdvKTpoY1/fwwhmD2NIhVGLqXMq1+x8SLy2YZGftkHfopWjoogx56f9HIxSaontVa/LowFWrK+tjkj01jswO8Eb97zt99fhdE65P3QrOpyx0euezjzHP/0ASGl686hDoeIR9+4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xRm3nQdI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xRm3nQdI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85C281F000FF;
	Wed, 30 Sep 2026 17:20:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790788810;
	bh=NPULQL+EZKT+NhuacoNEwXoWTEIZyltIUmTQpy7dzgU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xRm3nQdIpt6Nkh2j7SWH37UOZEaM92LpdGHFGxLHB0w211ixgsTKkjP3qmJGIlIcC
	 yNJEv3xBDm48I+bn2nOepNlp9JE9UVpaeICOFCT+X66giZm7hN2UcLXQY+Ka7WJSji
	 2Z+Y5BG3dqcid/ac+3nI7lu0EmXF4fXeVPjXiGBg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tzung-Bi Shih <tzungbi@kernel.org>,
	Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 6.12 254/877] watchdog: msc313e: Fix premature reset during timeout update
Date: Wed, 30 Sep 2026 17:19:25 +0200
Message-ID: <20260930152420.203012889@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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

From: Tzung-Bi Shih <tzungbi@kernel.org>

commit 22737cfced627ffcb4b5c36d63bb3d4476f63213 upstream.

Updating the 32-bit hardware timeout requires writing to two 16-bit
registers sequentially.  If the watchdog is actively running, this
non-atomic update might trigger a premature system reset.

Clear the watchdog counter before updating the registers to prevent the
timer from timing out prematurely against an intermediate threshold.

Fixes: e9800b799464 ("watchdog: Add Mstar MSC313e WDT driver")
Cc: stable@vger.kernel.org
Signed-off-by: Tzung-Bi Shih <tzungbi@kernel.org>
Link: https://patch.msgid.link/20260913065126.8350-1-tzungbi@kernel.org
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/watchdog/msc313e_wdt.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/watchdog/msc313e_wdt.c
+++ b/drivers/watchdog/msc313e_wdt.c
@@ -47,6 +47,9 @@ static void msc313e_wdt_set_hw_timeout(s
 {
 	u32 t = timeout * clk_get_rate(priv->clk);
 
+	/* Clear before to prevent premature reset during non-atomic updates. */
+	writew(1, priv->base + REG_WDT_CLR);
+
 	writew(t & 0xffff, priv->base + REG_WDT_MAX_PRD_L);
 	writew((t >> 16) & 0xffff, priv->base + REG_WDT_MAX_PRD_H);
 	writew(1, priv->base + REG_WDT_CLR);
@@ -77,6 +80,9 @@ static int msc313e_wdt_stop(struct watch
 {
 	struct msc313e_wdt_priv *priv = watchdog_get_drvdata(wdev);
 
+	/* Clear before to prevent premature reset during non-atomic updates. */
+	writew(1, priv->base + REG_WDT_CLR);
+
 	writew(0, priv->base + REG_WDT_MAX_PRD_L);
 	writew(0, priv->base + REG_WDT_MAX_PRD_H);
 	writew(0, priv->base + REG_WDT_CLR);


