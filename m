Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A20D46C4BD;
	Tue, 21 Jul 2026 19:49:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784663367; cv=none; b=kpedG/31y9t1U4vqYYa1L3hXrZfJxUTn1wWoK585pd687bFF9haLT5B6kc/j9t6SejIrOAMjCYYzJi19D91JMTwvw46Cae4Y+VE9bFZ5hJ2g+S1ckfLxQqgfLdZ8dtf3u8MCj/VmTS61BoUBQPCDJRcwLOmqsjfi+rh9zsLOhA4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784663367; c=relaxed/simple;
	bh=o/Bi3MDP9Ck0Qlpde/YMug6uANqOU7g/2nU4vIoPZ2M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TOhM7iD6KmmkyMYPJsfvfiUXsxbQQtG4fuisnbFj+XchEXAZOsCBpCTfHwyz2p1Mk6T2Y8Q7wZ/90kGUojkH7y/jaBsm/tg2gCqEui0BXkmcdv1t34pOHUpN61dnmvYybces78Dl0ekzTrcFGs5wgdK1uRuyKSkWAJGTF6/ehQw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HvXkC5g0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HvXkC5g0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFACA1F00ACA;
	Tue, 21 Jul 2026 19:49:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784663366;
	bh=Mf9sqHqGh1EBJSsmEbfzarGDqdVddJakTQOitk5tVNQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HvXkC5g0ONlv9snvSbpnAWw4PRVbAIk01plk4cA1mCb0z1r/ycxY5gwBiidvQjNQ3
	 qZC1oozgKnfqjwsa0XIZk2T34NqZaxVMIOESMOy/HnABy7UhZQr9Snz7Al+AVUwpql
	 zxcQ5vvDeIBPdcdKxo1QhuaIx41vTOKIaVHTASzQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Michael Nemanov <michael.nemanov@vastdata.com>,
	Anna Schumaker <anna.schumaker@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0797/1276] SUNRPC: release lower rpc_clnt if killed waiting for XPRT_LOCKED
Date: Tue, 21 Jul 2026 17:20:40 +0200
Message-ID: <20260721152503.908905057@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit 29bacb096d43bd04062f6655e50ceeed27fe6d2f ]

xs_tcp_tls_setup_socket() creates a temporary "lower" rpc_clnt with
rpc_create() to drive the inner TLS handshake, then waits for
XPRT_LOCKED on its xprt with TASK_KILLABLE so a stuck handshake can
be aborted by signal. When the wait is interrupted, the function
jumps to out_unlock without releasing lower_clnt. The success path
and the out_close error path both call
rpc_shutdown_client(lower_clnt); only the killed-wait path skips it,
leaking the clnt and its underlying xprt.

Call rpc_shutdown_client() on this path before joining out_unlock.
xprt_release_write() is not needed here because XPRT_LOCKED was
never acquired.

Fixes: 26e8bfa30dac ("SUNRPC/TLS: Lock the lower_xprt during the tls handshake")
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Tested-by: Michael Nemanov <michael.nemanov@vastdata.com>
Reviewed-by: Michael Nemanov <michael.nemanov@vastdata.com>
Signed-off-by: Anna Schumaker <anna.schumaker@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sunrpc/xprtsock.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/sunrpc/xprtsock.c b/net/sunrpc/xprtsock.c
index b78f1aae9e8068..f5b22267fadf46 100644
--- a/net/sunrpc/xprtsock.c
+++ b/net/sunrpc/xprtsock.c
@@ -2732,8 +2732,11 @@ static void xs_tcp_tls_setup_socket(struct work_struct *work)
 	lower_xprt = rcu_dereference(lower_clnt->cl_xprt);
 	rcu_read_unlock();
 
-	if (wait_on_bit_lock(&lower_xprt->state, XPRT_LOCKED, TASK_KILLABLE))
+	if (wait_on_bit_lock(&lower_xprt->state, XPRT_LOCKED, TASK_KILLABLE)) {
+		/* XPRT_LOCKED was never acquired. */
+		rpc_shutdown_client(lower_clnt);
 		goto out_unlock;
+	}
 
 	status = xs_tls_handshake_sync(lower_xprt, &upper_xprt->xprtsec);
 	if (status) {
-- 
2.53.0



