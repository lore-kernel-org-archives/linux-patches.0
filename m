Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7EDD17AA6
	for <patches@lists.linux.dev>; Wed,  9 Aug 2023 11:27:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5793FC433C9;
	Wed,  9 Aug 2023 11:27:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691580474;
	bh=nKPRrR4j3xUPcaJc/bF7Yzy78Ho44KZhEBgYkFe0f3U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wgkbF/WTgYnOVK5IPBVxbO8L5wJdI4t7/XlyZQ04fUZku4W/+N43kZ77gZNvqGG1B
	 a1Krfqcd6fcwSfUyI5Fm4gzX6lcKfvuz1yeN1y04ifmma43mNeCrji36AB8sTtwek8
	 r5RH3Mzm8nb+PsXbO97a5YYLRv1AgD1klwimVhOM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stewart Smith <trawets@amazon.com>,
	Samuel Mendoza-Jonas <samjonas@amazon.com>,
	Eric Dumazet <edumazet@google.com>,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 037/154] tcp: Reduce chance of collisions in inet6_hashfn().
Date: Wed,  9 Aug 2023 12:41:08 +0200
Message-ID: <20230809103638.257528003@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230809103636.887175326@linuxfoundation.org>
References: <20230809103636.887175326@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Stewart Smith <trawets@amazon.com>

[ Upstream commit d11b0df7ddf1831f3e170972f43186dad520bfcc ]

For both IPv4 and IPv6 incoming TCP connections are tracked in a hash
table with a hash over the source & destination addresses and ports.
However, the IPv6 hash is insufficient and can lead to a high rate of
collisions.

The IPv6 hash used an XOR to fit everything into the 96 bits for the
fast jenkins hash, meaning it is possible for an external entity to
ensure the hash collides, thus falling back to a linear search in the
bucket, which is slow.

We take the approach of hash the full length of IPv6 address in
__ipv6_addr_jhash() so that all users can benefit from a more secure
version.

While this may look like it adds overhead, the reality of modern CPUs
means that this is unmeasurable in real world scenarios.

In simulating with llvm-mca, the increase in cycles for the hashing
code was ~16 cycles on Skylake (from a base of ~155), and an extra ~9
on Nehalem (base of ~173).

In commit dd6d2910c5e0 ("netfilter: conntrack: switch to siphash")
netfilter switched from a jenkins hash to a siphash, but even the faster
hsiphash is a more significant overhead (~20-30%) in some preliminary
testing.  So, in this patch, we keep to the more conservative approach to
ensure we don't add much overhead per SYN.

In testing, this results in a consistently even spread across the
connection buckets.  In both testing and real-world scenarios, we have
not found any measurable performance impact.

Fixes: 08dcdbf6a7b9 ("ipv6: use a stronger hash for tcp")
Signed-off-by: Stewart Smith <trawets@amazon.com>
Signed-off-by: Samuel Mendoza-Jonas <samjonas@amazon.com>
Suggested-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Link: https://lore.kernel.org/r/20230721222410.17914-1-kuniyu@amazon.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/ipv6.h | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/include/net/ipv6.h b/include/net/ipv6.h
index 0e031a4fef408..8c454509f299f 100644
--- a/include/net/ipv6.h
+++ b/include/net/ipv6.h
@@ -660,12 +660,8 @@ static inline u32 ipv6_addr_hash(const struct in6_addr *a)
 /* more secured version of ipv6_addr_hash() */
 static inline u32 __ipv6_addr_jhash(const struct in6_addr *a, const u32 initval)
 {
-	u32 v = (__force u32)a->s6_addr32[0] ^ (__force u32)a->s6_addr32[1];
-
-	return jhash_3words(v,
-			    (__force u32)a->s6_addr32[2],
-			    (__force u32)a->s6_addr32[3],
-			    initval);
+	return jhash2((__force const u32 *)a->s6_addr32,
+		      ARRAY_SIZE(a->s6_addr32), initval);
 }
 
 static inline bool ipv6_addr_loopback(const struct in6_addr *a)
-- 
2.39.2



