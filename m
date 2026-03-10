Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D6893876A6;
	Tue, 10 Mar 2026 11:14:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773141255; cv=none; b=r6MqvsVkIcU9wvkk8FX1N60Xh9W3EITsAmkv/ZBj0C2eNqvXtjJfouSwRaMY5En2RnkQWl76HIq+CncDP2Bz5GLBhFxzYBPANfa9lzwZa/mei4yBI4UB3OmFsaEjlzk+QQJUa78eGhf5WoePfCU/DADHl8znMnkJRjjdriMAWhs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773141255; c=relaxed/simple;
	bh=yiqSskYdBYclBEI0+luJvgBw/KexLwU0vERVhIzheas=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aSGPLX7gDiTtl9EcatLnuv5MnBTDupanH2P9TdyG5TQsRhhPr3ceOS+Im8ZhqTlfBCWzjcIUqyApwOF+D0XNogyZpPK1DJkkMPYn87CULvKPwaA2E8YJJw0MN1J1ltQczs50K3g9tUvkxHGRjrIkC5XHDUrT4n7G86blMsyvJQc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EAs6ugB1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EAs6ugB1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49C04C2BC9E;
	Tue, 10 Mar 2026 11:14:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773141255;
	bh=yiqSskYdBYclBEI0+luJvgBw/KexLwU0vERVhIzheas=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EAs6ugB16hKv8sh/zjpOXL7FDj407XJzCH5BEEQQkeiqEATTuxkkgcRkpNdDwepPL
	 9/J6GbitNXukLlDztHgqBItqwaCVkeS0wIEttSPtsY/cKE2qVCYLmXtoKOX1Q4X7RA
	 7Uwc8JMsxpCCaVWtEzywjZftn2jcclKzNtEHNnwaTLrrqRIUYzelKcQThSKQIpE4Vq
	 qXPOWY5e/Jy2lKPnaG3zu1W0ZSOnTStLALUqXjTvP94i7K5Lb1KTQa0/gdV4TdBvVC
	 LgYNkyFYb/0VqfFknv7mVOQ9xNT3EakJgyg3CtTgvaKi9uCVIlG6nSK8AFOmdqhzQ/
	 UUVwkZPv4l6Qg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Yung Chih Su <yuuchihsu@gmail.com>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 257/311] net: ipv4: fix ARM64 alignment fault in multipath hash seed
Date: Tue, 10 Mar 2026 07:05:04 -0400
Message-ID: <c81feff8eb3ad7c0a852b146b2af5867d8148f27.1773140655.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773140654.git.sashal@kernel.org>
References: <cover.1773140654.git.sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Yung Chih Su <yuuchihsu@gmail.com>

[ Upstream commit 4ee7fa6cf78ff26d783d39e2949d14c4c1cd5e7f ]

`struct sysctl_fib_multipath_hash_seed` contains two u32 fields
(user_seed and mp_seed), making it an 8-byte structure with a 4-byte
alignment requirement.

In `fib_multipath_hash_from_keys()`, the code evaluates the entire
struct atomically via `READ_ONCE()`:

    mp_seed = READ_ONCE(net->ipv4.sysctl_fib_multipath_hash_seed).mp_seed;

While this silently works on GCC by falling back to unaligned regular
loads which the ARM64 kernel tolerates, it causes a fatal kernel panic
when compiled with Clang and LTO enabled.

Commit e35123d83ee3 ("arm64: lto: Strengthen READ_ONCE() to acquire
when CONFIG_LTO=y") strengthens `READ_ONCE()` to use Load-Acquire
instructions (`ldar` / `ldapr`) to prevent compiler reordering bugs
under Clang LTO. Since the macro evaluates the full 8-byte struct,
Clang emits a 64-bit `ldar` instruction. ARM64 architecture strictly
requires `ldar` to be naturally aligned, thus executing it on a 4-byte
aligned address triggers a strict Alignment Fault (FSC = 0x21).

Fix the read side by moving the `READ_ONCE()` directly to the `u32`
member, which emits a safe 32-bit `ldar Wn`.

Furthermore, Eric Dumazet pointed out that `WRITE_ONCE()` on the entire
struct in `proc_fib_multipath_hash_set_seed()` is also flawed. Analysis
shows that Clang splits this 8-byte write into two separate 32-bit
`str` instructions. While this avoids an alignment fault, it destroys
atomicity and exposes a tear-write vulnerability. Fix this by
explicitly splitting the write into two 32-bit `WRITE_ONCE()`
operations.

Finally, add the missing `READ_ONCE()` when reading `user_seed` in
`proc_fib_multipath_hash_seed()` to ensure proper pairing and
concurrency safety.

Fixes: 4ee2a8cace3f ("net: ipv4: Add a sysctl to set multipath hash seed")
Signed-off-by: Yung Chih Su <yuuchihsu@gmail.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Link: https://patch.msgid.link/20260302060247.7066-1-yuuchihsu@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/ip_fib.h       | 2 +-
 net/ipv4/sysctl_net_ipv4.c | 5 +++--
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/include/net/ip_fib.h b/include/net/ip_fib.h
index b4495c38e0a01..318593743b6e1 100644
--- a/include/net/ip_fib.h
+++ b/include/net/ip_fib.h
@@ -559,7 +559,7 @@ static inline u32 fib_multipath_hash_from_keys(const struct net *net,
 	siphash_aligned_key_t hash_key;
 	u32 mp_seed;
 
-	mp_seed = READ_ONCE(net->ipv4.sysctl_fib_multipath_hash_seed).mp_seed;
+	mp_seed = READ_ONCE(net->ipv4.sysctl_fib_multipath_hash_seed.mp_seed);
 	fib_multipath_hash_construct_key(&hash_key, mp_seed);
 
 	return flow_hash_from_keys_seed(keys, &hash_key);
diff --git a/net/ipv4/sysctl_net_ipv4.c b/net/ipv4/sysctl_net_ipv4.c
index a1a50a5c80dc1..a96875e32050a 100644
--- a/net/ipv4/sysctl_net_ipv4.c
+++ b/net/ipv4/sysctl_net_ipv4.c
@@ -486,7 +486,8 @@ static void proc_fib_multipath_hash_set_seed(struct net *net, u32 user_seed)
 			    proc_fib_multipath_hash_rand_seed),
 	};
 
-	WRITE_ONCE(net->ipv4.sysctl_fib_multipath_hash_seed, new);
+	WRITE_ONCE(net->ipv4.sysctl_fib_multipath_hash_seed.user_seed, new.user_seed);
+	WRITE_ONCE(net->ipv4.sysctl_fib_multipath_hash_seed.mp_seed, new.mp_seed);
 }
 
 static int proc_fib_multipath_hash_seed(const struct ctl_table *table, int write,
@@ -500,7 +501,7 @@ static int proc_fib_multipath_hash_seed(const struct ctl_table *table, int write
 	int ret;
 
 	mphs = &net->ipv4.sysctl_fib_multipath_hash_seed;
-	user_seed = mphs->user_seed;
+	user_seed = READ_ONCE(mphs->user_seed);
 
 	tmp = *table;
 	tmp.data = &user_seed;
-- 
2.51.0

