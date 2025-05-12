Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20C65299940;
	Mon, 12 May 2025 18:09:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747073344; cv=none; b=MZtI0D4FqODMx/+466Teq+cjCqdIiswyaGgpqTF6Shzw1JKA/O3swJA/8KPgL8Hke2Qsvy/IoJE7H0kR1TUYozLLMis7ovaxfRUKBKFURahlU455BHsuQW5pFO8wvR4CyMzvLuFNLMIxYr3kqoB51aIdTkAx7s6Qbl7ImsTMfOk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747073344; c=relaxed/simple;
	bh=cJHGxfSZLfXWvp6FM1STPzmvipVEAeJqmBHgBQrYkxc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NiT9tmeCUnZxqgIdlQFY6DCwU4SaPuHEv60h2o3rdcDbqBsAK0sHGMZv87s/IDhtzdlo1e7vfleWbHtdxKEWOUvfjc6+dyYXrt7BDturXJySfokD2P2e1CfCB1e9SoBcXdUWMNnLaJwJAgkPa9aKpEbSie0Kwru60wrkZY3Q8Dk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bZc77D1h; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bZc77D1h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5594C4CEE7;
	Mon, 12 May 2025 18:09:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747073344;
	bh=cJHGxfSZLfXWvp6FM1STPzmvipVEAeJqmBHgBQrYkxc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bZc77D1hBTDaqPnOeK+w2K4qLEguJ2JIUTIeOLd0kOSTsuKOjj9NAX9MYJAAoWbuO
	 DJ6ox7jqU/01trd1hxUogbZ3L+zdlHdKQgdzJi/8hXryurNGbnxU0Ye5xpTN4bl2+V
	 V4D0sVAA6m1g0z7hhiF2FodnlWcEiJS2i1CSjmsQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kota Toda <kota.toda@gmo-cybersecurity.com>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 018/113] netfilter: ipset: fix region locking in hash types
Date: Mon, 12 May 2025 19:45:07 +0200
Message-ID: <20250512172028.431171546@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250512172027.691520737@linuxfoundation.org>
References: <20250512172027.691520737@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jozsef Kadlecsik <kadlec@netfilter.org>

[ Upstream commit 8478a729c0462273188263136880480729e9efca ]

Region locking introduced in v5.6-rc4 contained three macros to handle
the region locks: ahash_bucket_start(), ahash_bucket_end() which gave
back the start and end hash bucket values belonging to a given region
lock and ahash_region() which should give back the region lock belonging
to a given hash bucket. The latter was incorrect which can lead to a
race condition between the garbage collector and adding new elements
when a hash type of set is defined with timeouts.

Fixes: f66ee0410b1c ("netfilter: ipset: Fix "INFO: rcu detected stall in hash_xxx" reports")
Reported-by: Kota Toda <kota.toda@gmo-cybersecurity.com>
Signed-off-by: Jozsef Kadlecsik <kadlec@netfilter.org>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/ipset/ip_set_hash_gen.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/ipset/ip_set_hash_gen.h b/net/netfilter/ipset/ip_set_hash_gen.h
index 20aad81fcad7e..c2d88b1b06b87 100644
--- a/net/netfilter/ipset/ip_set_hash_gen.h
+++ b/net/netfilter/ipset/ip_set_hash_gen.h
@@ -63,7 +63,7 @@ struct hbucket {
 #define ahash_sizeof_regions(htable_bits)		\
 	(ahash_numof_locks(htable_bits) * sizeof(struct ip_set_region))
 #define ahash_region(n, htable_bits)		\
-	((n) % ahash_numof_locks(htable_bits))
+	((n) / jhash_size(HTABLE_REGION_BITS))
 #define ahash_bucket_start(h,  htable_bits)	\
 	((htable_bits) < HTABLE_REGION_BITS ? 0	\
 		: (h) * jhash_size(HTABLE_REGION_BITS))
-- 
2.39.5



