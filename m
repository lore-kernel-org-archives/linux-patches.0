Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795625651;
	b=bq1vH+JX2GRYGNn/eVwQSuIQnFdswKQa5t31y/YsWPqCV6Q4jGizdvj9tyoTN3c1IkX9
	 BlME7chQlCekc7coSq0TO69841qEUg+Xfu+W6ZSpDsiGgyWEyTXaeoHpdxln9LvTLUJdR
	 w7ghTGt9Fg5wDc8jY6qtT4ktHosL6Fb5I6uLWFt2VBbv8jM9fhjoHAGbSAXp7SOQo8hFO
	 87ScirxS2BNTxQHUzIWIfr7Lvv/tYO70zYYK2Vw5C39W0Jt2oe7zw/PyTQQSs6Bp+ZqP1
	 PnAcNtA1cRTXVgkBMf3fqTn5uVhurqqhUSN3OemDgZyRfU7x8Lm8GlLwURFESYdIEag==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795625651;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=eiPXrrbv4sRBvs7S9E+nQvcoKwSxwxNXTBORiSJnMgo=;
	b=aIYSFM7FonYhB/CKt9oNXOHLrDvqsNv5JySeu80NFXCnGhIvsgu/vm8jpu120ZOhXp9O
	 Lbdk6TurKmb+PjdCxRLkK6HMvVxGJB2zcbuvgMO8ilzZRbhmmsaCcPYBeQg7UjHlfx+AC
	 RKge5bjTNEUbGlOVPDhKb4CFfPJC1dgSM6yt6s9gfQMti2XCNI6iX7ccvtc7ke+qF3Bll
	 iwCsCF3Af//09huuG1+Kvk5C2saX41YPTd5W6euYTuMOVCh0/ugMNtDDLJTcpraR16Jaw
	 6Tr9v5A5q7vM9Hx/B6kNQLbmndrlID/GKiGir9JeV24qE9FeDxkNacg9YGTELtsdI1g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bNP1PkFz;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D850C606A323;
	Wed, 25 Nov 2026 16:54:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bNP1PkFz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3489B1F000C4;
	Wed, 25 Nov 2026 16:54:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795625651;
	bh=eiPXrrbv4sRBvs7S9E+nQvcoKwSxwxNXTBORiSJnMgo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bNP1PkFznD3QkchMWvlXqyNqclyhwYmiZb5WUpI86iDVLPT5YU3ehzW2L9RvRoYe/
	 16xkI/FSoacldQnkT+KcwoZ0Z8c2zV9BHpKxTpxGuVMUMuau2Y8i2YS2HCWVCeo71Q
	 nTD0Bko21EsbpbKVtA24wIzNev1CA4EqGw/T10IU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?J=C3=A9r=C3=A9my=20Jean?= <Jeremy.Jean@oss.cyber.gouv.fr>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Dmitry Safonov <dima@arista.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.12 587/816] tcp: fix authentication bypass via unsupported TCP auth options
Date: Wed, 25 Nov 2026 15:35:35 +0100
Message-ID: <20261125143902.766150856@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jérémy Jean <Jeremy.Jean@oss.cyber.gouv.fr>

commit 7cc235fb1251fec1183e3158c60d2e504c2a8e8b upstream.

tcp_inbound_hash() parses both TCP-MD5 and TCP-AO options when at
least one of the two features is enabled. With TCP_MD5SIG=y and
TCP_AO=n, a packet carrying an AO option reaches the disabled
tcp_inbound_ao_hash() stub. That stub returns success, so sockets
configured to require MD5 authentication end up accepting
unauthenticated data. A forged AO option skips the unsigned fast
path, which is the only place where tcp_inbound_hash() can return
SKB_DROP_REASON_TCP_MD5NOTFOUND.

The inverse configuration with TCP_MD5SIG=n and TCP_AO=y has the same
problem for an MD5 option on AO sockets.

Note that TCP-AO depends on 64BIT: therefore, every 32-bit kernel with
TCP_MD5SIG=y is in the vulnerable configuration.

Make the disabled stubs reject options for the unsupported
authentication scheme. This matches the real helpers' behavior for
sockets without keys. It also means that kernels with TCP_MD5SIG=n and
TCP_AO=y now drop segments carrying an MD5 option on unkeyed sockets,
as kernels configured with TCP_MD5SIG=y already do.

Fixes: 0a3a809089eb ("net/tcp: Verify inbound TCP-AO signed segments")
Cc: stable@vger.kernel.org
Signed-off-by: Jérémy Jean <Jeremy.Jean@oss.cyber.gouv.fr>
Reviewed-by: Kuniyuki Iwashima <kuniyu@google.com>
Acked-by: Dmitry Safonov <dima@arista.com>
Link: https://patch.msgid.link/20261107224733.1104094-2-Jeremy.Jean@oss.cyber.gouv.fr
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/tcp_ao.h |    3 ++-
 net/ipv4/tcp.c       |    3 ++-
 2 files changed, 4 insertions(+), 2 deletions(-)

--- a/include/net/tcp_ao.h
+++ b/include/net/tcp_ao.h
@@ -287,7 +287,8 @@ static inline enum skb_drop_reason tcp_i
 		const struct request_sock *req, int l3index,
 		const struct tcp_ao_hdr *aoh)
 {
-	return SKB_NOT_DROPPED_YET;
+	NET_INC_STATS(sock_net(sk), LINUX_MIB_TCPAOKEYNOTFOUND);
+	return SKB_DROP_REASON_TCP_AOUNEXPECTED;
 }
 
 static inline struct tcp_ao_key *tcp_ao_do_lookup(const struct sock *sk,
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -4809,7 +4809,8 @@ tcp_inbound_md5_hash(const struct sock *
 		     const void *saddr, const void *daddr,
 		     int family, int l3index, const __u8 *hash_location)
 {
-	return SKB_NOT_DROPPED_YET;
+	NET_INC_STATS(sock_net(sk), LINUX_MIB_TCPMD5UNEXPECTED);
+	return SKB_DROP_REASON_TCP_MD5UNEXPECTED;
 }
 
 #endif


