Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8775DC8EB;
	Wed, 23 Apr 2025 14:52:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745419963; cv=none; b=MExvquHD6al9bP9LxRMGa9FdqITTLub+FW5/bcX+CHoc3GjVbhFlhVdabl3tmCww40rgSm3nHipThNS0ebOyAilPLyasIIFSgaKMwC446xSpov2q0oguXLc85nyaek+oLOcGYhUKlelKIw2bHFVsOMdw8azaX5WY4fEek0sDJew=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745419963; c=relaxed/simple;
	bh=q0iwB5cqfCLeUpTlBgn/Ashx6yJOgnIRPVZJbDW0MYU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mAzE6xS8IdVvpDuRm8TeSFEnl/24ipfMh5M8uWf5p7ElnzfukSCaEtAqJI9CT57gilDHBGk08/3xKGpmTxLgFdCAqKY3t67PLIQGMQ7HJllLhlD5SuCC46Yl6JdZpyhnZjSAWXadn7lrq0qYlD2lPZrnoxYKfMLCddE5/+Evmro=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uaC6vKNg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uaC6vKNg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13138C4CEE3;
	Wed, 23 Apr 2025 14:52:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745419963;
	bh=q0iwB5cqfCLeUpTlBgn/Ashx6yJOgnIRPVZJbDW0MYU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uaC6vKNgdgoIrzWhjspu155xRtmtSWG4p72ppEo41IFxiZpNINMBV68YZOtCV73Yj
	 B05vXhlaU1TOHhx5W5qh25Fx1KLXAh0cQ1gF7OIV8kwmMs2LLBdK9klwTcIIYpvPEI
	 s+OD7Objyg2B3cYGATxzUu+EhfH7OEVWjxGOnBQA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+b4cd76826045a1eb93c1@syzkaller.appspotmail.com,
	Jakub Kicinski <kuba@kernel.org>,
	Eric Dumazet <edumazet@google.com>,
	Sabrina Dubroca <sd@queasysnail.net>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 005/291] net: tls: explicitly disallow disconnect
Date: Wed, 23 Apr 2025 16:39:54 +0200
Message-ID: <20250423142624.634306940@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142624.409452181@linuxfoundation.org>
References: <20250423142624.409452181@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit 5071a1e606b30c0c11278d3c6620cd6a24724cf6 ]

syzbot discovered that it can disconnect a TLS socket and then
run into all sort of unexpected corner cases. I have a vague
recollection of Eric pointing this out to us a long time ago.
Supporting disconnect is really hard, for one thing if offload
is enabled we'd need to wait for all packets to be _acked_.
Disconnect is not commonly used, disallow it.

The immediate problem syzbot run into is the warning in the strp,
but that's just the easiest bug to trigger:

  WARNING: CPU: 0 PID: 5834 at net/tls/tls_strp.c:486 tls_strp_msg_load+0x72e/0xa80 net/tls/tls_strp.c:486
  RIP: 0010:tls_strp_msg_load+0x72e/0xa80 net/tls/tls_strp.c:486
  Call Trace:
   <TASK>
   tls_rx_rec_wait+0x280/0xa60 net/tls/tls_sw.c:1363
   tls_sw_recvmsg+0x85c/0x1c30 net/tls/tls_sw.c:2043
   inet6_recvmsg+0x2c9/0x730 net/ipv6/af_inet6.c:678
   sock_recvmsg_nosec net/socket.c:1023 [inline]
   sock_recvmsg+0x109/0x280 net/socket.c:1045
   __sys_recvfrom+0x202/0x380 net/socket.c:2237

Fixes: 3c4d7559159b ("tls: kernel TLS support")
Reported-by: syzbot+b4cd76826045a1eb93c1@syzkaller.appspotmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Sabrina Dubroca <sd@queasysnail.net>
Link: https://patch.msgid.link/20250404180334.3224206-1-kuba@kernel.org
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/tls/tls_main.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/net/tls/tls_main.c b/net/tls/tls_main.c
index 75cd20c0e3fdb..14d01558311d2 100644
--- a/net/tls/tls_main.c
+++ b/net/tls/tls_main.c
@@ -900,6 +900,11 @@ static int tls_setsockopt(struct sock *sk, int level, int optname,
 	return do_tls_setsockopt(sk, optname, optval, optlen);
 }
 
+static int tls_disconnect(struct sock *sk, int flags)
+{
+	return -EOPNOTSUPP;
+}
+
 struct tls_context *tls_ctx_create(struct sock *sk)
 {
 	struct inet_connection_sock *icsk = inet_csk(sk);
@@ -995,6 +1000,7 @@ static void build_protos(struct proto prot[TLS_NUM_CONFIG][TLS_NUM_CONFIG],
 	prot[TLS_BASE][TLS_BASE] = *base;
 	prot[TLS_BASE][TLS_BASE].setsockopt	= tls_setsockopt;
 	prot[TLS_BASE][TLS_BASE].getsockopt	= tls_getsockopt;
+	prot[TLS_BASE][TLS_BASE].disconnect	= tls_disconnect;
 	prot[TLS_BASE][TLS_BASE].close		= tls_sk_proto_close;
 
 	prot[TLS_SW][TLS_BASE] = prot[TLS_BASE][TLS_BASE];
-- 
2.39.5



