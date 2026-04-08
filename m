Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3F643D47A5;
	Wed,  8 Apr 2026 18:11:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775671872; cv=none; b=VmNrCaQPym+U2RilIc7iIC3oIctLytrbF4gBoZwKUVS+bODt7+ZMDeVoCmH46LXfehHdXKBw7oxtc7QslWWzqwzYmGP1//ZxU6tnaqm1hJg2xh2itJF1RJ8wKo7YoDKMS88XYxTc88irzO2YVYIvjl1CyB/Uob9OpDPtTXZOfHY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775671872; c=relaxed/simple;
	bh=3SRAM8W00LFNh7GRPUsjs1n9U4cFJAQIUj6Zb0lDdbo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kiAC8850QuZ8k/UhUmKm9IvIGKT6MFG/Lw/VGYofpBpSLwwjBee9wxS3EORuU1Gzib4E3F7fkxvfZwAeLB4PQ3PnQ61FPnCcepUETou7AqiVAwBCtGEaKCCYNHy63jvd6/HNpOdk/e+ChrPAIgZpXVCqhmqqu2BHZN8ddeXvxos=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fkkLhfl5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fkkLhfl5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34CD2C19421;
	Wed,  8 Apr 2026 18:11:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775671871;
	bh=3SRAM8W00LFNh7GRPUsjs1n9U4cFJAQIUj6Zb0lDdbo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fkkLhfl5XjuHp5fp866t2AwnEYmhwtcR5rqdF9pnl6Wh0ZYbI8yYqvlETxpQUMnUB
	 Mjs9LhyuZfvn2gIM28noyEcRW6p9JA6fkF/NEeFNWUeXBp7UdhHzsFglkdIeXW2BrZ
	 /YILIXJHYCGJgdpm33emsbmv9rEUgLewh041a98M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhan Xusheng <zhanxusheng@xiaomi.com>,
	Thomas Gleixner <tglx@kernel.org>
Subject: [PATCH 6.1 101/312] alarmtimer: Fix argument order in alarm_timer_forward()
Date: Wed,  8 Apr 2026 20:00:18 +0200
Message-ID: <20260408175937.536904657@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175933.715315542@linuxfoundation.org>
References: <20260408175933.715315542@linuxfoundation.org>
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


