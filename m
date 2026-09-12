Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33D0E288B2;
	Sat, 12 Sep 2026 10:23:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789208610; cv=none; b=ojEzc8l0GCtN8CecHGg9nQaLI8rLQlggh+HowTD9qDCweDruR7kwgRRNXYs7UHfEkfGCNqXvK3+focS2ZlbdHLwcnJ2dBWqZmkMTXYPWQBSGJ/NNLYDZUcqp3iVd1fP+0kqT90yfQk3rFNyPfr7rJ9ka7m4SgSiQTgHTvLF8tEo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789208610; c=relaxed/simple;
	bh=WaKuGBvyfloJwg6V5LOwulIcr8BGBEHQ4epWSGnbxZ0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uBFgePCcYUa525DSckAAMf3EKZVvQRreNU06yEdFtBfP0ocfFVZ9zmjuQRlTSJ+xoM+67DOmBhJAsngS4pp2DpDOnxIYQzNX7Z326S+iVa1F0bMExS2uRtIcp29SbeeQxdWDcVOrQknWt5Drp8GCbdeZiZzHntvgM+lH9/yfmQw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xrZ5NyqY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xrZ5NyqY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D66B31F000FF;
	Sat, 12 Sep 2026 10:23:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789208608;
	bh=qhGU8AvYe3V3hDaxOREsVmKjm4Pc6jIivKT85jjZwxs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xrZ5NyqYGkV9cqkZN7ppcvbm2vlrHgKXp1ArVe34Tll8SeAwZBz2cTj/c/F/LTTid
	 z6MOMZ8nc31irIgC1ue+nQxF2tg0KepcpQKn8c9NrJu3Bouk6mJFjE7J5Vi5EBscec
	 ln2A0/FamcF84Al8m4aRr9hzJwyWTtuBfmcuQnCY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yichong Chen <chenyichong@uniontech.com>,
	Jan Kara <jack@suse.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0653/1518] fanotify: stop permission watchdog when timeout is zero
Date: Sat, 12 Sep 2026 08:47:02 +0200
Message-ID: <20260912065638.202178905@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yichong Chen <chenyichong@uniontech.com>

[ Upstream commit 17463fe751309330b74618560f181426f643aa3d ]

The fanotify permission watchdog can be disabled by writing zero to
fs/fanotify/watchdog_timeout.  fanotify_perm_watchdog_group_add() already
checks for a zero timeout before scheduling the watchdog.

However, once the watchdog work has been scheduled, perm_group_watchdog()
unconditionally schedules itself again with the current timeout.  If the
sysctl is changed to zero while the work is active, secs_to_jiffies(0)
causes the work to be rescheduled immediately, resulting in a kworker
busy loop.

Read the timeout once in perm_group_watchdog_schedule() and do not
schedule the work when it is zero.  This lets a running watchdog stop
after the next execution when the sysctl is set to zero.

Fixes: b8cf8fda522d ("fanotify: add watchdog for permission events")
Signed-off-by: Yichong Chen <chenyichong@uniontech.com>
Link: https://patch.msgid.link/20260730070648.549458-1-chenyichong@uniontech.com
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/notify/fanotify/fanotify_user.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/fs/notify/fanotify/fanotify_user.c b/fs/notify/fanotify/fanotify_user.c
index eb808eda11f2f..9dbe33cf2ceaa 100644
--- a/fs/notify/fanotify/fanotify_user.c
+++ b/fs/notify/fanotify/fanotify_user.c
@@ -111,7 +111,12 @@ static DECLARE_DELAYED_WORK(perm_group_work, perm_group_watchdog);
 
 static void perm_group_watchdog_schedule(void)
 {
-	schedule_delayed_work(&perm_group_work, secs_to_jiffies(perm_group_timeout));
+	int timeout = READ_ONCE(perm_group_timeout);
+
+	if (!timeout)
+		return;
+
+	schedule_delayed_work(&perm_group_work, secs_to_jiffies(timeout));
 }
 
 static void perm_group_watchdog(struct work_struct *work)
-- 
2.53.0



