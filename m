Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E1AC22D785;
	Mon,  2 Jun 2025 14:27:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748874477; cv=none; b=WzJH+Gz+Y40n/hqJbFpYqLwm0CDLsdryncfJ5GRuPylO2jgtfKUu82PIXbadPDYWai79O8CNaHYef2Nh11HbhwpjsCGxfmQqoLDKm6y9S0cJYjCnaWC4UE9OW8QLHMLJXENcac/YPLQ6zTJbVYJiL+ifddukms6nWX4C/MazJ2U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748874477; c=relaxed/simple;
	bh=4s02/fWQYgWsYC6g4p8jqGehKB/LbdxxD+AYKLM0cwY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y67BQl5NoYdGHON5SIm7ok7QEm8pWNfNymWXUtHYeNtWEzbURLc9uEzrPjOjo6453/eKguMESRLIwxDxWWatNE+KJXA8xqGuuYbEPYPbwltx9uw5zShoo2C4Ru044PygtL8E+xkW4B0udmhZA3q8DhXmmWu3bLFwz9lYtKSunwo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pYNpu6B+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pYNpu6B+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E035CC4CEF0;
	Mon,  2 Jun 2025 14:27:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748874477;
	bh=4s02/fWQYgWsYC6g4p8jqGehKB/LbdxxD+AYKLM0cwY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pYNpu6B+peNvjh+bQUsy1/jEkWJaMz96KoI0BnamrExgfo9ytdxNHPJqIok71Qpze
	 dxpBpKAwMwX54VJFEkIneyOowevzjoMLz4uQG+fPUzKccCJNFkvk1+xx39slXRYyS2
	 E4WoINtVHuzt2daMQOtydseexdOVVuiwuQ0YmOMY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kota Toda <kota.toda@gmo-cybersecurity.com>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 035/204] netfilter: ipset: fix region locking in hash types
Date: Mon,  2 Jun 2025 15:46:08 +0200
Message-ID: <20250602134257.057815014@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134255.449974357@linuxfoundation.org>
References: <20250602134255.449974357@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 30b8b3fad1500..297631f9717bc 100644
--- a/net/netfilter/ipset/ip_set_hash_gen.h
+++ b/net/netfilter/ipset/ip_set_hash_gen.h
@@ -88,7 +88,7 @@ struct hbucket {
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



