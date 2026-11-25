Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795624781;
	b=zIQe9SeRO4OZbyUhV2KD92egivK9MGTtmQsDpE5dulUc/wxoUB2dmwpejRIaJz4NTDfI
	 rcOBG1hhd2CnTFWwpRcRP/ltm9lyy8JWCdX7f/igKCATs4fiyTvInYZlAk8PcN8PA98Ne
	 c09jTfqjWZ1mZCbrfWadKxGYC4A+i1DN48JrmL0dB4i4KoPZDZpW4TqvUMnP/rKKkNFud
	 Xl0PvF47dj23iktUnQVWRob/nMm5A5/LUdniSRdeB36hwoswaQqQgbJQr6fjC4tQUP3dP
	 PJtL0wQTwKGQqkClIHCerPhd7K9ePPaOLHDa4b+R3DPNH7Rd4qjP0rKydN5locZR2Ug==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795624781;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=0HKCAde/9WoIUK+wvBobj68FavErAD0Jvh4sz401o7o=;
	b=Ne7lbe6BHpjH+iSCzuaz061HEVkSNCQwDNJIa1NH0+69ua9GwQWuBchFWZ7+/9ZtAebG
	 DbXKMNGYhYGbyJhP3tidW99bGPx+dNMGax8L9fOMszPf80CIktM7mCD6hhikuQ2r1pJnz
	 RQJv+RXE1aO9kO6uAOoV0GoP3Cqy2ljKax5MsSLIlMJmmdbqxXx5O4+cVfaEI2ml7qGAg
	 39AbQV4EG9WBHmTAci3UDrY7ljLfGgEqdcNkzx7TR6u3P8xmWtMmbmlraou3D7NRNF3oI
	 k9bphhcIVg7YtQzFXYtKgK8vlXET/pIfwNB9Yi4HN+b4yBXRvQXeuo3pbkXCU2uxlkA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jCX2VqGx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FF35606A329;
	Wed, 25 Nov 2026 16:39:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jCX2VqGx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F6B51F000C6;
	Wed, 25 Nov 2026 16:39:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795624780;
	bh=0HKCAde/9WoIUK+wvBobj68FavErAD0Jvh4sz401o7o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jCX2VqGxrK6gkVbS2AjKDF0rtI6omsUCrbz6nOP+2NsYY/Tcd0CN1zEo3iBypoCNZ
	 UHFZVKRqEM1jcvhZs3fCU2DKNCBspXZSIL5jNJnWu96ndjifOiV7fqIQC92Cw86yvW
	 BaitGxsjlvetnnBEBypOE16xI62mooBArbpJpHEc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Avi Weiss <thnkslprpt@gmail.com>,
	Anna Schumaker <anna.schumaker@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 304/816] SUNRPC: Balance queue accounting when relocating a task
Date: Wed, 25 Nov 2026 15:30:52 +0100
Message-ID: <20261125143856.240271844@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Avi Weiss <thnkslprpt@gmail.com>

[ Upstream commit f14b157168ac106cfac6d577e08726488b1b886c ]

When rpc_task_set_transport() relocates a movable task from an
offline transport, it releases the request and drops the
transport reference without decrementing the old transport's
queuelen or the switch's xps_queuelen. Releasing the task
later only accounts for the replacement transport.

The stale counts affect transport selection and can prevent
xprt_delete_locked() from removing an otherwise idle transport.

Use rpc_task_release_xprt() to balance the previous assignment
before selecting a replacement. Pass clnt explicitly because
rpc_task_set_client() can assign a transport before tk_client
is initialized.

Fixes: 82ee41b85cef ("SUNRPC don't resend a task on an offlined transport")
Signed-off-by: Avi Weiss <thnkslprpt@gmail.com>
Signed-off-by: Anna Schumaker <anna.schumaker@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sunrpc/clnt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/sunrpc/clnt.c b/net/sunrpc/clnt.c
index 81e5e756d8ffa..745123c75cf5f 100644
--- a/net/sunrpc/clnt.c
+++ b/net/sunrpc/clnt.c
@@ -1188,7 +1188,7 @@ void rpc_task_set_transport(struct rpc_task *task, struct rpc_clnt *clnt)
 		      (task->tk_flags & RPC_TASK_MOVEABLE)))
 			return;
 		xprt_release(task);
-		xprt_put(task->tk_xprt);
+		rpc_task_release_xprt(clnt, task->tk_xprt);
 	}
 	if (task->tk_flags & RPC_TASK_NO_ROUND_ROBIN)
 		task->tk_xprt = rpc_task_get_first_xprt(clnt);
-- 
2.53.0



