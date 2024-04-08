Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9396381AC1;
	Mon,  8 Apr 2024 13:24:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712582664; cv=none; b=jzEEBtLOEgZKA3uF1IRIoVUiiDR2a7cyT7C2DkjbLKmw4GrIqwL9njsAW6VzIqRm6l0dBN6Dbnu3+TQM4anmv8SSwtpv1pIco8hlq/iQLaUK5QEnrQbFh4JL6OnNxIm/28St7UWdaw4bi3ejuffv9fiUmjUDdFC+6Dk2DU05agk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712582664; c=relaxed/simple;
	bh=SKd3VH/u8CmEqyypMLdf3FftggQGYyZIPKZEWBbfdYY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tAGHkj/3ZIQgO3Ta2WYZgViRoDhquRGaF3L8TdfNjDYOHbtUcLmevBOuo9HuQ5rWkAoSrmpt0zu5MAsJ7FOu34i46rKKsniF03PfoOuPYFXVpq/8NCKl04JK06XU9ZA7Mmv0tbFXIkmF9aHxYhjI5Omy44+Iwf01DARNWk7rkXc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d8TauiRp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d8TauiRp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC66FC433C7;
	Mon,  8 Apr 2024 13:24:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712582664;
	bh=SKd3VH/u8CmEqyypMLdf3FftggQGYyZIPKZEWBbfdYY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d8TauiRpJelVCreV4JlQif73mL6xrtyyw81ogBRefOZjgwkCStiAJZzVA504RyXKh
	 +xmEvjNeLfnOYvp8PftAGMi5g35jXr5Gj/+Qqf4kLnOMgkh5/uiPW5Bf5G8TzwOx6c
	 TveqHziYuPG2E1du7NApEIISsop55TMJv0AaFR2g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexei Starovoitov <alexei.starovoitov@gmail.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Mat Martineau <martineau@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.8 094/273] mptcp: prevent BPF accessing lowat from a subflow socket.
Date: Mon,  8 Apr 2024 14:56:09 +0200
Message-ID: <20240408125312.219734618@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125309.280181634@linuxfoundation.org>
References: <20240408125309.280181634@linuxfoundation.org>
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
@@ -1500,6 +1500,10 @@ int mptcp_set_rcvlowat(struct sock *sk,
 	struct mptcp_subflow_context *subflow;
 	int space, cap;
 
+	/* bpf can land here with a wrong sk type */
+	if (sk->sk_protocol == IPPROTO_TCP)
+		return -EINVAL;
+
 	if (sk->sk_userlocks & SOCK_RCVBUF_LOCK)
 		cap = sk->sk_rcvbuf >> 1;
 	else


