Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590108;
	b=GLM6CowdpH18UEyVtLe5aP672I7GOFfDuXijSTt+q2aBNxYitJ9wBBxYWEQR9IeZLso/
	 cuunoQIBsWtpj4/My8ly4ltIz19xxlZR9FHWuKyimWJWG10pNoP0nKmWhjPgCanvZxC8d
	 7OncP/McW6IKi5VRV36I1JyH5pNuKR2smeL61TncRsa/eaWNA2atwhTaZGZZTrgv7z+rG
	 ZH8Vxdy1lXIs+9H6Tf870uCfHuQQQISHv6qo+OeB5Jj9qkD3jSppOJmscBUiKOOpj0K8b
	 3ikgqbMjgOiimFexg550afaebjIUsYWd8OI6OCV3ntVi/pSIjd8kACYwRzRgItbGK8Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590108;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=FMBDWd9gyTQ0pVcexE1RZUQtmXXh24SnWuCDI8tWNlE=;
	b=tSzxOFFi9moBvaCEoftqLAZWN8sgTv6T7GvDlqQwql2B5PQYDfjVnxbMeb3MvRq/7GUa
	 ETzi2TqDvtTwAuFAylnwAin+DroXo50VMpmXSltKzxYcBOkqhlkYwr+B+cn5v5sp3gz9w
	 j+rFyR6xvAWnJSOTzwhIUyIp84a7iWCXgtzLGFibT9cQIRC6+tQilR79zYSYrvScYmJjO
	 OIAvsm5etpkinFZlaDyWKB76JHfaOc9KSaxH43UAT5pl5tUbQUJNCUeoluGC2VAnm26qZ
	 dpiT1HsV2Y2apkE97l43vvm8GG6/7T7qIMlX9ejCZAH9oy/P0hjcmhBVvuPtMhuMsDA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eYbRu96t;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 389F760A5BCD;
	Fri, 13 Nov 2026 17:15:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eYbRu96t
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D90701F000C4;
	Fri, 13 Nov 2026 17:15:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590108;
	bh=FMBDWd9gyTQ0pVcexE1RZUQtmXXh24SnWuCDI8tWNlE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eYbRu96tr17Dx1AXpSuUUrWnCXqKyZpOLUguLnTd5Nq9dbb9uRS1ZA0NbMA9klitA
	 h2t25w0HwOCF+L9ffXElYN6SVjUhQ8Zq1pbUc2aI7DMxKCTJyLNjNMvTsiLpAZyxsc
	 nzdFjlt5NOFzszIlP6ZBJ9KQfWAfP89r317i245I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bernard Pidoux <bernard.f6bvp@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 129/686] netrom: use the more flag of each frame taken from the resequencing queue
Date: Fri, 13 Nov 2026 10:44:22 -0500
Message-ID: <20261113153825.188895297@linuxfoundation.org>
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

nr_state3_machine() puts every received INFO frame on reseq_queue and
then delivers, in sequence order, the frames found there. Each of them
is passed to nr_queue_rx_frame() with the more flag of the frame just
received, not with its own.

When frames arrive out of order, the frames taken from the queue are
not the one just received, and the boundaries of the messages are
wrong: the last fragment of a message can be held as if more followed,
so the message is joined to the next one, or a first fragment is
delivered as a whole message.

Take the more flag from the frame being delivered.

Tested on two QEMU guests (6.12.94, KASAN, lockdep) linked by KISS: A
sends to a NET/ROM socket on B the second fragment of a message, then
its first fragment, then a one-frame message.

  before: one message of 120 bytes read (both messages joined)
  after:  two messages of 80 and 40 bytes read

No kernel report in either run.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Bernard Pidoux <bernard.f6bvp@gmail.com>
Assisted-by: Claude:claude-opus-5-5
(cherry picked from commit f04ef49452f88b5a97039dc413cf86966470265f)
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netrom/nr_in.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/netrom/nr_in.c b/net/netrom/nr_in.c
index b90a47dcf165e..a2c839e3dfb66 100644
--- a/net/netrom/nr_in.c
+++ b/net/netrom/nr_in.c
@@ -176,7 +176,7 @@ static int nr_state3_machine(struct sock *sk, struct sk_buff *skb, int frametype
 	struct sk_buff *skbn;
 	unsigned short save_vr;
 	unsigned short nr, ns;
-	int queued = 0;
+	int queued = 0, more;
 
 	nr = skb->data[18];
 
@@ -258,7 +258,9 @@ static int nr_state3_machine(struct sock *sk, struct sk_buff *skb, int frametype
 			while ((skbn = skb_dequeue(&nrom->reseq_queue)) != NULL) {
 				ns = skbn->data[17];
 				if (ns == nrom->vr) {
-					if (nr_queue_rx_frame(sk, skbn, frametype & NR_MORE_FLAG) == 0) {
+					/* The flags of this frame, not of the one just received */
+					more = skbn->data[19] & NR_MORE_FLAG;
+					if (nr_queue_rx_frame(sk, skbn, more) == 0) {
 						nrom->vr = (nrom->vr + 1) % NR_MODULUS;
 					} else {
 						nrom->condition |= NR_COND_OWN_RX_BUSY;
-- 
2.53.0



