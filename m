Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 900FA4DD3A6;
	Thu, 17 Sep 2026 15:43:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789659841; cv=none; b=uVs8c3IRkknqQSwP45/KZFMQi8Do6Nap/ZxEuWLxm6uwirEtcDP1nLvrgXX3NK0gAiYfQvyNJoScrlmQPzpcIasKR4uTQgjOz7up0qmABtg6A5cZpTUd7LY9//mR2uVtFPUK7xllwGMh8IxkqLu81G8oSGfuzJ7g432u4UDw9iA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789659841; c=relaxed/simple;
	bh=rC+hVKLRDAqrrWTCw4K7zGK7fxXiR2Yb97k53JIJuvA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZfUrVqrTQqaqCzQszxW6K9rraGsoxQ8K4ITfNU2GYKZhQl1uPRrxkAankyJwSgisD2+N6nQ5pE+ZZSoDrO69Ymmbz1bOhm2TQD1MrBBAvCX9IcbeR215a2fCrVCeWsQ5FflIqIHN2hkJg8wieXQSk3ZxrSSDfakaKIKVfUEolaM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wOSySGH2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wOSySGH2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 453021F00899;
	Thu, 17 Sep 2026 15:43:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789659835;
	bh=TGhpAnulevgSTXmjnzpgM1hAobPiEQz5lsi/Et9DtcA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wOSySGH2jvnkhTHHQjkNLrOzV52ILbbvQCBbfDakcvwTv9fd4aNhOs+03+SXJqT5v
	 aKnNnZ+LEhchcyZNEUtjbzuTzehM0FbHbMsLZrDDgkNMQSqibd9P9xIqFRhJQKOKu+
	 Gut9zLL5qYUK3CYhtTCYHMkF6mTE+L2XKWIvsipk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Arcari <darcari@redhat.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 390/733] watchdog: fix hrtimer start when pretimeout is zero
Date: Thu, 17 Sep 2026 16:11:38 +0100
Message-ID: <20260917151401.422364035@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index fbc7eecd8b203..49a05ea60c979 100644
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



