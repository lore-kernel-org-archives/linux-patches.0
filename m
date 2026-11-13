Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590948;
	b=yKrgiA6HCPPq+w9E47ROnHh1rhPlhKlW1zbVabJBY7jhLKVrQ0J0jsYIon3qq4IL5FXZ
	 MeKhLpof62Phta68CqZlFJXSyxn+nr64ODIUlyE35oB92nqkvoMChMR1cf18HgDv9JDu2
	 M3wuRQ+4RTTQ35dS6lf8fJM7s6qj0XUCoeRxDSOqmhTxgGSsNC7BqArTzxb8ww76xykj9
	 qfDDoJUu6if51TF67wa7qqu8PHrgW8OopHkMsxUUP9+0llcXnRWm+xTVkkZPOg6/hCpPn
	 r7rv+ZTlL/tR27dmdOLbxqo8USwq7mLzoqLOxPVN72j/rm94WIkX9JqSUWBbrtMsmIw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590948;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=MkKoECC8jyyQhhWxMsgz2FWVgh8yqp3oHCdGJzbS1Oc=;
	b=Gy4Mfwq+xBr6ATCeP8mzRAGUWu0KHxp3am7k/I6a0711uQMkDtevXAF/YrB9zVhz1Oqv
	 46AF4gSULVpBPmFJWZom9ci/h0QiKvuzIPWMEtJP3tw6MjnZzoYUS6q8lIFL8rYSKLQ22
	 Yr2lY7fmBE/ZTUcdGYuJ5PGTw2CGHUB2Xb7EefaaAfVAyAWsphwqa2YhThVjbCitgCCep
	 sb9S3tSU3Nl4K9VTwCLfXQmnkiqgY1MVFVOJ7bpVsRc+cuKyjFj92vy7F6amFoMtF3S9a
	 9p1yMgspmA7+8G/qDqP5Xzq+W3pLyzj8V7F/muBqAq48QrJUlLJSOtRcNTpv1sGut5A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="skr/jqoH";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1703D606B45A;
	Fri, 13 Nov 2026 17:29:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=skr/jqoH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B787C1F000C5;
	Fri, 13 Nov 2026 17:29:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590947;
	bh=MkKoECC8jyyQhhWxMsgz2FWVgh8yqp3oHCdGJzbS1Oc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=skr/jqoHuBxJyQn6rvax0zgYBNu2jyKuPCneUPyk0ibzXgmmn1pa7WrCcR3eB1B4v
	 lvAf5huAuupa7WyAzdFggFuSf8l0++aUnfgDEBZoSohoeBZWCEGTFQOhFgcEYnYsUV
	 3L8HC1iG1FaLv/5IKemyAIhJE5PhEKALWHU3aR2s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bernard Pidoux <bernard.f6bvp@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 129/670] netrom: return the peer node in the address given by recvmsg()
Date: Fri, 13 Nov 2026 10:44:53 -0500
Message-ID: <20261113153816.196725968@linuxfoundation.org>
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

nr_recvmsg() fills the source address with the 7 bytes found at offset 7
of the frame, where the destination of the NET/ROM network header once
was. But nr_queue_rx_frame() pulls the network and transport headers
before queueing the frame, so these bytes are user data, and for a
message shorter than 14 bytes they are read past its end: the caller
gets a few bytes of kernel memory as a callsign.

Give the node at the other end of the circuit, nr->dest_addr, which is
also what getpeername() returns with the user callsign.

Tested on two QEMU guests (6.12.94, KASAN, lockdep) linked by KISS: A
sends "hello" (5 bytes) then a message of 30 'q' to a NET/ROM socket on
B, which reads them with recvfrom().

  before: address bytes 16 eb 70 19 f7 91 5d (past the 5 bytes of
          data), then 71 71 71 71 71 71 71 ('q' of the message)
  after:  TESTA-1 for both messages

No kernel report in either run.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Bernard Pidoux <bernard.f6bvp@gmail.com>
Assisted-by: Claude:claude-opus-5-5
(cherry picked from commit 33171475c68078aebc88f87f35f5b9b4d50db0f5)
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netrom/af_netrom.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/net/netrom/af_netrom.c b/net/netrom/af_netrom.c
index c768c0afcc961..27ff6dd7878fe 100644
--- a/net/netrom/af_netrom.c
+++ b/net/netrom/af_netrom.c
@@ -1225,10 +1225,13 @@ static int nr_recvmsg(struct socket *sock, struct msghdr *msg, size_t size,
 	}
 
 	if (sax != NULL) {
+		/*
+		 * The NET/ROM headers were pulled when the frame was queued:
+		 * give the node at the other end of the circuit.
+		 */
 		memset(sax, 0, sizeof(*sax));
 		sax->sax25_family = AF_NETROM;
-		skb_copy_from_linear_data_offset(skb, 7, sax->sax25_call.ax25_call,
-			      AX25_ADDR_LEN);
+		sax->sax25_call   = nr_sk(sk)->dest_addr;
 		msg->msg_namelen = sizeof(*sax);
 	}
 
-- 
2.53.0



