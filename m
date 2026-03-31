Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6936C2FE042;
	Tue, 31 Mar 2026 17:05:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774976737; cv=none; b=tHO5J2RajaAkU5hnaARMKlWFMtkWftGXkxz/f80MOGHkwiC+iVHjwzCUpLcaJv0P6OSkl58brj/gn5eKl9eLLeGExv1pkk3yeVv1ey0y7Ld1q88CdIaQ+ZziHsSk+P2oM+oo8wQVKtrRD5Q5R2vT+fC2dHn1aRC7c5lnk29PQII=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774976737; c=relaxed/simple;
	bh=RX1a4hkxdQ79zM8doB7ZSvtrnCCAbiRWS5Mxit0h/LQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q8sZbU2UzrHehU5zjz12MNu7rFd1UVFogzSWIruV5FyDXEbW0tLySrdNKGmnTKiLYrJ/UZFgaK55Z+4wJ4bqgi9z2QMnVj1rw0gxAMUlN36TO4rYPIDas5h06a8Dx/EoyP2LJitJmEbA7pVG5RJy8uA0Ke/FXDYKzj0k+SJDY0Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rIJcq7gz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rIJcq7gz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 006C4C19423;
	Tue, 31 Mar 2026 17:05:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774976737;
	bh=RX1a4hkxdQ79zM8doB7ZSvtrnCCAbiRWS5Mxit0h/LQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rIJcq7gzgYDfNBKibZgTZV7Kahlp904VzHQMwZnNsOnYVMaEbA2Xm94YPzikYBANZ
	 pGsIAqvnHj6cE1mBrTUys+WCq6zr6rve9Hv2O5dLjFQloxM+/WTYwSx3U9HS8mXOAG
	 XLmfaEeY7k8n+GFvl36GHtafG8M9WD0MsYeqXSxk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhan Xusheng <zhanxusheng@xiaomi.com>,
	Thomas Gleixner <tglx@kernel.org>
Subject: [PATCH 6.18 209/309] alarmtimer: Fix argument order in alarm_timer_forward()
Date: Tue, 31 Mar 2026 18:21:52 +0200
Message-ID: <20260331161801.141593950@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161753.468533260@linuxfoundation.org>
References: <20260331161753.468533260@linuxfoundation.org>
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
@@ -540,7 +540,7 @@ static s64 alarm_timer_forward(struct k_
 {
 	struct alarm *alarm = &timr->it.alarm.alarmtimer;
 
-	return alarm_forward(alarm, timr->it_interval, now);
+	return alarm_forward(alarm, now, timr->it_interval);
 }
 
 /**


