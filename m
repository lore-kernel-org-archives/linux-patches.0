Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AD483B1EFC;
	Tue, 21 Jul 2026 20:53:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784667187; cv=none; b=qf0BjbNfSYMOlGDwejSPjEkTCDQt7wE48XCRe92uP9z8rirQJEJOiQg56yvVLDSnWqS/o9L+2O0+6Y4WN0DTpa+0O6AaOLyrKI/lyeGoIHzJXUkL4zABa/ifKcDjvB/Mp/6WKMspep34AeQJkMu/2jbnUrbmOW2sw+XGzVoaPTo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784667187; c=relaxed/simple;
	bh=d+iE6wfOPzXm7bwlyeCuqApQwrgMBT5uhAIIwsS8xpQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W8hGt2u/oyudIDdBIjTbg4zG7KFKKNUa4RT2qHFG17wZ3pytuVXjMbLkbuHF2JJbDMWBf536lqb4jVf5CcLEccys/P+PZMNO2AlrxUROyhnsjWnHbw5CrWVYo51UHgQQP7AyjMlAPlwQb4+fWa8T6B/z7a9KpKl/+aIGgFO7PYk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1vTuUZvs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1vTuUZvs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1AAC1F00A3D;
	Tue, 21 Jul 2026 20:53:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784667186;
	bh=HpiMCCboiPIaADLn2wLxrbR968JlEddw2n2Mhcds1AA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1vTuUZvs3QzJEr+XA/UxIKbOpx4/G03HyTKAJZcOL//3ggMopsAQVZT9vq509s2fz
	 I9l9W8A4Wgq1RaSXpjmS1+mLarA7cpTBdonc5db7s2yFmg+eMwhhWYYzx7HLE19qv5
	 mp7QuG8gWljThtfFub/4HOPmPLaKoLpxqvGt8g+g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Mason <clm@meta.com>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 6.6 0964/1266] sunrpc: pin svc_xprt across the asynchronous TLS handshake callback
Date: Tue, 21 Jul 2026 17:23:21 +0200
Message-ID: <20260721152503.401672171@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


