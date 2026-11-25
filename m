Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795620830;
	b=4EYQn964Jz/8+Skl05tSpXtv1IW5pN8Kor2RRVQrvc0wPhBj8lEMSpMoPxinA9m1m8Nb
	 lXLBDsXvtMcDR/6CjPdUNqIyKG4PG5lmI/hNAGMquBYso2Aw5X6JSOscyTClUi6ZnQUrQ
	 Wo9HL7J31AixNEnoVFpuVWoTWSKFfbDbwgLDgvAqQsV3qMgYjLzASKVg5/ukdokqOhII9
	 hnp9BzhO3+kQ99M2g5R3C3gHwYbxjA7s70HrcXWJrLBfbKQNA17j1weLtToAYJk12DvwJ
	 0ykL3Qd9jfDCjMACflRhzdz2rVRNf3wsIm6jicUFM6UJgd7ZoWJ5t0+C9+tvfA1Djzw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795620830;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=v1afAzTZdlm0BgFRZpFax12MG5HLBStogOFQknPhVdM=;
	b=u4XjRcEzMJ7u7rZN/x3+j3eXRd6UconlMdy32H3UVpcXjluYZp2PVIsYC+8A6c/aFhXN
	 ChK1yibvaTwie24WGgwdWMazyzAwhUfXaP4lD/fiMpnckB9jKD9nYZ9TMR+MyDolDQF1w
	 l9Y8pzptUT+zsVy1rpO/aJkUyyfF+XoSGK21NPjdqrIGJEmSUPQ02BM5UmC06xGeCoDJq
	 Q5oVLAzkPkMYSo1FNTr7jVizw8KNbBtlA1o5cuWbLbHd2KfMDqg6I5jSlzUGe0Of30kGq
	 NLHC7fonxmzLQF9pnDkqnqAABKxLAtxwrxGwvtmPg05LkUI3tsknyHf9c4JoOoOiYxA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=i2y+bKsm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4322606A31E;
	Wed, 25 Nov 2026 15:33:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=i2y+bKsm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 892031F000D1;
	Wed, 25 Nov 2026 15:33:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795620830;
	bh=v1afAzTZdlm0BgFRZpFax12MG5HLBStogOFQknPhVdM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=i2y+bKsmQePZcGoE5rOZYeC1VrLcZl8D8Do2bdcXbViskvEF8LYIVQC/0n8b+f/dl
	 gcMq/6DoXK8Ce+pohIVuJVWWKUxhSCXxGAEyrRt6pf9vWynW/DRy0gP2doLD5kx+A/
	 an24KUX/RaBWiVXmyrjtFRc6Zisa2MHvNhHwCkK4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bernard Pidoux <bernard.f6bvp@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 036/990] rose: reset a call when a DATA packet arrives out of sequence
Date: Wed, 25 Nov 2026 15:23:23 +0100
Message-ID: <20261125143822.934020287@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

In state 3, rose_state3_machine() drops a DATA packet whose N(S) is not
the expected V(R) and says nothing about it: the packet is not queued,
and at most an RR with the unchanged N(R) goes out later. ROSE never
sends a DATA packet again, so once a packet has been lost on the way (a
relay dropped it, or a link was reset under it), every following packet
is dropped as well, the window of the sender fills up and the call
hangs until one side clears it.

X.25 resets the call when P(S) is not the one expected. Do the same:
acknowledge what arrived in sequence with rose_enquiry_response(), so
that the sender frees those packets, then send RESET REQUEST and go to
state 4, as the other error cases of this function already do. On the
RESET, the sender sends again the packets it still holds, from N(S) 0.

Tested in two QEMU guests (6.12.94, KASAN and lockdep) linked over a
serial mkiss port. The calling guest runs a rose module changed for the
bench only to drop the third DATA packet it sends, keeping it on its
ack queue as if a relay had lost it; it writes d0 to d5 on the call.
Before, the called guest received d0 and d1, and the caller still had
3840 bytes queued 25 s later; after, the called guest received d0 to d5
in order, without duplicates, and the caller's queue was empty. No
kernel report.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Bernard Pidoux <bernard.f6bvp@gmail.com>
Assisted-by: Claude:claude-opus-5-5
(cherry picked from commit e15162d237ddecc2c1215f49b76f4cba06bbc2c8)
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/rose/rose_in.c | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/net/rose/rose_in.c b/net/rose/rose_in.c
index befb4c55e4597..b58f3b2700a69 100644
--- a/net/rose/rose_in.c
+++ b/net/rose/rose_in.c
@@ -194,6 +194,27 @@ static int rose_state3_machine(struct sock *sk, struct sk_buff *skb, int framety
 			if (atomic_read(&sk->sk_rmem_alloc) >
 			    (sk->sk_rcvbuf >> 1))
 				rose->condition |= ROSE_COND_OWN_RX_BUSY;
+		} else {
+			/*
+			 * A DATA packet was lost on the way: a relay dropped
+			 * it, or a link was reset under it. ROSE never sends a
+			 * DATA packet again, so the window of the sender would
+			 * stay full and the call would hang. Acknowledge what
+			 * arrived in sequence, then reset the call (X.25:
+			 * invalid P(S)); the sender then sends its
+			 * unacknowledged packets again.
+			 */
+			rose_enquiry_response(sk);
+			rose_write_internal(sk, ROSE_RESET_REQUEST);
+			rose->condition = 0x00;
+			rose->vs        = 0;
+			rose->vr        = 0;
+			rose->va        = 0;
+			rose->vl        = 0;
+			rose->state     = ROSE_STATE_4;
+			rose_start_t2timer(sk);
+			rose_stop_idletimer(sk);
+			break;
 		}
 		/*
 		 * If the window is full, ack the frame, else start the
-- 
2.53.0



