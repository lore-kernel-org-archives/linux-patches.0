Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC9CF313546;
	Wed,  3 Dec 2025 16:47:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764780454; cv=none; b=quTHGvD3Bkz9NE3axnh+WPWtUOsMMi1/uYZbUd2dfvvtsLYz45h/+6D0HVFy+NC1l5mljguvpWuxNTYB6EEEniV1Prtw7mShs0WXlz2KzTdSubPOxr96VjTGediwNp/UEYjaVZU+ydVYl8kfJJ+eO5ZJrt2LhvXk7iQNRpzGxzs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764780454; c=relaxed/simple;
	bh=6TmJcxQqz/ZjzchD0zIJeqhO+CyPzFjnHpPKKdDRo7w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KyU1Pkyo4VyBF43fb/bcakXo1/FANlZ+fJuHlodgbrFGLcreTXjpSadWab5TO9l+kNYIPuFcu2Jqfq/M0WdKlBPjngpZ56zzSWmy+GG9u8nQn91QXc2GwOtReHDc2ueQC/IAWdCtGp2Z5JM7Gt4xXfI1Hb1Aw59WUdYlP/neM54=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LYqR8Fee; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LYqR8Fee"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFDB4C4CEF5;
	Wed,  3 Dec 2025 16:47:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764780454;
	bh=6TmJcxQqz/ZjzchD0zIJeqhO+CyPzFjnHpPKKdDRo7w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LYqR8Fee1BaP0dleE49/ijLd8oDrCLZQLE/+vxdmxLy09IsvE5mVBc+hb3dSftQfI
	 KhI6Ng8nLLx4BptWRZ+bhRvUK0AVJJ/0Hs3Q3VmFIUFkDjm3TG5s63JWA1mVrp75Jo
	 RSHNK5RVSToB4jaWWzGM8DumiQIX//YVVMWNNejc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiayuan Chen <jiayuan.chen@linux.dev>,
	Martin KaFai Lau <martin.lau@kernel.org>,
	Jakub Sitnicki <jakub@cloudflare.com>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>
Subject: [PATCH 6.1 560/568] mptcp: Fix proto fallback detection with BPF
Date: Wed,  3 Dec 2025 16:29:22 +0100
Message-ID: <20251203152501.222977731@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152440.645416925@linuxfoundation.org>
References: <20251203152440.645416925@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
[ Conflicts in protocol.c, because commit 8e2b8a9fa512 ("mptcp: don't
  overwrite sock_ops in mptcp_is_tcpsk()") is not in this version. It
  changes the logic on how and where the sock_ops is overridden in case
  of passive fallback. To fix this, mptcp_is_tcpsk() is modified to use
  the family, but first, a check of the protocol is required to continue
  returning 'false' in case of MPTCP socket. ]
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/protocol.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -79,8 +79,13 @@ static u64 mptcp_wnd_end(const struct mp
 static bool mptcp_is_tcpsk(struct sock *sk)
 {
 	struct socket *sock = sk->sk_socket;
+	unsigned short family;
 
-	if (unlikely(sk->sk_prot == &tcp_prot)) {
+	if (likely(sk->sk_protocol == IPPROTO_MPTCP))
+		return false;
+
+	family = READ_ONCE(sk->sk_family);
+	if (unlikely(family == AF_INET)) {
 		/* we are being invoked after mptcp_accept() has
 		 * accepted a non-mp-capable flow: sk is a tcp_sk,
 		 * not an mptcp one.
@@ -91,7 +96,7 @@ static bool mptcp_is_tcpsk(struct sock *
 		sock->ops = &inet_stream_ops;
 		return true;
 #if IS_ENABLED(CONFIG_MPTCP_IPV6)
-	} else if (unlikely(sk->sk_prot == &tcpv6_prot)) {
+	} else if (unlikely(family == AF_INET6)) {
 		sock->ops = &inet6_stream_ops;
 		return true;
 #endif


