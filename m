Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10CBD3B1016;
	Wed, 30 Sep 2026 18:16:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790792190; cv=none; b=laGBN7VlKrF39zX9rhZis/LnZVriBevon2fu7ju0wKTq4RhsVvT8jEUrNtuRWcxoYOLUGMn6Jt2BIlkNwPNYWKW2o4SJAXQr54ozPYWtynAFsNXLgBX4NArUKAO2zd05xYloY9r39QniNlTclbN32iSYJ82RAyectswstejDUuQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790792190; c=relaxed/simple;
	bh=F6S1OVH4/B4DMp5SEBR5OXipMc2oHp0zXrN/mGTEyHM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GUb76JQoJm1hA43lm5lra3ioSduwl3eWBUPhEmsrGNjCiDYSY2I7Bz6xp0DdbeJmTim32EzQTp+mSnjoxH2rpNAKAvn/kyKkEXJb/4wvfzJXY7N/UWrjgf4SSEg915Vr1JHwlZW8gM6XDE2VYLuDYD3eubpjUZWbEW9rbqo8qDY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cToFfow0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cToFfow0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C5F41F000FF;
	Wed, 30 Sep 2026 18:16:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790792189;
	bh=fEuhcxp3hK0aAXEzyHTrMPCkYVGna+SGU9C6HHaoTWg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cToFfow0h26bCDU8RclORphBCXqpFCmPSmvgLCdPfCxB92QO1As3mUSt694rO8C4l
	 V2AmT/fYZND2WQUN1cORfQGKHCYM0Xwx6nNxUMnM5tb21FrMg4cQRG1chKKTZzIT1P
	 8XP5Le1SmUNNcZXirH3kEvnaQ2ZiQJiFuMneKn1E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tzung-Bi Shih <tzungbi@kernel.org>,
	Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 5.15 568/752] watchdog: msc313e: Fix premature reset during timeout update
Date: Wed, 30 Sep 2026 17:27:18 +0200
Message-ID: <20260930152410.526638614@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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
@@ -37,6 +37,9 @@ static void msc313e_wdt_set_hw_timeout(s
 {
 	u32 t = timeout * clk_get_rate(priv->clk);
 
+	/* Clear before to prevent premature reset during non-atomic updates. */
+	writew(1, priv->base + REG_WDT_CLR);
+
 	writew(t & 0xffff, priv->base + REG_WDT_MAX_PRD_L);
 	writew((t >> 16) & 0xffff, priv->base + REG_WDT_MAX_PRD_H);
 	writew(1, priv->base + REG_WDT_CLR);
@@ -67,6 +70,9 @@ static int msc313e_wdt_stop(struct watch
 {
 	struct msc313e_wdt_priv *priv = watchdog_get_drvdata(wdev);
 
+	/* Clear before to prevent premature reset during non-atomic updates. */
+	writew(1, priv->base + REG_WDT_CLR);
+
 	writew(0, priv->base + REG_WDT_MAX_PRD_L);
 	writew(0, priv->base + REG_WDT_MAX_PRD_H);
 	writew(0, priv->base + REG_WDT_CLR);


