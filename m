Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68C943161BF;
	Mon, 13 Apr 2026 16:55:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776099334; cv=none; b=jWoRuFIzLlPB0b2vAv8NFhf7zXBXccPxsV66vVkf0lw/x3UaFTszchn7bmpLvyzb1Wlz03fnMcCtOmmPdmg3T1A9F2cmxTusxU2mZuHiKjPWkczJRFIDhxe5fkvwrW7rdV/pP1U3FzlHUxpE080qiUXzCT+bdzUyQE0Dvf/cDqE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776099334; c=relaxed/simple;
	bh=v0OTXzyGY1WYRf5XoJ9poW1vjEzEm1cbkF4gozrSqzU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f147ZFZjl8EjUthgcpba0HHDkIEvEXl55DRxU+Z+45W9/3rfCxVcRvvodzkeB0VeM1sEpmRkyQRactcVo3KtL6mTGU2gPKoGvlcLj84UHbKfg4sVHhDWDvQOE+Jbq00Q3BJC97ehTRZy9qDUfRd8xO+AzCmcb97uXcmvaRxamyk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VdmpLVVH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VdmpLVVH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2F80C2BCB3;
	Mon, 13 Apr 2026 16:55:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776099334;
	bh=v0OTXzyGY1WYRf5XoJ9poW1vjEzEm1cbkF4gozrSqzU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VdmpLVVHhA2yNVT1/bfR/fadwYAEy0CbHLD23myfF/Tku4EvsMuiarVbLwzjGlswj
	 LF59fdqng8EnLBScghHy7iM4PCUyg6TsfC/ABLYrhN0T4JlRxuG7UOYKqrxer/+D/D
	 InVYRZIdZ5k0pR8Z+RNmIslWdAQ/A7SAtaT8fHcA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhan Xusheng <zhanxusheng@xiaomi.com>,
	Thomas Gleixner <tglx@kernel.org>
Subject: [PATCH 5.10 300/491] alarmtimer: Fix argument order in alarm_timer_forward()
Date: Mon, 13 Apr 2026 17:59:05 +0200
Message-ID: <20260413155830.274942839@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155819.042779211@linuxfoundation.org>
References: <20260413155819.042779211@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -606,7 +606,7 @@ static s64 alarm_timer_forward(struct k_
 {
 	struct alarm *alarm = &timr->it.alarm.alarmtimer;
 
-	return alarm_forward(alarm, timr->it_interval, now);
+	return alarm_forward(alarm, now, timr->it_interval);
 }
 
 /**


