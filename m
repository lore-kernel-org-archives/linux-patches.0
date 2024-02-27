Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFE072F2D;
	Tue, 27 Feb 2024 13:42:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709041377; cv=none; b=H73Z1Wm78jgkicEmRr19hdPhVLG8LZzhY3evZ0jN+EJaTJ6WJQ3OJUCGV6JNmqKRvbHnZpDra/ONfJV2HiURW+DSy1ZGlM39G66a3h+VJIUYwNwa4To7HFs+FN7CFoKV86hI5X5oKbIC4PER/0huUCherOXfMT4LevSMfNkeyX8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709041377; c=relaxed/simple;
	bh=5smB2m2nytr5Rvak5yPCm6Rj0SWeTJ5wFMpmyTdUwww=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LRPXsnuWpbYRMK0BL7JDBREqxM4KtaOGAyrtcHxMSZv8OuVLCB5xC3Nilw0QSaJbUxWsCfnx7HUlpG5jUz/9d9KFjBT1ST6HbkUDaRiSvVf3NhYVGOTDyfrMsuF2vuIPxeoaQWF59jDApvBNtsqZpXbwc/R+44sGnoTqA8sTUJE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=17VbT/Wr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="17VbT/Wr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 416A5C433C7;
	Tue, 27 Feb 2024 13:42:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709041377;
	bh=5smB2m2nytr5Rvak5yPCm6Rj0SWeTJ5wFMpmyTdUwww=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=17VbT/WrkUojxGJrj1iSrNjByLvm2TB38lo9uPiLeRtiV+GjR9IZKhViMvpEiSkTX
	 BjsSVVhe6aKQ4wYHJQbr5dvcN2TL1mKQdYDSRQfUZggJ4Fk0siY8Thv473MGFGXCjD
	 yJ9kqr9+Zlkv6qemY1OI6HXgkiidIPgpmeEa3NY4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paolo Abeni <pabeni@redhat.com>,
	Justin Iurman <justin.iurman@uliege.be>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 319/334] Fix write to cloned skb in ipv6_hop_ioam()
Date: Tue, 27 Feb 2024 14:22:57 +0100
Message-ID: <20240227131641.390800714@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131630.636392135@linuxfoundation.org>
References: <20240227131630.636392135@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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



