Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3C0919E7F5;
	Thu, 15 Aug 2024 13:44:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723729484; cv=none; b=BDOOw6Mtf4LUYk3ohitHuOFkid7VnSXeAlmtZBytxloFrLCx0gj927pJY5v9DIX/L3EkPFEHPdqcR+Q50YjRh3iC21Vl0rxHjzPacd44Pn9cgAkQWk3GdZ/YraXyA2dFxELtiqi7Q1/4g4uDMCxSzKHCiS9dhovSR+akyBLpmOg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723729484; c=relaxed/simple;
	bh=UpPkjYfDS/2rjU66vpwioUsMcMGiYJVrJNl94mwxY2w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CdEbx3WI3jwqqtxEl7nLJPl9Ko+nQ2IRlJ3zJTH0Hcb0fQ6C9a8EWuBo65eBEZUNPDBQ9H0llmni8/Gaq+LjrAVRF5Zh3g2ErpiYTc25Rg4JpOlGsd7JTZlEWCMpY6gYUxpAEmJ/qDIf5nMSY7dWjWCwJpaOv+8koLmsoIVPAJM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LWGb4zKl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LWGb4zKl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E725C32786;
	Thu, 15 Aug 2024 13:44:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723729484;
	bh=UpPkjYfDS/2rjU66vpwioUsMcMGiYJVrJNl94mwxY2w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LWGb4zKlE798bGXXhWhjw7IR8OYgnVPHWlpTOXhePvYM3DOu4qxhmYMvwcfjXfNDo
	 IagZQ0P1iOuGcmto95Nfby3eGcrY4ol+TyKtTryYTDy7ufREYHkyIqLB3ZxHcPzFW1
	 osFR0x4d0L5GXE7fx6ECmCb2GZPQlvgvYGZdgeFc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	NeilBrown <neilb@suse.de>,
	Anna Schumaker <Anna.Schumaker@Netapp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 113/484] SUNRPC: avoid soft lockup when transmitting UDP to reachable server.
Date: Thu, 15 Aug 2024 15:19:31 +0200
Message-ID: <20240815131945.657291988@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131941.255804951@linuxfoundation.org>
References: <20240815131941.255804951@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index f73d4593625cd..38071a6780211 100644
--- a/net/sunrpc/clnt.c
+++ b/net/sunrpc/clnt.c
@@ -2226,12 +2226,13 @@ call_transmit_status(struct rpc_task *task)
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



