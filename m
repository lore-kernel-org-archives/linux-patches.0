Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590102;
	b=kfvKeAjy6LBKVlGRopiQXD4vzVIS3Vy0lTL8XLlEg98ApPai+s/euixrReLzA4sMGwmq
	 jJkFRfbGy2NzVPSTTcNGKlJUwbCPuP4DUrqhoiqh+EdmGZEqWepvF8drN8bZRlA3eMGNq
	 Q2gG2QLvkU4pSvYJ2fyQ6okDKS1C4jBbkN4HnJXLWIz5UsOxZylZa4eZPs6HCBeHYxZOj
	 pn47ncUU4GR1xc3SU3hUeaS4CtF9VQKIreMbtn42yYRQefFe0UbmzBw083CO3LMUsVSj+
	 6UPoJOy/h9yCeSC7eRDM/KjH8BQA8bv2gBOe6OLGz/6FhH0lcISg4NoSrI4SLRqpqIw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590102;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=V4Sq8LnkfQURbehW2QKUnuUob9kXRYtdkbeBkclTUVw=;
	b=v4CLOwimC8VKZ3Nf2vHEhoPkTxMBXxSrtWE5oEby3HTJAEF5eDlyIztZ9wb9jS8aOIt+
	 yhPMtAQMwUyUZsDcYCcAtCj3bVLIsTeVeHRnDmIBBVkoxzmmcD0Ck7lVU6IJJXvp6AA8X
	 cEOfCV1b2p8mG0Kv/NQUS6hlfZpjOHSBkWoAMa9bEW/HBDDIOebdVYoml+aPVkUGIIWw5
	 L9hfiluDXZ+DXIO/nETEi7eKealmWgGuxTMqu5JXnjgYBr9iqav+kPWU0B6zcwqJJH7Zw
	 D91T3ASK1AY6UaTb/k54G4JKd4UUJzykmSVoZPRd3uXqAnJWtlfIjMjZHcJh8RlSd/w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=U7RT21Qi;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A68760A3810;
	Fri, 13 Nov 2026 17:15:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=U7RT21Qi
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD96D1F000C5;
	Fri, 13 Nov 2026 17:15:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590101;
	bh=V4Sq8LnkfQURbehW2QKUnuUob9kXRYtdkbeBkclTUVw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=U7RT21Qie7SHfFybGqkmDkdYmIMD76qj2qfxIHezD4jEvQ5GWf+Z0HVlUvxSdWzFb
	 LUGzedpAVrS2/VfPFqrONPKvV+Py1g9bALc8wZZ/M5NQ4zkf9EQ3zOpL2I2/7DgPea
	 Kx5+t4mVlHJ0IqShl7rbOjf7zE12DP6XRffgFywE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bernard Pidoux <bernard.f6bvp@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 125/686] ax25: let a socket connect again after a failed or ended connection
Date: Fri, 13 Nov 2026 10:44:18 -0500
Message-ID: <20261113153825.060034836@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bernard Pidoux <bernard.f6bvp@gmail.com>

When a connection fails or ends, ax25_disconnect() sets SOCK_DEAD on
the socket and shuts it down for sending, although the socket is still
open and its owner may call connect() again. ax25_connect() resets the
socket states but leaves both:

- the new attempt changes the state under SOCK_DEAD, and both
  ax25_disconnect() and the UA handling in state 1 skip
  sk_state_change() on a SOCK_DEAD socket: a blocking connect() is
  never woken up, whether the new link comes up or fails, and returns
  only on a signal;

- once connected, every send() fails with -EPIPE, since sendmsg()
  tests SEND_SHUTDOWN first.

Clear SOCK_DEAD and sk_shutdown when connect() starts a new attempt.

Tested on a QEMU bench (6.12.94 with KASAN and lockdep, two guests over
a KISS serial link). A listens on TESTA-9. B calls TESTA-8, where
nobody listens, then calls TESTA-9 with the same socket, a 20 s alarm
set, and sends a message:

  before: the second connect() returns only when the alarm fires
          20 s later, send() fails with -EPIPE, A receives nothing
  after:  the second connect() returns at once, send() succeeds and
          A receives the message

Applications that open a new socket for each call are not affected.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Bernard Pidoux <bernard.f6bvp@gmail.com>
Assisted-by: Claude:claude-opus-5-5
(cherry picked from commit d3773f1e0b60711b93529c658b672633f55f19fc)
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ax25/af_ax25.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/net/ax25/af_ax25.c b/net/ax25/af_ax25.c
index 81616e8438ce4..51a066ae4e89f 100644
--- a/net/ax25/af_ax25.c
+++ b/net/ax25/af_ax25.c
@@ -1302,6 +1302,15 @@ static int __must_check ax25_connect(struct socket *sock,
 		goto out_release;
 	}
 
+	/*
+	 * A connection that failed or ended through ax25_disconnect() left
+	 * the socket SOCK_DEAD and shut down for sending. The socket is still
+	 * its owner's: start afresh, or the state changes of the new attempt
+	 * would wake no one and every send() would fail with -EPIPE.
+	 */
+	sock_reset_flag(sk, SOCK_DEAD);
+	sk->sk_shutdown = 0;
+
 	sk->sk_state   = TCP_CLOSE;
 	sock->state = SS_UNCONNECTED;
 
-- 
2.53.0



