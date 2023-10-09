Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAF1E19464
	for <patches@lists.linux.dev>; Mon,  9 Oct 2023 13:13:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J5qXpSiN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 456F1C433C7;
	Mon,  9 Oct 2023 13:13:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696857184;
	bh=kiOrly07R7hwjiY6ADBoh2x4R82L50yeUBKfbHr91UI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J5qXpSiNUqHrEUx1zLuR6/QrkOFVZD08qJcwW3Y6XQIpFOzGcrJNAyDxxRHPy2S8A
	 P7AHTEXjYWfinJKcdbF2Y7xECxOM7VxhY3xxd+0HzmiBaEmT4EHGJHStoWZ3zOUGh1
	 1d3p1b+oU0N5sYnNGDi29ZKTaT8hsWOs9V5reFNk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jakub Sitnicki <jakub@cloudflare.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	John Fastabend <john.fastabend@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 099/163] bpf, sockmap: Reject sk_msg egress redirects to non-TCP sockets
Date: Mon,  9 Oct 2023 15:01:03 +0200
Message-ID: <20231009130126.766436956@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231009130124.021290599@linuxfoundation.org>
References: <20231009130124.021290599@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jakub Sitnicki <jakub@cloudflare.com>

[ Upstream commit b80e31baa43614e086a9d29dc1151932b1bd7fc5 ]

With a SOCKMAP/SOCKHASH map and an sk_msg program user can steer messages
sent from one TCP socket (s1) to actually egress from another TCP
socket (s2):

tcp_bpf_sendmsg(s1)		// = sk_prot->sendmsg
  tcp_bpf_send_verdict(s1)	// __SK_REDIRECT case
    tcp_bpf_sendmsg_redir(s2)
      tcp_bpf_push_locked(s2)
	tcp_bpf_push(s2)
	  tcp_rate_check_app_limited(s2) // expects tcp_sock
	  tcp_sendmsg_locked(s2)	 // ditto

There is a hard-coded assumption in the call-chain, that the egress
socket (s2) is a TCP socket.

However in commit 122e6c79efe1 ("sock_map: Update sock type checks for
UDP") we have enabled redirects to non-TCP sockets. This was done for the
sake of BPF sk_skb programs. There was no indention to support sk_msg
send-to-egress use case.

As a result, attempts to send-to-egress through a non-TCP socket lead to a
crash due to invalid downcast from sock to tcp_sock:

 BUG: kernel NULL pointer dereference, address: 000000000000002f
 ...
 Call Trace:
  <TASK>
  ? show_regs+0x60/0x70
  ? __die+0x1f/0x70
  ? page_fault_oops+0x80/0x160
  ? do_user_addr_fault+0x2d7/0x800
  ? rcu_is_watching+0x11/0x50
  ? exc_page_fault+0x70/0x1c0
  ? asm_exc_page_fault+0x27/0x30
  ? tcp_tso_segs+0x14/0xa0
  tcp_write_xmit+0x67/0xce0
  __tcp_push_pending_frames+0x32/0xf0
  tcp_push+0x107/0x140
  tcp_sendmsg_locked+0x99f/0xbb0
  tcp_bpf_push+0x19d/0x3a0
  tcp_bpf_sendmsg_redir+0x55/0xd0
  tcp_bpf_send_verdict+0x407/0x550
  tcp_bpf_sendmsg+0x1a1/0x390
  inet_sendmsg+0x6a/0x70
  sock_sendmsg+0x9d/0xc0
  ? sockfd_lookup_light+0x12/0x80
  __sys_sendto+0x10e/0x160
  ? syscall_enter_from_user_mode+0x20/0x60
  ? __this_cpu_preempt_check+0x13/0x20
  ? lockdep_hardirqs_on+0x82/0x110
  __x64_sys_sendto+0x1f/0x30
  do_syscall_64+0x38/0x90
  entry_SYSCALL_64_after_hwframe+0x63/0xcd

Reject selecting a non-TCP sockets as redirect target from a BPF sk_msg
program to prevent the crash. When attempted, user will receive an EACCES
error from send/sendto/sendmsg() syscall.

Fixes: 122e6c79efe1 ("sock_map: Update sock type checks for UDP")
Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: John Fastabend <john.fastabend@gmail.com>
Link: https://lore.kernel.org/bpf/20230920102055.42662-1-jakub@cloudflare.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/sock_map.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/core/sock_map.c b/net/core/sock_map.c
index 8f07fea39d9ea..3fc4086a414ea 100644
--- a/net/core/sock_map.c
+++ b/net/core/sock_map.c
@@ -668,6 +668,8 @@ BPF_CALL_4(bpf_msg_redirect_map, struct sk_msg *, msg,
 	sk = __sock_map_lookup_elem(map, key);
 	if (unlikely(!sk || !sock_map_redirect_allowed(sk)))
 		return SK_DROP;
+	if (!(flags & BPF_F_INGRESS) && !sk_is_tcp(sk))
+		return SK_DROP;
 
 	msg->flags = flags;
 	msg->sk_redir = sk;
@@ -1267,6 +1269,8 @@ BPF_CALL_4(bpf_msg_redirect_hash, struct sk_msg *, msg,
 	sk = __sock_hash_lookup_elem(map, key);
 	if (unlikely(!sk || !sock_map_redirect_allowed(sk)))
 		return SK_DROP;
+	if (!(flags & BPF_F_INGRESS) && !sk_is_tcp(sk))
+		return SK_DROP;
 
 	msg->flags = flags;
 	msg->sk_redir = sk;
-- 
2.40.1



