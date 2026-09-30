Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66BFD3CB8F1;
	Wed, 30 Sep 2026 16:21:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790785307; cv=none; b=Qkmm+zwmuBc/rgib4HNvvbQ62LxGSTZrXCXt3vUIjluDmwEJkDAGHc3Ng1rzT8QSj3KQ0kerRVy1UptakP00syUTTg+sl5oVkoBXVsq9tJkbvhlAiQoqNBXqjUylE7yOHbPbnBRsvZ2Zk3h4Le4j3LPk8P/u4WdY/SHpue4+T0s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790785307; c=relaxed/simple;
	bh=7GJEqCnIK8AIqmdyZeCJnHCGXwPHX+2sFSmsqAMoNQs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Zu2XIewdC0uTRjyWGY3P0eisq2pbeBZXbLgFd+sbr0jxH8M1x1xidt0bJNjKaDJ/XiqVSCN2SRQ522jRgYhYOWjVajKt7+kXRpB8L8Uoczj0gai6r+IsdTX1+r8xwsC+JrR5n3UgvN/en0iNA45cr13P+k5HT7L74dCU0duZRSY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JkDINIzA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JkDINIzA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2C161F000FF;
	Wed, 30 Sep 2026 16:21:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790785299;
	bh=LLP+1/IbcBgjsqaBTFV0jJVO/2kssI+bEFQmjN7a9Qw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JkDINIzAHRLGKMhQ/rddTJagC52pSuP7arTnEQjpYca6/kW+6oxBpdUxp85jcuRbe
	 CLXuRwemL95D/4MRcffb1r6hpALhCdwEbaVR/74fSU2Cn65cGxuHdsnW5QtVYbrHfy
	 YLEcUe4byjndBj/CpbMuPX7h1JAkoawNcLn5y9kc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Arcari <darcari@redhat.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 461/982] watchdog: fix hrtimer start when pretimeout is zero
Date: Wed, 30 Sep 2026 17:19:57 +0200
Message-ID: <20260930152426.689199484@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Arcari <darcari@redhat.com>

[ Upstream commit 0fa37512eb747e4ffdcf367274f9e72845f1bca4 ]

Per the watchdog API, a pretimeout value of 0 disables the feature.
However, watchdog_hrtimer_pretimeout_start() fails to verify if the
pretimeout is non-zero before arming the timer.

This omission inadvertently starts the software pretimeout timer,
which could result in the pretimeout handler executing incorrectly
when the watchdog timeout is reached.

Fix this by adding a check for wdd->pretimeout before calling
hrtimer_start(), ensuring the disabled state is respected.

Fixes: 7b7d2fdc8c3e ("watchdog: Add hrtimer-based pretimeout feature")
Signed-off-by: David Arcari <darcari@redhat.com>
Link: https://patch.msgid.link/20260903182029.936030-1-darcari@redhat.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/watchdog/watchdog_hrtimer_pretimeout.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/watchdog/watchdog_hrtimer_pretimeout.c b/drivers/watchdog/watchdog_hrtimer_pretimeout.c
index 940b53718a91e..7572489e647f2 100644
--- a/drivers/watchdog/watchdog_hrtimer_pretimeout.c
+++ b/drivers/watchdog/watchdog_hrtimer_pretimeout.c
@@ -30,6 +30,7 @@ void watchdog_hrtimer_pretimeout_init(struct watchdog_device *wdd)
 void watchdog_hrtimer_pretimeout_start(struct watchdog_device *wdd)
 {
 	if (!(wdd->info->options & WDIOF_PRETIMEOUT) &&
+	    wdd->pretimeout &&
 	    !watchdog_pretimeout_invalid(wdd, wdd->pretimeout))
 		hrtimer_start(&wdd->wd_data->pretimeout_timer,
 			      ktime_set(wdd->timeout - wdd->pretimeout, 0),
-- 
2.53.0



