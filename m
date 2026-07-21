Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D1F13368A5;
	Tue, 21 Jul 2026 20:55:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784667327; cv=none; b=ZSb0BbZJGgPn+znz1DqZlGIiTv9rvj359yVwoajDYY9ZMSLeNtp0UV9onXoxCTMZY5aYMM2PDjtqoDE9ebLhSnX80JWXbbaYwDGIeP9HM0X8T2FUD9edDsPJYcPGPbMQb+ib4iyomAAzJ0d77Y2PDfwTJggNzIIlNSE43sQbMeo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784667327; c=relaxed/simple;
	bh=YDG3NncVcJ0HeJpXokFMTpM+rGYLne+NaUqUQxB24sg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jiSL+o9UpizjPV86RERdv0iK5vRjTNZFXXF5qy1VYYWDq93v3Vm5AQ8n8JYW1rcwB2Z+qLXvjv7rlwofoIGB/Gf/a5rb2ndBQQosleuRGb+zJ0A1r4a5CpaPu+/kbp44NDAUQIAF5jYjVbFDPP8HTnyJ9hSvRzJVcibOmwiglzA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u0J6oAPn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u0J6oAPn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B35511F000E9;
	Tue, 21 Jul 2026 20:55:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784667326;
	bh=hnM0xBofiuU/88QXaiuCNfVdLu//x4+aUi/bViCsQs4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=u0J6oAPnpdG4UkLdmeCsoJfYtgAEvbZc+/giYlFx/7aze0BZD8eN+hdC5blxcfs25
	 tiqYrcnfd2RJBrd8Pfq7GNv0uhREbqgYObFPnbbJMxYeZMnuyjpv262C/MOxe9uioU
	 auwXt+qied3kMI9YPi0Pr2vnszZr3Mn6hwoj23c0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 6.6 0965/1266] sunrpc: wait for in-flight TLS handshake callback when cancel loses race
Date: Tue, 21 Jul 2026 17:23:22 +0200
Message-ID: <20260721152503.424612711@linuxfoundation.org>
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

From: Chuck Lever <chuck.lever@oracle.com>

commit d00e32f84ca1a77cb67a3fbf59f58dada95f5a21 upstream.

When wait_for_completion_interruptible_timeout() in
svc_tcp_handshake() returns 0 (timeout) or -ERESTARTSYS (signal) and
tls_handshake_cancel() then returns false, handshake_complete() has
won the cancellation race: it has set HANDSHAKE_F_REQ_COMPLETED and
is about to invoke svc_tcp_handshake_done(), but the callback's
side effects on xpt_flags and on svsk->sk_handshake_done have not
yet committed.

The current code reads xpt_flags immediately to decide whether the
session succeeded. Two races result.

If the callback has executed set_bit(XPT_TLS_SESSION) but not yet
clear_bit(XPT_HANDSHAKE), svc_tcp_handshake() sees a session,
enqueues the transport, and returns. svc_xprt_received() then
clears XPT_BUSY, a worker thread picks the transport up, the
dispatcher in svc_handle_xprt() observes XPT_HANDSHAKE still set,
and xpo_handshake is invoked a second time. That svc_tcp_handshake()
calls init_completion(&svsk->sk_handshake_done) while the original
callback concurrently calls complete_all() on it, corrupting the
embedded swait_queue.

If the callback has set HANDSHAKE_F_REQ_COMPLETED but not yet
entered svc_tcp_handshake_done(), svc_tcp_handshake() reads
XPT_TLS_SESSION as clear and tears the connection down even though
the handshake is about to succeed.

Wait for the callback to commit before inspecting xpt_flags. The
completion is guaranteed to fire because handshake_complete()
invokes svc_tcp_handshake_done() unconditionally once it has set
HANDSHAKE_F_REQ_COMPLETED.

Fixes: b3cbf98e2fdf ("SUNRPC: Support TLS handshake in the server-side TCP socket code")
Cc: stable@vger.kernel.org
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sunrpc/svcsock.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/net/sunrpc/svcsock.c
+++ b/net/sunrpc/svcsock.c
@@ -504,6 +504,10 @@ static void svc_tcp_handshake(struct svc
 			svc_xprt_put(xprt);
 			goto out_close;
 		}
+		/* Cancellation lost to handshake_complete(): the
+		 * callback is in flight and should finish quickly.
+		 */
+		wait_for_completion(&svsk->sk_handshake_done);
 	}
 
 	if (!test_bit(XPT_TLS_SESSION, &xprt->xpt_flags)) {


