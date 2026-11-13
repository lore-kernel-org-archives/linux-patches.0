Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590088;
	b=cRP/ZVsFEz2Nhk+fVAOTT2T3sKxwjh+1gQVLuWTVmCwU58MMzEoUamBqER4btQlGlW8C
	 hSDRfvtslNMe9HfFr/O7SgpGhub5JLvld6IrKNT+TUeeN0gNJU2gkBep0ojP7KMnSd+y1
	 q/1zSY317a8lwuzAFWYK+77/YMFq+rGzXbAPLYHAmx47HZEY529hnbBlvQ334gZ2dvq4x
	 3HlsZecgsKfEjiBd7w17JDadsmo9X3XOYKqoutFUwZgC95P8P8oY6+KgBsZOR1LrTRskL
	 q88ixXbAA+RQdNlwqjvFOtCRIKSvgoKFwlpy4w7e5voTb4BiwcaLxygCQvgv726sdlg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590088;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Kp7oL36kX55sC0KRIVe3tokk6qlaJSPYlxUBc5DiE5Y=;
	b=sg2WLDMIkJuSE4EDlm7DWeiqPPnH80lQsyk3HxWsGiqIddJynCTtI0aRP8QQ2Fk9zOdn
	 OOacht7G0xDnr8zv9FBJSBDjhI4OSMhmGxlZ9I8yMuu33fe0FNyw7jIi97KA2zZYoCQka
	 6x8jqKtNCGkqDYktNZ4uqI0V9KfgM+TOawUwityEdbhvdwmo84Bj8wpUFEh08OnOcecDZ
	 FAy+i4y959mJPMerCONSJR2UrGygbI//oG+QtftslSQ01AegLeKptEC8Ma/fCZpMngK5I
	 tgzcsQfON9EhsN/V2vdbhsNr/qrevfjwvqdgakjCi3cjXvSsKNHrwz+HbOfuINmzLWQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="IZyQ/r5z";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 524D7606A323;
	Fri, 13 Nov 2026 17:14:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IZyQ/r5z
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F35E71F000C7;
	Fri, 13 Nov 2026 17:14:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590088;
	bh=Kp7oL36kX55sC0KRIVe3tokk6qlaJSPYlxUBc5DiE5Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IZyQ/r5zGwAh/OtAiOex0t7WTJYNPsk+/wAOEi3Rf5aq0XM4MvopaHZcsbZt+bOhq
	 /PntbbRFxxh4+rNCO3j4bClHg9x3BaFJa5ej4AHIyY5uRwSwAr9FcrOEARRb0rRGiS
	 woSZ5gd2HSSFNrxi7bTdJX6H7/1KcbuHoTGsvxFs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bernard Pidoux <bernard.f6bvp@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 115/686] ax25: dont build a frame header from an uninitialised digipeater list
Date: Fri, 13 Nov 2026 10:44:08 -0500
Message-ID: <20261113153824.739810505@linuxfoundation.org>
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

ax25_sendmsg() reads the digipeaters given with the destination only
when the address is a full_sockaddr_ax25, but it then points dp at its
local ax25_digi whenever sax25_ndigis is not zero. sax25_ndigis is part
of the 16 byte struct sockaddr_ax25 as well, so a sendto() with that
short address and a non-zero sax25_ndigis makes ax25_sendmsg() build
the header from an ax25_digi that was never written: ax25_addr_size()
and ax25_addr_build() use whatever ndigi and calls[] the stack holds.

On a datagram socket the frame then goes out with kernel stack bytes as
digipeater calls, or skb_push() is asked for more than the headroom and
the kernel stops in skb_under_panic(). Any local user who can bind an
AX.25 socket can do it, and bind() is open to all with the default uid
policy. Kernels built with CONFIG_INIT_STACK_ALL_ZERO hide it, ndigi
is then 0.

Point dp at the local list only once the digipeaters have been read
into it. A short address now sends without digipeaters, as connect()
already does with the same address.

Tested on a QEMU bench (6.12.94 with KASAN, ax0 on mkiss, the frames
recorded on the serial line): ten sendto() with a full address and 8
digipeaters, each followed by one with a 16 byte address and
sax25_ndigis = 8, ax25 built with -ftrivial-auto-var-init=pattern as
with CONFIG_INIT_STACK_ALL_PATTERN:

  before: skb_under_panic (put:1793), kernel BUG on the first short one
  after:  20 frames, the short ones without digipeaters, the full ones
          with their 8 digipeaters, no KASAN report

With the zero init used by most distribution kernels, and on this bench
without any init, the stack held 0 there and the short frames already
went out without digipeaters before the change.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Bernard Pidoux <bernard.f6bvp@gmail.com>
Assisted-by: Claude:claude-opus-5-5
(cherry picked from commit 15f2d99ffa155d65e591fb171f3df048d3d3802c)
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ax25/af_ax25.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/net/ax25/af_ax25.c b/net/ax25/af_ax25.c
index 63fe99746d328..6b43aaf31b252 100644
--- a/net/ax25/af_ax25.c
+++ b/net/ax25/af_ax25.c
@@ -1569,7 +1569,7 @@ static int ax25_sendmsg(struct socket *sock, struct msghdr *msg, size_t len)
 	struct sock *sk = sock->sk;
 	struct sockaddr_ax25 sax;
 	struct sk_buff *skb;
-	ax25_digi dtmp, *dp;
+	ax25_digi dtmp, *dp = NULL;
 	ax25_cb *ax25;
 	size_t size;
 	int lv, err, addr_len = msg->msg_namelen;
@@ -1644,6 +1644,7 @@ static int ax25_sendmsg(struct socket *sock, struct msghdr *msg, size_t len)
 			}
 
 			dtmp.lastrepeat = 0;
+			dp = &dtmp;
 		}
 
 		sax = *usax;
@@ -1652,10 +1653,6 @@ static int ax25_sendmsg(struct socket *sock, struct msghdr *msg, size_t len)
 			err = -EISCONN;
 			goto out;
 		}
-		if (usax->sax25_ndigis == 0)
-			dp = NULL;
-		else
-			dp = &dtmp;
 	} else {
 		/*
 		 *	FIXME: 1003.1g - if the socket is like this because
-- 
2.53.0



