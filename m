Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AF612DFF06;
	Tue, 17 Jun 2025 15:47:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750175232; cv=none; b=Yrhqm5l1VzWlacVnk0YNaUXrT5pVkHRp5zsLNK2r1Sl3RsQqAaoYyUwzjng1fobdcOxaT67n79NJcrEnzbNjw+ov8PQ4MuXA2mkTKIog/DgSJnPtcmpEDSrL5Cu47zQtu4LtduiqUd2TeAlW4i0+GQR4UizZejGnjJzq/FsZuI0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750175232; c=relaxed/simple;
	bh=2LxLBFwOE6WO88ls9/pzF81em2DlmLs+Wm83WkRQT2E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kE9u7eZslGUgFs8U6M4c5/kHTMb/yCYh3DeMIAk3BVAmdZHu3fn1PCH48+obdkmbg02YJRJztorQNta2syV7dW9d7RhNziOzT5aBE7039sYTWtThQ6gXIWJTxlWpqZZWII1D/BCxdfSntaGWfH3LGgsH4HwdfzZ9AC69h1xPLR4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UylLC26A; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UylLC26A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D452C4CEE7;
	Tue, 17 Jun 2025 15:47:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750175232;
	bh=2LxLBFwOE6WO88ls9/pzF81em2DlmLs+Wm83WkRQT2E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UylLC26AX8v9HJQMm7omcPthztE/wgdiBcb0iUMo6le1gQBzo1uYB5YkhMiSrd4IC
	 Y26toRypgiT+xGyuGeZGSDzJbMuBDQprUJMXRQZUuyY3dHAHIqKAz5M4RjWoTKeHaw
	 TFuHeepI2jDo/b/haJG67lw7CQbAMx9jZaRIqEZo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Shiyan <eagle.alexander923@gmail.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 065/780] power: reset: at91-reset: Optimize at91_reset()
Date: Tue, 17 Jun 2025 17:16:13 +0200
Message-ID: <20250617152454.144892186@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
index 036b18a1f90f8..511f5a8f8961c 100644
--- a/drivers/power/reset/at91-reset.c
+++ b/drivers/power/reset/at91-reset.c
@@ -129,12 +129,11 @@ static int at91_reset(struct notifier_block *this, unsigned long mode,
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
@@ -145,7 +144,7 @@ static int at91_reset(struct notifier_block *this, unsigned long mode,
 		  "r" cpu_to_le32(AT91_DDRSDRC_LPCB_POWER_DOWN),
 		  "r" (reset->data->reset_args),
 		  "r" (reset->ramc_lpr)
-		: "r4");
+	);
 
 	return NOTIFY_DONE;
 }
-- 
2.39.5



