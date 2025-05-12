Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C02EE1A08CA;
	Mon, 12 May 2025 17:52:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747072355; cv=none; b=jkSJdZyw/3gtcRS5aa1V+TT9WpbbMuJcNuVL/eDCosZUSlouWQBU6GnMwTR+n+hsEa1oQbrXQPhZfc4vc157XdkF9gvYwV2aZpRKeBLWXrYm0ADuYeoOu1jarKwXR7Cxxy2tfixkCbR+nXZvQuKc6p2wyIqBN4i5VCXtrBdSXfg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747072355; c=relaxed/simple;
	bh=+Qgm1Botn39T1B9EL1Zioy9QwGI3sBrce52G4MYvdBs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oWlhmY1d/aehcHJxskD400mz5CqLMYy6SOiABc//WDRNNzVAbLmric7ENCTw3MFNHpzQidpLiUJsAvIHpfMzj4EfAxG4UrLi8RMSk9ncu4MjZhAcADuGMSzft2tKF4JSupBjX9sNKwTMvEN5bnLqNqRXXalNGIOdhfQAdEAS06w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=V7G705bR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V7G705bR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D3FEC4CEE7;
	Mon, 12 May 2025 17:52:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747072355;
	bh=+Qgm1Botn39T1B9EL1Zioy9QwGI3sBrce52G4MYvdBs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=V7G705bRZN6fRl4kpHJvcbwKXVJYIz3aib9c783FsbTnZ4R89pL8hWv6g+ftuZ+Ce
	 rl0LZjN1HLzZUJqRXAJkVYP7drGD2XYpFbRwUc7z6HHS7H/mCMCgiYiddavynz1OfO
	 k7+psvcbHe2UVB7PwE8s9UN2j7uZzifSt66Dr2ac=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kota Toda <kota.toda@gmo-cybersecurity.com>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 15/92] netfilter: ipset: fix region locking in hash types
Date: Mon, 12 May 2025 19:44:50 +0200
Message-ID: <20250512172023.745543583@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250512172023.126467649@linuxfoundation.org>
References: <20250512172023.126467649@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index ef04e556aadb4..0bd6bf46f05f3 100644
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



