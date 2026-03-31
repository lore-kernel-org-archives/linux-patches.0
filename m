Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD6024218A4;
	Tue, 31 Mar 2026 16:52:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774975963; cv=none; b=EFr250GtfKx1sn96F7OwaeaZRo1u0shCRLFyhONYSN+URHiHigdY4KsjPxVopbE+n6P3YdAfHC3IqoOhepFkcMbWo393Var2ldaCKlImIM2DcNBjiAbZEDDL7uwu11ZXJ6lz4ah0lNQVxEc7LPJb8hSi8gu43Pm4xGJVjrDUsDo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774975963; c=relaxed/simple;
	bh=26wl3aoyOt4BI3ZqkgubsM9ACsug8wPAJ3mMFE/bmzQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DTG9jVpees0PDVZzjm+N4r0fxNKtQysNb5ixStrklMf8Qr+XVvO8Ha7l5o0hbie9ZG4+/lzK74KeRI8RRHqkpQQrrM+nVMIfYH7VNgcVyq8L+ARI/KfSx7Fj82JZ9NKfCKgh0sOw0bSb2ocJpKj/xOIADrhx8B48oRgYXF8rVgk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jWUWc4br; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jWUWc4br"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B854C19423;
	Tue, 31 Mar 2026 16:52:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774975963;
	bh=26wl3aoyOt4BI3ZqkgubsM9ACsug8wPAJ3mMFE/bmzQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jWUWc4brf1/HUMdixi24zQKSqsnibznT9mAfZqOYQPSS0OAYGjDHckfDH/WWubEjN
	 flC5xYGBFdRH4XWSeyUXfXDqSC/lyDbUZO0JkHhOC9b37M0EmL599nNo4skbmK3k9R
	 9ZcRvs496RwY0tVQqRa5LHygJegdRFTth8LVfQSk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhan Xusheng <zhanxusheng@xiaomi.com>,
	Thomas Gleixner <tglx@kernel.org>
Subject: [PATCH 6.12 155/244] alarmtimer: Fix argument order in alarm_timer_forward()
Date: Tue, 31 Mar 2026 18:21:45 +0200
Message-ID: <20260331161747.490358740@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161741.651718120@linuxfoundation.org>
References: <20260331161741.651718120@linuxfoundation.org>
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
@@ -614,7 +614,7 @@ static s64 alarm_timer_forward(struct k_
 {
 	struct alarm *alarm = &timr->it.alarm.alarmtimer;
 
-	return alarm_forward(alarm, timr->it_interval, now);
+	return alarm_forward(alarm, now, timr->it_interval);
 }
 
 /**


