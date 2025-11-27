Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B689F2882C9;
	Thu, 27 Nov 2025 14:52:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764255120; cv=none; b=fe3KBHnurBd/QPno2TmiyGlRYXlgBwIGNr1xIqNEgWLsn2ZSIjN7vlROUYTHwMR7DDcSbm5AYj8XkNCB13IX3ocS7rTQhfiYODZ12xKlddEETJvBa8DYJmeVnzjQs+F++Oa7nS/BDSSm/a9hYSIptTahYdVQcIQ+Dbin+FIk/VM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764255120; c=relaxed/simple;
	bh=Q7xiEWAblFoYXQfS7zKq6u2Ua1nQeZVoBMXvF2y3/GI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JUHKxgA/WXPUzAC+aonFFzzHvvlqF6zmarTsnqo0nlfEYuZ5wiHP7gR6WOkTYSFb6IQR3E8N+5tigVjHndEa5V2J7R+DDQIPHheala3uOfJdQwyik7ROf52WW4iite7OzcSqriAHjCl9y2uH7CpW+Bd9qgbByBHDyVKsSpt+j2g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qyRWc43a; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qyRWc43a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BF14C4CEF8;
	Thu, 27 Nov 2025 14:51:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764255120;
	bh=Q7xiEWAblFoYXQfS7zKq6u2Ua1nQeZVoBMXvF2y3/GI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qyRWc43aXKAlq8uSYbEWI11kjOOdoI3LzYYNt3qww70KbaqR/MyGhHpUNZZrApg8i
	 btna4urfq98rCvQvqDg/tEL1t1fTS+rLmy9rT0FWrRhaLAvrWl67Pos+KZqZJeedUV
	 GIkEA+3KdmOCOo4gqJvEI2N3+OQ9jcaAmymc0pw8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiayuan Chen <jiayuan.chen@linux.dev>,
	Martin KaFai Lau <martin.lau@kernel.org>,
	Jakub Sitnicki <jakub@cloudflare.com>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>
Subject: [PATCH 6.12 015/112] mptcp: Fix proto fallback detection with BPF
Date: Thu, 27 Nov 2025 15:45:17 +0100
Message-ID: <20251127144033.289954555@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251127144032.705323598@linuxfoundation.org>
References: <20251127144032.705323598@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiayuan Chen <jiayuan.chen@linux.dev>

commit c77b3b79a92e3345aa1ee296180d1af4e7031f8f upstream.

The sockmap feature allows bpf syscall from userspace, or based
on bpf sockops, replacing the sk_prot of sockets during protocol stack
processing with sockmap's custom read/write interfaces.
'''
tcp_rcv_state_process()
  syn_recv_sock()/subflow_syn_recv_sock()
    tcp_init_transfer(BPF_SOCK_OPS_PASSIVE_ESTABLISHED_CB)
      bpf_skops_established       <== sockops
        bpf_sock_map_update(sk)   <== call bpf helper
          tcp_bpf_update_proto()  <== update sk_prot
'''

When the server has MPTCP enabled but the client sends a TCP SYN
without MPTCP, subflow_syn_recv_sock() performs a fallback on the
subflow, replacing the subflow sk's sk_prot with the native sk_prot.
'''
subflow_syn_recv_sock()
  subflow_ulp_fallback()
    subflow_drop_ctx()
      mptcp_subflow_ops_undo_override()
'''

Then, this subflow can be normally used by sockmap, which replaces the
native sk_prot with sockmap's custom sk_prot. The issue occurs when the
user executes accept::mptcp_stream_accept::mptcp_fallback_tcp_ops().
Here, it uses sk->sk_prot to compare with the native sk_prot, but this
is incorrect when sockmap is used, as we may incorrectly set
sk->sk_socket->ops.

This fix uses the more generic sk_family for the comparison instead.

Additionally, this also prevents a WARNING from occurring:

result from ./scripts/decode_stacktrace.sh:
------------[ cut here ]------------
WARNING: CPU: 0 PID: 337 at net/mptcp/protocol.c:68 mptcp_stream_accept \
(net/mptcp/protocol.c:4005)
Modules linked in:
...

PKRU: 55555554
Call Trace:
<TASK>
do_accept (net/socket.c:1989)
__sys_accept4 (net/socket.c:2028 net/socket.c:2057)
__x64_sys_accept (net/socket.c:2067)
x64_sys_call (arch/x86/entry/syscall_64.c:41)
do_syscall_64 (arch/x86/entry/syscall_64.c:63 arch/x86/entry/syscall_64.c:94)
entry_SYSCALL_64_after_hwframe (arch/x86/entry/entry_64.S:130)
RIP: 0033:0x7f87ac92b83d

---[ end trace 0000000000000000 ]---

Fixes: 0b4f33def7bb ("mptcp: fix tcp fallback crash")
Signed-off-by: Jiayuan Chen <jiayuan.chen@linux.dev>
Signed-off-by: Martin KaFai Lau <martin.lau@kernel.org>
Reviewed-by: Jakub Sitnicki <jakub@cloudflare.com>
Reviewed-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Cc: <stable@vger.kernel.org>
Link: https://patch.msgid.link/20251111060307.194196-3-jiayuan.chen@linux.dev
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/protocol.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -57,11 +57,13 @@ static u64 mptcp_wnd_end(const struct mp
 
 static const struct proto_ops *mptcp_fallback_tcp_ops(const struct sock *sk)
 {
+	unsigned short family = READ_ONCE(sk->sk_family);
+
 #if IS_ENABLED(CONFIG_MPTCP_IPV6)
-	if (sk->sk_prot == &tcpv6_prot)
+	if (family == AF_INET6)
 		return &inet6_stream_ops;
 #endif
-	WARN_ON_ONCE(sk->sk_prot != &tcp_prot);
+	WARN_ON_ONCE(family != AF_INET);
 	return &inet_stream_ops;
 }
 


