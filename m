Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590138;
	b=Oq+fAvMOIFD5bqJdYoa5HZg2RK/u3sJR3QORfgHiYsKwWTJNQue07YvFi2oD75K4rIn3
	 5Zou3Oelrl51Bl5i7zI7laElCsrY2h2UkSjCkI+2mi8PFhu1/EZS9nhtQEMa550jSdHfZ
	 A//oBG0IgrmCAFHGRZrBcNrABzLHSlp5n4cjTbTbc5aGtIADisAAK4Vppvxrwho4j3yjs
	 F3PECvZLy4jj4POq/H5G5jNp/7WJuA2AqIHFdHLLSdNJEjJ3vSFWYCEb+nqaUJxV9uzku
	 Z+njaBvSR+0z4B6QzLEzFZmqzSedHzroWz0CzTHobjq68k9D2T9HoA2FrtYQaz8gs+w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590138;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=DAOo5Kx3yAXWl7oYt1fh5zFt74Z2C1DEwrqgVcuusGg=;
	b=FCc9D6fz/PHZCoq0f8FpXePrjYy53BJL1LzE4sMGByEdSWgrhdFoAEyqc1wF2KySwLXT
	 c1NuWXT0J0Jvn5Q683+Zo4iveSOXJZVlR7uE35YcrAakHQ3NgPvzx53RponiIl9Ooxt9y
	 lSl0Zaoo2sxuZePM7O4M9nHAuxKZZ/00hc41349u3N9OVAnwfIfJ63P0TSHiYJjXQJmov
	 AGR1Jodi6GVh+1MDmUNNJq4cR6UMuwHvQfF1iKKoKY3R2qXbL70csn4kZrhrhhkxfk4Oj
	 TERzSqfYKJuGiGKrEmgAUqkMB82qHDRfSKrtjtMrnhLRQccXVqTNGN9ZZr2Mp/hcRlQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="UbjIqAI/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3021D60A5BE3;
	Fri, 13 Nov 2026 17:15:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UbjIqAI/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1D671F000C5;
	Fri, 13 Nov 2026 17:15:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590138;
	bh=DAOo5Kx3yAXWl7oYt1fh5zFt74Z2C1DEwrqgVcuusGg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UbjIqAI/1wk+Pfrf0WbjO22PKkI5uwItvDy5Z9/JxB0yDcIi7VA4vyw+UVHg93HVa
	 amwap3PSQptv2NwpydP1U5IMrnlaGoBM1qUWskNHuJZZMJm61qK/xto1HE7ibnXmmx
	 axlLfSJZa8ugsMiSf+etDyfdLw9WZZr3pms91j60=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bernard Pidoux <bernard.f6bvp@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 138/686] netrom: only update the BPQ extension flag on circuit set-up frames
Date: Fri, 13 Nov 2026 10:44:31 -0500
Message-ID: <20261113153825.480718453@linuxfoundation.org>
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

For a frame received on an existing circuit, nr_rx_frame() sets bpqext
when the frame is a CONNACK of 22 bytes and clears it for any other
frame. Yet only the set-up frames tell whether the peer uses the BPQ
extension: a CONNACK of 22 bytes, or a CONNREQ of 37 bytes. The first
INFO frame of an accepted circuit therefore clears the flag set from
the peer's CONNREQ.

When a BPQ peer then repeats its CONNREQ, because our CONNACK was lost,
nr_state3_machine() answers with a CONNACK built with bpqext clear,
without the TTL byte that the first CONNACK had.

Only change bpqext on a CONNACK or a CONNREQ, from its length.

Tested on two QEMU guests (6.12.94, KASAN, lockdep) linked by KISS: A
speaks NET/ROM itself, opens a circuit to a listening socket on B with a
37-byte CONNREQ, sends an INFO frame on it, then repeats the CONNREQ.

  before: first CONNACK 22 bytes, second one 21 bytes (no BPQ byte)
  after:  both CONNACK 22 bytes

No kernel report in either run.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Bernard Pidoux <bernard.f6bvp@gmail.com>
Assisted-by: Claude:claude-opus-5-5
(cherry picked from commit e0950e6b8432455e36dcdd4fcdcdf51b27e7404c)
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netrom/af_netrom.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/net/netrom/af_netrom.c b/net/netrom/af_netrom.c
index d9b2d74d44c8d..86c0fca779051 100644
--- a/net/netrom/af_netrom.c
+++ b/net/netrom/af_netrom.c
@@ -961,10 +961,16 @@ int nr_rx_frame(struct sk_buff *skb, struct net_device *dev)
 		bh_lock_sock(sk);
 		skb_reset_transport_header(skb);
 
-		if (frametype == NR_CONNACK && skb->len == 22)
-			nr_sk(sk)->bpqext = 1;
-		else
-			nr_sk(sk)->bpqext = 0;
+		/*
+		 * Only the circuit set-up frames tell whether the peer uses
+		 * the BPQ extension: a CONNACK of 22 bytes, or a CONNREQ of
+		 * 37 bytes (repeated, for a circuit already accepted). The
+		 * other frames say nothing about it.
+		 */
+		if (frametype == NR_CONNACK)
+			nr_sk(sk)->bpqext = (skb->len == 22);
+		else if (frametype == NR_CONNREQ)
+			nr_sk(sk)->bpqext = (skb->len == 37);
 
 		ret = nr_process_rx_frame(sk, skb);
 		bh_unlock_sock(sk);
-- 
2.53.0



