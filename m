Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 224ED4EFFB8;
	Thu, 17 Sep 2026 15:42:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789659751; cv=none; b=Cn+Wsb4OAswOOZDOnQupoSDnJA2+mlqxeyN3O4gRVWvODy48k/MSs92Upeyqje2TiHFu90alxr4eTNtx53H52uQkeYppJxAyXk04IgMrqmFDQcxvij5pHpXmd0dZMv5s2cYw2n4KNJNdmjOPSh2NVnkqY03cQ0fzkBOKt4S5dYc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789659751; c=relaxed/simple;
	bh=Q3CcGhTzQ1ahR/M500i4w5W6XfyhzxLNKqP1+KhE8Tg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Bfzw1uAHmHjGionxAAZ4xTqOPTgY+TZt3zJ6CvkgtE6M4lM/GEPvqDT7JFD+JCvvYXXVXsfDVSr+Vmp7lmow7Y6OCTdCiPNDTFq2drKKuhtwrHQFegwgnsHTrW6yYhHw+B+DRlilXdxJ4ohldcMo0upkTYaa9hDqwrTnoxApnnw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vKGnS9zi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vKGnS9zi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4ACC81F00898;
	Thu, 17 Sep 2026 15:42:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789659743;
	bh=IWeWtN6+bADMexlZzhbjw8LyhlZTO5qquWhQ9wjzSBM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vKGnS9zilhiu6t9c4z5Fi+5+0J5AyiS9xW/ih735rO7CnlEBRkPKlEPS/1GuQ697c
	 G3EJl6J5IKdEzC4PcRK3ljUdMc9cCjhbAzHCK9g73jZHe1pmgRz9bMwspH03flT5AK
	 cc6RrtTAj1bvxnDAU0sqU2r1hHNMNzk0YGX/5H58=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alice Mikityanska <alice@isovalent.com>,
	Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
	Willem de Bruijn <willemb@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 358/733] net: ipv6: Clamp to IP6_MAX_MTU in ip6_dst_mtu_maybe_forward
Date: Thu, 17 Sep 2026 16:11:06 +0100
Message-ID: <20260917151400.516013417@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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
index ac1acc0b74368..745ab62154ace 100644
--- a/include/net/ip6_route.h
+++ b/include/net/ip6_route.h
@@ -382,6 +382,8 @@ static inline unsigned int ip6_dst_mtu_maybe_forward(const struct dst_entry *dst
 	rcu_read_unlock();
 
 out:
+	mtu = min_t(unsigned int, mtu, IP6_MAX_MTU);
+
 	return mtu - lwtunnel_headroom(dst->lwtstate, mtu);
 }
 
-- 
2.53.0



