Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F829329C7C;
	Wed, 23 Sep 2026 14:44:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790174685; cv=none; b=L270Bfq/3ZvW3LXZd6l4jupTw0/Ykw08x3PfC1K0vjgS/Y4ZHXQL7DGMzHz7AM2K1okyiTwGY34MWqfWZwfFpRWPDEIrkyfOeQRfhFTYL48t9P1fOW4Qf+ydKAVn51FzcczZHs/JQyy9ZjKWH71lZjKQKIJH6TLM2H8LP8MGDE4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790174685; c=relaxed/simple;
	bh=aPmyNwdRIT1AQZY+eva8QC4TXJhUMn2JipwJBH7zjhQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QOUfRC+wdO+6iLXxq9y4cr6ToCCWXHQA3F4HVOhJxdFz809OWfRAEo7z67EESpyAKElQa5ICx3jKDu37ox4AhQTRvhb0coIshk5Lq1NWink6ZZu30Fs8RxyUjtxNK5pbBsFW4v0YTppqWCedimeoF2L3AZe0+WDDUcuptyV0Zxw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=C3lGgK4m; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="C3lGgK4m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9CEF1F000FF;
	Wed, 23 Sep 2026 14:44:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790174684;
	bh=fdJTqUzC1J0JLw0Nq9DGR6qwma2t/9ERnFStZC9dVGs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=C3lGgK4mbCG60WpZP3S1LzpI6Nqtc4bpGgK+mP8auAiiw/RFq8FdYYAv1T3jbkpoK
	 b7lFXj4w9PpGScxwbppD3ZkkyzsGH9GCh+/0FaDXGmUKnWjcMh0FlhnGZ9VOdx7Spj
	 +kytBzUug/qAGkADzAfEhIVKy6eeTK2Vpy86cS+k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li Jun <lijun01@kylinos.cn>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 193/398] watchdog: da9062: fix suspend/resume handling of HW_RUNNING watchdog
Date: Wed, 23 Sep 2026 16:04:27 +0200
Message-ID: <20260923140648.428496048@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140643.441954610@linuxfoundation.org>
References: <20260923140643.441954610@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Li Jun <lijun01@kylinos.cn>

[ Upstream commit 5071122bf5a628494db16d98d253f622a5aab074 ]

da9062_wdt_suspend() and da9062_wdt_resume() only check watchdog_active(),
when the watchdog is left running by the driver sets
WDOG_HW_RUNNING in da9062_wdt_probe() but userspace never opens the
device, so WDOG_ACTIVE remains cleared, the wdt_disable() will not be
executed in da9062_wdt_suspend. In this case, the suspend callback is
a no-op and the watchdog keeps counting during system suspend,
leading to an unexpected system reset.
Check WDOG_HW_RUNNING and wdt->wdd，can fix this issue.

Fixes: f6c98b08381c7 ("watchdog: da9062: add power management ops")
Cs: stable@vger.kernel.org
Signed-off-by: Li Jun <lijun01@kylinos.cn>
Link: https://patch.msgid.link/20260914062353.582205-1-lijun01@kylinos.cn
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/watchdog/da9062_wdt.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/watchdog/da9062_wdt.c b/drivers/watchdog/da9062_wdt.c
index 426962547df16..4d558652e9e71 100644
--- a/drivers/watchdog/da9062_wdt.c
+++ b/drivers/watchdog/da9062_wdt.c
@@ -256,7 +256,7 @@ static int __maybe_unused da9062_wdt_suspend(struct device *dev)
 	if (!wdt->use_sw_pm)
 		return 0;
 
-	if (watchdog_active(wdd))
+	if (watchdog_active(wdd) || watchdog_hw_running(wdd))
 		return da9062_wdt_stop(wdd);
 
 	return 0;
@@ -270,7 +270,7 @@ static int __maybe_unused da9062_wdt_resume(struct device *dev)
 	if (!wdt->use_sw_pm)
 		return 0;
 
-	if (watchdog_active(wdd))
+	if (watchdog_active(wdd) || watchdog_hw_running(wdd))
 		return da9062_wdt_start(wdd);
 
 	return 0;
-- 
2.53.0



