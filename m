Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2BDC30C366;
	Fri,  4 Sep 2026 05:51:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788501106; cv=none; b=ELoZKl3JrhqcvnGLOBTpiXLnzBYiE8YzW/xNQDjlBs6c3RE/7p5smoeUGWfeRRaaxstf/CL5WNWC2BeAJpB4Gr/CPduXFY1rTdUIrhuus8IQYDOTCb+8iHRQKpKElKh7a9pmZQ11TGtVbej7pMdq/Mut6kqKr+/zCcF7eKWi/jI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788501106; c=relaxed/simple;
	bh=4xAv+wJSu3JanbK/QwfaGNh3WGNznk2CVWYMnds/I3Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=EbkU913PbWMVMqbsrgi0LcXPNJmNiNZmQ3hUp7ZKm3TbI6/8MImgKufzCaAw9lRrcqGsJCyWnpa3rXT+2NR2YsoY1vlbuU6nKr5ICItbXzHPs4gcbda1iFFboltUzW7O6QZzx7EhHd7nksp8Eb2HenDTmZUtqyK0yHOv3w8x228=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZmGBYW5n; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZmGBYW5n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 596871F00A3D;
	Fri,  4 Sep 2026 05:51:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788501104;
	bh=UARxx3MCLyAfs6jQJuZbD62uAc1/xgZlpyPLrkCq6Hs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZmGBYW5notjib25A0WD6B3PsMiz0T27aqYqnOjoUpARtCrSZ/g1BG7F7ykCwIICY/
	 LQOjmp4GgGyEJUWTCI+ThpDVuLD/bCBokRF9+aKi+JIvQIH9O945tD1ki9aNqW32au
	 CGvxE+T2Aog/WItT+MWUUT4oMvc0XtBVAZqWxquQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?J=C3=A9r=C3=A9my=20Jean?= <Jeremy.Jean@oss.cyber.gouv.fr>,
	Chuck Lever <cel@kernel.org>,
	Trond Myklebust <trond.myklebust@hammerspace.com>
Subject: [PATCH 6.18 291/552] SUNRPC: wait for in-flight client TLS handshake callback
Date: Fri,  4 Sep 2026 06:57:28 +0200
Message-ID: <20260904045756.572722768@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045747.813364717@linuxfoundation.org>
References: <20260904045747.813364717@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jérémy Jean <Jeremy.Jean@oss.cyber.gouv.fr>

commit a89dd597458848b463d284b15e42a8078beeb046 upstream.

xs_tls_handshake_sync() gives xs_tls_handshake_done() a reference to the
lower transport before submitting the handshake request. On timeout or
signal, the synchronous waiter drops that reference after calling
tls_handshake_cancel().

handshake_req_cancel() returns false when handshake_complete() has
already marked the request complete. In that case the completion callback
can still be running, so dropping the callback-owned reference in the
waiter can free the lower transport before xs_tls_handshake_done() stores
xprt_err or drops its own reference.

If cancellation loses to completion, wait until xs_tls_handshake_done()
signals handshake_done and let the callback release its reference. This
mirrors the server-side handshake lifetime handling and keeps the timeout
or signal return value unchanged.

Fixes: 75eb6af7acdf ("SUNRPC: Add a TCP-with-TLS RPC transport class")
Cc: stable@vger.kernel.org
Assisted-by: Codex:gpt-5
Signed-off-by: Jérémy Jean <Jeremy.Jean@oss.cyber.gouv.fr>
Reviewed-by: Chuck Lever <cel@kernel.org>
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sunrpc/xprtsock.c |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

--- a/net/sunrpc/xprtsock.c
+++ b/net/sunrpc/xprtsock.c
@@ -2647,7 +2647,17 @@ static int xs_tls_handshake_sync(struct
 	rc = wait_for_completion_interruptible_timeout(&lower_transport->handshake_done,
 						       XS_TLS_HANDSHAKE_TO);
 	if (rc <= 0) {
-		tls_handshake_cancel(sk);
+		if (!tls_handshake_cancel(sk)) {
+			/*
+			 * Cancellation lost to handshake_complete(): the
+			 * callback still owns its xprt reference and is in
+			 * flight. Wait for it to finish before returning.
+			 */
+			wait_for_completion(&lower_transport->handshake_done);
+			if (rc == 0)
+				rc = -ETIMEDOUT;
+			goto out;
+		}
 		if (rc == 0)
 			rc = -ETIMEDOUT;
 		goto out_put_xprt;


