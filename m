Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31763197A9F;
	Thu,  6 Jun 2024 14:08:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717682931; cv=none; b=HnNqAvTKF3q/NU2f62sh0Y4iGp1OUDfHR+pqo8aYBL5P0RGdLtx4sRPycrZZaGxJkSf792ITltYTgt0u1JLpsUsJigxOr92xxfWAKS99ugMkMfpeQPx2dDqz6QHptN2lRvB2oQMoj5EP9jbP9/SRimYCEYJ0uF0U8nNCKkutHH4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717682931; c=relaxed/simple;
	bh=YGEPgeDpuWsWl55xRAUAcW2Qeo7oeSr4bDg+QVYMTdY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QtygjqhQdGv9lbcX4CDE+5E+ggzJOjiv+OzhkyocQSugbd4AHMLRf86f5ZQdb3gyG9nQrk01jb3SBmAzSys1IVcF9WBy1BuNjjMN3TNQ89p5J5hyb1tLWJh7oe6iNLrUt/Mb0U+zZQOIg44n8bO9xmCkLC0SOgtiVIOzSYXLw94=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iS5MQjU4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iS5MQjU4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08603C2BD10;
	Thu,  6 Jun 2024 14:08:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717682931;
	bh=YGEPgeDpuWsWl55xRAUAcW2Qeo7oeSr4bDg+QVYMTdY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iS5MQjU49UQgQ9hPgTAG3ntomSNfWmVyK0ejBNejNLM43VIo8ZxQ2V1vLwWeY/ATJ
	 ogeAqEhGZsFTLQ5Hflmg2lyRnlFLFZ+6N4iYeZycQ7C4y/HV1iI5L1NDh/BfxNuBVh
	 gqK8s8miqxodAdJy6Us59rN7r7JKJkE0W72esy0Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Duoming Zhou <duoming@zju.edu.cn>,
	Guenter Roeck <linux@roeck-us.net>,
	Wim Van Sebroeck <wim@linux-watchdog.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 078/374] watchdog: cpu5wdt.c: Fix use-after-free bug caused by cpu5wdt_trigger
Date: Thu,  6 Jun 2024 16:00:57 +0200
Message-ID: <20240606131654.468334860@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131651.683718371@linuxfoundation.org>
References: <20240606131651.683718371@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

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
2.43.0



