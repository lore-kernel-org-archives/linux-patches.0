Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89A02402B9B;
	Tue, 31 Mar 2026 16:42:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774975370; cv=none; b=l8aokwzD0GyzF5ZRPcVh8PA13Fuk9H81ofwWgB9uwLomqHf/Hahugw6Mku6gq/K10NRSTVXYuq7cRbVjEFDqIH33/iBD4bg7s/lU+N2mBZQcKAcKKh7lDsButkDlTQWf+KIjDnK7Tby0rDBfCs3bOKpUQxr5pPv75FLhSBWwZ8M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774975370; c=relaxed/simple;
	bh=iLEoHetaD5ZlaANSsYpBpeHB4UyjmNzbBTsLdHdIheY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l0jpb+bi/IVNd5eV+YlCakTIGTojiKiwb4JIeZkunmm9H9IjOaLx/lpTyQHRWWezYNm+qWhGpq/qrWnhimH2k959aoWbIB9cXv+nn+h8yoGfJ03yFM3+S+uYs7qx1TLSWFbMk6ekKRB6lRyCFDpLoIWgsP2loFod6Ie5uWMIZTo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2OozNn1V; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2OozNn1V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F889C19423;
	Tue, 31 Mar 2026 16:42:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774975370;
	bh=iLEoHetaD5ZlaANSsYpBpeHB4UyjmNzbBTsLdHdIheY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2OozNn1Va9rEwLPvn6Kf3d0p2/NlitUUjkiudaQ60bJyQeSHWe0XDO8MaoE0skSZk
	 fGQDEUTBJQkvolwOAZzZrohjhwb867c5zNnqulR8I2eC8Y6yvnKkKiWotfIFC2sR/N
	 rhpftnyjsMHjl+ElwHOZkXRsYiNbu2dONEp1gIQQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhan Xusheng <zhanxusheng@xiaomi.com>,
	Thomas Gleixner <tglx@kernel.org>
Subject: [PATCH 6.19 236/342] alarmtimer: Fix argument order in alarm_timer_forward()
Date: Tue, 31 Mar 2026 18:21:09 +0200
Message-ID: <20260331161807.649113054@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161758.909578033@linuxfoundation.org>
References: <20260331161758.909578033@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

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


