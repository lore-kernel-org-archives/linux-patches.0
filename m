Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 229BE1DFD1;
	Sun,  1 Sep 2024 16:48:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725209330; cv=none; b=AwZobklGqd01zF5Mq6jqz+8VsAvEO732BUO63MjMFyZvLMP/hxzUp9pOobMMigNE9QYFAhQvXxoMCLvIFkwWya8hNKUebf7fY5yoymL4HddSIAxuSma//JEgBrI/RhJIdCsA22M3X9DTcgofwOxjdPZ3UD2w71tyyAy3FiHoPnQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725209330; c=relaxed/simple;
	bh=PCvX4HOowOV3y3ZnTTzaDDo8m8Cg1uAu1XEzJVBIuiE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jqbTxYyWs4XW+NwUZWedjy3ogftqYmFkxYi47FGz4YLB7CIp6NOZg/mRCLKGGFkADLOt5gLL3H3k/n0CYp46Tj/OJiUK/KtB+YT3KR3H9kEtsYEbl3MrpTK3DWHcBLMEm/mvOyc0yqz3JQQCu2f24us3gmMWM7sBzm7gVaYMhTk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M+v2g+ME; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M+v2g+ME"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88582C4CEC3;
	Sun,  1 Sep 2024 16:48:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725209330;
	bh=PCvX4HOowOV3y3ZnTTzaDDo8m8Cg1uAu1XEzJVBIuiE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=M+v2g+MEUlIENl6sRA5SEwNQhE+nPHt5pHu3IVpFXLIanSi89uV0Vte2PeMdwqYru
	 LihwTdBBiy+d6bVcgNUCASUzNh5ozrfcKlPymwlkq6vTYV+AK/hFvH0cXyIFy/evCp
	 /rz6avftQCVQj8QmtX5K79tgqiQ2IOua/JBlirLg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Mina Almasry <almasrymina@google.com>,
	Willem de Bruijn <willemb@google.com>,
	Joe Damato <jdamato@fastly.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 54/71] net: busy-poll: use ktime_get_ns() instead of local_clock()
Date: Sun,  1 Sep 2024 18:17:59 +0200
Message-ID: <20240901160803.927857284@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160801.879647959@linuxfoundation.org>
References: <20240901160801.879647959@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 0870b0d8b393dde53106678a1e2cec9dfa52f9b7 ]

Typically, busy-polling durations are below 100 usec.

When/if the busy-poller thread migrates to another cpu,
local_clock() can be off by +/-2msec or more for small
values of HZ, depending on the platform.

Use ktimer_get_ns() to ensure deterministic behavior,
which is the whole point of busy-polling.

Fixes: 060212928670 ("net: add low latency socket poll")
Fixes: 9a3c71aa8024 ("net: convert low latency sockets to sched_clock()")
Fixes: 37089834528b ("sched, net: Fixup busy_loop_us_clock()")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Mina Almasry <almasrymina@google.com>
Cc: Willem de Bruijn <willemb@google.com>
Reviewed-by: Joe Damato <jdamato@fastly.com>
Link: https://patch.msgid.link/20240827114916.223377-1-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/busy_poll.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/net/busy_poll.h b/include/net/busy_poll.h
index f90f0021f5f2d..5387e1daa5a8b 100644
--- a/include/net/busy_poll.h
+++ b/include/net/busy_poll.h
@@ -63,7 +63,7 @@ static inline bool sk_can_busy_loop(struct sock *sk)
 static inline unsigned long busy_loop_current_time(void)
 {
 #ifdef CONFIG_NET_RX_BUSY_POLL
-	return (unsigned long)(local_clock() >> 10);
+	return (unsigned long)(ktime_get_ns() >> 10);
 #else
 	return 0;
 #endif
-- 
2.43.0



