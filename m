Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E86993A7189;
	Sat, 17 Oct 2026 16:59:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792256387; cv=none; b=iL7FZA+XkBMOUSs9v7V08aG/r9d8lNWjYuOHAFPNm6+TE6jMn5wlM369PpCUZgc1OUn4fRLqIB6SUAhCP7RLwsr6ujeG/8XOva2E4GL7JM9TKjwBoB5Fpk0vXMJSe7PGHONpfsCSk50VHeNRCH2Vutbh4Wxrco4BU4Ln/2cnQE4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792256387; c=relaxed/simple;
	bh=9KUMZxd6A8+pNAspBzwmLSmufvylTs5Tfx81lQfsyU8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LZH8H3n6ZacsDXAkOdW3VNrDfMdegvBXw7SaVj0XGJz6ZarkIz2oWuK7NAH1CiNEFq67OX4wB10mjRh+jQJN6wSed5aNtOosADty1IR3t3GGf/emJwnhaTuQt/HdFu5wk9IMfOY9XJjImzzcrqHVil56v6wvmWhMoVivl2uirW8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SehnWVx9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SehnWVx9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 432751F000C4;
	Sat, 17 Oct 2026 16:59:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792256385;
	bh=oUjDLs0mZn8X4hgkRYQYutsxf0UNp0F7ksOQqlCaapo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SehnWVx9o0FOVav/Wj6jVbTKyqVqweTWnLnN1GzmL8Y14M8MTRmEN2ACbVb6J1AlN
	 xRGXW7KZCGhX0F5keBy1DB9ZkSbv5Bi2PiGyGIBYSkjCefPGb9LRme+7ooE50yTtJt
	 Q1DhdiJhNzaNaixm35wb4I9hFwHtwth+nT2SKeZo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Julian Anastasov <ja@ssi.bg>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0220/1674] ipvs: fix missing counter decrement in lblc
Date: Sat, 17 Oct 2026 17:41:32 +0200
Message-ID: <20261017160436.793357495@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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
index 70014c89955d6..521e68603d14e 100644
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



