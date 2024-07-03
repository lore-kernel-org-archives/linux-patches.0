Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFE30944D;
	Wed,  3 Jul 2024 11:05:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720004717; cv=none; b=jL5mW238vU/B2WYItDL2Qx+dpyUMe8i3zWVWKs7vwtI4+6BST8Bm4rm7Muwrmb6D+eNf20KneHSca7+GJU8OlsqZOQDumtA7srHUm+1Jjii4MxSchyA3ANGAtbQkXSzNDx+Oow8/EWBB1mjSXlhTkjATRpyu0Uh0mjYWp75k9Fg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720004717; c=relaxed/simple;
	bh=a8T9cbF7LIQSGqkYpT1m3IzKNTe+zLqzauPsdxb5+eA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oaZvJJp4tV56l9b0NOUvQwQx8XLO++Em8QjOovf6EX2LhKvRJObv8N6towZritp87XKFctyMfS0pqiywk/yoWZzJedXEJsMEJwlg2kG9yUldhT113OCeiHwyS2EVdTM2mN86qWw6gKVZt7+W/7/LUpvZd3RoRz7rQpXiIaLCSls=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0JM0EA1q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0JM0EA1q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDED2C32781;
	Wed,  3 Jul 2024 11:05:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720004717;
	bh=a8T9cbF7LIQSGqkYpT1m3IzKNTe+zLqzauPsdxb5+eA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0JM0EA1qEaVYm7bQed/qs1FtpJx04NRmcaxG/murv5OEYsJlQzro2mHjMJlhJpQ7+
	 rQ89YyppzzO1vFDkCBKcws+eazKwYwLeCop175GMOjGkYpAD3okesll4l6kwkweJtY
	 tSG0GqRrDQZ8kasKCB4JiJ5xKZY8EvsLaZhdQrkk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Marangi <ansuelsmth@gmail.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 136/290] mips: bmips: BCM6358: make sure CBR is correctly set
Date: Wed,  3 Jul 2024 12:38:37 +0200
Message-ID: <20240703102909.323515230@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102904.170852981@linuxfoundation.org>
References: <20240703102904.170852981@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Christian Marangi <ansuelsmth@gmail.com>

[ Upstream commit ce5cdd3b05216b704a704f466fb4c2dff3778caf ]

It was discovered that some device have CBR address set to 0 causing
kernel panic when arch_sync_dma_for_cpu_all is called.

This was notice in situation where the system is booted from TP1 and
BMIPS_GET_CBR() returns 0 instead of a valid address and
!!(read_c0_brcm_cmt_local() & (1 << 31)); not failing.

The current check whether RAC flush should be disabled or not are not
enough hence lets check if CBR is a valid address or not.

Fixes: ab327f8acdf8 ("mips: bmips: BCM6358: disable RAC flush for TP1")
Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
Acked-by: Florian Fainelli <florian.fainelli@broadcom.com>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/bmips/setup.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/mips/bmips/setup.c b/arch/mips/bmips/setup.c
index 16063081d61ec..ac75797739d22 100644
--- a/arch/mips/bmips/setup.c
+++ b/arch/mips/bmips/setup.c
@@ -110,7 +110,8 @@ static void bcm6358_quirks(void)
 	 * RAC flush causes kernel panics on BCM6358 when booting from TP1
 	 * because the bootloader is not initializing it properly.
 	 */
-	bmips_rac_flush_disable = !!(read_c0_brcm_cmt_local() & (1 << 31));
+	bmips_rac_flush_disable = !!(read_c0_brcm_cmt_local() & (1 << 31)) ||
+				  !!BMIPS_GET_CBR();
 }
 
 static void bcm6368_quirks(void)
-- 
2.43.0



