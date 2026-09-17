Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C10FB54706F;
	Thu, 17 Sep 2026 18:45:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789670719; cv=none; b=nA6uysqnRmv4aeQwH2ITnGhBKnBF7PqRiC+jjFJEcAxMLagLbuetn5pbizgjkkjx+KowUOzf5QqZvJZLn7c4x1mQmj/Xd2AEEAJLVDO7HVKYq5CFImod6t8uu1UwmjZSCZ3WpWXsFcXIQorDpWscjvrpU4oJDZL5p6qP4NxbLfY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789670719; c=relaxed/simple;
	bh=6myt0rKR1cnGE21JB8PbFoRBQx6AUbvT/tLt4bfvsEE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Bsj58f4tHPrNv+lPe3NAevIwKtm6KXXUhMQU1e69YpWv4cUJxQZG4B2D27iogRX68EZCK7VJlVjmoDvtnKgDc+dsvXGMkbJJelF2JuSKv5/1UFB9C9jEtplU9rz6sA1lB0VAmUjIMsNNzbGePvYNF/XFESkGAQlOh8aiV3ACGOE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=p1hUUOg6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="p1hUUOg6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C84D51F000FF;
	Thu, 17 Sep 2026 18:45:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789670718;
	bh=rOlRpD9N5T3pjeRkJAK+vviK7Ohxgq63EjqLl9+POGI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=p1hUUOg6p2HhbJY6PFB6BFKdqHcmn2MirpQDBSw/8rm0aCZWVpRoOZ13CthPcu1q4
	 tJV1BQLVvEn4A9gwl/gI4fkIR47ppfHnNDwym2tGG/XRCwo+gccOcyPpmrvNckRpRJ
	 Xr7fcfY57gjdZNrRP4HNXfx96IgZga4FXwhvb+CI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Arcari <darcari@redhat.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0747/1102] watchdog: fix hrtimer start when pretimeout is zero
Date: Thu, 17 Sep 2026 16:11:30 +0100
Message-ID: <20260917151559.170138151@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



