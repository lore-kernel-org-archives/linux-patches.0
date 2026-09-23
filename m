Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36439533582;
	Wed, 23 Sep 2026 14:31:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790173887; cv=none; b=Li8rbqu0DchGD53GwjBZ8T9SrMKEcZU07SYhw0PuITi9QLs9I/o/E0FZNGR9EDgSX7/KERb9WY3bgV79YNebQyYA3FQxKg0nUMs1LWewLyeF58l2i3zdlMoE9UVMTsLS6SldaNvjqqZYVmxp19Q0wf3XBkxCZphvyZImCi4lSXE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790173887; c=relaxed/simple;
	bh=Q6uH1cnUj8B19UkP79waGDiQWxH3va4ehger/skVZww=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E5Uh0wYaLI8e+Jtw5qAr4d2BmVZORk4nh6rHesemhyrBJcnAVrGSlMXcrZ0C7zcSVIZUcxEq75T/o/ZgxPlYJVwVxYdvZbhhaKblSBMhBaXd6CCbnab2ZMtOivWeX98lN29uFnE0ZtOFOqWrA4iZ1dSFMpF3Ln/tElDIJqZCbKQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IwQSavgB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IwQSavgB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 316191F000FF;
	Wed, 23 Sep 2026 14:31:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790173886;
	bh=H8GHrxtcHqgDp+ibyYFnJ4P0uHnhKuDcflKFhUQTx0U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IwQSavgB2j9VqkgATUUuQtvfQe5hnt+p7gtkXsbavfyiPSprrx0Kvnc+Uk2m6AR0K
	 OyiepS6QgZ7yd1ZGbmPxW1HF14Wwfo/tLjJ67bJlVhX+Tz8Tok6SumvaqGC6OVw+ic
	 n9BLqrg1x6CjjU/3MXqpU8uvBHix8S4jVNEVCTKo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tzung-Bi Shih <tzungbi@kernel.org>,
	Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 7.2 376/438] watchdog: msc313e: Fix premature reset during timeout update
Date: Wed, 23 Sep 2026 16:06:37 +0200
Message-ID: <20260923140654.609968811@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140644.756254324@linuxfoundation.org>
References: <20260923140644.756254324@linuxfoundation.org>
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
@@ -46,6 +46,9 @@ static void msc313e_wdt_set_hw_timeout(s
 {
 	u32 t = timeout * clk_get_rate(priv->clk);
 
+	/* Clear before to prevent premature reset during non-atomic updates. */
+	writew(1, priv->base + REG_WDT_CLR);
+
 	writew(t & 0xffff, priv->base + REG_WDT_MAX_PRD_L);
 	writew((t >> 16) & 0xffff, priv->base + REG_WDT_MAX_PRD_H);
 	writew(1, priv->base + REG_WDT_CLR);
@@ -76,6 +79,9 @@ static int msc313e_wdt_stop(struct watch
 {
 	struct msc313e_wdt_priv *priv = watchdog_get_drvdata(wdev);
 
+	/* Clear before to prevent premature reset during non-atomic updates. */
+	writew(1, priv->base + REG_WDT_CLR);
+
 	writew(0, priv->base + REG_WDT_MAX_PRD_L);
 	writew(0, priv->base + REG_WDT_MAX_PRD_H);
 	writew(0, priv->base + REG_WDT_CLR);


