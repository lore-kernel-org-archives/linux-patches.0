Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062108;
	b=BTu8C/uEII4lw9BHmLLA4JYfJHzS7nZOMCUZ1WuUNP9rrpoUEAeknbPQ9n/90f0cp/ei
	 S+1p1arqWPoJyKPIvOWyuZk+BeTIxpzkvCZzoiEjofc+Q+IrfySMk/VVT6kv883bD+zAf
	 lxBl117jadLR+MbmOM3IfpP3+uMytDDKhGCtWGGJZNmN2UsEuImNen+sWHmlMi46IxeQh
	 A3dlOgOlfqJH7+qFM6v/tlsH1l9IFHzXGUJtxliG1OUhd+LXgXAVtyWkR/OQSEqio/GHN
	 FuuanjioTbrfnkqSEOmieFmI2INCTWhh2R1MTHQ6zVPs6SPNJqyNl3TN8zdw6ZD4PYA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062108;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=IcSZxLJ/GiDYIlmuB0V0ytBzxggfQuUUzCorSIwl7NY=;
	b=VVZXsNFryVTBf+n2/0BlnfBeAVReKwDzFT0W5qbj1jYZyzXEBq8c/sjdOKsiWMEXdj/Q
	 XrCChGXWQkwzd2lyWwnxWRNfTqe55t8oqaC01RHKlm46H2ZZ+nApcExVrwefahRbETbN6
	 FsAjspXPI+uEV7t9zB5V3WFUXcpRXVUzIBa32axSSlol/5pjcROCt5ucB8OwQoppHlt9e
	 Ef+NbwLX3pVxC/3nU/GwfdXo1Zh1ZlcJUj7APG9m5SkaOr3brq3iPIjluio68fjQoEftj
	 MP5tOGL6tRPSxnKY6zN3vw77259ncGBM3iXdhfGy6UEmceidxMFJFz3pyNnN68Jj6iw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VFulxYru;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92AA160A3821;
	Sat,  7 Nov 2026 14:35:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VFulxYru
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D36E1F008A5;
	Sat,  7 Nov 2026 14:35:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062108;
	bh=IcSZxLJ/GiDYIlmuB0V0ytBzxggfQuUUzCorSIwl7NY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VFulxYruvn2VwJUAMCLczd4yoYvlny6oa7hydsjaZ2Vc4qvF77XUOMnsRmFS5C2Jj
	 s5RcalLxhy6KKA0UQgdpRGxxStluwcTXIFWxnjuS+fO7bR5nya7Kx2pnQz030q/Do1
	 076RKLwQzlCr5qHt/YUPCtYZjsW1pxLZdetSqbz8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Piotr Kubik <piotr@kubik.pl>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1081/1536] netfilter: ctnetlink: fix inverted IPv6 address match in dump filter
Date: Sat,  7 Nov 2026 08:51:37 -0500
Message-ID: <20261107135028.059151390@linuxfoundation.org>
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
index 60a4fb4088963..a2431fee4c9b9 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -1074,13 +1074,13 @@ static int ctnetlink_filter_match_tuple(struct nf_conntrack_tuple *filter_tuple,
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



