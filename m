Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16352385D97;
	Wed, 30 Sep 2026 18:05:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790791552; cv=none; b=sUVjtEi+/Cq8dNuRYofhzpgpz3+5GAe93T7H81PsO7/Lwml8CNriFcexAAnOq2fK6dGDOzKGU3WTFM/qyB0utrfC8M/yp4uMYLx38jGMqDb0io1reTsR+jiWKIgiPh9/5p/axP+xZRPfUAoj+oK7kyYhGhV4ORJoMJPpr8UT1E8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790791552; c=relaxed/simple;
	bh=aCRWy45SHrMxbjWHCVPk36sNSzop8KlpjRL+KU2G3bU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sHVJxWj1w63Vz+wKMO/5LYJfSSjaUlwq0nHAS1Fz7LMUizk/oeO62jip+ZdavpcztHT/d/sS8kawtuWTsVkOtZ3/ZnCj3ROJ5ASz1p1I9FmfQc61HvH8xT5o9L6XIK/8sjxQB6KKS/u4cqLBtZpnMrTVpXWNQ7jDbo3aX1JZEWI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Pt7gIWEB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Pt7gIWEB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FC3F1F000FF;
	Wed, 30 Sep 2026 18:05:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790791551;
	bh=Dh7Whfbu5/rzBRClwmLP4Mhid+iCSMEFloxB2epO7Ko=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Pt7gIWEB/7LP3Xh7IOQ6bA1G7ipftn1/PBylbgXebfuNHvQzk2drBYS4l3QEo3zwZ
	 OJ+fAEQpqvJJwLrlo0PwwFyKghxiByWpWGlaH3v5GJ9+S8CpXop9ji1NBLDbCcqXgE
	 2Dqe/Bg4FzY0ACMJQk+py1atiWCdjR98ipUbSbjg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Arcari <darcari@redhat.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 342/752] watchdog: fix hrtimer start when pretimeout is zero
Date: Wed, 30 Sep 2026 17:23:32 +0200
Message-ID: <20260930152405.693364760@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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



