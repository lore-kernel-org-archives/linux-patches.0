Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AE7B3B3BE1;
	Wed, 30 Sep 2026 19:10:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790795431; cv=none; b=Bn4rWtGZU2ioulqyrzaqcsliDVGb2nhcNiI0++LEg9to5LbagzIFxFAIBhoAOD3Sbgjs4EdZFsOrQJjVvrLJnI5LVZZMWgaWaWTp6LDmvKhsIwGJkX8sw4FMgbPfeu/k9LwvesECrBg8mLTPR2ToNorZNU15njgONexp+lHgY1c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790795431; c=relaxed/simple;
	bh=eMbUZr58nanVvPY2yLwRiADCKyiLdCcHR6YK34XX+yU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RgIF7E+zffDWSiYe8hnWhd4RMSuMv4T/2rJrpip1jfvEJ/RDqbUt5wnmy1oZ2/ZUu38Q4K/ytix6BbX3WzkXQMnRYrRCCJQIgGMWnjSmLuBJN12WOVg/gI+80wnw2UDMCMoQCPyypbJXVZ5E6AD8D05peI2yuDQ0DZx/LlnWA9w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KytC7GG+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KytC7GG+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F421F1F00898;
	Wed, 30 Sep 2026 19:10:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790795430;
	bh=FMHigDpE3f0SZeji6H1uLSLLFEyvcKfPa4A1d5KeeSA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KytC7GG+6N/ODZioO7vCZqalTf+JHNpcBZB1MA/psWxfEcYs0mZ5y2Wv70t7PtKLI
	 kOJzvj/BPJqFU2i8AgSSQ4f3+iOw7w0I/z3tSxvlWH0VTGJKHqNPzOkYfrtK2FLLjV
	 TXkx2LMApHvWd+x6Tr8DZsXUBAwoHYEa+Mgpgh8I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Arcari <darcari@redhat.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0557/1193] watchdog: fix hrtimer start when pretimeout is zero
Date: Wed, 30 Sep 2026 17:20:41 +0200
Message-ID: <20260930152446.613679833@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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



