Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590955;
	b=Ca9diPdGmGrpTDHiSMFB88yzRoG6VbCfhPkU2vQ9rqeXWLp4S71dCwnc4Ymb3FjZnb1G
	 lpG+gy1KK6739rM4H6Hb76Alg5XGipMpYPTbHypjTZtnNQ01LdbqqM83wFNvN1h7CZARd
	 9BNPoT/h4V/U+Tds+5iBfCLoQkJlae682IOrQQqNea0N3b0QHOtEitLzmELHMUFIv0TPv
	 1/w1/IkBCPX64yL4MPq+hUApwdSuH4UeWBsj2sBoJsVBiLLn+DcQFqfRw8xmtNoyhYdDk
	 RWs7ytUSCo3K8+Sh2ZjPH9K1SfCS4PBKxZi4sH1jXJtFUGC41zg5R1YWxF6GgmuK1Hg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590955;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=6jZYkzoQmsDHAOQvrXWTcXzeYQiAKb7K3IcqM3UM+8A=;
	b=amUbHg/08aYeCngAYMzHJnl+ZXaQLIYYAuLJI4PLbx79bjefAmnmhhcHI/LTscqUneUj
	 s+MOUQPrH1zjzmVb2W9oRB0rTW73T1E04y6yrXQME8XrgLeCrZ+DtcNnmWTopX5VjWeD3
	 PcYvjIrUxzjBFnVKoEDXM2QyoPCA53mBF/Urr8K7ZntvsPZhHPoDOerW1coskb2qu/Z+x
	 IDnf+0ehz6aLNHiWszgwtludYg8W4tcXMnWkeCFCd+w9GlyP6VcS5c+OxAo+SagxkYp+k
	 /BJUK0bKkk3m8DgLdP4TVBjRvMTujsnQCH0p4jrd5w6uUHRkkJtptKB6QkkbakJodjQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mRhZLd4S;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F647606F710;
	Fri, 13 Nov 2026 17:29:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mRhZLd4S
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C9911F000C8;
	Fri, 13 Nov 2026 17:29:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590955;
	bh=6jZYkzoQmsDHAOQvrXWTcXzeYQiAKb7K3IcqM3UM+8A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mRhZLd4S9nKG86jU47059ZGiDnPKTuioA1zAo+LA8NGIJb7UC6AGHoxnb4TjUQblo
	 Y/kJSnpN4oDgy0oUMZaczonsOb4evqZPPEwn1K3eHGcQLXbHlZW+hMHpA+P0Z8e945
	 jpHR91H7tZ2C7hgPvjOYhy3l37ID0EvU9yHI1Nsw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bernard Pidoux <bernard.f6bvp@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 135/670] netrom: only update the BPQ extension flag on circuit set-up frames
Date: Fri, 13 Nov 2026 10:44:59 -0500
Message-ID: <20261113153816.406752702@linuxfoundation.org>
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
index 55abdeaeb6fec..99d9fe19d27f1 100644
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



