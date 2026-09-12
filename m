Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C49BB2D739C;
	Sat, 12 Sep 2026 13:43:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789220613; cv=none; b=TC1lRV54oQmyuG8Itqx5Wpp4H6XpqpeydqnJBP8wLwPEnYN8feyomoGO96hdzlrs1h6NCH4fZqA4Ma7wF52DOrYhUBRBKeGu210u0QSFNhByftqfOHn72eyB5ZgG7OaBsa5dTLY6LqYteYMQRR7DTnt3GOZMK6UdgPgbf2LN26k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789220613; c=relaxed/simple;
	bh=aBdN4HBVfln29sRy0BxQBTpRm4hBFL5GFiQjvAM3kgw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UCc34DTIksdo/86B2SbaUj753AxHG/BTc5p1Ae6Z00SQLllFHc0UsUz6KQZ1vQGDpXqOhfjsb+qiStR+Rxmmv3/OrePNEnfHevZlMEO3uvYaTLgeUrbk6z6+VPXHx0NmN+P9nIoC/lt/uxeq7DX4x0BDg/UymcaB+Hdoo8iq9nU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ey8MI/8r; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ey8MI/8r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 433A31F00893;
	Sat, 12 Sep 2026 13:43:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789220612;
	bh=y/apfXvm5LYAQGTKbXn+BH/CsG3Lf6T8cgz6CGugP6Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ey8MI/8rjAi2xvku2DOjCKJPFa+0yaqvqOIaHfklaIHvl+mwNzz6uDDdiKtGXnU0p
	 88m6qk4QABaMYLIgyRvVnvfJIhC4QROMG7uHBLG/bGf1Tx6y9XPMwjqB5EgW7uGXJR
	 yZY/T25OJtXD9SBCC6m2uN7/LTdQY7BnEt4jYMxY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?J=C3=A9r=C3=A9my=20Jean?= <Jeremy.Jean@oss.cyber.gouv.fr>,
	Chuck Lever <cel@kernel.org>,
	Trond Myklebust <trond.myklebust@hammerspace.com>
Subject: [PATCH 6.6 0160/1424] SUNRPC: wait for in-flight client TLS handshake callback
Date: Sat, 12 Sep 2026 08:43:12 +0200
Message-ID: <20260912065610.877672004@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2627,7 +2627,17 @@ static int xs_tls_handshake_sync(struct
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


