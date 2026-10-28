Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793209648;
	b=R0TXMd99p/reewJntohNL01qqJOVBNeb2BteqKIivD68HA6powktywdpo81pQAinOUPk
	 ZkApbg1biDtZYOzQTTVmNXxYXXb0hSzBcTWLPiLU/Pc6v/yT8miC8L1r/l+eS3dVXpPVw
	 vRej06ON54fWApRBtNJF4xvlM/KPIhT8bVwgYTWK7fNoeqH+NeDIQnioNDVTwrqVVx4+b
	 CxkmuHVAfB6MGwTa610txQAf9eZy8zGzycWtlOXQTX94FJV4QkN2Y3m6G2pOYgLwQ3Jvs
	 oJL20UfTL8quUKXQpNG2hUQq8niygFeJdSYdlC7icWOYEZhbuFgFpCk6EEQahVD3kYg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793209648;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=vscc2wnYGHPQpWl3K92W0hRdd8pCETQ7cX9ETxZMyBI=;
	b=lWd82BBNT22ioXJUw8m80mohBXSQ7JuXfPfh3i7EKjq7Yp45XJrr9K5TxbTlE4pr0j5R
	 Eot8zg2iPKWcIpJyM4Wn+bZ3GdHmDiHCmai+hyDNfqO0ZHbDxFA7SpW8ilnDtDlu6PUML
	 2NyH+nptNW7TBh4d1KzcGDZapnMEJbXUX5LASEW76yCBujPhUMhzbixH7nIwvG2U/P/1i
	 GlN4CQPgzlsWO/aqXtLrPeWcFpDx40gyMwitzE5pcPF2TfCkweWojtSK5P6kXNnJbAVNJ
	 VqWGLpGOM1G7edy4u2UEMLQ8WStFrsNAtIM9D6TZOBb24hWvxtN72vOrLAGnF0CK0NQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dkbHZDkS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92C9B606A31F;
	Wed, 28 Oct 2026 17:47:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dkbHZDkS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E28EF1F01829;
	Wed, 28 Oct 2026 17:47:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793209648;
	bh=vscc2wnYGHPQpWl3K92W0hRdd8pCETQ7cX9ETxZMyBI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dkbHZDkSl4oEinHqhR6d5fTH5AkysgfZevYkftfZHIC+MaWaB1BZtprVbVnwwSyyY
	 jm63jpRRqAdq8VXU7X4agYRsD4nBe7yVK3ST+4BEjb5exuCUT8P0Y/IJluRn/6zKnV
	 wnxEucX7I6N9tgNrGZm7Duf5jvonxJODHCoKNvNc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bernard Pidoux <bernard.f6bvp@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 028/109] ax25: send unacknowledged I frames again when a link is re-established
Date: Wed, 28 Oct 2026 18:00:12 +0100
Message-ID: <20261028165943.025484623@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028165942.357251485@linuxfoundation.org>
References: <20261028165942.357251485@linuxfoundation.org>
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

When a connection goes back through state 1 from state 3 or 4 (invalid
N(R), FRMR, illegal frame), the UA that re-establishes it resets V(S),
V(A) and V(R) but leaves the I frames that were waiting for their
acknowledgment in the ack queue. From then on every acknowledgment
frees the frame at the head of the queue, an old one, instead of the
one it is for, so the queue keeps that many frames too many for ever:

- they stay charged to the socket that sent them, whose send memory is
  never given back;
- they are sent again by the next go-back-N, long after the event, and
  the peer gets duplicates;
- they were not sent again when the link came back, so the layer above
  lost them.

Seen on a live ROSE node: an AX.25 connection in state 3 with
V(S) == V(A), empty write queue and 18 frames in its ack queue, and the
ROSE sockets using it showing a send queue that never drains.

Requeue those frames when the UA is received, as is already done when
the peer resets the link with a SABM in state 3 or 4. Same change in
the DAMA slave state machine.

Like that existing path, this can send again a frame that the peer had
received just before the reset: AX.25 has no way to know. The layer
above sees a duplicate instead of a silent loss. ROSE drops an exact
duplicate, but resets the circuit when the replayed frame carries an
N(R) that is no longer valid. On the nodes below those resets came
with link re-establishments caused by a late N(R), which "ax25: send a
private copy of each I frame" removes: with both patches the node that
is instrumented saw no re-establishment and no reset in 49 hours,
against five resets in the 47 hours before.

Tested in QEMU (6.12.94 with lockdep and KASAN), two nodes over a
mkiss serial link, one ROSE circuit, 40 messages 150 ms apart, the
link forced through state 1 three times by an injected FRMR. Before:
6 runs of 6 deliver 40/40 and leave one frame in the ack queue, the
ROSE socket keeps 960 bytes of send memory. After: 6 of 6 deliver
40/40 and the send memory goes back to zero. No lockdep, KASAN or
refcount report.

On four production nodes since 3 October 2026, six since 6 October. A
relay node that had 18 to 20 such frames on one link is sampled every
hour: 124 samples and 1301 link states in five days, none with a frame
left in an ack queue.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Bernard Pidoux <bernard.f6bvp@gmail.com>
Assisted-by: Claude:claude-opus-5-5
(cherry picked from commit 7b22827cb729de19ccba284ebaff3eeee21d4f11)
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ax25/ax25_ds_in.c  | 2 ++
 net/ax25/ax25_std_in.c | 8 ++++++++
 2 files changed, 10 insertions(+)

diff --git a/net/ax25/ax25_ds_in.c b/net/ax25/ax25_ds_in.c
index c62f8fb06189e..b78a577760c6f 100644
--- a/net/ax25/ax25_ds_in.c
+++ b/net/ax25/ax25_ds_in.c
@@ -58,6 +58,8 @@ static int ax25_ds_state1_machine(ax25_cb *ax25, struct sk_buff *skb, int framet
 		ax25->vr      = 0;
 		ax25->state   = AX25_STATE_3;
 		ax25->n2count = 0;
+		/* I frames left unacknowledged by a link reset: send them again */
+		ax25_requeue_frames(ax25);
 		if (ax25->sk != NULL) {
 			bh_lock_sock(ax25->sk);
 			ax25->sk->sk_state = TCP_ESTABLISHED;
diff --git a/net/ax25/ax25_std_in.c b/net/ax25/ax25_std_in.c
index f280683f83fcf..d0269ece4fc58 100644
--- a/net/ax25/ax25_std_in.c
+++ b/net/ax25/ax25_std_in.c
@@ -66,6 +66,14 @@ static int ax25_std_state1_machine(ax25_cb *ax25, struct sk_buff *skb, int frame
 			ax25->vr      = 0;
 			ax25->state   = AX25_STATE_3;
 			ax25->n2count = 0;
+			/*
+			 * The link may have been re-established from state
+			 * 3 or 4 with I frames still waiting for their
+			 * acknowledgment. V(S) and V(A) start again from
+			 * zero: send those frames again, as is done when
+			 * the peer resets the link with a SABM.
+			 */
+			ax25_requeue_frames(ax25);
 			if (ax25->sk != NULL) {
 				bh_lock_sock(ax25->sk);
 				ax25->sk->sk_state = TCP_ESTABLISHED;
-- 
2.53.0



