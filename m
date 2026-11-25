Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795623156;
	b=KvgO3UJP74DhqUKe6/IOjxVi8KkeG9sydbgyOhZitXcUKzXThiWb9X1p+jYvjAE55EYd
	 QX47Gk0Tv0RALeE/cy8bjMbzGMFkqfAkp4AYwYwZkGK+cOz5t+XeT7czmDBtk27hm0JHJ
	 0SVxj8MUrxp1yhg5U+vqm4HUIM7h0/og/ECrDJZF0jCxDeDL3RGy8DXX1yaab6HYsgfp0
	 DZBpBxAWXb6mn3tpZR0lXO4aUtFiz4aOK4+gNqbcJ5vh8bzxiYhEkMh4S1MUfFmEpdHLo
	 7YwrGxWs46Bh/iJoNz5qFzeN19hKtDH6A7j1vXTdQlzAKc1NWRRg9tSV7CsCib+oRyQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795623156;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/GlpIqh1Nq8ZzzfWQKXoLoioCTeu+als7GxHI6ZETzw=;
	b=y0LrNUpNeOj4y4DDnwt2wygYS6mEZ2ku4EJnDYw9lN4Y2/PfMBN0IaMwf3bwPj+hJp7g
	 jrf/TEL3qWNCcNssqbHJmRLzBEvOmHY3WEI7iOCnZs51pFLYSy/p9BYGxPXffCv8scFts
	 E60GuOmEUs4g3J/LlYglz6opWVg2/olfFFCN4iWjLujYSUuyZF9kROKk7sTva3Wz6c+sp
	 Rp9VnAhz7oiaSl0rF8HvOnSDlb4+CuY1YU/d4kfDhu8eC2QBIcDvgtkZiVyUwfrMrHwgU
	 i+ZI+WArKXVl2qVr14hjongW9J6a++C0ePS3CKJ5gJUsFcS0iRnDCGG30Ryq0LeEv0w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Bgt8dr86;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A6D1606A321;
	Wed, 25 Nov 2026 16:12:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Bgt8dr86
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FF391F000D2;
	Wed, 25 Nov 2026 16:12:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795623155;
	bh=/GlpIqh1Nq8ZzzfWQKXoLoioCTeu+als7GxHI6ZETzw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Bgt8dr86WpPBw4PnmMXCa+BOgn90KuDwsAiwaOUsPFHCU0N5uLaElqZjJNCn8AQ5H
	 BvQDRlkgsBU2I9y9Q46T1uaNBFvzEkao1j3qt/xuvdk7moTnCNwOWcsnBrMIuoSTW3
	 QgrQaeq72QsgwWD16x7T9PhDQtdem0YyXJScVjb8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhao Feng <zhaofeng2@cmss.chinamobile.com>,
	Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 6.18 768/990] watchdog: npcm: fix clock prepare leak when setting timeout on a running watchdog
Date: Wed, 25 Nov 2026 15:35:35 +0100
Message-ID: <20261125143840.044091627@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhao Feng <zhaofeng2@cmss.chinamobile.com>

commit 57c7cbe21acc77291ec0fbdd4bd72aa259cf4986 upstream.

npcm_wdt_start() unconditionally prepares and enables the watchdog
clock, and npcm_wdt_stop() is the only place that disables it.
npcm_wdt_set_timeout() calls npcm_wdt_start() again whenever the
watchdog is already active, so every WDIOC_SETTIMEOUT ioctl issued
while the watchdog is running takes one extra clock prepare/enable
reference that is never dropped.

Split the register programming out of npcm_wdt_start() into a
__npcm_wdt_start() helper that assumes the clock is already running,
and call the helper from npcm_wdt_set_timeout() instead; only the
watchdog .start callback (and the restart path, which intentionally
keeps the clock) now acquires the clock.

Fixes: af084fdccfaf ("watchdog: npcm: Enable clock if provided")
Cc: stable@vger.kernel.org
Signed-off-by: Zhao Feng <zhaofeng2@cmss.chinamobile.com>
Link: https://patch.msgid.link/20261109071004.1506-1-zhaofeng2@cmss.chinamobile.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/watchdog/npcm_wdt.c |   15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

--- a/drivers/watchdog/npcm_wdt.c
+++ b/drivers/watchdog/npcm_wdt.c
@@ -63,13 +63,11 @@ static int npcm_wdt_ping(struct watchdog
 	return 0;
 }
 
-static int npcm_wdt_start(struct watchdog_device *wdd)
+static void __npcm_wdt_start(struct watchdog_device *wdd)
 {
 	struct npcm_wdt *wdt = to_npcm_wdt(wdd);
 	u32 val;
 
-	clk_prepare_enable(wdt->clk);
-
 	if (wdd->timeout < 2)
 		val = 0x800;
 	else if (wdd->timeout < 3)
@@ -94,6 +92,15 @@ static int npcm_wdt_start(struct watchdo
 	val |= NPCM_WTRE | NPCM_WTE | NPCM_WTR | NPCM_WTIE;
 
 	writel(val, wdt->reg);
+}
+
+static int npcm_wdt_start(struct watchdog_device *wdd)
+{
+	struct npcm_wdt *wdt = to_npcm_wdt(wdd);
+
+	clk_prepare_enable(wdt->clk);
+
+	__npcm_wdt_start(wdd);
 
 	return 0;
 }
@@ -134,7 +141,7 @@ static int npcm_wdt_set_timeout(struct w
 		wdd->timeout = 2750;
 
 	if (watchdog_active(wdd))
-		npcm_wdt_start(wdd);
+		__npcm_wdt_start(wdd);
 
 	return 0;
 }


