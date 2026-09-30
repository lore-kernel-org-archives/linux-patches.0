Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB6AD3CC300;
	Wed, 30 Sep 2026 19:27:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790796432; cv=none; b=RPVyAB8PoZVP94H5iSXnkstbBMRPPEuX0u2+GEbGBW1RbfwqdDTNF2CrHl8AQcdIp21uLDyykwPnOGHbTA6i6P557j6JSfIE+oi3yvL/WjtWob1mUAh+e3I6NwHRaQaSI9Wil45yKXdDbVOs9wfXlMjrzqjGLTp6RDjSEtYDdhA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790796432; c=relaxed/simple;
	bh=0HrrK/e+JYZOnpmDqC4oMXMXyCKG9KCFgTgKu2/MEWo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ey671kCKhk7tzSbsCe6PZsj1Yc4W9KA3L6hC35tVMN9ok7Itv0pcy7Pgo9uj6SpzpXJXCBeJ4FEbCdGEHo1uU6pJTMbEV4vTMU5s95bvwlvsk0iklMMoJ8Wvum+ClxsNYN/J5bZsoneaJlerTMCNH97wGyYZ1+cRB8bWMN3D1do=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MUAbLZB2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MUAbLZB2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D321B1F000FF;
	Wed, 30 Sep 2026 19:27:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790796431;
	bh=MTDhRdCN3wtrGcGjXpsl+DnEntCgeTM1sukMYPVTD8g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MUAbLZB24PQE70gqLS8QJ16NUFpb7C2SeJSAUOXmtNYxSUhwKmI196lFKqIZgzzGn
	 XhnVD1LxqjC6vl+FXNqWqPu9W9GXoqVt4SgwFgARIFiux4WH+sVkXmUNCd1UGIgI2K
	 GBraEall8UL1jE77zCoXlUcA8G/1RLKz4Eo0N/+M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tzung-Bi Shih <tzungbi@kernel.org>,
	Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 6.6 0912/1193] watchdog: msc313e: Fix premature reset during timeout update
Date: Wed, 30 Sep 2026 17:26:36 +0200
Message-ID: <20260930152454.505206313@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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


