Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 783143403F5;
	Sat, 12 Sep 2026 08:05:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789200335; cv=none; b=YCzReXi7k4Zm1xx6YAxtf1PFM7B2fgOyJkNj6hxd0E4z5iMcJWDVG872oD3NKxuqjuwadbBhNSa5yi9ZTUZyFckJTExMOwqNU/H2wm8MuF74yY2r8D0vNgRXPB9CAya/1ZX1bZE77jn+kesNrsRZZ744DmIyEUxal4EdOJsYuS0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789200335; c=relaxed/simple;
	bh=+I8Obml1+0gJcBJerfbr5MRp/5R3a55pjeokcgeLqGY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=isDX/L3WkFA/YInhR3RKvcUdefmPPFbPUZRE2u1L5vmggjwTV1cNiSGGrZjrXxqM0aP0DCdQsUSe8VeRxJNpixmWHqT82Rg77Ps5Kvnh3x8priBg+dndU5DTLwX563EKFzuDzAJaTOaPE1VIEae33uNBQo45urNzSa4zXVnttm0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zvvpn6j+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zvvpn6j+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 169E01F000FF;
	Sat, 12 Sep 2026 08:05:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789200334;
	bh=alw0jcjhho6VZUyuWkzIRU5r/Df03Qj26weUI6K6YWg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zvvpn6j+KCVcTEDj5H9NQyFfbVrwCBajUsABCqMSHzSlj7mX9dWolgvA/HxcIZbRp
	 A8LL+CLk96EsGf6/Z8OJH2NETUagZNSPY+A/rTgfPkElIGsKyOShXJraTKMEvFaxdI
	 9g3NpjH6bziB9uSY7hbzfVWv/9sMgmqCRgM4BVfw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yichong Chen <chenyichong@uniontech.com>,
	Jan Kara <jack@suse.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0767/1815] fanotify: stop permission watchdog when timeout is zero
Date: Sat, 12 Sep 2026 08:41:57 +0200
Message-ID: <20260912065706.911769707@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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
index 7278286f5a6d9..9ec8fa6a27a67 100644
--- a/fs/notify/fanotify/fanotify_user.c
+++ b/fs/notify/fanotify/fanotify_user.c
@@ -112,7 +112,12 @@ static DECLARE_DELAYED_WORK(perm_group_work, perm_group_watchdog);
 
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



