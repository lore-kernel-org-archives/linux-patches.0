Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A8A4254873;
	Mon, 23 Jun 2025 13:27:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750685274; cv=none; b=Z7XKwCMlWLCWsOJ3Aev5UWJzaeGdzOjB2MzKU7yWUJ+hV8PP3Jvcqkcp9hF/CilOXXmYJKDkrjwfVDDduNWVyskBsMSVUzPZM30kvp5OWiaCPbDdMheVGuEInv99f/jqqdazey9qWMg2k3jsYISUeqnmPUK/WPJuWO/9zSm2Jp0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750685274; c=relaxed/simple;
	bh=lhg60KX9pfrlol44a2EP8NsW8SrR+r+nDxrYdTwcIQQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g+y6VDjpWdRpsrCKxuuAL1kD6zrzds3ANazw0xSzfZfRjlN2CODeSqbu2JvraBmFa5/TzPJx//T/BNWqWvICFJDPaP8ZnpDdMSEirWswrNqBo1KEhq1KVA70634zxkAvPyw+8G2vRX2aabpF+ke/FZvpWyhxtIh+Ln/VLdaj4+M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xYKQERka; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xYKQERka"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F90CC4CEEA;
	Mon, 23 Jun 2025 13:27:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750685272;
	bh=lhg60KX9pfrlol44a2EP8NsW8SrR+r+nDxrYdTwcIQQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xYKQERkaE3wKxYAB8Tg0zbDY9G4EfwLvepqV5gHo7vzOUvgsFmD+e8pilyY6A9MvS
	 +bcduKDsh+jxEM+O9CcVgLX7i4MMx3gPgFs7R6VDtnYfc6TFRLZMVJe3qMpX0QmmXd
	 ysbNJ+hQdjjdSVkbFpUT2P5z8uaMqh7T8eL9NFw4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Shiyan <eagle.alexander923@gmail.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 022/411] power: reset: at91-reset: Optimize at91_reset()
Date: Mon, 23 Jun 2025 15:02:46 +0200
Message-ID: <20250623130633.668578952@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130632.993849527@linuxfoundation.org>
References: <20250623130632.993849527@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 64def79d557a8..e6743a3d7877a 100644
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



