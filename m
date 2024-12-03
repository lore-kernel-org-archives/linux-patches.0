Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 793991AB6C9;
	Tue,  3 Dec 2024 16:20:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733242813; cv=none; b=EedCInJld/pRfX37Gnmyx2X9rJbcF+QK7iEZ9tL/P+g3OP+hH1LYnclU9DuSbHgIkDnJCLgXO7wr2wL0OaAjMnm12IjUY70f7bxvYAfUrxoaEFT7J83OBs8vYTOb0cp3l6MNEMdSIpEN9xZUCpy0ENR8Mtdg+BRM8bMdR9efAiA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733242813; c=relaxed/simple;
	bh=dBH7rVvicn1FimPcP9ib3bYfWcBDkjuMbarJyQSgKGg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hEmqe+DsMxQPn7NZ1jSBtePU67hShARP3y3TUoEV1FaiFwMeW2afskoxX2/ZRWrR7Cxc5lw72dzvZZm9vZkwDH2nF0Qz1z3rexM6UnlNH4to+5qWuZ6jZlMYPH+7zWO50xh04dIU6x9jI7pL0MrzmtiHL/LgBRmKUXmkSHXfv5Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=biKKKwU6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="biKKKwU6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF5DDC4CECF;
	Tue,  3 Dec 2024 16:20:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733242813;
	bh=dBH7rVvicn1FimPcP9ib3bYfWcBDkjuMbarJyQSgKGg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=biKKKwU6KLhouzDdb8uXPPuj6XeDdvcNug9w9rv+SQJ7dX69X79f322mlhoZ3FhrA
	 g+KyF0wldrnYSOCstr1znuFxsGh6DQUeGfrnuqkNdlFby4Ed2S8QMeHPItz79JbOJR
	 uKllCMVe9eNu6mulX2yXVz14AWesDd1A25V1gJag=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Coddington <bcodding@redhat.com>,
	Chuck Lever <chuck.lever@oracle.com>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 816/826] SUNRPC: timeout and cancel TLS handshake with -ETIMEDOUT
Date: Tue,  3 Dec 2024 15:49:03 +0100
Message-ID: <20241203144815.584473011@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Benjamin Coddington <bcodding@redhat.com>

[ Upstream commit d7bdd849ef1b681da03ac05ca0957b2cbe2d24b6 ]

We've noticed a situation where an unstable TCP connection can cause the
TLS handshake to timeout waiting for userspace to complete it.  When this
happens, we don't want to return from xs_tls_handshake_sync() with zero, as
this will cause the upper xprt to be set CONNECTED, and subsequent attempts
to transmit will be returned with -EPIPE.  The sunrpc machine does not
recover from this situation and will spin attempting to transmit.

The return value of tls_handshake_cancel() can be used to detect a race
with completion:

 * tls_handshake_cancel - cancel a pending handshake
 * Return values:
 *   %true - Uncompleted handshake request was canceled
 *   %false - Handshake request already completed or not found

If true, we do not want the upper xprt to be connected, so return
-ETIMEDOUT.  If false, its possible the handshake request was lost and
that may be the reason for our timeout.  Again we do not want the upper
xprt to be connected, so return -ETIMEDOUT.

Ensure that we alway return an error from xs_tls_handshake_sync() if we
call tls_handshake_cancel().

Signed-off-by: Benjamin Coddington <bcodding@redhat.com>
Reviewed-by: Chuck Lever <chuck.lever@oracle.com>
Fixes: 75eb6af7acdf ("SUNRPC: Add a TCP-with-TLS RPC transport class")
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sunrpc/xprtsock.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/net/sunrpc/xprtsock.c b/net/sunrpc/xprtsock.c
index 539cdda2093e5..43fb96de8ebe5 100644
--- a/net/sunrpc/xprtsock.c
+++ b/net/sunrpc/xprtsock.c
@@ -2615,11 +2615,10 @@ static int xs_tls_handshake_sync(struct rpc_xprt *lower_xprt, struct xprtsec_par
 	rc = wait_for_completion_interruptible_timeout(&lower_transport->handshake_done,
 						       XS_TLS_HANDSHAKE_TO);
 	if (rc <= 0) {
-		if (!tls_handshake_cancel(sk)) {
-			if (rc == 0)
-				rc = -ETIMEDOUT;
-			goto out_put_xprt;
-		}
+		tls_handshake_cancel(sk);
+		if (rc == 0)
+			rc = -ETIMEDOUT;
+		goto out_put_xprt;
 	}
 
 	rc = lower_transport->xprt_err;
-- 
2.43.0



