Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793208023;
	b=Bb4+qR4Y99K2AKKr/GUFRYlrss2UvVh/14gi2vVTKjpkGU0vJzRNecYn5Xp0kCWbyXcC
	 imXtVHKRfY25NpKEmCsEYcMe6fo7P6WfC3tCM8skZAwEtFkKW0iwBfDFjzbwrxAtJDmrC
	 4UxDWlgyH/+wpxbKoVpTiG4t25uTuWHy7NT+oQkGn+f4HgTtEFN4tXsHqgKPKuJZuVIGi
	 xiwVIgEs2n/JZlGiPQ75numhYODqt/bOxeYwK/W2mnnR6WZqZgfymKUJgO+3z66LB9OQA
	 Mlln9DLgX9XmpbRqQjB5cDmvigPJjjku48efpDkXhzo/1OJ1DGuyOfPoOcbiYuI8hNA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793208023;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=oJQlffoeLaxlBhhPQ6qEV8C79ovKaaloccg3xpucLDw=;
	b=3ukm1t8zUqXiOSSvK6BToPJoCeBOCiVyzglM7oczCdsrArhm+90dSPKy5Vn5ceP1NQfv
	 XPmtMAYah9hNxhuzQlx8onOrtszis1k/LDcP1x2g3lmqaWPCwrpuDqcgHbF7cw2ep66jw
	 JQbLib4LA1zqJkk8dr5BoF55XFHGsQrxKjXQyeo4c1tBcgU1xRXjqEjzxYAVoO0/QLNn5
	 egq0MLYu54NoDWy/eJpXQOsH8WL/QOtIVo9g9EZTPhOnKNEn4OSVVqCatfOg5FomkrXcj
	 XM90H4AUWrphak5iWNncV/rkOu1zzbug3bwzn2Lq/EN1v5+vGnQ7rd8XIHSo/uHRRoA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mNF9ZxKU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 997CB606A31C;
	Wed, 28 Oct 2026 17:20:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mNF9ZxKU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3F111F01828;
	Wed, 28 Oct 2026 17:20:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793208023;
	bh=oJQlffoeLaxlBhhPQ6qEV8C79ovKaaloccg3xpucLDw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mNF9ZxKURGYtiuNEaW3UCHbtVTsITUGgmKSkyZj+PRpMgCFcHDaGo/BjPb56i9xzL
	 FmEXY/PGCCQ6iMC4rDRFbtf0rX9axlN8+AwtP7oymipeNrhtUcKbqMkkxf4RB+v8KH
	 8+tAZeaPYVr5OC5FaMpwuxHKN9ByIqK674rI2k5M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bernard Pidoux <bernard.f6bvp@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 179/247] ax25: send unacknowledged I frames again when a link is re-established
Date: Wed, 28 Oct 2026 17:59:42 +0100
Message-ID: <20261028165951.661152230@linuxfoundation.org>
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



