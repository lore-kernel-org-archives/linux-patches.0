Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792774092;
	b=V33pwX5qb80sFBGYvoDNxXdmtk6eGUH771ogS2RR6TCFr3+RPo8KwZ+ZT7vd2XsUe1D4
	 TmB3VtvcslCqvEHa+e+8ehRYbLL1dBsyJFRJR1I13T4iyntDFGFfm4rrjlj7ipolbwfuv
	 NHUsTCfTe+EQkF+mhtG23W2iVQD8nCVo5ekbIRN++v9UUHJZpBO9o4T7vRZlajApUwN7B
	 05UafNIJ6SMgmgIpo1av0mxef3ux8JEtXwHhdKXzP8LCwuDNaYONkhdGG8+PhYvpWyAQr
	 q5YT444ffK657jzCXg+tqhdNFwmk+Yfas4qqulUtywjxCf2uJp1iywENfqiHgceNyTg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792774092;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=O2VhRuMUla0BL/pc0NqU/3OoL4uicQPAX0/R+h4zDFw=;
	b=RsRUf9LbpIgTs0CNXSTEk02fCRS+PH8pn/xLusROvvQnKKKcoqqhOuhCDB2ltKCQ/YmG
	 bx+lhF0ReTpo05noBrR05bypZ1d5a4bMzb+B2f0u06TctZtODf7PbqsgLPleSeyNguV9M
	 TK15l0kEPebFYR7D+iwsEYWeEV/4jhX2hmKuvKqu6VLvMx6QHhpvf1jpOsefEuY9TIIKU
	 YAuk1oiTuMfAbIqzEiQe9L7lopAqN4J5+0QY0bvPN1gKB2VqAsu9kuGJ89ebNSVwnQnqs
	 aKmoK6folQRK2Sb0P+/JdluXJk0YsSjUtDti9mfMCPBJYfBB0aq4kaQ0nRBBgVZuueg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jFJoCs4o;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16905606A31B;
	Fri, 23 Oct 2026 16:48:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jFJoCs4o
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B3F51F01825;
	Fri, 23 Oct 2026 16:48:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792774091;
	bh=O2VhRuMUla0BL/pc0NqU/3OoL4uicQPAX0/R+h4zDFw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jFJoCs4oEaHH2F1QkE/zOH1duPE9H7yWyIpSDjqDWV1pkynF68MJ8TwEEfFry2LNu
	 dsUJa8tFfLdvaa1mLJTUtk5XeIDRHcw4rT6kE2GoHVw//4YOcecicHG2EUZ9M4YDEV
	 iP6xUPLQ2j9GRL0PNhWhsW4IUdjdGNfl6gUDQtRM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	AutonomousCodeSecurity@microsoft.com,
	"Cen Zhang (Microsoft Security FORGE Labs)" <blbllhy@gmail.com>,
	Jiayuan Chen <jiayuan.chen@linux.dev>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.18 118/193] tcp: fix use-after-free in do_tcp_getsockopt(TCP_CC_INFO)
Date: Fri, 23 Oct 2026 18:36:35 +0200
Message-ID: <20261023163716.994348191@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261023163714.201276352@linuxfoundation.org>
References: <20261023163714.201276352@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cen Zhang (Microsoft Security FORGE Labs) <blbllhy@gmail.com>

commit 385e474086c2e7e29e2dded690be40dc273e20ee upstream.

do_tcp_getsockopt() reads icsk->icsk_ca_ops and dereferences the
get_info function pointer without rcu_read_lock(). With BPF struct_ops
congestion control, ca_ops can point to dynamically allocated memory
that is freed concurrently, resulting in a use-after-free when the
kernel dereferences or calls through the stale pointer.

  BUG: KASAN: slab-use-after-free in do_tcp_getsockopt+0x2037/0x23e0
  Read of size 8 at addr ffff888013701258 by task exploit/149
   do_tcp_getsockopt+0x2037/0x23e0 (net/ipv4/tcp.c:4564)
   tcp_getsockopt+0x91/0xf0
   __sys_getsockopt+0xf7/0x170

Fix this by wrapping the ca_ops load and get_info call within
rcu_read_lock()/rcu_read_unlock(), and using READ_ONCE() to load
the icsk_ca_ops pointer.

Fixes: 0baf26b0fcd7 ("bpf: tcp: Support tcp_congestion_ops in bpf")
Suggested-by: Eric Dumazet <edumazet@google.com>
Cc: AutonomousCodeSecurity@microsoft.com
Cc: stable@vger.kernel.org
Reviewed-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: Cen Zhang (Microsoft Security FORGE Labs) <blbllhy@gmail.com>
Reviewed-by: Jiayuan Chen <jiayuan.chen@linux.dev>
Reviewed-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://patch.msgid.link/65fd3816ed5d541d9edd4bf4fcf97104a2cf907a.1787870710.git.blbllhy@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/tcp.c       |    4 +++-
 net/ipv4/tcp_dctcp.c |    2 +-
 2 files changed, 4 insertions(+), 2 deletions(-)

--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -4540,9 +4540,11 @@ int do_tcp_getsockopt(struct sock *sk, i
 		if (copy_from_sockptr(&len, optlen, sizeof(int)))
 			return -EFAULT;
 
-		ca_ops = icsk->icsk_ca_ops;
+		rcu_read_lock();
+		ca_ops = READ_ONCE(icsk->icsk_ca_ops);
 		if (ca_ops && ca_ops->get_info)
 			sz = ca_ops->get_info(sk, ~0U, &attr, &info);
+		rcu_read_unlock();
 
 		len = min_t(unsigned int, len, sz);
 		if (copy_to_sockptr(optlen, &len, sizeof(int)))
--- a/net/ipv4/tcp_dctcp.c
+++ b/net/ipv4/tcp_dctcp.c
@@ -224,7 +224,7 @@ static size_t dctcp_get_info(struct sock
 	if (ext & (1 << (INET_DIAG_DCTCPINFO - 1)) ||
 	    ext & (1 << (INET_DIAG_VEGASINFO - 1))) {
 		memset(&info->dctcp, 0, sizeof(info->dctcp));
-		if (inet_csk(sk)->icsk_ca_ops != &dctcp_reno) {
+		if (READ_ONCE(inet_csk(sk)->icsk_ca_ops) != &dctcp_reno) {
 			info->dctcp.dctcp_enabled = 1;
 			info->dctcp.dctcp_ce_state = (u16) ca->ce_state;
 			info->dctcp.dctcp_alpha = ca->dctcp_alpha;


