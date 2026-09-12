Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CD2D3911D6;
	Sat, 12 Sep 2026 19:59:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789243178; cv=none; b=ugHIj3XlOvaqeHiEzehwc4TRwB4e7pjoY9mAA73+nO9TZSVCPIZEp/AtpiF61HJnrRt/hbxtReXM7eyuApkou8InTd1NNbKKynoaM18Kz0fWvVGB8CoH8nFZUjLLWk4qmFaOrWPwxP2AdWE2KBtW3vrQE5Bcl77+K6nygOiDjPk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789243178; c=relaxed/simple;
	bh=6RGOsdwBXDy9ZZJqBRELKIQ1IGxhkO8lADSRSwkkZTE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=guQnej2MR5Ivn378kPZ37l8UH2TIs/XvQPDL6ZH50s3PTb09Tf5Jx1lZmwFx+b4J58zz7RL7+qnenJ8Mtt4UnwiuWkIs6Ct1yWwNwI9QJOC1Stha6L0/beRTQnJgYxjyJhewxSZkmiQvNxxNXS1h+x4q+7OATYNGAyr9GEFv8PQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=n9kjLqT0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="n9kjLqT0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 997D51F000FF;
	Sat, 12 Sep 2026 19:59:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789243177;
	bh=bKvj0DlI6pesTastMD4iVJDL3Xy1iUuBIj10dyjBisU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=n9kjLqT0PaKa8csZc9YouNOM8mFTRwjm/SJLPVULUBjpLN8RMaBWbOkfwSH40lvMS
	 /hmXFQKB0sEXRINuXEGU9kJecDoNOaz0Q4SC9v+tEWiOOOLBIomG5I4JxmVf80nNfm
	 snQD1mf55Y96Oraky1OJoJuWTSxQ2ixrkAWkx6JY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiang Mei <xmei5@asu.edu>,
	Weiming Shi <bestswngs@gmail.com>,
	Jeff Layton <jlayton@kernel.org>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 665/798] SUNRPC: check rpc_sockaddr2uaddr() return value in rpcb_register_inet4/6
Date: Sat, 12 Sep 2026 09:04:53 +0200
Message-ID: <20260912065532.348177495@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Weiming Shi <bestswngs@gmail.com>

[ Upstream commit fd22370226a0d8109045d0831fd5aaadee921693 ]

rpcb_register_inet4() and rpcb_register_inet6() store the result of
rpc_sockaddr2uaddr() into map->r_addr without checking it for NULL.
rpc_sockaddr2uaddr() returns NULL when its final kstrdup() fails, and
the unchecked NULL is then carried into the synchronous RPCBPROC_SET
encode path: rpcb_register_call() -> rpc_call_sync() ->
rpcb_enc_getaddr() -> encode_rpcb_string(), whose first statement is
strlen(string), dereferencing NULL and oopsing the kernel.

The crash reproduces under failslab on v6.12; with KASAN the NULL
dereference surfaces as a fault on the shadow of address zero:

 Oops: general protection fault, probably for non-canonical address
       0xdffffc0000000000 [#1] PREEMPT SMP KASAN
 RIP: 0010:strlen (lib/string.c:409)
 Call Trace:
  encode_rpcb_string (net/sunrpc/rpcb_clnt.c:890)
  rpcb_enc_getaddr (net/sunrpc/rpcb_clnt.c:910)
  rpcauth_wrap_req_encode (net/sunrpc/auth.c:745)
  call_encode (net/sunrpc/clnt.c:1966)
  __rpc_execute (net/sunrpc/sched.c:952)
  rpc_run_task (net/sunrpc/clnt.c:1243)
  rpc_call_sync (net/sunrpc/clnt.c:1272)
  rpcb_v4_register (net/sunrpc/rpcb_clnt.c:500)
  svc_generic_rpcbind_set
  nfsd_rpcbind_set
  svc_register
  svc_setup_socket
  svc_addsock
  write_ports
  nfsctl_transaction_write
  vfs_write

The crash is reachable when an in-kernel RPC service (nfsd, lockd,
nfs-callback) registers with the local rpcbind under enough memory
pressure for the small GFP_KERNEL kstrdup() in rpc_sockaddr2uaddr() to
fail. The asynchronous getport path already handles this exact failure
mode by returning -ENOMEM; only the two register helpers omit the check.

Mirror that handling: bail out with -ENOMEM when rpc_sockaddr2uaddr()
returns NULL, before the address is fed into the encoder.

Fixes: d77385f23830 ("SUNRPC: Fix rpc_sockaddr2uaddr")
Reported-by: Xiang Mei <xmei5@asu.edu>
Assisted-by: Claude:claude-opus-4-8
Signed-off-by: Weiming Shi <bestswngs@gmail.com>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sunrpc/rpcb_clnt.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/sunrpc/rpcb_clnt.c b/net/sunrpc/rpcb_clnt.c
index f1bb4fd2a2707..86fc4661646e1 100644
--- a/net/sunrpc/rpcb_clnt.c
+++ b/net/sunrpc/rpcb_clnt.c
@@ -465,6 +465,8 @@ static int rpcb_register_inet4(struct sunrpc_net *sn,
 	int result;
 
 	map->r_addr = rpc_sockaddr2uaddr(sap, GFP_KERNEL);
+	if (!map->r_addr)
+		return -ENOMEM;
 
 	msg->rpc_proc = &rpcb_procedures4[RPCBPROC_UNSET];
 	if (port != 0) {
@@ -491,6 +493,8 @@ static int rpcb_register_inet6(struct sunrpc_net *sn,
 	int result;
 
 	map->r_addr = rpc_sockaddr2uaddr(sap, GFP_KERNEL);
+	if (!map->r_addr)
+		return -ENOMEM;
 
 	msg->rpc_proc = &rpcb_procedures4[RPCBPROC_UNSET];
 	if (port != 0) {
-- 
2.53.0



