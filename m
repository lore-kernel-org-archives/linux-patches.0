Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CD0142254A;
	Mon, 17 Aug 2026 13:52:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786974755; cv=none; b=gTLb3NCd+Q28UqFz9tToo17B8DXiwsZxc3nc2j/p0nqkJBl/uJ0X8h8uycZ4XWhJQmGhsTiARAqscu+XuzIFAc0zBU1CqgQxWhOLDKCuci+p7cPRmDV1q3nqeFwhUE+IiyK6K5Env5VL9O5y/mSlEFHYYtVYc7JkKivsg7pT9RY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786974755; c=relaxed/simple;
	bh=Wm1HguL2+G2Ts7Fkj2I+YfRyGRUpEQc9L6FHt4rRqvQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S5YJsG8BHN4BJob33KCHPcrXr6uhPLpMAQasS/Pt2iMohKLEcRS5PM4sN5GEDRrVlDtCtaSYRe7CymJ2DUdp6sgCm1QPMF6GKTAFPQx5dSBA2nnVZcTQHNIPwsTCWuL2O8TODXDE8hFqR99nM9U57izNXfOzefPxFq1U9aOfGak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PIG/LKEm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PIG/LKEm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B7BB1F00A3A;
	Mon, 17 Aug 2026 13:52:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786974744;
	bh=Uqj0+JoBcm2BupG7GdSOtQY18E/bO0kVr/uZFxxw1bY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PIG/LKEmvT4cC4Lio5hFNd/ki1m4lD3pNzNsHrKQgR48Wdlz1XnmHd1szxeScK5A5
	 jYwSX4PsPO83Wfah5kxE7Xsk8y/4lc5fu7SboMB9muKKDPxLUnW/knLVaRefwKUoU9
	 xSgWwjpJLnkjuVgAxzqb+Bgpc/aFyQTWqBE6jWos=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Julian Anastasov <ja@ssi.bg>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 040/250] ipvs: return the csum validation for forward hook
Date: Mon, 17 Aug 2026 15:30:01 +0200
Message-ID: <20260817132538.091967566@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132536.466235697@linuxfoundation.org>
References: <20260817132536.466235697@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Julian Anastasov <ja@ssi.bg>

[ Upstream commit 99609cb0aa789c8d071050ce8579989551882cc6 ]

Sashiko notes that playing games with the skb dst and rt
flags instead of providing hooknum is not a good idea
when validating the checksums.

Also, skipping checksum validation for FORWARD packets
risk silent data corruption, even if the only user is
the FTP-CMD packets coming from the real server.

Sashiko also noticed that by using common checksum
helper in the previous commit we actually fixed old bug
where the TCP/UDP checksum for IPv6 on CHECKSUM_COMPLETE
was not validated correctly.

Fixes: e876b75b9020 ("ipvs: fix the checksum validations")
Link: https://sashiko.dev/#/patchset/20260722211420.153933-1-pablo%40netfilter.org
Link: https://sashiko.dev/#/patchset/20260727185024.67534-1-ja%40ssi.bg
Link: https://sashiko.dev/#/patchset/20260728202520.59179-1-ja%40ssi.bg
Signed-off-by: Julian Anastasov <ja@ssi.bg>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/ip_vs.h                   | 19 +++++--------------
 net/netfilter/ipvs/ip_vs_proto_sctp.c |  2 +-
 2 files changed, 6 insertions(+), 15 deletions(-)

diff --git a/include/net/ip_vs.h b/include/net/ip_vs.h
index cbad9c74a8868..d63d6459727d6 100644
--- a/include/net/ip_vs.h
+++ b/include/net/ip_vs.h
@@ -24,9 +24,7 @@
 #include <linux/netfilter.h>		/* for union nf_inet_addr */
 #include <linux/ip.h>
 #include <linux/ipv6.h>			/* for struct ipv6hdr */
-#include <net/route.h>
 #include <net/ipv6.h>
-#include <net/ip6_fib.h>
 #if IS_ENABLED(CONFIG_NF_CONNTRACK)
 #include <net/netfilter/nf_conntrack.h>
 #endif
@@ -1753,30 +1751,23 @@ static inline __wsum ip_vs_check_diff2(__be16 old, __be16 new, __wsum oldsum)
 	return csum_partial(diff, sizeof(diff), oldsum);
 }
 
-static inline bool ip_vs_checksum_needed(struct sk_buff *skb, int af)
+static inline bool ip_vs_checksum_needed(struct sk_buff *skb)
 {
 	/* Checksum unnecessary or already validated? */
 	if (skb_csum_unnecessary(skb))
 		return false;
-	/* LOCAL_OUT ? */
-	if (!skb->dev || skb->dev->flags & IFF_LOOPBACK)
+	/* Locally generated ? */
+	if (!skb->dev)
 		return false;
-	/* !LOCAL_IN (FORWARD) ? */
-	if (af == AF_INET6) {
-		if (!(dst_rt6_info(skb_dst(skb))->rt6i_flags & RTF_LOCAL))
-			return false;
-	} else {
-		if (!(skb_rtable(skb)->rt_flags & RTCF_LOCAL))
-			return false;
-	}
 	return true;
 }
 
 static inline bool ip_vs_checksum_common_check(struct sk_buff *skb,
 					       int offset, int proto, int af)
 {
-	if (!ip_vs_checksum_needed(skb, af))
+	if (!ip_vs_checksum_needed(skb))
 		return true;
+	/* Validate csum even for FORWARD */
 	return !nf_checksum(skb, NF_INET_LOCAL_IN, offset, proto, af);
 }
 
diff --git a/net/netfilter/ipvs/ip_vs_proto_sctp.c b/net/netfilter/ipvs/ip_vs_proto_sctp.c
index 3dbd3096e1637..c80567c73469b 100644
--- a/net/netfilter/ipvs/ip_vs_proto_sctp.c
+++ b/net/netfilter/ipvs/ip_vs_proto_sctp.c
@@ -193,7 +193,7 @@ sctp_csum_check(int af, struct sk_buff *skb, struct ip_vs_protocol *pp,
 	struct sctphdr *sh;
 	__le32 cmp, val;
 
-	if (!ip_vs_checksum_needed(skb, af))
+	if (!ip_vs_checksum_needed(skb))
 		return 1;
 	sh = (struct sctphdr *)(skb->data + sctphoff);
 	cmp = sh->checksum;
-- 
2.53.0



