Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B05C47141D;
	Fri,  9 Oct 2026 14:30:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791556250; cv=none; b=gRl5Nh1sNnBtKOIGdFvt7WM0BtrxfLJUTb6LO2cC11wGk4ngTPzmjMEV2XbaLRqxqCh6zSkCvzjUmT7jr50/Ltj+l2yyAZPe0eVNab/BXR0TIMD0FiTpaisuKVLo7ghsU0sKTg5HftsaOBEWYkqVUeZ+IddOfiowoHr5iiqZy9Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791556250; c=relaxed/simple;
	bh=GiSCP/T6UIhUKdP6EDfgmhgG2Q65id7VsBJUdwrkrfc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ID5YF46/9rHvawBBjJrLqMpJiCleh4w+4MgoijJCHnVjL6O98YA62WNQ3OY7LSg4KJgOPhKy06a9QnBV05nWcWnnbMeTs7F/lQxtVWK65yD2Flr94xOxD97X4luJFze3ZaVDP91mR41T8oX/DfPbIEktFSDLMZdQ2GN1KPUiQ8o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=q6cMVP0b; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q6cMVP0b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 840411F00893;
	Fri,  9 Oct 2026 14:30:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791556249;
	bh=XwRGIfsUKxDEseg/e/AlaPOVEEdmVmKAi4ueGH6vetM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=q6cMVP0bRZ/2Eus7qFxgOWjk1MRQXVsp7UFHaciFMk3/AnG5w/SepXYP8w3roCM1y
	 NYXT6Jv6QprtV8VKBUZXTD7EH/A5cmcKyfn283sIuHOzI7Vrbl1Ih8twsmULB+ZFg2
	 /g4gDN+6CR1V1Z1jkYsSpJ7eEBSaN9RfrdpSp6RI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Julian Anastasov <ja@ssi.bg>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 146/428] ipvs: fix missing counter decrement in lblc
Date: Fri,  9 Oct 2026 16:08:03 +0200
Message-ID: <20261009140949.379172685@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140946.008206689@linuxfoundation.org>
References: <20261009140946.008206689@linuxfoundation.org>
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
index 8180a7ba9f538..55af77a569292 100644
--- a/net/netfilter/ipvs/ip_vs_lblc.c
+++ b/net/netfilter/ipvs/ip_vs_lblc.c
@@ -203,6 +203,7 @@ ip_vs_lblc_new(struct ip_vs_lblc_table *tbl, const union nf_inet_addr *daddr,
 		if (en->dest == dest)
 			return en;
 		ip_vs_lblc_del(en);
+		atomic_dec(&tbl->entries);
 	}
 	if (atomic_read(&tbl->entries) >= tbl->max_size * 3 / 2)
 		return NULL;
-- 
2.53.0



