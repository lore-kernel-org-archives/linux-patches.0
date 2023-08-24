Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B1DB14A81
	for <patches@lists.linux.dev>; Thu, 24 Aug 2023 17:21:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 805EEC433C7;
	Thu, 24 Aug 2023 17:21:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1692897665;
	bh=kIWlIWdYcZhNpeA0b/VATOFSwJWSZStlRZfudmRJZAc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=i6Y6BZ4YerpL14PAAct2N/11YZ98HFKIkS+yOKrgecntwx2rzP51cT1YavO6K/b+F
	 +VdSbvED1u/NPbhBV+rWrZ2R2ngjvZ54cOqW3BqbgFToRVynGjbwhE8jhToZzi1y4C
	 XCJn7KYtWB5+lbGlnuyYhXZ/tTbMHo1Lm1s3zS/8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abel Wu <wuyun.abel@bytedance.com>,
	Shakeel Butt <shakeelb@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 092/135] sock: Fix misuse of sk_under_memory_pressure()
Date: Thu, 24 Aug 2023 19:09:24 +0200
Message-ID: <20230824170621.249848581@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230824170617.074557800@linuxfoundation.org>
References: <20230824170617.074557800@linuxfoundation.org>
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

From: Abel Wu <wuyun.abel@bytedance.com>

[ Upstream commit 2d0c88e84e483982067a82073f6125490ddf3614 ]

The status of global socket memory pressure is updated when:

  a) __sk_mem_raise_allocated():

	enter: sk_memory_allocated(sk) >  sysctl_mem[1]
	leave: sk_memory_allocated(sk) <= sysctl_mem[0]

  b) __sk_mem_reduce_allocated():

	leave: sk_under_memory_pressure(sk) &&
		sk_memory_allocated(sk) < sysctl_mem[0]

So the conditions of leaving global pressure are inconstant, which
may lead to the situation that one pressured net-memcg prevents the
global pressure from being cleared when there is indeed no global
pressure, thus the global constrains are still in effect unexpectedly
on the other sockets.

This patch fixes this by ignoring the net-memcg's pressure when
deciding whether should leave global memory pressure.

Fixes: e1aab161e013 ("socket: initial cgroup code.")
Signed-off-by: Abel Wu <wuyun.abel@bytedance.com>
Acked-by: Shakeel Butt <shakeelb@google.com>
Link: https://lore.kernel.org/r/20230816091226.1542-1-wuyun.abel@bytedance.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/sock.h | 6 ++++++
 net/core/sock.c    | 2 +-
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/include/net/sock.h b/include/net/sock.h
index 1fb5c535537c1..665e388593752 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -1346,6 +1346,12 @@ static inline bool sk_has_memory_pressure(const struct sock *sk)
 	return sk->sk_prot->memory_pressure != NULL;
 }
 
+static inline bool sk_under_global_memory_pressure(const struct sock *sk)
+{
+	return sk->sk_prot->memory_pressure &&
+		!!*sk->sk_prot->memory_pressure;
+}
+
 static inline bool sk_under_memory_pressure(const struct sock *sk)
 {
 	if (!sk->sk_prot->memory_pressure)
diff --git a/net/core/sock.c b/net/core/sock.c
index 98f4b4a80de42..742356cfd07c4 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -2724,7 +2724,7 @@ void __sk_mem_reduce_allocated(struct sock *sk, int amount)
 	if (mem_cgroup_sockets_enabled && sk->sk_memcg)
 		mem_cgroup_uncharge_skmem(sk->sk_memcg, amount);
 
-	if (sk_under_memory_pressure(sk) &&
+	if (sk_under_global_memory_pressure(sk) &&
 	    (sk_memory_allocated(sk) < sk_prot_mem_limits(sk, 0)))
 		sk_leave_memory_pressure(sk);
 }
-- 
2.40.1



