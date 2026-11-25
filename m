Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795622972;
	b=swt2QsQc1H2d+VIFkMokUuOglEV+OoIeTCQCUGGdfkNvZD+vHpM+kiEvf1ju/Gk1kYGS
	 za3fXHqbCgXkz9ciUD0lulSEbPgvYxZCm3FCrjA9ThaQ6d6w9mn2jDORhglV6Qspfctcq
	 R5fJ83IOeXpTBsbZ4hWdW0rhkIrUsSDVIqqu4s/TTO3fUPWnjO+yfMFrTWuQuWd0W9+P4
	 E/9dsRi8f9tBwwKeZb/DzOzIejkf4NaE2vhpK9C3zwTAjPsLsduIhKOilTJKQZyssjIhB
	 2TWRby8U+uWfb3+T/YhFN3r71RQFdCQCAAyQAvbSPjTho6oUAw+a4Tuh2IBvb+NQgqg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795622972;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=F80LKjOOH9cuIG5pn1rqdRFx04jNcgVI6SPtswRu7QI=;
	b=42udgCiUk5T37WR0M1lEmPVLLSjjLy996wVCDqLlSOjqpLzxNpHA9hLQRYmdEyZK7P7B
	 dvn3oyc1tC/ouEbnXd8Oa2hDVo9f5S9qbt6iFbliZ+oUxFgDr7wZ9pZSO8S+xjU7OB8d6
	 welW7Z8pdTnPiYXYav1e3XO4yO44RIwQJOP+KthBjMVOzPrAHnzH/bYp6NIWK4h7yCeqH
	 eZsTa2QCvGcsF8XG5Z2/7VflCOA6umO6/LKmvq3JOI6FatuKhJt5E7H5FmFkS/We2m8vx
	 lWHdSrl4K/w4NNoPJ9M3mL0ESaemVSCt28lwZchE1RzOJFPQ2e0RwqZNylyOY95Da9w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="FHaq/xIx";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2C54606A327;
	Wed, 25 Nov 2026 16:09:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FHaq/xIx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB7241F000E6;
	Wed, 25 Nov 2026 16:09:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795622971;
	bh=F80LKjOOH9cuIG5pn1rqdRFx04jNcgVI6SPtswRu7QI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FHaq/xIxB0/r38LVHole4Lx8c3Y73WrScEJGbwJ34ZxQrYI5OqzNOMyyGxdVi5s3N
	 Pt2IGzf32drnzBmdLouuPAvldmjX6ciixsoMtQItdxDDs1bkcaVXD8zOc0ztAGzdlX
	 BSML553U1tHZZH6+5mspsKY6OCtcQP4JP1HNP6s8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?J=C3=A9r=C3=A9my=20Jean?= <Jeremy.Jean@oss.cyber.gouv.fr>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Dmitry Safonov <dima@arista.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.18 708/990] tcp: fix authentication bypass via unsupported TCP auth options
Date: Wed, 25 Nov 2026 15:34:35 +0100
Message-ID: <20261125143838.666481036@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -4965,7 +4965,8 @@ tcp_inbound_md5_hash(const struct sock *
 		     const void *saddr, const void *daddr,
 		     int family, int l3index, const __u8 *hash_location)
 {
-	return SKB_NOT_DROPPED_YET;
+	NET_INC_STATS(sock_net(sk), LINUX_MIB_TCPMD5UNEXPECTED);
+	return SKB_DROP_REASON_TCP_MD5UNEXPECTED;
 }
 
 #endif


