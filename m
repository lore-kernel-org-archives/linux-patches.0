Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 859CF1A6195;
	Tue, 30 Jul 2024 16:55:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722358553; cv=none; b=r+d5uxtdnrtfDgaOLWOJp5zpMwNJA4n3T1mgvM7lRFPdrpQUSXPGbt1B/wd+evkPfFmNcbCvt53jCw0UitxbZJ2+3w6hVYc+jyx3ilq6EV7SwthCz17oCD8BadT0QnpWwgy7bjGD7jCPmixMq+aHFP5FUvk6B3bw6b6VyjlwJwQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722358553; c=relaxed/simple;
	bh=k+v4OZ783285d8LLbWu+o+WJmXFREWcZ2IrjL2PF7W0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sCBg8vi3AV5X8iuaNBtCQ22cCMmWTNqA+VWU8rx/zgFZJLzcQPrD71e4bur4Uob0wvkwQf9tO+Oc29T3Put2m4hliYSx/TYaD6MZZFpBalXtpSi9Cprhw101rE8LNYiw28j/p0AgPJDxI6gTlqun0OBj1RhiSM6tAmD4HPQI08E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vRLHwkjS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vRLHwkjS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05C9AC32782;
	Tue, 30 Jul 2024 16:55:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722358553;
	bh=k+v4OZ783285d8LLbWu+o+WJmXFREWcZ2IrjL2PF7W0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vRLHwkjSlnHWpfY56zYS/bM+/gPWyDPZ3aAG/DsQ4afJkF3Q0ladk2BAyy8TcrOPu
	 i8pxciWGehWCaOiZfE44lBOfn+QzMHCNAy5rJTLQnP6btUQa6cev16iDLu5h54qYvq
	 KIW6lIF9bOWqcDWozQr35AXufU6e8XsPtMiWcYXA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	NeilBrown <neilb@suse.de>,
	Anna Schumaker <Anna.Schumaker@Netapp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 369/809] SUNRPC: avoid soft lockup when transmitting UDP to reachable server.
Date: Tue, 30 Jul 2024 17:44:05 +0200
Message-ID: <20240730151739.232755394@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: NeilBrown <neilb@suse.de>

[ Upstream commit 6258cf25d5e3155c3219ab5a79b970eef7996356 ]

Prior to the commit identified below, call_transmit_status() would
handle -EPERM and other errors related to an unreachable server by
falling through to call_status() which added a 3-second delay and
handled the failure as a timeout.

Since that commit, call_transmit_status() falls through to
handle_bind().  For UDP this moves straight on to handle_connect() and
handle_transmit() so we immediately retransmit - and likely get the same
error.

This results in an indefinite loop in __rpc_execute() which triggers a
soft-lockup warning.

For the errors that indicate an unreachable server,
call_transmit_status() should fall back to call_status() as it did
before.  This cannot cause the thundering herd that the previous patch
was avoiding, as the call_status() will insert a delay.

Fixes: ed7dc973bd91 ("SUNRPC: Prevent thundering herd when the socket is not connected")
Signed-off-by: NeilBrown <neilb@suse.de>
Signed-off-by: Anna Schumaker <Anna.Schumaker@Netapp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sunrpc/clnt.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/sunrpc/clnt.c b/net/sunrpc/clnt.c
index cfd1b1bf7e351..09f29a95f2bc3 100644
--- a/net/sunrpc/clnt.c
+++ b/net/sunrpc/clnt.c
@@ -2326,12 +2326,13 @@ call_transmit_status(struct rpc_task *task)
 		task->tk_action = call_transmit;
 		task->tk_status = 0;
 		break;
-	case -ECONNREFUSED:
 	case -EHOSTDOWN:
 	case -ENETDOWN:
 	case -EHOSTUNREACH:
 	case -ENETUNREACH:
 	case -EPERM:
+		break;
+	case -ECONNREFUSED:
 		if (RPC_IS_SOFTCONN(task)) {
 			if (!task->tk_msg.rpc_proc->p_proc)
 				trace_xprt_ping(task->tk_xprt,
-- 
2.43.0



