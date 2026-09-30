Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B3EC51C357;
	Wed, 30 Sep 2026 18:05:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790791529; cv=none; b=CMB3B+B6QdJHExnWmjAdfu4S/YQtFq1VsWz4/c4MvIEslv8NY2CNztYpFgb5CHtUYFdpHdAPMb9dZdPgG3zeVysTjSPwEbUOu1noLFIG4iYdAeyZ3RBGDaZaE3UA/EYH/nmSfGMzb0lx1fpZ0+s+6nMVXNsq+WQ8sz4antgAAS0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790791529; c=relaxed/simple;
	bh=GGBW7WJCkSE6s4UZnNwSn3QrGYshlsxa1Nb0SPt1OzY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qqDAllSvo8SFVqmXcEyfI7tz66rXY0PnlYR5m43yOXgtTZNdh/TA2Thisp/n+cZuf2xM2dwL84X8dAa9xrB1uA/YbGd6it6Dkfy9vjtXhLnds4J/+MdvyNBOTv//TptJ1pSaav2NXW8OwI9GW4W5XKjQ+XKe7Af40I9MPkS07ac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uUXYu0dH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uUXYu0dH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A85551F00899;
	Wed, 30 Sep 2026 18:05:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790791528;
	bh=+prN4IwSeB6z3DgvKgXSknJBHONpASIjQjZRPpiB2O4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uUXYu0dH7eWWcZb0HGrQgA2ZGXV2q0LeIziE4J19/d3XXfJxkx14AJRW+oa1TyIni
	 /0vzsHYcdGOycMia2b5J+s3TKi86zrt9JYnwB3APQSn2E2UT4lib6wfzAm4NWfhg+B
	 flR/4YfEOVoDqFteCDyHnbQfC5gMY1Hi0Gr0n4CE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alice Mikityanska <alice@isovalent.com>,
	Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
	Willem de Bruijn <willemb@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 335/752] net: ipv6: Clamp to IP6_MAX_MTU in ip6_dst_mtu_maybe_forward
Date: Wed, 30 Sep 2026 17:23:25 +0200
Message-ID: <20260930152405.541729234@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 5efd0b71dc673..1e54bd8a347ff 100644
--- a/include/net/ip6_route.h
+++ b/include/net/ip6_route.h
@@ -336,6 +336,8 @@ static inline unsigned int ip6_dst_mtu_maybe_forward(const struct dst_entry *dst
 	rcu_read_unlock();
 
 out:
+	mtu = min_t(unsigned int, mtu, IP6_MAX_MTU);
+
 	return mtu - lwtunnel_headroom(dst->lwtstate, mtu);
 }
 
-- 
2.53.0



