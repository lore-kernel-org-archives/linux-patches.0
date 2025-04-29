Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 771811DF73C;
	Tue, 29 Apr 2025 17:11:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745946676; cv=none; b=tiqqkrNfxpSWdD9qeIHfwlygqknM/cwKhLIm1Ov0lFmyZ/54dxkVgBcLpLKu72Fn1kUE7BCf0TlFY07046YUHnimqFuWAUx3gFXR11nyZfsnboBaddSaDiS//aqG2GngtdomtF4DpfVg/eWmAU5OgtqzUpjTN1PE6z8KgWIKGak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745946676; c=relaxed/simple;
	bh=4jr5cyL8lorZiWfUplsg7HcdZ/xtPJ4GtEG3L0ioaDM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aoyau1fq2tofxzG6fA0RMT625Y+OMtZJTja8XNaMTid1+Rbg7bO2QXDrho752eh3N8DuOYSApM6/86rKq9C/Uz29f55PPQ7TTRf+sqiPX/mTbDn6rln/LndI/ML9wYqMhM68LDOQ8SAFtdiKXifDtvFxPf//9WiBLk0r+JKxOks=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kVJBSfWq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kVJBSfWq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F31C0C4CEE3;
	Tue, 29 Apr 2025 17:11:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745946676;
	bh=4jr5cyL8lorZiWfUplsg7HcdZ/xtPJ4GtEG3L0ioaDM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kVJBSfWqtYGB41D+lsI6KStoP70Jo46NPFS1ShXZlVCdsMk8f6lbxdG42b8N3r+H2
	 orX7SqXBGbLiLcZchyHp2DjsP3XCfqL/ltS4jXZOtZgXbSUN+WM6csq3UqYWIUpag1
	 fcfsoJG4lMkJwgkg3k9JGZsdy9sd2iJKzHGJYLH8=
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
Subject: [PATCH 5.10 004/286] net: tls: explicitly disallow disconnect
Date: Tue, 29 Apr 2025 18:38:28 +0200
Message-ID: <20250429161108.036398905@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161107.848008295@linuxfoundation.org>
References: <20250429161107.848008295@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index ebf856cf821da..9d7b52370155b 100644
--- a/net/tls/tls_main.c
+++ b/net/tls/tls_main.c
@@ -623,6 +623,11 @@ static int tls_setsockopt(struct sock *sk, int level, int optname,
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
@@ -717,6 +722,7 @@ static void build_protos(struct proto prot[TLS_NUM_CONFIG][TLS_NUM_CONFIG],
 	prot[TLS_BASE][TLS_BASE] = *base;
 	prot[TLS_BASE][TLS_BASE].setsockopt	= tls_setsockopt;
 	prot[TLS_BASE][TLS_BASE].getsockopt	= tls_getsockopt;
+	prot[TLS_BASE][TLS_BASE].disconnect	= tls_disconnect;
 	prot[TLS_BASE][TLS_BASE].close		= tls_sk_proto_close;
 
 	prot[TLS_SW][TLS_BASE] = prot[TLS_BASE][TLS_BASE];
-- 
2.39.5



