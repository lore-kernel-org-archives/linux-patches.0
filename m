Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB08C274669;
	Mon, 13 Oct 2025 15:37:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760369824; cv=none; b=gSYzGO8Y2uvTeweZOfDGkBOFWIesztrsxF0mvQxqsUeFAAr8vfm8kyZEx+98DopJlsiG+fEhJbHqxggGzYhHJJ6eU+NGaNLRE50cOEk6ooGnW2N8N97pmlNYRx4PJue8XjbOQt26cecMWDh/IEKM+M/Ix/qce3PNhUxK0mn02FI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760369824; c=relaxed/simple;
	bh=R6TOlV92cJuxlkwKv0mUXHrcZXNCmYKKfps3qhYFX7E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s8BHNS1xn4ae15LrBDFwmLeO/JEDkY4+l6+W/VbWxRPap6hmerZ3OxaB9gyAXVxz/dezmVY7uZimNPtX1kf2XrFlKjXQ2/lCfTi9067Yby3dnNguI7cmXYuyncDLMXAPJmMJ7VPUHPuaVuVZyFh0wGxS12kty6oG4N5OtOTcM3E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wJVkybxh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wJVkybxh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50005C4CEE7;
	Mon, 13 Oct 2025 15:37:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760369824;
	bh=R6TOlV92cJuxlkwKv0mUXHrcZXNCmYKKfps3qhYFX7E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wJVkybxhyTJSNPLvu0ZIIFoVTqH1f+3hOANzAhzBKDtFAZ9I+GKQXl8DCiS5Bvhpt
	 q/EjVq50gXjrb3hJwsym6xqYHd973p6EhTE8bTjjpj662n3dFU0dH9mobBK8mczuJi
	 2rHKYkKnF+ebBiU70brt2g+1pJ50ZFVEOnusx41A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Guenter Roeck <linux@roeck-us.net>,
	Wim Van Sebroeck <wim@linux-watchdog.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 349/563] watchdog: mpc8xxx_wdt: Reload the watchdog timer when enabling the watchdog
Date: Mon, 13 Oct 2025 16:43:30 +0200
Message-ID: <20251013144423.913037370@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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



