Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DEA42E540C;
	Tue,  8 Jul 2025 16:52:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751993558; cv=none; b=JtJj8+FSkxMHrbM9I90+ab5YzcPsDm2vFWDkt79PzrdQXKBk4PgXkMeLJQJm2dmXLxjNMTS8gj/Xx89K0Mb3wcGFVWmipW6KiaGw6V6iGqt0v0ItmjVk6KniJ3EMlMu90XGAboeHImq1XFNVbTtt/zeA6TAu1Qb4q2aS/PUZrFI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751993558; c=relaxed/simple;
	bh=gcLVMj5mOuNRjMl5EImKVCQyCrcDDpfweLz24J7Si3g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Sq7pmApOsPBJeqjzgCb4s2mJ54XCUwI9k5eviqmyvTMK8osqX/JLanpQUuINRFmAX0U36E8f2U0KzRfIW/4d6Ul1tcvRWY/OJyxkZkE+2LQzJ8uY5Z9IVBF+b1gwavndmjZ248fEwyF2Mytoz+18CXFUm9TO1gRKrsGVe6xMVIo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vNoCDFxS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vNoCDFxS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7AB7C4CEF0;
	Tue,  8 Jul 2025 16:52:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751993558;
	bh=gcLVMj5mOuNRjMl5EImKVCQyCrcDDpfweLz24J7Si3g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vNoCDFxSP1rhxi5cQgVYcLI8gwUX5EwMdTS5huuatxCabacRG7BjEfFZdRuNneHn0
	 /IDaeOccoHC8m9pFHnpgJC2OYsFlVHpVUqs09YZErSQPvWf4HWXjZj0RdQorc++dLt
	 lC1CWgVJEjqRE50QIAGFMW85JtkcdS6QJqUNZs+k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Menglong Dong <menglong8.dong@gmail.com>,
	Sabrina Dubroca <sd@queasysnail.net>,
	Antoine Tenart <atenart@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 116/178] net: ipv4: fix stat increase when udp early demux drops the packet
Date: Tue,  8 Jul 2025 18:22:33 +0200
Message-ID: <20250708162239.646769480@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162236.549307806@linuxfoundation.org>
References: <20250708162236.549307806@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Antoine Tenart <atenart@kernel.org>

[ Upstream commit c2a2ff6b4db55647575260bf2227b0e09d46addb ]

udp_v4_early_demux now returns drop reasons as it either returns 0 or
ip_mc_validate_source, which returns itself a drop reason. However its
use was not converted in ip_rcv_finish_core and the drop reason is
ignored, leading to potentially skipping increasing LINUX_MIB_IPRPFILTER
if the drop reason is SKB_DROP_REASON_IP_RPFILTER.

This is a fix and we're not converting udp_v4_early_demux to explicitly
return a drop reason to ease backports; this can be done as a follow-up.

Fixes: d46f827016d8 ("net: ip: make ip_mc_validate_source() return drop reason")
Cc: Menglong Dong <menglong8.dong@gmail.com>
Reported-by: Sabrina Dubroca <sd@queasysnail.net>
Signed-off-by: Antoine Tenart <atenart@kernel.org>
Reviewed-by: Sabrina Dubroca <sd@queasysnail.net>
Link: https://patch.msgid.link/20250701074935.144134-1-atenart@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/ip_input.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/net/ipv4/ip_input.c b/net/ipv4/ip_input.c
index 30a5e9460d006..5a49eb99e5c48 100644
--- a/net/ipv4/ip_input.c
+++ b/net/ipv4/ip_input.c
@@ -319,8 +319,8 @@ static int ip_rcv_finish_core(struct net *net,
 			      const struct sk_buff *hint)
 {
 	const struct iphdr *iph = ip_hdr(skb);
-	int err, drop_reason;
 	struct rtable *rt;
+	int drop_reason;
 
 	if (ip_can_use_hint(skb, iph, hint)) {
 		drop_reason = ip_route_use_hint(skb, iph->daddr, iph->saddr,
@@ -345,9 +345,10 @@ static int ip_rcv_finish_core(struct net *net,
 			break;
 		case IPPROTO_UDP:
 			if (READ_ONCE(net->ipv4.sysctl_udp_early_demux)) {
-				err = udp_v4_early_demux(skb);
-				if (unlikely(err))
+				drop_reason = udp_v4_early_demux(skb);
+				if (unlikely(drop_reason))
 					goto drop_error;
+				drop_reason = SKB_DROP_REASON_NOT_SPECIFIED;
 
 				/* must reload iph, skb->head might have changed */
 				iph = ip_hdr(skb);
-- 
2.39.5



