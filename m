Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795624906;
	b=o3dPjEmFN2TPOVltQ7WJiyXl2/IM1WD6qu9upcFF7bpsxlGC7Eh3oq+G55VEsHQ0X6eG
	 x4w9RLMnd9nLy1Kg6w86eor/rhhojpL133lyujQDcQ+QmGgHOJedU9a3YN+HVTMmgrToe
	 o+XVvnGAtKgV+Df+57its9WyD4JHrxAzBXyKd8JZYIxRuEp03Yy/nsw10rlNtoznRk5b6
	 1e6nhrFK6XxQFLPThQkGge0QluLwH7kjnZuPr1khML+lRLXLe/EA680NAkYv3Q/GRAk2F
	 Vk6JEz8MKhSGGmR5FJ7NzvQ7sxW7F0Yaf5qCpWNBMydX6FalbZzpEB+Ajky1/AywqXA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795624906;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=N4BgddI9Z5obqWb3chtaybnMpOKkuVnPPIoSJTL8cpE=;
	b=QgAQiRfIwcqwyoreE0TMid6AorYwc4I9xSx6+aQsnfsK7rS4VxXVCPcKn1wpG92sZVtD
	 jYbQzkaMzIDpddLUgvEiKEyzBk7uGetNQkd6IyVUFYGgBadKqYAHsS8J6UXfWDVdW7G25
	 uz6Vqib9xAtWq1OAe6b1BLe9xzwR+AonpMGfWkdWDTu1kNtgd1iN7K3/UKguRIcdSo2V8
	 8Ia6sCfM7CZn9sK/ZipdVQsOiHxGoMZGVNatsjOB0AYvrJHH5gCmzeCokvSyOECQ3VWvh
	 WtiJEPcn9bYnTHS7OW9QbCbx2Kyd6I5nUF9Gl9AdVVyvtX3ZGU9WWmfRaUV1jy2dQYg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pNMa2Vn1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E0A1606A32E;
	Wed, 25 Nov 2026 16:41:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pNMa2Vn1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAB531F000F2;
	Wed, 25 Nov 2026 16:41:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795624906;
	bh=N4BgddI9Z5obqWb3chtaybnMpOKkuVnPPIoSJTL8cpE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pNMa2Vn1u/5VsTOubslmDibYSZUmQ9WlWudf2HF1ru9DaD84PEoVEbqWujx9IXXFS
	 JeiiE+g6S8M8TwBcNpQmMayPiCSrebpHymPED3fCnAgYxBdnF6Jtbx6U/uEMM+yris
	 EdkcRYusGP3HqbHC1skWsVqajAksBtCyzaTHc3mM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Mason <mason@kernel.org>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 344/816] tcp: Drop any segments if DEFER_CONNECT is set.
Date: Wed, 25 Nov 2026 15:31:32 +0100
Message-ID: <20261125143857.160231400@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chris Mason <mason@kernel.org>

[ Upstream commit 44809e49177992b15708a150437d9aebc5beea9c ]

TCP Fast Open lets a client send data in its SYN. With
TCP_FASTOPEN_CONNECT and a cached Fast Open cookie, which the server
sent in the SYN-ACK of an earlier connection, the connection is set up
in two steps:

- connect() sends nothing, so that the SYN can carry the data of the
  first write(). It only sets DEFER_CONNECT and inserts the socket into
  the hash table in SYN_SENT.
- The first write() calls tcp_connect(), which runs tcp_connect_init()
  and sends the SYN.

A socket must not accept any segment before it has sent its SYN. But
nothing on the receive path checks DEFER_CONNECT. So until the write(),
the half-initialised socket processes segments like any socket in
SYN_SENT, and a forged SYN is accepted.

Similarly, ICMP with seq matching ISN is accepted in the state.
Before commit 57889a8f6d49 ("tcp: initialize send sequence numbers
before deferring TFO"), even seq 0 message was accepted.

Drop any segments if DEFER_CONNECT is set.

Fixes: 19f6d3f3c842 ("net/tcp-fastopen: Add new API support")
Signed-off-by: Chris Mason <mason@kernel.org>
[kuniyu: revised DEFER_CONNECT tests and the commit message]
Signed-off-by: Kuniyuki Iwashima <kuniyu@google.com>
Link: https://patch.msgid.link/20261107235720.3129212-3-kuniyu@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/tcp_input.c | 9 +++++++++
 net/ipv4/tcp_ipv4.c  | 2 +-
 net/ipv6/tcp_ipv6.c  | 2 +-
 3 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index 547adefba7ea9..eb8f824254866 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -6832,6 +6832,15 @@ tcp_rcv_state_process(struct sock *sk, struct sk_buff *skb)
 		goto discard;
 
 	case TCP_SYN_SENT:
+		/* We sent nothing yet, so no segment belongs to this connection.
+		 * Send no RST: it would be built from this socket, whose TCP-AO
+		 * keys are not set up either.
+		 */
+		if (unlikely(inet_test_bit(DEFER_CONNECT, sk))) {
+			SKB_DR_SET(reason, NOT_SPECIFIED);
+			goto discard;
+		}
+
 		tp->rx_opt.saw_tstamp = 0;
 		tcp_mstamp_refresh(tp);
 		queued = tcp_rcv_synsent_state_process(sk, skb, th);
diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index 4d1b3c4602a36..293a3b2bdd9e3 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -539,7 +539,7 @@ int tcp_v4_err(struct sk_buff *skb, u32 info)
 		if (!(type == ICMP_DEST_UNREACH && code == ICMP_FRAG_NEEDED))
 			__NET_INC_STATS(net, LINUX_MIB_LOCKDROPPEDICMPS);
 	}
-	if (sk->sk_state == TCP_CLOSE)
+	if (sk->sk_state == TCP_CLOSE || inet_test_bit(DEFER_CONNECT, sk))
 		goto out;
 
 	if (static_branch_unlikely(&ip4_min_ttl)) {
diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
index 431d958272b8d..d8d3a688c0104 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -418,7 +418,7 @@ static int tcp_v6_err(struct sk_buff *skb, struct inet6_skb_parm *opt,
 	if (sock_owned_by_user(sk) && type != ICMPV6_PKT_TOOBIG)
 		__NET_INC_STATS(net, LINUX_MIB_LOCKDROPPEDICMPS);
 
-	if (sk->sk_state == TCP_CLOSE)
+	if (sk->sk_state == TCP_CLOSE || inet_test_bit(DEFER_CONNECT, sk))
 		goto out;
 
 	if (static_branch_unlikely(&ip6_min_hopcount)) {
-- 
2.53.0



