Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F6703C4551;
	Wed, 30 Sep 2026 19:09:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790795383; cv=none; b=F9of9zao0gupWVPGJxFsvaujyYcQfoUeepZpwv3/8qVXltvVaaqEMv4MtoQ4EIfBZka19MaAsnM449fgq1UE3ffDtkUhCpEk/PXnxISexbxrK/7PJg7IbjMmWD/fljdruOaxLhB/eXKFqqIyO8LqQWjhXthAXmx2v0Xbwd7sHqs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790795383; c=relaxed/simple;
	bh=hMfhcfxRNn6oGAe95/y4sw6jyqIuG9W7ui6PDAvgrvU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F3n43e4zhSPWkqD8kRqodZ0S6SOK5bV91IUEns8xoaZBPHdlVCHWzjAv3w2YbtV9HVpYIdq3O3dzQwCG/UCCoHeEXhE5+bdxobm2OXEkO+P7qh7mnGJSJcwb9GjdSugXjspUuVcRz0VJJ7dYibqmS/5919ZDwvOiyC5Sesggai4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rxDCGVc5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rxDCGVc5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 651041F000FF;
	Wed, 30 Sep 2026 19:09:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790795382;
	bh=4YMmJkfBVbQtPHHNvHAN986+B2vv9z3tMBIFex2OgEM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rxDCGVc5KlzpVgaAd6tD5Bj+eBny88Fn7oZ5kZpM+B0ql9R6z7/J9oqDVC43nMGuv
	 hmZ3i9ufMLQcwgnqEVUXupEKCN74eWA+6rhErkO32oqqYDmUcgmNeNfOM7P5yoD4Zs
	 mzEapzve3r7IBkWTZbBd2T0KVyVa1Y0s+QX74NhQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alice Mikityanska <alice@isovalent.com>,
	Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
	Willem de Bruijn <willemb@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0542/1193] net: ipv6: Clamp to IP6_MAX_MTU in ip6_dst_mtu_maybe_forward
Date: Wed, 30 Sep 2026 17:20:26 +0200
Message-ID: <20260930152446.268127115@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alice Mikityanska <alice@isovalent.com>

[ Upstream commit 199271ebc71c1e0913b2fad988a7bff330a8828a ]

Commit 427faee167bc ("net: ipv6: introduce ip6_dst_mtu_maybe_forward")
dropped the IP6_MAX_MTU clamp that used to be present in ip6_mtu(). A
similar IPv4 commit ac6627a28dbf ("net: ipv4: Consolidate ipv4_mtu and
ip_dst_mtu_maybe_forward") preserves the IP_MAX_MTU clamp.

Restore the upper bound in the IPv6 flow to avoid potential 16-bit
overflows in forwarding paths.

Fixes: 427faee167bc ("net: ipv6: introduce ip6_dst_mtu_maybe_forward")
Signed-off-by: Alice Mikityanska <alice@isovalent.com>
Suggested-by: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Reviewed-by: Willem de Bruijn <willemb@google.com>
Link: https://patch.msgid.link/20260901195714.673548-5-alice.kernel@fastmail.im
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/ip6_route.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/net/ip6_route.h b/include/net/ip6_route.h
index 392232fcd703c..211d1ef8ab421 100644
--- a/include/net/ip6_route.h
+++ b/include/net/ip6_route.h
@@ -339,6 +339,8 @@ static inline unsigned int ip6_dst_mtu_maybe_forward(const struct dst_entry *dst
 	rcu_read_unlock();
 
 out:
+	mtu = min_t(unsigned int, mtu, IP6_MAX_MTU);
+
 	return mtu - lwtunnel_headroom(dst->lwtstate, mtu);
 }
 
-- 
2.53.0



