Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793210803;
	b=mYecV0W/blNjf1F2OfC4JpNAKnboteEJ/y1GH+syZ1uE0iL5BYeSmWX5xTUrdDcZDFQt
	 WMwBxczVG/jvKKntuHNfld4R6lLTlf3FljRNiyMhBbCFkEZtVI6gPUieZIwgq1EYss7De
	 m/jA0yCNVYIzELjsfhe9Dy1zZ+4HQchbcPtQxwJAtOX1lmUpbXsZumFYioMvcz0q5zK53
	 9yOD02GDXFdvh2dp35hDaX9X2laI998de29fJYeAgaMIYv+2XLx2gy6jXfRmdKyzFxl2A
	 dHmp3myaA9b5tbR33DU4bykfWLzRPvvh7Yr09mVA70vf3SZOJvTbZPO02vznROxjTGA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793210803;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=eLxdDD2mdkgGzpjPLOgRlMlLILhw8jr6UQtVVxghiIU=;
	b=LbC+Lc7Yj4JR4OSDu2mzg5SfotzZfU2u9ZJh8vK8WhDSGto4GDciR0tOeoyTvIblTHHp
	 uM3gBJKsHKGbSJp2rH1zqBh5thFKK/sWel94QG075zumLGrzSFCt48Uzec0ib1VKlHr2W
	 L1eCwCk4mvSKBD7QQaZgRKZ6TGOFhjXFcu39+hm+7honWeZ8J8pJNd5NkQf8PoFaCRBZW
	 5qUXfoIYQ/wmZPJu000zxDka/qcSuJtzJ2nvYwvnToSRmwk84d4ybsGrwOQ+K0oB31YYX
	 1nopSg5uBpMoPOpq3eQ+cyx6t8qQG5ywKXGm15HFrtxjqPQbNAYEA05lYkY6Z7v3Tpw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XECjKdaR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5ABF6606A31F;
	Wed, 28 Oct 2026 18:06:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XECjKdaR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 608EF1F01825;
	Wed, 28 Oct 2026 18:06:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793210802;
	bh=eLxdDD2mdkgGzpjPLOgRlMlLILhw8jr6UQtVVxghiIU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XECjKdaR+FPVSunHlXwV3SaWA7wEI+DbOCMngs4Bn8fsnXCf+BWSFOMCO74eIHjtZ
	 ZDHe6fKNtX6efgFzmi5yfygeQwSkAIHDXuFGcWZr49ykk8WgLaCoySz90ldhBw3O1U
	 ANioHO3w94SMe6bqxmJTDC7SU8/I7bLSDzCODAJU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Duoming Zhou <duoming@zju.edu.cn>,
	Guenter Roeck <linux@roeck-us.net>,
	Wim Van Sebroeck <wim@linux-watchdog.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 154/571] watchdog: cpu5wdt.c: Fix use-after-free bug caused by cpu5wdt_trigger
Date: Wed, 28 Oct 2026 17:55:01 +0100
Message-ID: <20261028170011.668884308@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Duoming Zhou <duoming@zju.edu.cn>

[ Upstream commit 573601521277119f2e2ba5f28ae6e87fc594f4d4 ]

When the cpu5wdt module is removing, the origin code uses del_timer() to
de-activate the timer. If the timer handler is running, del_timer() could
not stop it and will return directly. If the port region is released by
release_region() and then the timer handler cpu5wdt_trigger() calls outb()
to write into the region that is released, the use-after-free bug will
happen.

Change del_timer() to timer_shutdown_sync() in order that the timer handler
could be finished before the port region is released.

Fixes: e09d9c3e9f85 ("watchdog: cpu5wdt.c: add missing del_timer call")
Signed-off-by: Duoming Zhou <duoming@zju.edu.cn>
Reviewed-by: Guenter Roeck <linux@roeck-us.net>
Link: https://lore.kernel.org/r/20240324140444.119584-1-duoming@zju.edu.cn
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Wim Van Sebroeck <wim@linux-watchdog.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/watchdog/cpu5wdt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/watchdog/cpu5wdt.c b/drivers/watchdog/cpu5wdt.c
index 688b112e712ba..9f279c0e13a66 100644
--- a/drivers/watchdog/cpu5wdt.c
+++ b/drivers/watchdog/cpu5wdt.c
@@ -252,7 +252,7 @@ static void cpu5wdt_exit(void)
 	if (cpu5wdt_device.queue) {
 		cpu5wdt_device.queue = 0;
 		wait_for_completion(&cpu5wdt_device.stop);
-		del_timer(&cpu5wdt_device.timer);
+		timer_shutdown_sync(&cpu5wdt_device.timer);
 	}
 
 	misc_deregister(&cpu5wdt_misc);
-- 
2.53.0



