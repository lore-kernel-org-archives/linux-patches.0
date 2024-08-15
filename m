Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A26163C;
	Thu, 15 Aug 2024 14:29:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723732156; cv=none; b=HoLxq2Z+iO6gsA6DYfJa/qgPz89KbjcI+cGiPhcfmZ0tRHxDRKezAgh2x18XOyXpzJiQw7PqzyTyf7wa8+EVDg+KitoO6/C/y51TR0zgiC7DTUkNdPQAPsipzISt+3TEQU4AgC7gwnEqD0sBrkU8nOSveayzvRZOfGHn5qVLCMQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723732156; c=relaxed/simple;
	bh=aLjXMN7kAbbs291EvCNvqsC+jAyMAu14NcA8vfU+Sro=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Urw1kUmtQcBur04XhrgCQjB3ovjtMLCtYvkd6FBFU5CM9D8sR9YoApSxCszufBQcRxKSdsS93w8FDd9nO0Fk68q14uUPOsiH08kiIvrGP6flgCXIjMtFqvWYBNXXxhs5vA3XTA4Y28qGEmExr5FyQ3gL/Z2a3QDTV+X23w3eEqk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZNLriY6d; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZNLriY6d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD57BC32786;
	Thu, 15 Aug 2024 14:29:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723732156;
	bh=aLjXMN7kAbbs291EvCNvqsC+jAyMAu14NcA8vfU+Sro=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZNLriY6dyHML4XSgpnmW0DmUvIkR0kFq2BvgkgVvfA1fHSVh2gQCWG4edNbqGR5lp
	 /ewbWN4HGqSH1iASrM+5NiJmval4Tdc5XapK8o6YNPqEoET6PVlQSzLWiPEU8Scchr
	 OtJUkVHeBU2DcfxIAuWEFw2SyK3WmAA5SzZzTtlI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	NeilBrown <neilb@suse.de>,
	Anna Schumaker <Anna.Schumaker@Netapp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 092/352] SUNRPC: avoid soft lockup when transmitting UDP to reachable server.
Date: Thu, 15 Aug 2024 15:22:38 +0200
Message-ID: <20240815131922.817856198@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131919.196120297@linuxfoundation.org>
References: <20240815131919.196120297@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 196a3b11d1509..86397f9c4bc83 100644
--- a/net/sunrpc/clnt.c
+++ b/net/sunrpc/clnt.c
@@ -2188,12 +2188,13 @@ call_transmit_status(struct rpc_task *task)
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



