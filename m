Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590095;
	b=rYt4I02uGa7E6tJb3Ss2qPgBGSDVMLAmGGt2ChYh1Ko0BL4ROqujbsxUBDgx+J82Mfoq
	 mNaf0YhQxVkiaUWW6T/FFwqvKccnH20PlDe/uQZ+EoX6i50dRSzHCzJDfMWyDix39JnVK
	 vK2YQb/C6Bl7LiQHL9bAteBhE9eCbBAJXWBwAGgE050un91giG1dgQzU8JakHIunurwE/
	 b1HNFrll0xKnqOZYJK3gAOP39W2YDIll0/IiTqiSUhnPdWh+CIeLg1jxnj300RD0qOdRz
	 F+GX2PXYVb22lnEsLxHxnjwN540VbjYb1KtDMUY4X+SdUZfEdzgUpROD64qNUqaR7fQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590095;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=DfYmeNz9dDXQ8wkRzNHxoMEQV7i8gZTyaNcHuUkMJ5s=;
	b=JId+ug+3XWTwvfLzAZcu9hI6GAt4xC+TQNSUwtOilvBr4vs2OANV5QBzc5B3Jra9KHKm
	 N0k4jMIE+SG5z615Us6xxLTqDa90lWHecbw4p0A5T4QS6SgDAxzJb4L//SzhYO2ZuZQAD
	 ZLP65P05RreviP/szuu8yrdJ7gsjSh0VTX8Mrakr4sats17fZ9YP79EfofH85Fp1wnPLN
	 w+aDYt/X7Oe4hOTig7el74KiIz3A6OO+A/uYNJPDDmBVIyD8Ragy/cNPbwNnZEKlKyn1Q
	 a843fqr8UZXrhKlGg3k6a2ip2YW+1Fl2NLd9bqLYeeIo8YUSVOOEYqbxo2I3SYOet+Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IuOCHknZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1C7E606C0B9;
	Fri, 13 Nov 2026 17:14:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IuOCHknZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DD271F000C4;
	Fri, 13 Nov 2026 17:14:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590095;
	bh=DfYmeNz9dDXQ8wkRzNHxoMEQV7i8gZTyaNcHuUkMJ5s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IuOCHknZDTfjiiwv5HQxFdILbZlapioROiN+VJ7xUf7x+l2Gu3DjcInFqJppTHT6p
	 9VvGO/UGgsj/PsBRa/+rPhjT96ZlJq5Mto+1TelN06TiVhYdb6WO2M2+Fu1UXbPxSu
	 1T88P/38dptUXwj6qIvEdzPWK1ajQ56BA4BPmbxo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bernard Pidoux <bernard.f6bvp@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 120/686] ax25: dont test the socket flags of a connection that has no socket
Date: Fri, 13 Nov 2026 10:44:13 -0500
Message-ID: <20261113153824.894860124@linuxfoundation.org>
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

When T1 runs out in state 2 (DISC sent, awaiting UA or DM), both
ax25_std_t1timer_expiry() and ax25_ds_t1_timeout() call
sock_flag(ax25->sk, SOCK_DESTROY) without checking ax25->sk. The
connections that ROSE, NET/ROM, IP in VC mode and incoming calls to the
port callsign make in the kernel have no socket, and reach state 2 when
their idle timer sends DISC. If the peer does not answer N2 times
before the heartbeat removes the connection, the timer dereferences a
NULL socket:

  BUG: KASAN: null-ptr-deref in ax25_std_t1timer_expiry+0x3d9/0x4f0
  Oops: general protection fault ... RIP: ax25_std_t1timer_expiry

With the default idle_timeout of 0 this cannot happen. With an idle
timeout set, it takes a short T1 and a small N2 on the standard path,
but on a DAMA slave ax25_ds_t1_timeout() runs on every poll.

A connection with no socket has nothing to destroy afterwards: test
the flag only when there is a socket, as ax25_disconnect() does.

Tested on a QEMU bench (6.12.94 with KASAN and lockdep, two guests over
a KISS serial link). A sets idle_timeout 1000 ms, t1_timeout 100 ms and
N2 1, with no listener; B calls NODEA-0, so A's kernel answers with a
connection without socket, then B removes its ax0 and stays silent:

  before: null-ptr-deref in ax25_std_t1timer_expiry(), oops
  after:  the connection is disconnected and freed by its heartbeat,
          ax25 refcount back to its starting value, /proc/net/ax25
          empty, no report, five runs out of five

The DAMA path was not run on the bench.

Fixes: 4a7d99ea1b27 ("AX.25: Close socket connection on session completion")
Signed-off-by: Bernard Pidoux <bernard.f6bvp@gmail.com>
Assisted-by: Claude:claude-opus-5-5
(cherry picked from commit fa410516cbf02e38bd951f78cfa848b7ac22f5df)
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ax25/ax25_ds_timer.c  | 2 +-
 net/ax25/ax25_std_timer.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/ax25/ax25_ds_timer.c b/net/ax25/ax25_ds_timer.c
index 0c9e7775aa54e..a0d6e9c5ec9f3 100644
--- a/net/ax25/ax25_ds_timer.c
+++ b/net/ax25/ax25_ds_timer.c
@@ -211,7 +211,7 @@ void ax25_ds_t1_timeout(ax25_cb *ax25)
 	case AX25_STATE_2:
 		if (ax25->n2count == ax25->n2) {
 			ax25_send_control(ax25, AX25_DISC, AX25_POLLON, AX25_COMMAND);
-			if (!sock_flag(ax25->sk, SOCK_DESTROY))
+			if (!ax25->sk || !sock_flag(ax25->sk, SOCK_DESTROY))
 				ax25_disconnect(ax25, ETIMEDOUT);
 			return;
 		} else {
diff --git a/net/ax25/ax25_std_timer.c b/net/ax25/ax25_std_timer.c
index b17da41210cb1..05ff1032748f6 100644
--- a/net/ax25/ax25_std_timer.c
+++ b/net/ax25/ax25_std_timer.c
@@ -143,7 +143,7 @@ void ax25_std_t1timer_expiry(ax25_cb *ax25)
 	case AX25_STATE_2:
 		if (ax25->n2count == ax25->n2) {
 			ax25_send_control(ax25, AX25_DISC, AX25_POLLON, AX25_COMMAND);
-			if (!sock_flag(ax25->sk, SOCK_DESTROY))
+			if (!ax25->sk || !sock_flag(ax25->sk, SOCK_DESTROY))
 				ax25_disconnect(ax25, ETIMEDOUT);
 			return;
 		} else {
-- 
2.53.0



