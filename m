Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793208590;
	b=UfCLYv+vBgTattlHWUsK9jA3gtYYikeNpa429/dSuZBTHFsTuL08D9G7ve/YlvBIub64
	 rM98yebX7kM6qdqIPd8L7BPXRVW1b3GpIIDk19b0xtUJnHvz56BiFnjnMUyHCo2BO2QrU
	 zw2XjXOcYU67QySkWbiRoogQFvPHGcez+uc5xMSXJwQKB96PmOfPhfT+adfl8c9PZfi9C
	 +wtEu6LE208mTzeiSWYxhEpcVv5rb7fFnfhMnhruLrfytMmLSXcvOm+4GiwHrB3JpmxpE
	 lEQvRNGaUOQcR7QYEWczdeSEqzhod3RttLJUYqjsdD9HSOrtDLZm9PRGLzZ2GMNIahA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793208590;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=UMLcuP/29Kv3gmTFf+j5iuw0fqjKXb1/jOR0zDig1ws=;
	b=cH2caetUuYP0eLYvzsEn72mUNjEKk7umK3HhSpCGEXK7FcAYrMFjZDcQp5a5wWHjCQHi
	 tQUOGCV8yAyMF/PEQn9gCXDVvb5RxFjh330b2BDzAnyjZUfv3gFidVZ/jg/alXqNSvEPV
	 QNndJ4ouWujUsBjm0f/RVWNKY4VveCzkuYAp/9Vt3gC48855OdPV+0tqftGBT1tIeJc/5
	 HW0dMC0SPkYzCZphd/21cDQz8Vx73GVM1wszoXHhg+29xA9QVit29c5YSBHr4s+US74jv
	 8EiJuBaWQjnQdyqnp24e4VKQVU4oRrsrr27huaf1X/QeGMP6oPmeQBodluXIZ9QZmwQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dBfm27HS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F0EC606A31A;
	Wed, 28 Oct 2026 17:29:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dBfm27HS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E227E1F01828;
	Wed, 28 Oct 2026 17:29:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793208590;
	bh=UMLcuP/29Kv3gmTFf+j5iuw0fqjKXb1/jOR0zDig1ws=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dBfm27HSENxnA67fa238I4t9AOCH7sc/TYvYSuHwYUuSAD7o8bpUk4ThJjc5F0wUe
	 sHCK9WK4WuEs8CKz2rsx2TVsCf+U9q7xMwOt5mw/vN6nFuJ2rgs+UI+Y2dYSHUXhVd
	 qq4WtUEQGRx7MQxfVM+oae3X3e1esIQAYIEQUEfI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Julian Anastasov <ja@ssi.bg>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 172/516] ipvs: fix missing counter decrement in lblc
Date: Wed, 28 Oct 2026 17:55:24 +0100
Message-ID: <20261028170007.581260171@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Julian Anastasov <ja@ssi.bg>

[ Upstream commit bdac17779f46817f60103baf09f0370546c3f023 ]

LBLC may delete cache entries for destinations that are
removed or overloaded and replace them with available ones.
But ip_vs_lblc_new() forgets to decrement the tbl->entries
counter after calling ip_vs_lblc_del(). This can lead to
increased shrinking of the cache with every new garbage
collection.

Fixes: 2f3d771a35fe ("ipvs: do not use dest after ip_vs_dest_put in LBLC")
Link: https://sashiko.dev/#/patchset/0bdd5abe9968ded7ca2b9cb6844ba83d94cc8d53.1787318053.git.zhilinz%40nebusec.ai
Signed-off-by: Julian Anastasov <ja@ssi.bg>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/ipvs/ip_vs_lblc.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/netfilter/ipvs/ip_vs_lblc.c b/net/netfilter/ipvs/ip_vs_lblc.c
index e2480f33a1963..9b0832f56f14e 100644
--- a/net/netfilter/ipvs/ip_vs_lblc.c
+++ b/net/netfilter/ipvs/ip_vs_lblc.c
@@ -205,6 +205,7 @@ ip_vs_lblc_new(struct ip_vs_lblc_table *tbl, const union nf_inet_addr *daddr,
 		if (en->dest == dest)
 			return en;
 		ip_vs_lblc_del(en);
+		atomic_dec(&tbl->entries);
 	}
 	en = kmalloc(sizeof(*en), GFP_ATOMIC);
 	if (!en)
-- 
2.53.0



