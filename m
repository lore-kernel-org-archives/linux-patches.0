Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CAE13FB7F1;
	Tue, 31 Mar 2026 16:30:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774974605; cv=none; b=RX0BF/U1NbAdEM/0H6dUBjSjr2EGLrOjf0KBMoe5esN+pweSOtC6sjAMwDEN9RrA8V7Z2JH42EHjvCuFIcdwPqwlRaiCkSqQN/htoFiuKXBqKsCNwt+E//5u3+VSO7CMVkW1tYF793d8aYLB0nS48sa3CmDPwpNvEx7bHT36EoA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774974605; c=relaxed/simple;
	bh=qsAw8BciD7LE5KSepi4zFzNCjL/HAMA4tK5053TRIUQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iG15Lnu9E8SA8WtF0Up5NvqkPLFyVAR5DYDqO/8k1Rd+MpMcExkmWhLPpMwIRZd1G5N/Rfd690+tdiZwxOSjfT5P+grlg6638kP8dV8Ky3b8E2R0XvgI6+1fiYngrA9xkGEbZI3YTCR7pzV87Llw70JVUZJS29G/yKwXLkvVcM8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2KVo+prR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2KVo+prR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BF29C19423;
	Tue, 31 Mar 2026 16:30:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774974604;
	bh=qsAw8BciD7LE5KSepi4zFzNCjL/HAMA4tK5053TRIUQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2KVo+prRiuVwcCalThfk0yr8Vdg4Np/xGmnP11rlynwyEHxrEdi0BgJ2fWkLCgKrT
	 73iI+Fn7KKQnVZTofmk3tuHqFWSyx8H3UdSKDafoDtr94Qr4OcwGUrWenqljM2O9O0
	 hNEHFcFNFJmIeRS6tTFTtYrhDpcAATeRCtbYl9RI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhan Xusheng <zhanxusheng@xiaomi.com>,
	Thomas Gleixner <tglx@kernel.org>
Subject: [PATCH 6.6 117/175] alarmtimer: Fix argument order in alarm_timer_forward()
Date: Tue, 31 Mar 2026 18:21:41 +0200
Message-ID: <20260331161734.079957714@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161729.779738837@linuxfoundation.org>
References: <20260331161729.779738837@linuxfoundation.org>
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
@@ -608,7 +608,7 @@ static s64 alarm_timer_forward(struct k_
 {
 	struct alarm *alarm = &timr->it.alarm.alarmtimer;
 
-	return alarm_forward(alarm, timr->it_interval, now);
+	return alarm_forward(alarm, now, timr->it_interval);
 }
 
 /**


