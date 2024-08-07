Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FEF781751;
	Wed,  7 Aug 2024 15:11:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723043516; cv=none; b=F9DbDbLLweDuLoGjC3EIDEmKKl0eMcHKi5T1m8TNW78EUT+nkDK4dcmuWhUnqLz8jMWOEH1md+mNAZ7/sXorYiPb+AwNuNf/3q/z2josukYBrWOd6CoRLxo5a6Kx+pHhGgPS2h1d/aSqfsH4Uxjl6ds0MoOKUAl5HaKnEJdkyOc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723043516; c=relaxed/simple;
	bh=cEWZEMKdC+tbpPlRnq/TsyEr0gvxDo+HrfshmYM34hI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=esjspgWBTLsoUivw7qfCYlXY0ip+jvOhTx9UX/D6FIloQ4EXUiOS+Mi3u+zCVujZ+g5kNt79JSX/1n2XePPFDkClWj2TAxSC1KVWRm8yY7RvgyrvY7vB5DRKhSzcd2WYCrAy4LQjcLtHAkSyy9dKWMfRvwIRqMSN9B+7/6dBd7Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XsxB9rCe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XsxB9rCe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22A8FC32781;
	Wed,  7 Aug 2024 15:11:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723043516;
	bh=cEWZEMKdC+tbpPlRnq/TsyEr0gvxDo+HrfshmYM34hI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XsxB9rCew8oS+V3j+dYG7/iPBAuuWMGZGxw1TZggwA9Db0eQDVlV/gJ5VLeiBd4Fr
	 pcvBdYA0VNVIO9JgC57fY6iTkYXbhRNtNPHNdQ1vEAmbBcQGs2kdKWym1y3HR2SODh
	 AjnDco56VwpJxpd3/e2Ma7+hVODW5M6O0MvVvnlU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexei Starovoitov <alexei.starovoitov@gmail.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Mat Martineau <martineau@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.6 121/121] mptcp: prevent BPF accessing lowat from a subflow socket.
Date: Wed,  7 Aug 2024 17:00:53 +0200
Message-ID: <20240807150023.359740508@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240807150019.412911622@linuxfoundation.org>
References: <20240807150019.412911622@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paolo Abeni <pabeni@redhat.com>

commit fcf4692fa39e86a590c14a4af2de704e1d20a3b5 upstream.

Alexei reported the following splat:

 WARNING: CPU: 32 PID: 3276 at net/mptcp/subflow.c:1430 subflow_data_ready+0x147/0x1c0
 Modules linked in: dummy bpf_testmod(O) [last unloaded: bpf_test_no_cfi(O)]
 CPU: 32 PID: 3276 Comm: test_progs Tainted: GO       6.8.0-12873-g2c43c33bfd23
 Call Trace:
  <TASK>
  mptcp_set_rcvlowat+0x79/0x1d0
  sk_setsockopt+0x6c0/0x1540
  __bpf_setsockopt+0x6f/0x90
  bpf_sock_ops_setsockopt+0x3c/0x90
  bpf_prog_509ce5db2c7f9981_bpf_test_sockopt_int+0xb4/0x11b
  bpf_prog_dce07e362d941d2b_bpf_test_socket_sockopt+0x12b/0x132
  bpf_prog_348c9b5faaf10092_skops_sockopt+0x954/0xe86
  __cgroup_bpf_run_filter_sock_ops+0xbc/0x250
  tcp_connect+0x879/0x1160
  tcp_v6_connect+0x50c/0x870
  mptcp_connect+0x129/0x280
  __inet_stream_connect+0xce/0x370
  inet_stream_connect+0x36/0x50
  bpf_trampoline_6442491565+0x49/0xef
  inet_stream_connect+0x5/0x50
  __sys_connect+0x63/0x90
  __x64_sys_connect+0x14/0x20

The root cause of the issue is that bpf allows accessing mptcp-level
proto_ops from a tcp subflow scope.

Fix the issue detecting the problematic call and preventing any action.

Reported-by: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Closes: https://github.com/multipath-tcp/mptcp_net-next/issues/482
Fixes: 5684ab1a0eff ("mptcp: give rcvlowat some love")
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Reviewed-by: Mat Martineau <martineau@kernel.org>
Reviewed-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://lore.kernel.org/r/d8cb7d8476d66cb0812a6e29cd1e626869d9d53e.1711738080.git.pabeni@redhat.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/sockopt.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/net/mptcp/sockopt.c
+++ b/net/mptcp/sockopt.c
@@ -1538,6 +1538,10 @@ int mptcp_set_rcvlowat(struct sock *sk,
 	struct mptcp_subflow_context *subflow;
 	int space, cap;
 
+	/* bpf can land here with a wrong sk type */
+	if (sk->sk_protocol == IPPROTO_TCP)
+		return -EINVAL;
+
 	if (sk->sk_userlocks & SOCK_RCVBUF_LOCK)
 		cap = sk->sk_rcvbuf >> 1;
 	else


