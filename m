Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063008;
	b=uaoNGuImSIcEKXRAD6v6mwPamCqTOgtn/EBsrdl5TcDdyfbRF8Sxjb1lK28AFPgXggoO
	 UYrfuLaaFK4Yk9/VlyzBykP6d/Tp0oumuJGW9l4gJQYpO5CSbavFGY6KW/lobIqfo4ldZ
	 IXXE3ZgrTPdXpOx9sgnPIlf57T5KWZFWn3INu4KjU9567nTHPZaMUGp6/tGnYxfulEbwW
	 xWWgvZX/sycb4GhkazgMIfzlSTRgRdc/9TWGfbNZfGCAE/tabgUJ1CfBhOD7w4IZ33GhI
	 bxkS54oil5MJobKOJRZLqxGC5kvtj6VwXoQGXcXOFyQIEFEoP7FCTshJEBWLyHn23DA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063008;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=9JcNI+UDUvb97IPM2bJTfEo1lSw5cwIruI6F6zA336s=;
	b=BbEPG9ro+3RI7iro/G4Grnm8LNfrPTCyyTZLgk+43kwoPLGrf4CBhVmOh9UayiK8lk7v
	 +nZKyKuWD+9Yel0kMwIDLwojkc7pQE+mI0fgzGW2pAOatjlsPvc5nSjHZ44FIbwm5nftA
	 dA3wgq8cYZLvvClCcr5JRezewBuO7fVQQOaP1H+jykiHDARqOby/LzBmgadMgW/XkLMYB
	 EqnAyu7Kla1vw2qXWVsOjYyB1csz1jPve1vkeC4sdSrYRwK0qApWYa3b0B7MDOTPdAVi7
	 oLJqoYtvTGGumrufUR5WCkslr3DrNe70z3xXWbYH2fF84PAhfFrAkDs7CNMn3U4Olqw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=g7hnNajj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A2C2606EE84;
	Sat,  7 Nov 2026 14:50:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=g7hnNajj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D24C11F008BE;
	Sat,  7 Nov 2026 14:50:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063008;
	bh=9JcNI+UDUvb97IPM2bJTfEo1lSw5cwIruI6F6zA336s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=g7hnNajjP4uppiA+5RyB+KXbASvgmiOncQ+GWlS0z9VKqdQgrYy2JSXNFeadrfFM6
	 D2vJl9AA1FAMPp9biV8UenmPhuTzfNPqCU8mSqMrPbZzgKRib4SNUQ6/De8+cmXQB7
	 ZE+N1VFSOoqe9rDtYnWZTJev0FRZmZy4uZQpMLvs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Piotr Kubik <piotr@kubik.pl>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 260/869] netfilter: ctnetlink: fix inverted IPv6 address match in dump filter
Date: Sat,  7 Nov 2026 08:49:02 -0500
Message-ID: <20261107134900.573706104@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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

From: Piotr Kubik <piotr@kubik.pl>

[ Upstream commit 1ae2d094b0200f687923298c0e42579273558988 ]

ctnetlink_filter_match_tuple() rejects an entry when
!ipv6_addr_cmp(filter, entry) is true. ipv6_addr_cmp() is a memcmp() and
returns 0 for equal addresses, so the condition is true exactly when the
addresses match: a CTA_FILTER dump with an IPv6 CTA_IP_SRC or CTA_IP_DST
skips every entry that matches the requested address and returns all the
others. The IPv4 branch compares with != and behaves correctly.

Observed with libnetfilter_conntrack NFCT_FILTER_DUMP_TUPLE: a dump
filtered on src 2001:db8::10 returned only the unrelated entries, and a
dump filtered on ::1 returned every entry except the ::1 ones.
conntrack-tools does not use the tuple filter for -L, which is why this
went unnoticed.

Use ipv6_addr_equal() so the IPv6 branch mirrors the IPv4 one.

Fixes: cb8aa9a3affb ("netfilter: ctnetlink: add kernel side filtering for dump")
Cc: stable@vger.kernel.org
Signed-off-by: Piotr Kubik <piotr@kubik.pl>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_conntrack_netlink.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index 6ccb23a640d85..0ff9da922c392 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -1098,13 +1098,13 @@ static int ctnetlink_filter_match_tuple(struct nf_conntrack_tuple *filter_tuple,
 		break;
 	case NFPROTO_IPV6:
 		if ((flags & CTA_FILTER_FLAG(CTA_IP_SRC)) &&
-		    !ipv6_addr_cmp(&filter_tuple->src.u3.in6,
-				   &ct_tuple->src.u3.in6))
+		    !ipv6_addr_equal(&filter_tuple->src.u3.in6,
+				     &ct_tuple->src.u3.in6))
 			return 0;
 
 		if ((flags & CTA_FILTER_FLAG(CTA_IP_DST)) &&
-		    !ipv6_addr_cmp(&filter_tuple->dst.u3.in6,
-				   &ct_tuple->dst.u3.in6))
+		    !ipv6_addr_equal(&filter_tuple->dst.u3.in6,
+				     &ct_tuple->dst.u3.in6))
 			return 0;
 		break;
 	}
-- 
2.53.0



