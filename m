Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3C5211C83
	for <patches@lists.linux.dev>; Mon, 28 Aug 2023 10:47:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD2EFC433C8;
	Mon, 28 Aug 2023 10:47:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1693219667;
	bh=fIL4lUI0mtenToI5GPL97ZgDwoIBs2QZ+zAbt6X5uF0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=j3u+2muc0zzsejwLh9A4/6olYh9jTJO0/7KnYtlKmL1ANAFIKPNq2ULq4qk4Lb3Tm
	 LfzZIF4053KB8XMqgnws+gh3DOmE7coZd2FnU5phvjuWgkYbdNyn8EkrXaVEQ4KMmD
	 XNRAQmHDwc3Mh0FCmgkGHs6/ppeDjnGTqfYtyRyA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Abel Wu <wuyun.abel@bytedance.com>,
	Shakeel Butt <shakeelb@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 28/84] sock: annotate data-races around prot->memory_pressure
Date: Mon, 28 Aug 2023 12:13:45 +0200
Message-ID: <20230828101150.200332817@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230828101149.146126827@linuxfoundation.org>
References: <20230828101149.146126827@linuxfoundation.org>
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

[ Upstream commit 76f33296d2e09f63118db78125c95ef56df438e9 ]

*prot->memory_pressure is read/writen locklessly, we need
to add proper annotations.

A recent commit added a new race, it is time to audit all accesses.

Fixes: 2d0c88e84e48 ("sock: Fix misuse of sk_under_memory_pressure()")
Fixes: 4d93df0abd50 ("[SCTP]: Rewrite of sctp buffer management code")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Abel Wu <wuyun.abel@bytedance.com>
Reviewed-by: Shakeel Butt <shakeelb@google.com>
Link: https://lore.kernel.org/r/20230818015132.2699348-1-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/sock.h | 7 ++++---
 net/sctp/socket.c  | 2 +-
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/include/net/sock.h b/include/net/sock.h
index 665e388593752..234196d904238 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -1233,6 +1233,7 @@ struct proto {
 	/*
 	 * Pressure flag: try to collapse.
 	 * Technical note: it is used by multiple contexts non atomically.
+	 * Make sure to use READ_ONCE()/WRITE_ONCE() for all reads/writes.
 	 * All the __sk_mem_schedule() is of this nature: accounting
 	 * is strict, actions are advisory and have some latency.
 	 */
@@ -1349,7 +1350,7 @@ static inline bool sk_has_memory_pressure(const struct sock *sk)
 static inline bool sk_under_global_memory_pressure(const struct sock *sk)
 {
 	return sk->sk_prot->memory_pressure &&
-		!!*sk->sk_prot->memory_pressure;
+		!!READ_ONCE(*sk->sk_prot->memory_pressure);
 }
 
 static inline bool sk_under_memory_pressure(const struct sock *sk)
@@ -1361,7 +1362,7 @@ static inline bool sk_under_memory_pressure(const struct sock *sk)
 	    mem_cgroup_under_socket_pressure(sk->sk_memcg))
 		return true;
 
-	return !!*sk->sk_prot->memory_pressure;
+	return !!READ_ONCE(*sk->sk_prot->memory_pressure);
 }
 
 static inline long
@@ -1415,7 +1416,7 @@ proto_memory_pressure(struct proto *prot)
 {
 	if (!prot->memory_pressure)
 		return false;
-	return !!*prot->memory_pressure;
+	return !!READ_ONCE(*prot->memory_pressure);
 }
 
 
diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index 534364bb871a3..fa4d31b507f29 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -97,7 +97,7 @@ struct percpu_counter sctp_sockets_allocated;
 
 static void sctp_enter_memory_pressure(struct sock *sk)
 {
-	sctp_memory_pressure = 1;
+	WRITE_ONCE(sctp_memory_pressure, 1);
 }
 
 
-- 
2.40.1



