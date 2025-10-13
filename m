Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D614530AD1D;
	Mon, 13 Oct 2025 15:02:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760367721; cv=none; b=tm23JwmK9roTuNrjG4rlr6ABI++eC2e4vpzRn8Hg9yVC9+JX7MSn8pdflLG5A4GAegnUOyEw/l5q76V3/Ly/9sPqI40EMHkBdjO19p/4BRFAZsjj/RmEcsziSc4oI2kJ88Jf82iD/s4j3mzREqPCzE6exntOpXJQFQxt8tH3qVY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760367721; c=relaxed/simple;
	bh=t3lMl97MuATCtwsIqCID3VG24Gp2X9G67JsQBL9LGs4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g41tEkBUHYWRp4Lo1J+vVmInCvdH0C3ao6sT9ksRUizQb4g7Yo7xmlW8N1nEIMSnx6lpZUZvGieP5L57RWeyTzmIygRkpa0w20Mc/RAKiFBLOWASrL6qnNVSh/Mm/mDvSOQB8QwnMpwlgaMdyeaiuVL90k32UrShg9NcCjOcSO0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yUy2VWUe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yUy2VWUe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 631E9C4CEE7;
	Mon, 13 Oct 2025 15:02:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760367721;
	bh=t3lMl97MuATCtwsIqCID3VG24Gp2X9G67JsQBL9LGs4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yUy2VWUeAykSHcyxDCJivWFE4b4f1ZgltgomXj1gt43tr/+IsoL4PULCa68kFwMMt
	 NvUP9t8FkiEnoP5FbOaVkrZJEhqgQw9F56vHoHzGh6tW88rCpyF04l2I8KMbl6XE9M
	 GGXGnyr0ReikUgqCnq38BlnqMQvy9tLginPJIZas=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Guenter Roeck <linux@roeck-us.net>,
	Wim Van Sebroeck <wim@linux-watchdog.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 111/196] watchdog: mpc8xxx_wdt: Reload the watchdog timer when enabling the watchdog
Date: Mon, 13 Oct 2025 16:45:02 +0200
Message-ID: <20251013144319.327597389@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144315.184275491@linuxfoundation.org>
References: <20251013144315.184275491@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christophe Leroy <christophe.leroy@csgroup.eu>

[ Upstream commit 7dfd80f70ef00d871df5af7c391133f7ba61ad9b ]

When the watchdog gets enabled with this driver, it leaves enough time
for the core watchdog subsystem to start pinging it. But when the
watchdog is already started by hardware or by the boot loader, little
time remains before it fires and it happens that the core watchdog
subsystem doesn't have time to start pinging it.

Until commit 19ce9490aa84 ("watchdog: mpc8xxx: use the core worker
function") pinging was managed by the driver itself and the watchdog
was immediately pinged by setting the timer expiry to 0.

So restore similar behaviour by pinging it when enabling it so that
if it was already enabled the watchdog timer counter is reloaded.

Fixes: 19ce9490aa84 ("watchdog: mpc8xxx: use the core worker function")
Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Reviewed-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Wim Van Sebroeck <wim@linux-watchdog.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/watchdog/mpc8xxx_wdt.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/watchdog/mpc8xxx_wdt.c b/drivers/watchdog/mpc8xxx_wdt.c
index 867f9f3113797..a4b497ecfa205 100644
--- a/drivers/watchdog/mpc8xxx_wdt.c
+++ b/drivers/watchdog/mpc8xxx_wdt.c
@@ -100,6 +100,8 @@ static int mpc8xxx_wdt_start(struct watchdog_device *w)
 	ddata->swtc = tmp >> 16;
 	set_bit(WDOG_HW_RUNNING, &ddata->wdd.status);
 
+	mpc8xxx_wdt_keepalive(ddata);
+
 	return 0;
 }
 
-- 
2.51.0



