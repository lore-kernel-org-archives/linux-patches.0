Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C289C54BD4;
	Tue, 27 Feb 2024 14:00:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709042404; cv=none; b=bp9M9T69IedqYNlv5pdyhJz+riU+qJnUlw/L0l6MiV+4lBtfCiBv/JEpnK0iiZjPuxpPD+vcHdVf79gUzCj2/Cpj1aAdoOaQQMG58Ou65noN4g6i2mVVrGXe0+urRQzvI4aDDEF5HwUJKHNVNaaSsSUquG/vPOh3eGqezvol+/U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709042404; c=relaxed/simple;
	bh=kEtX4YFbh+05tN+vouklYy1AoKvgQ8Gc+AKgQJXlb4M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G57xkdnS522N2ONX444NjnRfQucH1jZfV7y5wpZa6PpOAXoqRlnoYhky1q2RluBznsIOLWo9qUCxThYkvwZE7hqRVtBoxDGO+e8mpOHx/qoEaZcBKeKgwGH6KoZqnO7rBbg49w0VSjB5NUSonY0myWBtqmVmjRPaKlxnrsjILk8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=y6cswFbh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="y6cswFbh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 531C6C433C7;
	Tue, 27 Feb 2024 14:00:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709042404;
	bh=kEtX4YFbh+05tN+vouklYy1AoKvgQ8Gc+AKgQJXlb4M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=y6cswFbhylY5JndIvj8DVf4XOl9Q8ptCGcpFumMo+a6scvFBfDt55p5Y0z/c71LGm
	 W+A/TklHbiU2QauZWBbN+CVzmdiw5w5vqJJwmpTydoX1kubHvhl4Z/zwg8PWEYZ99I
	 aVN/ROXf04q1E1JNWMv5wlBtNyL6Wrve7LBaSCpg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paolo Abeni <pabeni@redhat.com>,
	Justin Iurman <justin.iurman@uliege.be>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 284/299] Fix write to cloned skb in ipv6_hop_ioam()
Date: Tue, 27 Feb 2024 14:26:35 +0100
Message-ID: <20240227131634.817527902@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131625.847743063@linuxfoundation.org>
References: <20240227131625.847743063@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 4952ae7924505..02e9ffb63af19 100644
--- a/net/ipv6/exthdrs.c
+++ b/net/ipv6/exthdrs.c
@@ -177,6 +177,8 @@ static bool ip6_parse_tlv(bool hopbyhop,
 				case IPV6_TLV_IOAM:
 					if (!ipv6_hop_ioam(skb, off))
 						return false;
+
+					nh = skb_network_header(skb);
 					break;
 				case IPV6_TLV_JUMBO:
 					if (!ipv6_hop_jumbo(skb, off))
@@ -943,6 +945,14 @@ static bool ipv6_hop_ioam(struct sk_buff *skb, int optoff)
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



