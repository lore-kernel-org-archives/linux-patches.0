Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590931;
	b=D8lmOKkIN70tvvZ8TcZWk7re2bd6q36JdAbbQfyV+c9J0lCnQ2giFyPpvQPVwedHv6V8
	 7ke/J5rnRtAIXUX378QeZrrzU7fkWB42dff6lIuUeaY3qW4nS6UNDvWl63FS4TxfYO14A
	 aLzBwFDbPqQEet5gudiQedFliXmwETYQtaYCW3mAua/1rwDPtVLhr4nCwzXkoNOX+/LZl
	 qZjfAnwlX9iFqNmL+9J1f1z7EdYLXLglhg6+OeGLSqdgoE4iy+31AwosH5tb1V8Bq7LY3
	 hwd0lp0r7L92X/ZAKykVYFHr1gahiPsKApfiugh0WyyJKV19Nq3i8AXl968BJRCELxw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590931;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=GZAaY9TQZRyHQguINg5+43QV3ss4w9AggXwzx4rZT7w=;
	b=33TnCn5ug1zlW+sxRaDFr6gExsJZE67gTRO8MWKMtM1ahuwLkabgklu3/qPtyhmRWWmp
	 fvlk2WPb1RDpH8SDvmfBZd6JvY+EEXALEUPhhxaACZex8IqIXfhXzED4ZysPDWbr6Wkg1
	 MMKxK6RyDMuasTY82e9WZdJkLK6qRH+L/I3O8P3uiISpzRzr1y8hWMky5Eny9KObQ/RBU
	 2ncEtzONKN0f16JusUGzu8/cQajC0SCBhpF4y+E0O1WXwB0yGj9UOGHVrnoAonMZTQd9H
	 oTbPG/djGO/Z9y+jLEXqmpAErr+bA7OgEvP4i8Hys08MUU10sQMU6F1+gEvViNGGa5g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="Jr51Y/0F";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D372C606E67A;
	Fri, 13 Nov 2026 17:28:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Jr51Y/0F
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F8471F000C4;
	Fri, 13 Nov 2026 17:28:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590931;
	bh=GZAaY9TQZRyHQguINg5+43QV3ss4w9AggXwzx4rZT7w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Jr51Y/0FdS22UFgh8EbATpWT7tM1049peWELmkMU1geT7SGygWNptg69Sf3dTkSab
	 qxtQ2wWpUrhv16oBqJ6sQzwrSCuFrcjDyg6HXsThaKSnKaV4iRFmCou9Br+PK4OTBl
	 dMOU07WuseLIvV5fSZnqhdJ4ZWKvkbdNwiCAw1iE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bernard Pidoux <bernard.f6bvp@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 117/670] ax25: dont test the socket flags of a connection that has no socket
Date: Fri, 13 Nov 2026 10:44:41 -0500
Message-ID: <20261113153815.791241586@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
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
index c4f8adbf81441..5eb54dd1120a5 100644
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



