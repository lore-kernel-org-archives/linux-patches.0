Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0676A34B1A6;
	Tue, 21 Jul 2026 22:42:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784673739; cv=none; b=pETxhfe1la+nne0F8V9U7jzTxLaD0M2oiV8SSAImpFt0mSUdzClpTruiaiDmDwzTXdvaVNZZACQLE9kQ7VokIXxMgbjguDy6SvJXBWG4KtYeZ62r42EuTPcKcHBmq6mBNQnunKVFpmhGpq1901ZYios4GGFx8Ddr8fKibiP+eK0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784673739; c=relaxed/simple;
	bh=frw5N3YG1i/7mAh43SqDZAY3TKlP0Zf22gYaQ3VUfiM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mzaQ60OH0WERo9E/dC+exqPqyGx3KMYGtEYT+qBgpW+CMUzDpUh8TD95viCD1cpnZz93olGtnANIHVnaCWop4s3BvL/XpFUT6J2Vk2jBJ4LERLsYdKnsIRVsmqQB1TY16SQSgNEOgfUNdQIlcReeOuX1dl0dJMUD4rdQpYJlVqQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kSkvXJdG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kSkvXJdG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CA7C1F000E9;
	Tue, 21 Jul 2026 22:42:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784673737;
	bh=JqvTfcoIoUxHLtuFzAE0mJ+CXngBn/REOW0IxRp9b5A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kSkvXJdG2Gg0InufEFKA5+GzWtvJLFI8bnOgZWTd7dhOGF01DbPBzjpcmFwxw0Hwm
	 qxQSPbzsoOd4sX1yep1Y2B4MahUPVeECyK9zjOgs7RXHuI4Hzlr6oSPNtoJFFK/WSU
	 R5A6LGMOquYP9sNRJLEsQb7OVEjJhazxo6UQ3EFA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+ebdb22d461c904fc3cb2@syzkaller.appspotmail.com,
	Eric Dumazet <edumazet@google.com>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 277/699] tcp: ipv6: clamp default adverting MSS to avoid GSO_BY_FRAGS (0xFFFF)
Date: Tue, 21 Jul 2026 17:20:36 +0200
Message-ID: <20260721152401.946316205@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152355.667394603@linuxfoundation.org>
References: <20260721152355.667394603@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 2bf43d0e2e6a27d52a7d624e2d6b9116972e8a22 ]

When MTU is large, ip6_default_advmss() can return IPV6_MAXPLEN (65535).
This is interpreted by TCP as mss_clamp, allowing the MSS to reach 65535.

However, 0xFFFF is also used as a magic value GSO_BY_FRAGS in the kernel.
If a TCP packet with gso_size=0xFFFF is passed to skb_segment(), it will
be mistakenly treated as GSO_BY_FRAGS, leading to a NULL pointer
dereference because local TCP packets do not use frag_list.

Fix this by returning min(IPV6_MAXPLEN, GSO_BY_FRAGS - 1) (65534) from
ip6_default_advmss() when MTU is large.

Also update the stale comment in ip6_default_advmss() which suggested
that IPV6_MAXPLEN is returned to mean "any MSS".

Fixes: 3953c46c3ac7 ("sk_buff: allow segmenting based on frag sizes")
Reported-by: syzbot+ebdb22d461c904fc3cb2@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/netdev/6a2c3193.8812e0fc.3c3fa4.0001.GAE@google.com/T/#u
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Kuniyuki Iwashima <kuniyu@google.com>
Link: https://patch.msgid.link/20260612162517.83394-1-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/route.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index 9726c5002dbdfc..039e1304b03136 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -3072,11 +3072,11 @@ static unsigned int ip6_default_advmss(const struct dst_entry *dst)
 	/*
 	 * Maximal non-jumbo IPv6 payload is IPV6_MAXPLEN and
 	 * corresponding MSS is IPV6_MAXPLEN - tcp_header_size.
-	 * IPV6_MAXPLEN is also valid and means: "any MSS,
-	 * rely only on pmtu discovery"
+	 * Limit the default MSS to GSO_BY_FRAGS - 1 to avoid
+	 * collision with the GSO_BY_FRAGS magic value (0xFFFF).
 	 */
 	if (mtu > IPV6_MAXPLEN - sizeof(struct tcphdr))
-		mtu = IPV6_MAXPLEN;
+		mtu = min_t(unsigned int, IPV6_MAXPLEN, GSO_BY_FRAGS - 1);
 	return mtu;
 }
 
-- 
2.53.0



