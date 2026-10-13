Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2BEE4FC330;
	Tue, 13 Oct 2026 11:57:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791892667; cv=none; b=ei2sS9G8hB69klCcELbN/RRh7R/9iaB3oewqZi9UId22S6hmBRPw8eltbFLm4/HcutmeVSyQwCoup+PXifP2Io3yxy3IjBXX8TVugU1+gP00+hohhHgZmdoWobhdrIsnUVyqgkHOzIipFA382+BNhB1aGQBMX6VYBe6jCEWzziM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791892667; c=relaxed/simple;
	bh=jYTR2zlL4U3P+mjlv9oGVlgV+i0YMTsgRdukJIZVckw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cvmI3jmj7wb71q7K5YUloSHz+FWtWAfvhsR+o9hRKGHk2P7eH2vsF7q6zaClEmUqN+DZiwZ2ysIYtemoCfYFj94zRleybnzzX5FyFz6kS5MXc+AzPTm/zxPax08s5SZ/AL9aGPQKa3bnCxSrls4eD0y0/97Wx7o3PZw9mcHRbmo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dWP/tYnT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dWP/tYnT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAFC61F000FF;
	Tue, 13 Oct 2026 11:57:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791892666;
	bh=P3tINlEu87TTinjZDAkDp3EqMeNBi38bFd6m4rI/ayI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dWP/tYnTzcLDLr8UvH2DrFeCagoJr21Ldb73Oofoiwdp5zK2HNj4AlPn8DcN6HqcS
	 9r1oix4sIaQg0GfCi2X1EY0cjRa5YCRwJxotquJYH4q2JDdvIiajd2391mz8WVdvF8
	 VfZVsPcrt83MHaNlKjnNQ01uAieQoEkmoOU2oyOw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@kernel.org>,
	Willem de Bruijn <willemb@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 248/281] flow_dissector: avoid u16 truncation of skb->len when computing thoff
Date: Tue, 13 Oct 2026 13:39:24 +0200
Message-ID: <20261013112901.163497423@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112855.045212108@linuxfoundation.org>
References: <20261013112855.045212108@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@kernel.org>

[ Upstream commit 99bda1ecbd56905f8bd934b9cdccd3bd251192b1 ]

__skb_flow_dissect() computes key_control->thoff using:

  key_control->thoff = min_t(u16, nhoff, skb ? skb->len : hlen);

min_t(u16, ...) casts both arguments to u16 before comparing them.
Whenever skb->len (or hlen) modulo 65536 is smaller than nhoff, the
truncated length wins and thoff is set to a bogus small value, even
when the dissection succeeded. For example, an IPv4/TCP frame with
skb->len == 65540 and nhoff == 34 gets thoff == 4, so callers such as
skb_probe_transport_header() point the transport header inside the
Ethernet header.

Such skbs are not exotic:
- At the time of commit d0c081b49137 ("flow_dissector: properly cap
  thoff field"), AF_PACKET with PACKET_VNET_HDR could already build GSO
  skbs larger than 64KB (MTU checks are skipped for GSO, and
  alloc_skb_with_frags() accepted up to MAX_SKB_FRAGS (17) order-0
  pages on top of the linear part).
- BIG TCP now makes skbs larger than 64KB common.
- The following patch makes tun_get_user() dissect IFF_TAP frames
  before eth_type_trans() pulls the Ethernet header, so a GSO frame
  carrying a 65522..65535 byte L3 packet will be dissected with
  skb->len in [65536, 65549].

Compare as u32 instead. If the resulting offset cannot be represented
in the u16 key_control->thoff, cap it to U16_MAX and report the
dissection as failed rather than silently returning a wrong transport
offset. thoff is still set on failure, as some callers (such as
eth_get_headlen()) use it regardless of the return value.

Fixes: d0c081b49137 ("flow_dissector: properly cap thoff field")
Signed-off-by: Eric Dumazet <edumazet@kernel.org>
Reviewed-by: Willem de Bruijn <willemb@google.com>
Link: https://patch.msgid.link/20261001191140.2818991-2-edumazet@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/flow_dissector.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/net/core/flow_dissector.c b/net/core/flow_dissector.c
index 8aa4f9b4df810..27d8a01bc9230 100644
--- a/net/core/flow_dissector.c
+++ b/net/core/flow_dissector.c
@@ -1071,6 +1071,7 @@ bool __skb_flow_dissect(const struct net *net,
 	int mpls_lse = 0;
 	int num_hdrs = 0;
 	u8 ip_proto = 0;
+	u32 thoff;
 	bool ret;
 
 	if (!data) {
@@ -1692,7 +1693,13 @@ bool __skb_flow_dissect(const struct net *net,
 	ret = true;
 
 out:
-	key_control->thoff = min_t(u16, nhoff, skb ? skb->len : hlen);
+	thoff = min_t(u32, nhoff, skb ? skb->len : hlen);
+	if (unlikely(thoff > U16_MAX)) {
+		/* Cannot be represented in key_control->thoff. */
+		thoff = U16_MAX;
+		ret = false;
+	}
+	key_control->thoff = thoff;
 	key_basic->n_proto = proto;
 	key_basic->ip_proto = ip_proto;
 
-- 
2.53.0



