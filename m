Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CE0C30FC1E;
	Mon, 13 Apr 2026 16:35:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776098136; cv=none; b=kQt6K1pS0tIwc17roRnDVdn7e6HZSpvHUw4tuyDMLa6Go4wU7uKxqnV3ae7qGwJrOc0usc+NoWBnqsmI9EeEBiGgKAlF7qWU3y+Hs6KAEB9JQbCwHrXc7qNTACBMBoiqiKCr3TlmekKHU9BIPPSWk/UnH6YR1W96pcEG5mOYq9o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776098136; c=relaxed/simple;
	bh=u1hNqV31fBoZdonY/ex9JpX2ncFxpMLG+xRWS+EcJhc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fxcY9NelkWM63AD2eo8mC4lQCFUpDhywUDzpIo1HiASW3kmvo+PgkJI2wpFLKbRxD1sJErlImNBp4A4XiaUZ49oNh+szS+806gV75fCHuhF87MR7T2iDp+cz0X+WdijJeuqgnI0Yktc4m6c+qxjse8tVChv84sjbGIPr9I4Z7WE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Luz+r0aa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Luz+r0aa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A736C2BCB3;
	Mon, 13 Apr 2026 16:35:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776098135;
	bh=u1hNqV31fBoZdonY/ex9JpX2ncFxpMLG+xRWS+EcJhc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Luz+r0aaLsKs/ddVfXxEc6qUJ4E18afSqQtx/MdYX+NITtLCGTLvKbVt2IfzJKnhl
	 8nKzg9eqeDKOX1E/3Motr70DxEnrnufBOplpCwBedXx9gmc/q4YAU2FTZkn77vYqfr
	 ng5XnXJkhgDq8sFYJ8PdKJD5ViIsYNmBKAwUg9CI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhan Xusheng <zhanxusheng@xiaomi.com>,
	Thomas Gleixner <tglx@kernel.org>
Subject: [PATCH 5.15 375/570] alarmtimer: Fix argument order in alarm_timer_forward()
Date: Mon, 13 Apr 2026 17:58:26 +0200
Message-ID: <20260413155844.526849900@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155830.386096114@linuxfoundation.org>
References: <20260413155830.386096114@linuxfoundation.org>
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

From: Zhan Xusheng <zhanxusheng1024@gmail.com>

commit 5d16467ae56343b9205caedf85e3a131e0914ad8 upstream.

alarm_timer_forward() passes arguments to alarm_forward() in the wrong
order:

  alarm_forward(alarm, timr->it_interval, now);

However, alarm_forward() is defined as:

  u64 alarm_forward(struct alarm *alarm, ktime_t now, ktime_t interval);

and uses the second argument as the current time:

  delta = ktime_sub(now, alarm->node.expires);

Passing the interval as "now" results in incorrect delta computation,
which can lead to missed expirations or incorrect overrun accounting.

This issue has been present since the introduction of
alarm_timer_forward().

Fix this by swapping the arguments.

Fixes: e7561f1633ac ("alarmtimer: Implement forward callback")
Signed-off-by: Zhan Xusheng <zhanxusheng@xiaomi.com>
Signed-off-by: Thomas Gleixner <tglx@kernel.org>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260323061130.29991-1-zhanxusheng@xiaomi.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/time/alarmtimer.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/time/alarmtimer.c
+++ b/kernel/time/alarmtimer.c
@@ -609,7 +609,7 @@ static s64 alarm_timer_forward(struct k_
 {
 	struct alarm *alarm = &timr->it.alarm.alarmtimer;
 
-	return alarm_forward(alarm, timr->it_interval, now);
+	return alarm_forward(alarm, now, timr->it_interval);
 }
 
 /**


