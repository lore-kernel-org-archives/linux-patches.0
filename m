Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BD964431
	for <patches@lists.linux.dev>; Wed, 15 Mar 2023 12:34:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5829C433D2;
	Wed, 15 Mar 2023 12:34:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678883643;
	bh=ffGYKZewXyWkbzMRzxdCv5xpaRaJM2+uClDpNdqV4Ks=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=s3G4SmPgEZIgufQkmXuP1oTI08cVvuXYICTsleuJEm4PPn6W8t4x8AkoFXtgIu5bQ
	 A0ZzfxH/RdfptmdOZAckA43TQc1VmgXybSx8Cp0QO8mIotcL7cAMaFjPoFBitFOgc0
	 Cv7ztucPS6xLmRf5uuaHCl1EsrQvqVbgGYCIMi9A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Westphal <fw@strlen.de>,
	Brian Vazquez <brianvv@google.com>,
	Eric Dumazet <edumazet@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 075/143] net: use indirect calls helpers for sk_exit_memory_pressure()
Date: Wed, 15 Mar 2023 13:12:41 +0100
Message-Id: <20230315115742.826325639@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230315115740.429574234@linuxfoundation.org>
References: <20230315115740.429574234@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Brian Vazquez <brianvv@google.com>

[ Upstream commit 5c1ebbfabcd61142a4551bfc0e51840f9bdae7af ]

Florian reported a regression and sent a patch with the following
changelog:

<quote>
 There is a noticeable tcp performance regression (loopback or cross-netns),
 seen with iperf3 -Z (sendfile mode) when generic retpolines are needed.

 With SK_RECLAIM_THRESHOLD checks gone number of calls to enter/leave
 memory pressure happen much more often. For TCP indirect calls are
 used.

 We can't remove the if-set-return short-circuit check in
 tcp_enter_memory_pressure because there are callers other than
 sk_enter_memory_pressure.  Doing a check in the sk wrapper too
 reduces the indirect calls enough to recover some performance.

 Before,
 0.00-60.00  sec   322 GBytes  46.1 Gbits/sec                  receiver

 After:
 0.00-60.04  sec   359 GBytes  51.4 Gbits/sec                  receiver

 "iperf3 -c $peer -t 60 -Z -f g", connected via veth in another netns.
</quote>

It seems we forgot to upstream this indirect call mitigation we
had for years, lets do this instead.

[edumazet] - It seems we forgot to upstream this indirect call
             mitigation we had for years, let's do this instead.
           - Changed to INDIRECT_CALL_INET_1() to avoid bots reports.

Fixes: 4890b686f408 ("net: keep sk->sk_forward_alloc as small as possible")
Reported-by: Florian Westphal <fw@strlen.de>
Link: https://lore.kernel.org/netdev/20230227152741.4a53634b@kernel.org/T/
Signed-off-by: Brian Vazquez <brianvv@google.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Link: https://lore.kernel.org/r/20230301133247.2346111-1-edumazet@google.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/sock.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/core/sock.c b/net/core/sock.c
index 4dfdcdfd00114..eb0b76acd9df1 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -2805,7 +2805,8 @@ static void sk_enter_memory_pressure(struct sock *sk)
 static void sk_leave_memory_pressure(struct sock *sk)
 {
 	if (sk->sk_prot->leave_memory_pressure) {
-		sk->sk_prot->leave_memory_pressure(sk);
+		INDIRECT_CALL_INET_1(sk->sk_prot->leave_memory_pressure,
+				     tcp_leave_memory_pressure, sk);
 	} else {
 		unsigned long *memory_pressure = sk->sk_prot->memory_pressure;
 
-- 
2.39.2



