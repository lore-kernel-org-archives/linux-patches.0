Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA8673F8EBE;
	Mon, 17 Aug 2026 15:23:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786980210; cv=none; b=WsbkFTH9wMZariB0NCZsabma3WMJAkX1TF2rBwBbFbE75cbVm0qVMV51pO/wVtuOFYwhl8X7sEJNEBFZ+pmpAvh/6Gl/vi340gtUJDp3ZQ19M4CXfj73vbC5HM1JWxrh/xDLwL0vq1rpO3lF3nVABgQMS5YXSIbSFWKwDWG5PhA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786980210; c=relaxed/simple;
	bh=4xoq7hIa46LOOLmIFIPF8t7cIjxw8OafJuyKtJaZJ1U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A3DxMtMkTQTOJ9cihJRMI6hXB2orTB/F10+C31v388JqGOYyejKWbzYyz1mmwTpIII8hl2OtstmjdYBgg7hr/cxqVRTVP/18b4aZqpyq6DwNsgRlem+en3duif4/2r65vXkkmRAPHbKw48s+dHDjB/M6Ex+LlL0dUCRYGjZvZeQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LBDYwL6k; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LBDYwL6k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E99A91F000E9;
	Mon, 17 Aug 2026 15:23:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786980208;
	bh=Yr5Goeanhp4/SUgmY3YESwdqsy+7tfPTHkNp1VUTya4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LBDYwL6kCKAjCBuUjGylSiNNdYDeQC+9TaqbBP71A74yzgQH0rlye0pPBcvrUw0D8
	 sBT6q61bT89tItfBbyfMlKc1NS9BBts2UL6OYY2ypigCe9Dnx4rGfEDdWt8kdbc6N6
	 9EZI/pD0sablL++NoWFD7xA4XvLHGXVSzswlcs9Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Julian Anastasov <ja@ssi.bg>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 494/609] ipvs: return the csum validation for forward hook
Date: Mon, 17 Aug 2026 15:33:10 +0200
Message-ID: <20260817132600.437017671@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132543.039278408@linuxfoundation.org>
References: <20260817132543.039278408@linuxfoundation.org>
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
index 876852c2d37f5..6df46a7a4f976 100644
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
@@ -1610,30 +1608,23 @@ static inline __wsum ip_vs_check_diff2(__be16 old, __be16 new, __wsum oldsum)
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



