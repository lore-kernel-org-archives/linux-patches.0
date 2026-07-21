Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55C403ED3B2;
	Tue, 21 Jul 2026 15:56:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784649388; cv=none; b=MAfYEvq3FBD7G/Gj3I3pRQVBHt3lPEttfTbhdRH/g+xNuIAnDTjNzRa6sJ0PWiIN0bM2lExHf4WJLAsNHi6RtMZ8jHLJxtbPpE2c4IWH7PDe5iqfZGznY0Xic8so9mH7DrRqJzoYHpWyxCOCZ/lqeWvMgAvCGvaOs4vrJPELkD8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784649388; c=relaxed/simple;
	bh=8s98rAP6L+3mcvmgaz71VJjjDrbVkYNMQB1vIqOuHzI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mB9vxxoDv8pm2pVOxDzONWopvZoa1FDJqjcE25P2Jos3GbNwK2wX1nd1O/XetckavhAi17ChXuFB40lyXWvHgL59u4Kv84y06ekuq2rmfM4OgLrE1zG5i3rTV5mhQg0ByDqJmn63w82sRjQQMNwv8uF6T8Rt93GmmsajCXTtpIE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lpD712fA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lpD712fA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE7DD1F000E9;
	Tue, 21 Jul 2026 15:56:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784649387;
	bh=MSuVzaZrlmNssth032A883cN7j7onEkZl/M8/a0OqJU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lpD712fAcOlus8UOgjOq/BNLMo4qwpHJSt7M9b1mHFEfb3csUBgQ71hbD6bszbWXA
	 Uf8+Fyl5POCV9+fcKt1ylMbzALRdXxZFRKY6DiIB+sLpMDWY+rfdmf/sEa8HJq1g3A
	 bRyhuSmwZyh55GJAQytHu3t+F7mXh4lZgK2OmmIQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuho Choi <dbgh9129@gmail.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0560/2077] watchdog: unregister PM notifier on watchdog unregister
Date: Tue, 21 Jul 2026 17:03:53 +0200
Message-ID: <20260721152606.021387796@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yuho Choi <dbgh9129@gmail.com>

[ Upstream commit a298c7302ee9584a7a1ac1e8acbede8d98ab51a4 ]

watchdog_register_device() registers wdd->pm_nb when
WDOG_NO_PING_ON_SUSPEND is set, but watchdog_unregister_device() does not
remove it. This leaves an embedded notifier block on the PM notifier chain
after the watchdog device has been unregistered.

A later suspend/resume notification can then call watchdog_pm_notifier()
with a stale watchdog_device pointer, or at minimum after wdd->wd_data has
been cleared by watchdog_dev_unregister().

Unregister the PM notifier before tearing down the watchdog device.

Fixes: 60bcd91aafd2 ("watchdog: introduce watchdog_dev_suspend/resume")
Signed-off-by: Yuho Choi <dbgh9129@gmail.com>
Link: https://lore.kernel.org/r/20260601192005.1970805-1-dbgh9129@gmail.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/watchdog/watchdog_core.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/watchdog/watchdog_core.c b/drivers/watchdog/watchdog_core.c
index 8300520688d079..6c087b4ef5dd52 100644
--- a/drivers/watchdog/watchdog_core.c
+++ b/drivers/watchdog/watchdog_core.c
@@ -391,6 +391,9 @@ static void __watchdog_unregister_device(struct watchdog_device *wdd)
 	if (test_bit(WDOG_STOP_ON_REBOOT, &wdd->status))
 		unregister_reboot_notifier(&wdd->reboot_nb);
 
+	if (test_bit(WDOG_NO_PING_ON_SUSPEND, &wdd->status))
+		unregister_pm_notifier(&wdd->pm_nb);
+
 	watchdog_dev_unregister(wdd);
 	ida_free(&watchdog_ida, wdd->id);
 }
-- 
2.53.0



