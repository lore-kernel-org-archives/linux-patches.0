Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590943;
	b=itD1GarSakKCGP4pE6G/rIG39ZzaWpCU7ZJdU6dUHMBtzVrfMWAZjs3rwc/GsUh2pCid
	 8tZ7iVhOR9CPqCoJvP3zPRfRcsg9MrIr+MvgBPyTxXNZoOax0CD9uWvBNQFi5capsKqg/
	 cpgJWCm55fTme4A1S+W+PURKqnB412JBuQNPu+uWwwRJHaEwXruN5WchTlhBaCwX9k5S2
	 wGE4rOIE1+Ayj+OEmhepnkw1ZeAM+eYGoHxc1o/kvLdC4E/xiVL6d8CC2CDxhPalwjrbW
	 iY81v/tafAB9VUkOL5qB8Y812XI918rA6S0uELqhQkUB5eInAGSbMYSB2awG61AJ0/w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590943;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ekawW6O7BOjq3qSxcphndXTJMWlDk1KLxCTvGteapAc=;
	b=nOHFDlPn1gIBWMVT7h9E/SnIcaVGExNbJluq7iRT9qPb7MPqEcLBLiAdCxxNu611shIj
	 ndFt/ppE0tzUdinS5oePtGKeyHw0rhGpCJl5yUMPAIh0aTGW672hMapNPDHlTuH+U5QT+
	 S/mhLXghBw73YCQIQ40z4gwawwaVgVlfViO2a1GF1eu/qiyZO1sKUUZFzjSf0F0T5LQWd
	 324zQP+CaDLcAoqMHm3JBdmc5IbuHu8qFTz4EIUhgetbWPJzj0oj8fE6EjtM/u0Nn1n7N
	 OZuLDA8PPd/pp5YwTR2uWppLaRfhZ531gHhwTK3ZOy6iuRVUqmwqqtSV+IMG3VNKE1A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iKB0X6Qj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17528606A8A1;
	Fri, 13 Nov 2026 17:29:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iKB0X6Qj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B74D71F000C4;
	Fri, 13 Nov 2026 17:29:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590942;
	bh=ekawW6O7BOjq3qSxcphndXTJMWlDk1KLxCTvGteapAc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iKB0X6Qj7zhqWf73skQa+qYrY65AWI79RCKsTsrqcDOxs0eIonZ0UbtEmpeTyrmGK
	 3HckttpOPF6qwZGJJm60XaONdg8oTQ2lnJNRKDqvgLBPE3vQCYvfsW6qjMBeVE/a2p
	 qy50jWeyX3pCvqrPzlha0F0k3fcMaAh2bClm8CvQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bernard Pidoux <bernard.f6bvp@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 126/670] netrom: use the more flag of each frame taken from the resequencing queue
Date: Fri, 13 Nov 2026 10:44:50 -0500
Message-ID: <20261113153816.084288680@linuxfoundation.org>
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



