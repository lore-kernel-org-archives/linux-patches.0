Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16D752EBDC0;
	Tue, 17 Jun 2025 15:31:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750174314; cv=none; b=QFTt9Vkst7Qk31Nt6HydoA8bzjjv8He9M8TQSs04lUQSytgVCwyEIgaP+Qmylpf7qEkHMhFBXiVp5w5kgjuytm2JvTTjKiZZK8zvdqXkrpC/mN5iHMOSdOYKM3JZY0MWFJbr2EYIy2+WjLhUuMPORvcrL06XVHz6NGxEuhec8Mg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750174314; c=relaxed/simple;
	bh=kpHOF+VfuxHxbhKWnwVB/C8amXysBW2rqrnYh22gbvU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oSacwXgjeZeAmzkcTzBsXOgVCbxFFulcfwkQJthSUd5Cuu9Xb9IWyo+2iriqGInCZkEOZ9UNMKR0yLu3USWM3XxcPIGynhbry1MWOpKrh/TtlxJy26AQFGdgg/BgkAbsaF4Hf/ReHHsjRccXofFoucixiIGb/kI1ofL6h0nKog0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DAXylAq/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DAXylAq/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88CADC4CEE3;
	Tue, 17 Jun 2025 15:31:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750174314;
	bh=kpHOF+VfuxHxbhKWnwVB/C8amXysBW2rqrnYh22gbvU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DAXylAq/XcA3iZ8U20xbfPUqgZ6XrV8D/vZ4JCWYa2sHZwu72Sb1LyBjfV2okuO5D
	 Y24PgJWdUxRiuI5m0mX9cxA1m2EM8H6VvDL6xvvTa40JI9ArJZ+BJnZBbvdDh1zjuT
	 VXu+U1gf9/crNQYUmiG3LQ3nSF/55HIMlH9goPE0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Shiyan <eagle.alexander923@gmail.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 047/356] power: reset: at91-reset: Optimize at91_reset()
Date: Tue, 17 Jun 2025 17:22:42 +0200
Message-ID: <20250617152340.131217211@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152338.212798615@linuxfoundation.org>
References: <20250617152338.212798615@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index aa9b012d3d00b..bafe4cc6fafdc 100644
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



