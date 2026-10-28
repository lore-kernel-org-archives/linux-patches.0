Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793211010;
	b=D3Xu8TcTaNTnE3K2PIInTxc/S2j8LlKOoxQDY1TYOwtHUPrYUykdkDNap+bCsxGlhtAr
	 6TnzfZk1UuNA86scGIuNTjoeAjzOPRcJ8rL4JL8eZs80Fl5PZXy6aREIz9VUpGPsJGxpR
	 EgTXtOzBg2ZC1UxSlspCYVdYcwkehGt7L2Q+w/vXBNxf3GWbwIHQHpyFgt62FvyCBqfUZ
	 +RKXzbvyPV/9y3YyDAr5XXFOxef1t41+cZb6BeisMufkZxPxab3B9yjGwDtuGCsRWT3cM
	 0G7uPmYZAQLxiSFQHyVgSgWUqNHFOvYR9sPu4w4E2DA9YHG7GzWLzV7OCp9QCv2GwcQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793211010;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=hh5F9LnRU8UUTSG3jUz5LtiL2v/IaI3vWOcr92Jp/u0=;
	b=0xX7vxPfOWtpibS1PzlHEf3dEqVr6O1YlU81e7asMg0682BVCdmIUYH0zp9AFmAxOJ0g
	 pVQqMPN105Rd+RR1/ZxBzYT01zMSiRvgUR+9JmKAYGOYjQST00VgCuBCirVWP0K7wiQ1a
	 sQXsDuTADwyhgFJMtf4sv4XQO8iIQ5CMRQUZET55JwRvVy6NUVBhuP95X1XDRPViIp6Ui
	 iszMu42eIOXhNG8qVbDOBVZt9iTdyw3sTKW++POQx+Zf9GDgBaTeYPy3RAvp3GMjIsHy7
	 I50nLmkgg7iIKuyyjppUEE+QJeWDidwBMZttxX096mY0acBKc5gr6DIMZTo6ki8CabQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UiaNkfCi;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C896606A31D;
	Wed, 28 Oct 2026 18:10:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UiaNkfCi
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DCBE1F01825;
	Wed, 28 Oct 2026 18:10:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793211010;
	bh=hh5F9LnRU8UUTSG3jUz5LtiL2v/IaI3vWOcr92Jp/u0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UiaNkfCiQp75vu1l/epVw3tcHO3ynTr7rejNtmK/aBx4ZmkmbH4cARSvX3rOOiBFD
	 yM1Nzy0O/IlBdbo2KHRZuIGamDp9ZR5oQY3I2Xkmq4g8+lajkl1vUZkNLxrPwxQn4n
	 +c1khJJW5hChRiG88+8hm+8kP/0INb0aqqpZTzA8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Julian Anastasov <ja@ssi.bg>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 182/571] ipvs: fix missing counter decrement in lblc
Date: Wed, 28 Oct 2026 17:55:29 +0100
Message-ID: <20261028170012.331240994@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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



