Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795625520;
	b=EhGIcwoXYJ85cpMt6lxig9byU2wZUxQyhjfyv7AygbKXPbMboeVs8Trv79qisIegfS80
	 iwico0LQcK6Y3isYzeWNbe6HCbz+fzFFBVeLqOFmcuKL4zmWyGHcmLw6EKJszh61NG7jY
	 v1Eo9ajShontnHUk6T/nA7Wykv1lUp6ZTOJVm4CQiFtgso5eWq32f9DjHtgSp1OIKuPK4
	 MCYpVhG4EZfWr0FKczIGFQLlflYdNMwPhW+9UWFByXZD7V8M4ylYQSiutUiV1dCDKhclw
	 DGGKjHsVQjUQxhfZc2n1E5Fhiz4cfBhlun4cjq2caQINRTz3cURngQMMmrmAvBcQ7DQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795625520;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=i7tWip7T/Cve2OQMtV3UIkjp7ytTKBy3SeDeOfPKMSc=;
	b=RoB347O2I1sDsYn//496r5j0iwMY96ylAbkIHPcWxIHGr5lSQb7ezh+6sn0ns7PvreJF
	 ObpnVvcgUNkpBinT+KCAxvQsG61L5GPFu5ysI78XnVA6pFQdyLBdL2l3JqWkUUURphGW/
	 63SQS2rpteg6UskiC5ciohDcEVXNsp1VvyYyPiX55U926QnPISbsy9EwnGf/gfmLu6aN+
	 1EIX2ClWy3K1a+bAjBkgO2H6lG2FYzZmGQVTN8uORuELiZ74R8rAKelBdQ6bA+JsZRiM3
	 Ykqk1pKLixjsvfmET23h+F9P/9SHnX8ln4KQqyGm9Y1NIGCJvMCGP+N1/gbmM1UslHg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CbNZMPM8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2594606A31E;
	Wed, 25 Nov 2026 16:52:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CbNZMPM8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D7141F000C4;
	Wed, 25 Nov 2026 16:51:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795625520;
	bh=i7tWip7T/Cve2OQMtV3UIkjp7ytTKBy3SeDeOfPKMSc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CbNZMPM8B26KBoisrNH898+JL040OEYfZqjJC/48wRm7Z8j5AgnYTDhIPaROA/Qoh
	 TmEjnqNXI5KZ5N5rRpwrxYjSliAe0VrDZc+ghdAuzygq2Mbli5kf634p3eFOlumh6v
	 J4pxxpGYfG8PVSHKv7/yhgxw9BoC9VJD8CpfA/OM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <cel@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 543/816] tls: Honor O_NONBLOCK in tls_sw_splice_read()
Date: Wed, 25 Nov 2026 15:34:51 +0100
Message-ID: <20261125143901.755231433@linuxfoundation.org>
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

From: Chuck Lever <cel@kernel.org>

[ Upstream commit 78ded647d43e335891f981f68c5992a2e763cfcc ]

tls_sw_splice_read() takes its blocking behavior from
SPLICE_F_NONBLOCK alone. When splicing from a socket to a pipe,
do_splice() sets that flag from the pipe's O_NONBLOCK, not the
socket's. On a nonblocking socket, a splice(2) call without
SPLICE_F_NONBLOCK therefore sleeps in tls_rx_rec_wait() until a
record arrives. tcp_splice_read() instead reads sock->file->f_flags
and returns -EAGAIN.

Polling first does not avoid the sleep once tls_sw_splice_read()
consumes zero-length records, as it does after a later patch in this
series. tls_sw_sock_is_readable() reports the socket readable while
any record sits on rx_list, including a zero-length record that
delivers no bytes to the pipe. For TLS 1.3 the strparser announces a
record before decryption, when its plaintext length is still unknown,
so the readiness test cannot screen such a record out. A splice that
consumes the record and waits for the next stalls every connection
an event loop multiplexes.

An LLM audit of the TLS read paths found this defect.

Treat the socket's O_NONBLOCK as nonblocking too. A caller that
sets O_NONBLOCK on the socket and splices without SPLICE_F_NONBLOCK
now gets -EAGAIN where the splice blocked before. sendfile(2) from
a TLS socket changes the same way, because do_sendfile() leaves the
input file's O_NONBLOCK out of the splice flags. Both now behave as
they do on a plain TCP socket.

Fixes: c46234ebb4d1 ("tls: RX path for ktls")
Signed-off-by: Chuck Lever <cel@kernel.org>
Link: https://patch.msgid.link/20261027015215.605919-2-kuba@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
[ sashal: Adapted the tls_rx_rec_wait() call to keep this tree's extra NULL psock argument while passing the new nonblock variable. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/tls/tls_sw.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/net/tls/tls_sw.c b/net/tls/tls_sw.c
index bc2848d79c7d8..1b188f8fe45dc 100644
--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -2298,10 +2298,14 @@ ssize_t tls_sw_splice_read(struct socket *sock,  loff_t *ppos,
 	struct tls_msg *tlm;
 	struct sk_buff *skb;
 	ssize_t copied = 0;
+	bool nonblock;
 	int chunk;
 	int err;
 
-	err = tls_rx_reader_lock(sk, ctx, flags & SPLICE_F_NONBLOCK);
+	nonblock = flags & SPLICE_F_NONBLOCK ||
+		   sock->file->f_flags & O_NONBLOCK;
+
+	err = tls_rx_reader_lock(sk, ctx, nonblock);
 	if (err < 0)
 		return err;
 
@@ -2315,8 +2319,7 @@ ssize_t tls_sw_splice_read(struct socket *sock,  loff_t *ppos,
 	} else {
 		struct tls_decrypt_arg darg;
 
-		err = tls_rx_rec_wait(sk, NULL, flags & SPLICE_F_NONBLOCK,
-				      true, false);
+		err = tls_rx_rec_wait(sk, NULL, nonblock, true, false);
 		if (err <= 0)
 			goto splice_read_end;
 
-- 
2.53.0



