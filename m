Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 817E426F288;
	Thu, 12 Mar 2026 20:25:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773347156; cv=none; b=lX1fU1hlnkNxfwRXxIT0moXwg+cP+iGFFDkwP7vMArSLDz/z9ryeo9BHuVBk8St1zti1UzBEt2kC0cjBszBcYLvuEUJv4rzajRewhyTRF8RbEdbsMoPUo9iQlKCFDIMszrJl/HC034BksexHFwbvrg0agVeMWQw8ZfVTXWeHd4M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773347156; c=relaxed/simple;
	bh=RCd4Svm9DS7wz9C2u8Vx0JlMamTHAEgsTdbHF9iBMkw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aIB4ggr1ujnCcOnAzFE+vqlJ/c6lJnwmwclF0wNBkkP5FJvozFjFn8/DuovCNpc0AwOpmlwxhuP9Pv7u43qpPmyD4la8J/MX+LoYuxlezsLzp6Tvf7nRPDVXQVIw4v2ADOkEepsAmucqgRMs0bzeSq657ogdpt+vQb7j2rNg8Jo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IdKsz0kR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IdKsz0kR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2639C4CEF7;
	Thu, 12 Mar 2026 20:25:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773347156;
	bh=RCd4Svm9DS7wz9C2u8Vx0JlMamTHAEgsTdbHF9iBMkw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IdKsz0kR+vYPAXGCY/QsTYHoiMJlUwndM4paQcgAH1k0hIWxurmhdXktg4k4Jtqi3
	 vvzLnJChA6nw0VAW2EHOc5xzNgTewHkEKW2thVXk5ndvgVHcIeVPtXu4GlABZk/NF3
	 /EdHzJpBKJgipJq/5G1ZizVRZPpgick6rwb9I5go=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yung Chih Su <yuuchihsu@gmail.com>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 218/265] net: ipv4: fix ARM64 alignment fault in multipath hash seed
Date: Thu, 12 Mar 2026 21:10:05 +0100
Message-ID: <20260312201026.197117813@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260312201018.128816016@linuxfoundation.org>
References: <20260312201018.128816016@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

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
index 967e4dc555fac..339b92cd5cec6 100644
--- a/include/net/ip_fib.h
+++ b/include/net/ip_fib.h
@@ -544,7 +544,7 @@ static inline u32 fib_multipath_hash_from_keys(const struct net *net,
 	siphash_aligned_key_t hash_key;
 	u32 mp_seed;
 
-	mp_seed = READ_ONCE(net->ipv4.sysctl_fib_multipath_hash_seed).mp_seed;
+	mp_seed = READ_ONCE(net->ipv4.sysctl_fib_multipath_hash_seed.mp_seed);
 	fib_multipath_hash_construct_key(&hash_key, mp_seed);
 
 	return flow_hash_from_keys_seed(keys, &hash_key);
diff --git a/net/ipv4/sysctl_net_ipv4.c b/net/ipv4/sysctl_net_ipv4.c
index a79b2a52ce01e..8d411cce0aedc 100644
--- a/net/ipv4/sysctl_net_ipv4.c
+++ b/net/ipv4/sysctl_net_ipv4.c
@@ -481,7 +481,8 @@ static void proc_fib_multipath_hash_set_seed(struct net *net, u32 user_seed)
 			    proc_fib_multipath_hash_rand_seed),
 	};
 
-	WRITE_ONCE(net->ipv4.sysctl_fib_multipath_hash_seed, new);
+	WRITE_ONCE(net->ipv4.sysctl_fib_multipath_hash_seed.user_seed, new.user_seed);
+	WRITE_ONCE(net->ipv4.sysctl_fib_multipath_hash_seed.mp_seed, new.mp_seed);
 }
 
 static int proc_fib_multipath_hash_seed(const struct ctl_table *table, int write,
@@ -495,7 +496,7 @@ static int proc_fib_multipath_hash_seed(const struct ctl_table *table, int write
 	int ret;
 
 	mphs = &net->ipv4.sysctl_fib_multipath_hash_seed;
-	user_seed = mphs->user_seed;
+	user_seed = READ_ONCE(mphs->user_seed);
 
 	tmp = *table;
 	tmp.data = &user_seed;
-- 
2.51.0



