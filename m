Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA9AE1E98EC;
	Tue, 11 Mar 2025 15:38:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741707534; cv=none; b=AIsZtYVLxS2RnwzSYef0b7OTg9zCN2GlEnXcV0F5ZvXIUJyG8mE41FnNkjxnHnCLIpOrHa448ALsmVorWbZlrmi4e8EAo/gt6WO0AC/3s6A0xZA+3iYn42oyxAUjP9P+25vdxgim/lIIzebtfBRgefZfBBYX73hg2d+K15qBHu0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741707534; c=relaxed/simple;
	bh=b0VNiRAegLgF+QuH7dIVcZkl1wMqKOszlgnl2i08NQo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kW1u0qsc6JoB7f1XoC3Dp6f4Qh4o9gCaJj3dPh+ALU3+EitVaT09IRQxGk9seUlon1OzM87ddO37juiHi/4ouuVItoTr/G3jXQZ4Y0XQFPIy3KmYkUmWLtRNq0JnNgWQ/3PY1iPLRVA/xifmqyY72K9Byg44XK8lRUxAbSS9vwA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dVB/1Q0R; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dVB/1Q0R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42911C4CEE9;
	Tue, 11 Mar 2025 15:38:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741707534;
	bh=b0VNiRAegLgF+QuH7dIVcZkl1wMqKOszlgnl2i08NQo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dVB/1Q0Rkq0KiWI6g53eX39GfNEQVNhECWmE4iS9WQdsfyzCJM3FIN3r0Ju416KXy
	 agfEyQjDWyYs2FPdnDwEYDWAlsexleb3bhGPz3Nq9/BDJHEPZ8+QF3ZoM6GX1548rv
	 Vof6UXBNuA7J/TarZpz+zz+sNjnoOdTHRqwrAkPA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tom Herbert <tom@herbertland.com>,
	Justin Iurman <justin.iurman@uliege.be>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 422/462] net: ipv6: fix dst ref loop in ila lwtunnel
Date: Tue, 11 Mar 2025 16:01:28 +0100
Message-ID: <20250311145815.006485891@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145758.343076290@linuxfoundation.org>
References: <20250311145758.343076290@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Justin Iurman <justin.iurman@uliege.be>

[ Upstream commit 0e7633d7b95b67f1758aea19f8e85621c5f506a3 ]

This patch follows commit 92191dd10730 ("net: ipv6: fix dst ref loops in
rpl, seg6 and ioam6 lwtunnels") and, on a second thought, the same patch
is also needed for ila (even though the config that triggered the issue
was pathological, but still, we don't want that to happen).

Fixes: 79ff2fc31e0f ("ila: Cache a route to translated address")
Cc: Tom Herbert <tom@herbertland.com>
Signed-off-by: Justin Iurman <justin.iurman@uliege.be>
Link: https://patch.msgid.link/20250304181039.35951-1-justin.iurman@uliege.be
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/ila/ila_lwt.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/ipv6/ila/ila_lwt.c b/net/ipv6/ila/ila_lwt.c
index 9d37f7164e732..6d37dda3d26fc 100644
--- a/net/ipv6/ila/ila_lwt.c
+++ b/net/ipv6/ila/ila_lwt.c
@@ -88,7 +88,8 @@ static int ila_output(struct net *net, struct sock *sk, struct sk_buff *skb)
 			goto drop;
 		}
 
-		if (ilwt->connected) {
+		/* cache only if we don't create a dst reference loop */
+		if (ilwt->connected && orig_dst->lwtstate != dst->lwtstate) {
 			local_bh_disable();
 			dst_cache_set_ip6(&ilwt->dst_cache, dst, &fl6.saddr);
 			local_bh_enable();
-- 
2.39.5



