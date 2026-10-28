Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793208001;
	b=Ic8bad5cd6vlJiDv6/ytEAeumu6uYM4sioaoMchAQGYHngLz4yBXgiMABDi1dSj0HNCk
	 HCxoZSL+CQaLqUQG3WjhcSamkqBbTHYwWI5rCc2w2pKBRHTm393DP0wP1yyJuIdzLYxwE
	 8YuBm8B5WykyyRXsv1z8/IR/q1UILaXMWziFKFm22G9wKGNj1ZplR62QuqhVuvDUpBMoO
	 LU7x/Gpm9l5nFEaZewjE6TxFOEok3QuEGCPw8QjMmQGomJJBT1QTHLeAKGJHenSSw3PVj
	 a9g10O+jazTsHpsst0VhixyxkxtsCj/9qaZ9ZepOOVTMTEOlQiRVWaNSb6JP7aNVCaw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793208001;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ylVnDq7T4qdNhuzuukjnQ2t5C6vkAmZaUo7GQ0hjlqo=;
	b=LM/vUz7JVdFCeJRx2W99OLC76trmd7r/pLdfnviFW9S7YrAsgFMRw6r03AEzguygWu3q
	 3h2bgTtlqrcsSPi1UjFMOYHm/OUqDaIPP+iG+cVw4n8yeslUSG6ryvHK9NBSo5HkYIwUq
	 j/AlHORrtlC3CpphMn+maD1srEUr9vUVwQYKQw9IH5NXlbi3njHHimpSD1RtYkjQPIYwD
	 5P6GMUF45v2mqOo0SQ93IPWyjhQ2vNN/MGvhefmUflvpXpjgUGANxbxLSNNZ9QR6+DHIa
	 oGOboT9srBuMI38b35CUCnUx+VmH6ikq4M6BQQ5c7z01F8LJMzuESpDyR87glxCRBKQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JbUes5e2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAF1C606A31A;
	Wed, 28 Oct 2026 17:20:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JbUes5e2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13BF51F01825;
	Wed, 28 Oct 2026 17:19:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793208000;
	bh=ylVnDq7T4qdNhuzuukjnQ2t5C6vkAmZaUo7GQ0hjlqo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JbUes5e2BRsGNlTmlju6Io0kEKt7lD6K/Bt6NDjjD77oyOHksDbQd2zvAejEq8ffP
	 Wv8GJJvg0iT5cWjjbkiG5Lhl2iswIOIm8gLyeVUzd+vJfedm+XEd5uyo0S5R0Wtlwa
	 cpWxqa9LEeS9G1E2Kl36jBKKXUdySm20UVJmBIwo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bernard Pidoux <bernard.f6bvp@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 177/247] ax25: send a private copy of each I frame
Date: Wed, 28 Oct 2026 17:59:40 +0100
Message-ID: <20261028165951.613987272@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028165947.349197979@linuxfoundation.org>
References: <20261028165947.349197979@linuxfoundation.org>
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

ax25_kick() keeps every I frame on the ack queue until it is
acknowledged and hands a clone of it to the device. After a REJ or a T1
timeout the frame goes back to the write queue and ax25_kick() clones it
again. A clone shares its data with the original, so ax25_send_iframe()
and ax25_transmit_buffer() write the control field and the address
header of the new clone in the very bytes used by the previous one. If
the previous clone is still waiting in the device queue, its control
field is rewritten there: it leaves with the N(R) current at the time
of the retransmission, not the one it was sent with.

Frames queued behind it, an RR for instance, were built in between with
a lower N(R). The peer then receives an N(R) lower than one it has
already been given. ax25_validate_nr() rejects it and
ax25_std_nr_error_recovery() resets the link with a SABM, in the middle
of a transfer. The layers above pay for it: on a ROSE circuit, the
frames replayed after the reset carry stale sequence numbers and the
circuit is reset as well, with loss of data.

Hand a private copy to the device instead. The frames are small (256
bytes of data by default) and the link is slow, the extra copy is not
measurable.

Found on a test bench: two virtual machines with four CPUs each, a
6.12.94 kernel with KASAN and lockdep, one ROSE circuit over an AX.25
link on a serial line (mkiss), 192 messages each way in bursts of 24,
and three REJ frames injected by one side. Instrumentation showed that
frames reached the driver in the order they were given to
dev_queue_xmit(), that V(R) never went backwards on the sender, and
that the driver nevertheless saw frames whose N(R) was lower than the
one before.

Counting, on the receiver, the frames whose N(R) is lower than the
previous one:

 - this code plus the two pending AX.25 fixes used on the bench (REJ
   guard, requeue on re-establishment): 4 runs, 13 such frames, 4 link
   resets; with this patch: 6 runs, none, no link reset;
 - the same with the transmit serialisation patches for AX.25 and ROSE
   on top: link resets in most runs before; with this patch: 6 runs,
   none, no link reset, no ROSE reset, 192/192 messages both ways in
   every run.

Signed-off-by: Bernard Pidoux <bernard.f6bvp@gmail.com>
Assisted-by: Claude:claude-opus-5-5
(cherry picked from commit 1b464137f3173fadf81a7a1bf4a9584ebaf72c7b)
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ax25/ax25_out.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/net/ax25/ax25_out.c b/net/ax25/ax25_out.c
index f082b69126623..7c4ebef5ae6c2 100644
--- a/net/ax25/ax25_out.c
+++ b/net/ax25/ax25_out.c
@@ -341,7 +341,16 @@ void ax25_kick(ax25_cb *ax25)
 	ax25->vs = start;
 
 	do {
-		if ((skbn = skb_clone(skb, GFP_ATOMIC)) == NULL) {
+		/*
+		 * Send a private copy, not a clone. The frame stays on the
+		 * ack queue and is sent again after a REJ or a T1 timeout,
+		 * while the previous copy may still be waiting in the device
+		 * queue. A clone shares its data with the original: building
+		 * the frame again would rewrite the control field, and so
+		 * the N(R), of the copy already queued.
+		 */
+		skbn = skb_copy(skb, GFP_ATOMIC);
+		if (!skbn) {
 			skb_queue_head(&ax25->write_queue, skb);
 			break;
 		}
-- 
2.53.0



