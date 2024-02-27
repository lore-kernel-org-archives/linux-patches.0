Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 328B113B2B4;
	Tue, 27 Feb 2024 14:20:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709043640; cv=none; b=MR740hBeZmw0DslvNn89HAbUXWwPmwKL+/gFpPT5cCWZMp0Fv4HP7wcUQzNo3DbMV54V857X8Mv3+EkuSi9Zd4xcByYhLXrrGhrWxXRd15PnuVvIWvf2/MgO7OYf0gFxzxg+vWrJnQkYHj8/5BO75SMdnOH0FobzwzSKAoolj6s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709043640; c=relaxed/simple;
	bh=hZvLR11v3N90bIqQ1tV4h1kVhTGIcoUJaaDdGybD6b4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GpTt+MwCCE+3KqsYjz4ivVBoFuTWXqQVbawwkn7EhGQKTlKdpsHAtNcHS75SWJgK8QdwQvFyKRgjswRC77OXCN/18Q/erNJ8VimIy8fWS4kw4Rg/tdRNHJMqVv5hUEtTX5aW12i1M7fWdLHS5WxFPn6s0cfAGjkJLrdjX2iqblM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lrEUqUe+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lrEUqUe+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B706C433F1;
	Tue, 27 Feb 2024 14:20:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709043638;
	bh=hZvLR11v3N90bIqQ1tV4h1kVhTGIcoUJaaDdGybD6b4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lrEUqUe+uQ6pvrG5a7y32nvt5G5jHi8TLR25Vm/zKr05CTb6cHIPfRH4R63lClhm1
	 Yh75U9bgPYUUPvvDDYES7SiC2SUDY04LTERED2yGModKx9Ij67xnKWUzhozx5t8WSO
	 qmxe5Mtsxi1PpZaHezNCE0tS4PlDIec++ZJiNjV4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paolo Abeni <pabeni@redhat.com>,
	Justin Iurman <justin.iurman@uliege.be>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 180/195] Fix write to cloned skb in ipv6_hop_ioam()
Date: Tue, 27 Feb 2024 14:27:21 +0100
Message-ID: <20240227131616.346583875@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131610.391465389@linuxfoundation.org>
References: <20240227131610.391465389@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Justin Iurman <justin.iurman@uliege.be>

[ Upstream commit f198d933c2e4f8f89e0620fbaf1ea7eac384a0eb ]

ioam6_fill_trace_data() writes inside the skb payload without ensuring
it's writeable (e.g., not cloned). This function is called both from the
input and output path. The output path (ioam6_iptunnel) already does the
check. This commit provides a fix for the input path, inside
ipv6_hop_ioam(). It also updates ip6_parse_tlv() to refresh the network
header pointer ("nh") when returning from ipv6_hop_ioam().

Fixes: 9ee11f0fff20 ("ipv6: ioam: Data plane support for Pre-allocated Trace")
Reported-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Justin Iurman <justin.iurman@uliege.be>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/exthdrs.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/net/ipv6/exthdrs.c b/net/ipv6/exthdrs.c
index 5fa0e37305d9d..1cfdd9d950123 100644
--- a/net/ipv6/exthdrs.c
+++ b/net/ipv6/exthdrs.c
@@ -180,6 +180,8 @@ static bool ip6_parse_tlv(bool hopbyhop,
 				case IPV6_TLV_IOAM:
 					if (!ipv6_hop_ioam(skb, off))
 						return false;
+
+					nh = skb_network_header(skb);
 					break;
 				case IPV6_TLV_JUMBO:
 					if (!ipv6_hop_jumbo(skb, off))
@@ -974,6 +976,14 @@ static bool ipv6_hop_ioam(struct sk_buff *skb, int optoff)
 		if (!skb_valid_dst(skb))
 			ip6_route_input(skb);
 
+		/* About to mangle packet header */
+		if (skb_ensure_writable(skb, optoff + 2 + hdr->opt_len))
+			goto drop;
+
+		/* Trace pointer may have changed */
+		trace = (struct ioam6_trace_hdr *)(skb_network_header(skb)
+						   + optoff + sizeof(*hdr));
+
 		ioam6_fill_trace_data(skb, ns, trace, true);
 		break;
 	default:
-- 
2.43.0



