Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061813;
	b=hXpciKDIJ4c1oRbn+E41XDdKH44uYJDP67rh10crc8wn8/xLhwp2A01WJAfJX5v58Fk3
	 9xFVSQUmNm28zwog0O8r8x3qHYlbbDbO9GBBG4Vnz6H+tpzPHHGjKAo89oLm+FMyGRzsC
	 t8EG8ZPO6GrvutRpSb+Rv+YWD3n9vQV8qNaHdWo6BSkj6XKwz2auYn3H7fCPaRGhw8MQS
	 Ydwv46aY/ka3f2h/Lk37vFZUaMhjKJi0mNdUxuqXpFJWMKJbQ+F+Km+wr+XnXCyJae+ua
	 PdRuzOUh2UtZquqKykn/D4bGfbYlDc2fs/hyBBDIoQ8qfuD777MGerW3InZWI+j6YAA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061813;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=K7atdaHJWpeE9HvcgrEqfxLp1GrxV5M2HQQ92ygfdIU=;
	b=NRpgoaNXL91hxGNIiSdKRww31AUfOmw2k8IMdwre5x07VRu+UChFskKZkmdCu/seXT4d
	 OwuqK8eUi8bL3T2LAmI/VPetiAd5+BptIdJ7uiNt2v2+M1BYMpTFUPI7NjkMfw7htPQqq
	 ZVE1Ka5JU/u8eWLQkrchpToeGUWUEaru0PltdYgv0cQjvZDGkZTnEyva17Tcqu13GE1h6
	 PQleNHB5lmZ+yig/F2R+zDqKF8WuX9or7uQ5okMHTJwVtBRToRYZL3c/8EWjbqxrF2B8o
	 LzgMGhNOcE5ptGp5N19xCUbptUXaZp4B9c2ppcswDsVOMTaQXH5DOUn6hwuCu9Kf/Xw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xsPyAUQK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E6BC606A32D;
	Sat,  7 Nov 2026 14:30:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xsPyAUQK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C115C1F008A1;
	Sat,  7 Nov 2026 14:30:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061813;
	bh=K7atdaHJWpeE9HvcgrEqfxLp1GrxV5M2HQQ92ygfdIU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xsPyAUQKs1SIwCxYMna3ocuQwNwVaSgeBfcPgly25CW60GSKJvqSq0XVQ4Ngr6Dg5
	 QJ4PIApzpWOQvuDNz+iTFyiywdvZ9SLAgPMZhtzWZ/Q5w7c78/siDkwd06vot1s/46
	 1QCrN6TeN3tdBBok2fxevmJltm5PLD5OVMVaK1BY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 6.12 0839/1536] netfilter: conntrack: always lower timeout for non-closing RST packets
Date: Sat,  7 Nov 2026 08:47:35 -0500
Message-ID: <20261107135021.114402830@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

From: Pablo Neira Ayuso <pablo@netfilter.org>

commit 73df81b38cb7f70a347a97370386378a86e53019 upstream.

The existing check might extend the timeout if the ESTABLISHED timeout
has been tuned to be lower than UNACK via sysctl. Reported by sashiko.

Fixes: bf80e6802273 ("netfilter: conntrack: tcp: use UNACK timeout for non-closing RST packets")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/netfilter/nf_conntrack_proto_tcp.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/net/netfilter/nf_conntrack_proto_tcp.c
+++ b/net/netfilter/nf_conntrack_proto_tcp.c
@@ -1326,7 +1326,8 @@ int nf_conntrack_tcp_packet(struct nf_co
 	    timeouts[new_state] > timeouts[TCP_CONNTRACK_RETRANS])
 		timeout = timeouts[TCP_CONNTRACK_RETRANS];
 	else if (unlikely(index == TCP_RST_SET &&
-			  new_state == TCP_CONNTRACK_ESTABLISHED))
+			  new_state == TCP_CONNTRACK_ESTABLISHED) &&
+		 timeouts[new_state] > timeouts[TCP_CONNTRACK_UNACK])
 		timeout = timeouts[TCP_CONNTRACK_UNACK];
 	else if ((ct->proto.tcp.seen[0].flags | ct->proto.tcp.seen[1].flags) &
 		 IP_CT_TCP_FLAG_DATA_UNACKNOWLEDGED &&


