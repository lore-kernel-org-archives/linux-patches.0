Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2A9E46E005;
	Tue, 21 Jul 2026 19:54:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784663649; cv=none; b=hWm0IgyYaxMZ4oukI2xQqE3PeyQkdiFmoNTQB6K/cB7npGGpwk81m87vu4YCcB7evKIiBMhLIquv0ufnvSz33wklc3DiM7XedjTMgOz14L7CBemheKrqLLKb9lSQgh3mv/1B3SUH7WycM2oyT9Xf3Hkn0z49e/Yl9VkmfIK/QUQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784663649; c=relaxed/simple;
	bh=itTxsIcWV45Gba1U0tOdKN0H6StrzDNU9HCtMilUUxg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RnpEcw0zrn9yaqo2eItlwKXiUe38+8cNjIuiFalaPw2eUr07Od+IhonPAeEUOuzxeLoEFHqjXp3FlvRqEuI44cCIOistm0mrsVJr/eo2KEaZXEmm3NWWaWnA9x9UzdqyPjXpHAVdslok3y+Jca7ZxgUUK0H9702/cvXEFVmUEok=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=o+8AjyoH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o+8AjyoH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F9451F000E9;
	Tue, 21 Jul 2026 19:54:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784663647;
	bh=JCq96+APzYGwGtdaMmCx1ZulaHeS8qKS4Esd4y3rt3c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=o+8AjyoHIP/JJ6Av+YWFGM3Ve0aUiKE82J8afweFC2455LIEsOb3A3VvOaDCcs/qk
	 sM0OAHe4mfdyX5SAfP9m7elXcr+EtWYQQJG78DJy0r6Cf4kfcrI2PEx+7gopqgmfOo
	 hst76IN4OpyCSwEQ+xKe5JhY0+77KKq32yPTgZS4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Mason <clm@meta.com>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 6.12 0902/1276] sunrpc: pin svc_xprt across the asynchronous TLS handshake callback
Date: Tue, 21 Jul 2026 17:22:25 +0200
Message-ID: <20260721152506.224485489@linuxfoundation.org>
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

From: Chris Mason <clm@meta.com>

commit 4f988f3a2808fb659f3880c282041ff067acad78 upstream.

svc_tcp_handshake() stores the raw svc_xprt pointer in
tls_handshake_args.ta_data and submits the request through
tls_server_hello_x509(). The handshake core takes only
sock_hold(req->hr_sk); nothing references the embedding struct
svc_sock that svc_tcp_handshake_done() reaches via container_of().

Two close races leave the in-flight callback writing through a freed
svc_sock. svc_sock_free() calls tls_handshake_cancel() and discards
its return value: a false return means handshake_complete() has
already set HANDSHAKE_F_REQ_COMPLETED but hp_done() may not have
finished, yet svc_sock_free() proceeds to kfree(svsk). The
cancel-loser fall-through inside svc_tcp_handshake() itself produces
the same window: when wait_for_completion_interruptible_timeout()
returns <= 0 (timeout or signal) and tls_handshake_cancel() returns
false, the function does not drain, returns, and svc_handle_xprt()
calls svc_xprt_received(), which clears XPT_BUSY and can drop the
last reference. A concurrent close then runs svc_sock_free() while
svc_tcp_handshake_done() is still updating xpt_flags and walking
svsk->sk_handshake_done.

The corruption surfaces as set_bit/clear_bit RMW into the freed
xpt_flags slab slot and as complete_all() walking and writing the
freed wait_queue_head_t list embedded in sk_handshake_done -- a
slab-corruption primitive, not a benign read. The path is reachable
on any TLS-enabled NFS server whenever a connection close overlaps
the tlshd downcall delivery window; the interruptible wait means
signal delivery suffices, not just SVC_HANDSHAKE_TO expiry.

Take svc_xprt_get(xprt) immediately before tls_server_hello_x509()
so the in-flight callback owns its own reference. Release it on the
two edges where the callback is guaranteed not to fire -- submission
failure from tls_server_hello_x509() and a successful
tls_handshake_cancel() -- and at the tail of
svc_tcp_handshake_done() after complete_all().

Fixes: b3cbf98e2fdf ("SUNRPC: Support TLS handshake in the server-side TCP socket code")
Cc: stable@vger.kernel.org
Signed-off-by: Chris Mason <clm@meta.com>
Assisted-by: kres (claude-opus-4-7)
[cel: rewrote commit message to describe the actual change]
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sunrpc/svcsock.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/net/sunrpc/svcsock.c
+++ b/net/sunrpc/svcsock.c
@@ -462,6 +462,7 @@ static void svc_tcp_handshake_done(void
 	}
 	clear_bit(XPT_HANDSHAKE, &xprt->xpt_flags);
 	complete_all(&svsk->sk_handshake_done);
+	svc_xprt_put(xprt);
 }
 
 /**
@@ -485,9 +486,13 @@ static void svc_tcp_handshake(struct svc
 	clear_bit(XPT_TLS_SESSION, &xprt->xpt_flags);
 	init_completion(&svsk->sk_handshake_done);
 
+	/* Pin the transport across the asynchronous handshake callback. */
+	svc_xprt_get(xprt);
+
 	ret = tls_server_hello_x509(&args, GFP_KERNEL);
 	if (ret) {
 		trace_svc_tls_not_started(xprt);
+		svc_xprt_put(xprt);
 		goto out_failed;
 	}
 
@@ -496,6 +501,7 @@ static void svc_tcp_handshake(struct svc
 	if (ret <= 0) {
 		if (tls_handshake_cancel(sk)) {
 			trace_svc_tls_timed_out(xprt);
+			svc_xprt_put(xprt);
 			goto out_close;
 		}
 	}


