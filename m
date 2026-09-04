Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 594C94156F0;
	Fri,  4 Sep 2026 05:22:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788499359; cv=none; b=OZtHFUmMDYCn2reHNFydWJeGu5avLAIq9XwCMd2VfL0CaFKJveq968nW/yZ4Lv4RoQdGR7OmbUvZ317DSI8uXAqvId3vhAhmpZsu0736854YqOT1eusLE2LfCwQWgy034vFM8uZPJhXHodfYGx9uRMh+UHOhrqAoXwJnNC7Nzd8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788499359; c=relaxed/simple;
	bh=Om6y5VYnE+0v5iN5yZefdLIHhTvn9+poxd0FdQe2gCo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=B7IVYhjDh5lio9Sf+N2QsF8qzGHoWKX8w9lS13WtspVT1DFQE1w6G7nBZiCXKjwTg/8enMN4gfAegx6dzm6i4WkSbQ4gHg4/Pv0WrlEmKiy4YqjJwv8luz7MvRWokDjPOLKU9r9XiLZfjTi0h7Hm2U6Qd+BqiFBuVVom5aeRuqI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Tm4hZulH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Tm4hZulH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E4271F00A3D;
	Fri,  4 Sep 2026 05:22:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788499358;
	bh=M0F327jMid3gN9uSP8ovsi6DBjrg7bQtcjSpDqyJSoo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Tm4hZulH/Vz9btEQxmw/bIpq6h1qjKg4U+1PGM4fYYk7HsK5vCaflJOl8AfXlhaH/
	 NrPAfmfgJYW1MfUVXY4+SimLp20w/xp5RsnnQHLbTOr1wqTXUV9Gs1N51IINf3Az7i
	 VeUbw1d+1sb/ldbKjyeAMl74pVHYTvGeqvAwX35k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?J=C3=A9r=C3=A9my=20Jean?= <Jeremy.Jean@oss.cyber.gouv.fr>,
	Chuck Lever <cel@kernel.org>,
	Trond Myklebust <trond.myklebust@hammerspace.com>
Subject: [PATCH 7.2 388/713] SUNRPC: wait for in-flight client TLS handshake callback
Date: Fri,  4 Sep 2026 06:55:56 +0200
Message-ID: <20260904045812.520894196@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2648,7 +2648,17 @@ static int xs_tls_handshake_sync(struct
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


