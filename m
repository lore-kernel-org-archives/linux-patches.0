Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D98C9181334;
	Sun,  1 Sep 2024 16:56:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725209770; cv=none; b=f8nFIylcJPAUHqGgmz/jbvhyXSpneYJmPyhOWN0Xwt4ho9soQW1PAIAOejgQme8TLQ4VS898XFzsLnVmyqLPeva4ti5gKaoltqShfwuF3pKFKrgwB07McwBLyk7z+6tbmHQq7LHjPSJMA8dCEVTXagEp3q/Ed3Bf94dzEdaCKPo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725209770; c=relaxed/simple;
	bh=g7+eWRfHdW/lDABwU/suSHqO6GaFeS82RpjZVHPMZ30=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X9X2InL7QcXyPYDOUiL+R4d8fqfKEYvycfJKzFcY7Lr2CyAmFiGBZtVazBCNyGBJ9qrS+5bOsaYght6pL+DfFCLO/ajz7oXRfKIBzU9EGdCfBdS3EuLKZXRkXAWrBC0bc7rv4Y1WVcQu63yXJHZu4ZgPiW3Q/dWPHDhYSUgTYks=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VKopTk0u; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VKopTk0u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 465E2C4CEC3;
	Sun,  1 Sep 2024 16:56:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725209770;
	bh=g7+eWRfHdW/lDABwU/suSHqO6GaFeS82RpjZVHPMZ30=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VKopTk0uh2J5RZ6ruNaYSLfhVPSBTEYVFSALyASYjQNIO9dL0zCPNGBVpMkrpg+C7
	 Sh4mh8pEKArapvsNqeqvV2WzA/tjKlqv4oqAbY+ss+6HSxBH69/72Niy6TP/aJO789
	 tNgz0m+hlKGVkQNJWBuwttIwC04OtBZm1MiB3X1k=
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
Subject: [PATCH 5.10 140/151] net: busy-poll: use ktime_get_ns() instead of local_clock()
Date: Sun,  1 Sep 2024 18:18:20 +0200
Message-ID: <20240901160819.374454433@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160814.090297276@linuxfoundation.org>
References: <20240901160814.090297276@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 36e5e75e71720..be01eda3b6ff7 100644
--- a/include/net/busy_poll.h
+++ b/include/net/busy_poll.h
@@ -61,7 +61,7 @@ static inline bool sk_can_busy_loop(struct sock *sk)
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



