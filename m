Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62C5235C69B;
	Tue, 21 Jul 2026 21:29:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784669355; cv=none; b=my5PjUNAtGpEU4Bm+nhKE+CvNW4tOr3nkUQdjL+fyWleredtAPh0dp35UnkI9aULLIe/RxdVRtZcVn2zpow599NlnOpKRCF5eyHI2BYmkcwywrgxtspgeDOJnNYRhBViQndxUlm0+CHhfqmrINj34WsNVqCdFm2zdTPd6YiOmkI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784669355; c=relaxed/simple;
	bh=S+Reo7NnYoyEzaOW4bh1ZhW2hocpbwnNHyUR12ZO05c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r5UVcSxTxxfRYtC44gseLWaOsSQwnraDV3P9EFBSmhvPPM7ucnDzZSWUW1HRMVPYKDNf7u/tAwgniK00Uf0+UU4x64obASnDAKJ+B7yohnmNoGWtpVft855ItbzQkkjt5fsLsbF58fNlismOV7qN+eIBq4B2wg7Xif481qi5htc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0tLld6BB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0tLld6BB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3516A1F000E9;
	Tue, 21 Jul 2026 21:29:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784669350;
	bh=InlpSXNrpPf+xqsCpXy2FyBlZUxLMVTmJD3Mbcdoyko=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0tLld6BB/atv0ITkjAwgIPJHzOs5v3Yus+00VSLj6/G4UZMspSHA7ZMbqtfwcjRN/
	 oafyK+DxipOrSaSUZDS/GZXg5TOQ8jhZxA9QcuF+U3kUcBmxI4oIFD/SP11IB802fQ
	 KWdrD7QTUTVOCdla/FiyOv5IuIU3qHoRtolAwLYI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+ebdb22d461c904fc3cb2@syzkaller.appspotmail.com,
	Eric Dumazet <edumazet@google.com>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0468/1067] tcp: ipv6: clamp default adverting MSS to avoid GSO_BY_FRAGS (0xFFFF)
Date: Tue, 21 Jul 2026 17:17:49 +0200
Message-ID: <20260721152435.085479264@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 2b861eacee30e4..dde86722cc0399 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -3243,11 +3243,11 @@ static unsigned int ip6_default_advmss(const struct dst_entry *dst)
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



