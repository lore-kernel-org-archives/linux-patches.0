Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4F632F5B;
	Sat, 25 Oct 2025 16:11:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761408671; cv=none; b=k3qFWPobMpP+1l2ZOwF3ZEf+g911UH7WzYyVgRtKkp+cWDNuwhikfDJfl5Kj1XS8+VUV+BFAl6bGeBwkRXMiW99uLgyR8p6jXYVKcgY+1R5/Re2mzIqh/POjgIg+S6ReT8pk0upeeX19Ha9vIRoZM3LvwNaEE870RQrCs3T3JpQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761408671; c=relaxed/simple;
	bh=rALhKopiYWtHnleB6VpyBTdJO5JhkyCn+Qu3tZTmoYE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=q85zNryV5FfTcQMfEfoosj/7LKidBhx/psZ6m2qGlkQihlmIaj7HjOrY9HT0dqKf+1nO1VH8wtsy4TrkRgcLClCJJJ0oufKU2cdVWe5juEVlsNzObCxeeCGA528ZP+9ZftrRBMiDt34tknXuhjcaTCeKG6pe5x3muWQy99f0q3Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=L8qcLsol; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="L8qcLsol"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EF24C4CEFF;
	Sat, 25 Oct 2025 16:11:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761408671;
	bh=rALhKopiYWtHnleB6VpyBTdJO5JhkyCn+Qu3tZTmoYE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L8qcLsolmX+VnJU1EZ7d/GeHj6II+TeJV87WWbTaATyfw4wB51GKX5Wz6IRnLKZLJ
	 YTyK3dVlqR/WZkVz9DkW1LXuIhOfWgkWNGBR7b50mrRwgW/4MbPx60WgYxq+hxswqX
	 ssxuS07oCzk/zcytGkzcofbrdFlrsPxYmHqG2u+i36hRfaRM45N4N3kkwMbCxCO/if
	 sqEVFVf8USG/E06TwIpp+cHykYPKba+PPwK6KbmRvjzc6U3TzTa/W/wtW/Mho1+zrJ
	 XjUEXzad3Oq2eQs1VF+o2wNOhjO0fm6qAsQDtrxh1j4QHq0fGT5oZPJTui6L6ouccA
	 AfwqgE6OeScxg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Eric Dumazet <edumazet@google.com>,
	Willem de Bruijn <willemb@google.com>,
	David Ahern <dsahern@kernel.org>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>,
	davem@davemloft.net,
	willemdebruijn.kernel@gmail.com,
	netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 6.17-5.4] ipv6: np->rxpmtu race annotation
Date: Sat, 25 Oct 2025 11:54:28 -0400
Message-ID: <20251025160905.3857885-37-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251025160905.3857885-1-sashal@kernel.org>
References: <20251025160905.3857885-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.17.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 9fba1eb39e2f74d2002c5cbcf1d4435d37a4f752 ]

Add READ_ONCE() annotations because np->rxpmtu can be changed
while udpv6_recvmsg() and rawv6_recvmsg() read it.

Since this is a very rarely used feature, and that udpv6_recvmsg()
and rawv6_recvmsg() read np->rxopt anyway, change the test order
so that np->rxpmtu does not need to be in a hot cache line.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Willem de Bruijn <willemb@google.com>
Reviewed-by: David Ahern <dsahern@kernel.org>
Reviewed-by: Kuniyuki Iwashima <kuniyu@google.com>
Link: https://patch.msgid.link/20250916160951.541279-4-edumazet@google.com
Reviewed-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

YES
- `udpv6_recvmsg()` and `rawv6_recvmsg()` both dereference `np->rxpmtu`
  without synchronization even though writers update it via
  `xchg(&np->rxpmtu, skb)` in `ipv6_local_rxpmtu()`
  (`net/ipv6/datagram.c:415`) and clear it in other contexts; that
  unsupervised read is undefined behaviour under the kernel memory model
  and is caught by KCSAN. Annotating the load with `READ_ONCE()` at
  `net/ipv6/udp.c:483` and `net/ipv6/raw.c:448` guarantees an atomic,
  non-reordered fetch, eliminating the data race.
- The branch order swap (`np->rxopt.bits.rxpmtu` first) keeps the hot-
  path behaviour identical—both functions already consult
  `np->rxopt`—while avoiding an unnecessary cache-line touch of
  `np->rxpmtu` unless the option is enabled, so the risk of regression
  is negligible.
- Older stable kernels share this lockless pattern and therefore the
  same latent race, while the fix is self-contained (no new APIs, no
  dependency churn). Delivering accurate IPV6_PATHMTU notifications to
  user space is observable behaviour, so backporting this minimal
  annotation is justified for correctness on stable branches.

Natural next step: consider running an IPv6 UDP/RAW recv regression or
KCSAN sanity check once merged into stable to confirm the race no longer
fires.

 net/ipv6/raw.c | 2 +-
 net/ipv6/udp.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/ipv6/raw.c b/net/ipv6/raw.c
index 4c3f8245c40f1..eceef8af1355f 100644
--- a/net/ipv6/raw.c
+++ b/net/ipv6/raw.c
@@ -445,7 +445,7 @@ static int rawv6_recvmsg(struct sock *sk, struct msghdr *msg, size_t len,
 	if (flags & MSG_ERRQUEUE)
 		return ipv6_recv_error(sk, msg, len, addr_len);
 
-	if (np->rxpmtu && np->rxopt.bits.rxpmtu)
+	if (np->rxopt.bits.rxpmtu && READ_ONCE(np->rxpmtu))
 		return ipv6_recv_rxpmtu(sk, msg, len, addr_len);
 
 	skb = skb_recv_datagram(sk, flags, &err);
diff --git a/net/ipv6/udp.c b/net/ipv6/udp.c
index 6a68f77da44b5..7f53fcc82a9ec 100644
--- a/net/ipv6/udp.c
+++ b/net/ipv6/udp.c
@@ -479,7 +479,7 @@ int udpv6_recvmsg(struct sock *sk, struct msghdr *msg, size_t len,
 	if (flags & MSG_ERRQUEUE)
 		return ipv6_recv_error(sk, msg, len, addr_len);
 
-	if (np->rxpmtu && np->rxopt.bits.rxpmtu)
+	if (np->rxopt.bits.rxpmtu && READ_ONCE(np->rxpmtu))
 		return ipv6_recv_rxpmtu(sk, msg, len, addr_len);
 
 try_again:
-- 
2.51.0

