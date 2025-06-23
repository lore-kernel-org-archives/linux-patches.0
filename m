Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B313254AF0;
	Mon, 23 Jun 2025 13:23:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750684996; cv=none; b=mRm3aRP5MfV+lxz3RHtdUEIsr+uz3PbWPT4Wr0ph//8yy8bS0X0rLs0x3icwWyqxgxS3SmM2UqE9xAvpwWtv9PMHgC9WMh4n5rg61zT12P/jHaFnMaDyC6afMBtcaXe5oE+LsK/OQJ7G1NXeFWo0PsYPDHWiZYaWsT/FIAI9vFI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750684996; c=relaxed/simple;
	bh=kfY55+D22fQv2HYzrlhfk1AU6w+fN3OXhOS06xFVzT8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o5f8oMsLmwRflJR2mZNTU/l/tNKEj3TLAQ4U/q1ksiQAUSMwBlhUfi1y4xQozWlFb2xF6rxOdwjyrpR1pBV3HV4wxaxqqgWHnEJQojAZhrcO6FyxmGA99VFK/qVbxUAfeY1F0q48DM55Yva4BnXMKvQ2Lg8oVzz6tArmJ5ICHR0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Cs6gH9Y1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Cs6gH9Y1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98D3AC4CEF2;
	Mon, 23 Jun 2025 13:23:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750684995;
	bh=kfY55+D22fQv2HYzrlhfk1AU6w+fN3OXhOS06xFVzT8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Cs6gH9Y1ceQ3cSGxIJXpv+Bjc6RxPtRzN8IwuUiswbzvpuLW/iT7/pZoajRBBWdzi
	 p39M5DzCUKW5q5E4yGFEfwh7ioYiDBee1CD1yOBmnFJJNLKjqe30aPSm5lzTF5n0pO
	 Vua8HgIXa9wPSYSZ0pLUiCiFuvrPjqNoNBnVtrjI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Shiyan <eagle.alexander923@gmail.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 020/355] power: reset: at91-reset: Optimize at91_reset()
Date: Mon, 23 Jun 2025 15:03:41 +0200
Message-ID: <20250623130627.405807811@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130626.716971725@linuxfoundation.org>
References: <20250623130626.716971725@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexander Shiyan <eagle.alexander923@gmail.com>

[ Upstream commit 62d48983f215bf1dd48665913318101fa3414dcf ]

This patch adds a small optimization to the low-level at91_reset()
function, which includes:
- Removes the extra branch, since the following store operations
  already have proper condition checks.
- Removes the definition of the clobber register r4, since it is
  no longer used in the code.

Fixes: fcd0532fac2a ("power: reset: at91-reset: make at91sam9g45_restart() generic")
Signed-off-by: Alexander Shiyan <eagle.alexander923@gmail.com>
Reviewed-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Link: https://lore.kernel.org/r/20250307053809.20245-1-eagle.alexander923@gmail.com
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/reset/at91-reset.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/power/reset/at91-reset.c b/drivers/power/reset/at91-reset.c
index 3ff9d93a52267..6659001291f41 100644
--- a/drivers/power/reset/at91-reset.c
+++ b/drivers/power/reset/at91-reset.c
@@ -81,12 +81,11 @@ static int at91_reset(struct notifier_block *this, unsigned long mode,
 		"	str	%4, [%0, %6]\n\t"
 		/* Disable SDRAM1 accesses */
 		"1:	tst	%1, #0\n\t"
-		"	beq	2f\n\t"
 		"	strne	%3, [%1, #" __stringify(AT91_DDRSDRC_RTR) "]\n\t"
 		/* Power down SDRAM1 */
 		"	strne	%4, [%1, %6]\n\t"
 		/* Reset CPU */
-		"2:	str	%5, [%2, #" __stringify(AT91_RSTC_CR) "]\n\t"
+		"	str	%5, [%2, #" __stringify(AT91_RSTC_CR) "]\n\t"
 
 		"	b	.\n\t"
 		:
@@ -97,7 +96,7 @@ static int at91_reset(struct notifier_block *this, unsigned long mode,
 		  "r" cpu_to_le32(AT91_DDRSDRC_LPCB_POWER_DOWN),
 		  "r" (reset->args),
 		  "r" (reset->ramc_lpr)
-		: "r4");
+	);
 
 	return NOTIFY_DONE;
 }
-- 
2.39.5



