Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFF971292C8;
	Tue, 30 Apr 2024 10:48:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714474137; cv=none; b=RUg4fIE47a3NZyRIDFbzxCAlJGIMX0Y6/RD69pH/EBDj8hQRNeVqdaDRIbIRBqDFW1BA3Ie8z4ms4MazeVbWpPx+8uW4b77M8eYGvPmjgPRvhzQ+qwg83yKwY3vMRJKyog5yG6lSu4fG3oRfQUjX4vYfxNttOlyfPhPARRssX7w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714474137; c=relaxed/simple;
	bh=45Irq4r6mHvjqv56TuSilZTAdojhAVinqjxnj/S3rJs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fg6PaRMudJhLXugg+7ilIj6jrCzWLIiSIiDDlMCDClwfnKeIlCfjyUkNJbBeNFuQ1PzNNqxikn4YMZdOtfQXCjY516zibE8J0hVNDej+TK2gF2emlGBC8LI8fjchJFWeP7M+wN/FAM8tdEUUZEeMWovkdD3XxCrgPCKgXGNZaIE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RCUwI5FL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RCUwI5FL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23A43C2BBFC;
	Tue, 30 Apr 2024 10:48:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714474137;
	bh=45Irq4r6mHvjqv56TuSilZTAdojhAVinqjxnj/S3rJs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RCUwI5FL34RPp6X0FcNdhSVfiVkostgGjC0FcggpfwUfz/BTJicjYO6qOdmnTLt+o
	 qO3uQLoLeVKMNB2Ch0o2I3eQ4TzPM3EmcauJ1MKNxKH/5HWNkY5hue4jUcpPs23JMM
	 krvhECKKqnbTMJ7uP3JONSaAQnHA9VAn+V6Uk5UY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonathan Heathcote <jonathan.heathcote@bbc.co.uk>,
	Eric Dumazet <edumazet@google.com>,
	Soheil Hassas Yeganeh <soheil@google.com>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 068/228] net: fix sk_memory_allocated_{add|sub} vs softirqs
Date: Tue, 30 Apr 2024 12:37:26 +0200
Message-ID: <20240430103105.770461297@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103103.806426847@linuxfoundation.org>
References: <20240430103103.806426847@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 3584718cf2ec7e79b6814f2596dcf398c5fb2eca ]

Jonathan Heathcote reported a regression caused by blamed commit
on aarch64 architecture.

x86 happens to have irq-safe __this_cpu_add_return()
and __this_cpu_sub(), but this is not generic.

I think my confusion came from "struct sock" argument,
because these helpers are called with a locked socket.
But the memory accounting is per-proto (and per-cpu after
the blamed commit). We might cleanup these helpers later
to directly accept a "struct proto *proto" argument.

Switch to this_cpu_add_return() and this_cpu_xchg()
operations, and get rid of preempt_disable()/preempt_enable() pairs.

Fast path becomes a bit faster as a result :)

Many thanks to Jonathan Heathcote for his awesome report and
investigations.

Fixes: 3cd3399dd7a8 ("net: implement per-cpu reserves for memory_allocated")
Reported-by: Jonathan Heathcote <jonathan.heathcote@bbc.co.uk>
Closes: https://lore.kernel.org/netdev/VI1PR01MB42407D7947B2EA448F1E04EFD10D2@VI1PR01MB4240.eurprd01.prod.exchangelabs.com/
Signed-off-by: Eric Dumazet <edumazet@google.com>
Acked-by: Soheil Hassas Yeganeh <soheil@google.com>
Reviewed-by: Shakeel Butt <shakeel.butt@linux.dev>
Link: https://lore.kernel.org/r/20240421175248.1692552-1-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/sock.h | 38 ++++++++++++++++++++------------------
 1 file changed, 20 insertions(+), 18 deletions(-)

diff --git a/include/net/sock.h b/include/net/sock.h
index 6855c50a70f1b..54a7967613348 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -1431,32 +1431,34 @@ sk_memory_allocated(const struct sock *sk)
 #define SK_MEMORY_PCPU_RESERVE (1 << (20 - PAGE_SHIFT))
 extern int sysctl_mem_pcpu_rsv;
 
+static inline void proto_memory_pcpu_drain(struct proto *proto)
+{
+	int val = this_cpu_xchg(*proto->per_cpu_fw_alloc, 0);
+
+	if (val)
+		atomic_long_add(val, proto->memory_allocated);
+}
+
 static inline void
-sk_memory_allocated_add(struct sock *sk, int amt)
+sk_memory_allocated_add(const struct sock *sk, int val)
 {
-	int local_reserve;
+	struct proto *proto = sk->sk_prot;
 
-	preempt_disable();
-	local_reserve = __this_cpu_add_return(*sk->sk_prot->per_cpu_fw_alloc, amt);
-	if (local_reserve >= READ_ONCE(sysctl_mem_pcpu_rsv)) {
-		__this_cpu_sub(*sk->sk_prot->per_cpu_fw_alloc, local_reserve);
-		atomic_long_add(local_reserve, sk->sk_prot->memory_allocated);
-	}
-	preempt_enable();
+	val = this_cpu_add_return(*proto->per_cpu_fw_alloc, val);
+
+	if (unlikely(val >= READ_ONCE(sysctl_mem_pcpu_rsv)))
+		proto_memory_pcpu_drain(proto);
 }
 
 static inline void
-sk_memory_allocated_sub(struct sock *sk, int amt)
+sk_memory_allocated_sub(const struct sock *sk, int val)
 {
-	int local_reserve;
+	struct proto *proto = sk->sk_prot;
 
-	preempt_disable();
-	local_reserve = __this_cpu_sub_return(*sk->sk_prot->per_cpu_fw_alloc, amt);
-	if (local_reserve <= -READ_ONCE(sysctl_mem_pcpu_rsv)) {
-		__this_cpu_sub(*sk->sk_prot->per_cpu_fw_alloc, local_reserve);
-		atomic_long_add(local_reserve, sk->sk_prot->memory_allocated);
-	}
-	preempt_enable();
+	val = this_cpu_sub_return(*proto->per_cpu_fw_alloc, val);
+
+	if (unlikely(val <= -READ_ONCE(sysctl_mem_pcpu_rsv)))
+		proto_memory_pcpu_drain(proto);
 }
 
 #define SK_ALLOC_PERCPU_COUNTER_BATCH 16
-- 
2.43.0



