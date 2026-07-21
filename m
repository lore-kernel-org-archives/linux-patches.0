Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 819F6433042;
	Tue, 21 Jul 2026 19:54:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784663651; cv=none; b=JbCoRvos9g8oMXV6oTnI6ERMMueQIzpFwFltEjbp9nXEIQcA4eg2AQFmsRqisCNwQ6aXHhYzvkPmyDaM676UqXbYT4CLSZrogbhPBZXyW92mUoII0oIhpr1Feml67vRfrFoiJOLppdkA/LtiEL1CUDBgx4Mhs3cbRV2zcUR/ZQk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784663651; c=relaxed/simple;
	bh=r0lvcTAfb1VngIOvFJC8CKlyGEn9WIFTn8NSYrjdXZU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cs4TZjvTy56BS0kTJxukq1vhD7zu7ZItm9Wy3XI0cEjXtRFWXnzus/lfaxaIsAt8ORezLoS0Y/kzk1iY2Es7C1dPhErrtFfv4K0egUSf2sAvSSVHwPqu8+X0V2I87Idisz+obkkdz27dwEBgybNBB2FYydlER3lNjIZ1SinpenY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1nS37f8R; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1nS37f8R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD1A01F000E9;
	Tue, 21 Jul 2026 19:54:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784663650;
	bh=mjRBRy0M0IHRramb1xsF6HPsgWPd+Io5+g30FbqWNlw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1nS37f8RJ2E2TWKdGnDnIkoQPY1sOcQQDa/HHLHice8NP09t8JR/szAKRfxNjlgqa
	 IZYlt8BlhKQ8NZDzRZJYdyeyw4y1xE24fo+ga0o9v9/YTLcYjZ5Fy/9GDYaC2Z2WPc
	 73KDPc1iBDCaSYEe/J7sr7vOP5yvPEY1Y4PtaxE0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 6.12 0903/1276] sunrpc: wait for in-flight TLS handshake callback when cancel loses race
Date: Tue, 21 Jul 2026 17:22:26 +0200
Message-ID: <20260721152506.246103896@linuxfoundation.org>
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


