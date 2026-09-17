Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08754522EE4;
	Thu, 17 Sep 2026 17:25:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789665924; cv=none; b=d+7HqamZMmbRYALDJSvjSmiykZ/xoe0J1vYeTSjCSHku1ieirBSjJPDSM9tbrdjKT3JnA48nx09BDhOeugUqYpF2yI9ksGB0h0kgM4JHusYj1hR0nwWdIInRbaZsYGCJU/LohMI/x0+g8T+PLO0hbfdataWr2QvHW9OhaImK0PA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789665924; c=relaxed/simple;
	bh=KShLQ7rxuQUOo3swQXdfredMegxVyyeJvtAR12DZOnw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lM8lzr+ADaWcSLRTjCCzFzXDklv4zcbdsYrQPT86vRIMP9nP1h0OkroNWmdXTDxC08VSc8AvTKGxE2ViXohZ/yUYNcbe7AKy73zUoCgkyyviA50j8m0ZWkJRw18g+/QagJ90BhxBUvrK80YDiOwoxIdvtdHFJJaDZC/y7CVVrbM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ESNVl9i1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ESNVl9i1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EBDB1F00893;
	Thu, 17 Sep 2026 17:25:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789665922;
	bh=oeLrcaCsLfg3Nf24ervW0yCUp6U5v6PAYTyasw6+8Ck=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ESNVl9i1MjxtYGJuZTl1v7NR9nGXwoWLWvRv+ERxS1B/P3WMug+ZXpWrku4pgtYGY
	 t7XLPuhmx270uCpmam+yNKG8rvBOeJwMKSziXB3ScTmxJgyQJ8Iy4lgCxFiI2M56i7
	 JBzNnXwij5H8rnceO8+sMWSS9DCOZdC3jivUb9aA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alice Mikityanska <alice@isovalent.com>,
	Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
	Willem de Bruijn <willemb@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0866/1250] net: ipv6: Clamp to IP6_MAX_MTU in ip6_dst_mtu_maybe_forward
Date: Thu, 17 Sep 2026 16:11:01 +0100
Message-ID: <20260917151615.446936479@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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
index bcbd5eb1a0787..2e8ca123d1465 100644
--- a/include/net/ip6_route.h
+++ b/include/net/ip6_route.h
@@ -349,6 +349,8 @@ static inline unsigned int ip6_dst_mtu_maybe_forward(const struct dst_entry *dst
 	rcu_read_unlock();
 
 out:
+	mtu = min_t(unsigned int, mtu, IP6_MAX_MTU);
+
 	return mtu - lwtunnel_headroom(dst->lwtstate, mtu);
 }
 
-- 
2.53.0



