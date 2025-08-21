Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB7342E92DF;
	Thu, 21 Aug 2025 20:09:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755806995; cv=none; b=PmiyMocEt+tdDHpO5V39k4f+k6uz0fDQwmqDMQ7UPNFsFnJUxcB1Jz0Fm/uuNT/2CHHbyxkobxGdYeS+9xLH/AIl2/5Z/nQ1UNOH+VW8BBK8rjr7ReA8xkJJKLfh6YRTJqpGDmteMPS/COV0NhF73/J98MC0R8aLacqAwN5c4fI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755806995; c=relaxed/simple;
	bh=9X3pFBb5yxZaxNWnSnAqLVpPYIODHpVZUQNs5W1xLws=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=hMeRhgegxschXsB68+5HmJvmlS8vq10qNQxTFgp/bo4dtoCKvauWg/zchpQxYfrYxfjPucQFf5CnlqwT3yKmE0ThmxnSkWEoZa7/KaP18xLkGMH67fc4S72VRylR3/CbyqhywQ5oPdCo0zinmApzy9PDc0y2n4vU3YP0oGoZoaI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JdFOX/mf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JdFOX/mf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22892C116B1;
	Thu, 21 Aug 2025 20:09:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755806995;
	bh=9X3pFBb5yxZaxNWnSnAqLVpPYIODHpVZUQNs5W1xLws=;
	h=From:Date:Subject:To:Cc:From;
	b=JdFOX/mfDbIQ4jJZRYctMjsd9kcO8VOdjkqvXxfOZkDRiGK7qWxgqbFF+RgkS0VjB
	 jMLG2bajHVipdTdErvzyc6AImebvpsFSb/CU6hJu+IkjigMIkbq0MLbC9bsGl+BMDR
	 0UQIu+vPh67XOXtFdX0A77xq3ty5dlgwNnK77x/D22n1rWexa1xEfDT2C6YPmrMVxv
	 naz2iWOfjrUom4ZSsmM3O0l/DqQOlVt0G8Nv5Iw1RJut0L+4mZPC5WKT4Nx03e914S
	 L0XY1IcZNZcMOBvsDNwAwOBnTPIlyeO18DjudVLf4yqidYVcVbgk/o1yKRMekW472C
	 Z6cebRuo/oYHA==
From: Nathan Chancellor <nathan@kernel.org>
Date: Thu, 21 Aug 2025 13:09:24 -0700
Subject: [PATCH] dm-pcache: Fix 64-bit division for 32-bit platforms in
 get_kset_id()
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250821-dm-pcache-fix-32-bit-div-err-v1-1-cab5448f44e6@kernel.org>
X-B4-Tracking: v=1; b=H4sIAPN8p2gC/x3MSwqEMBBF0a1IjX0QY/xuRRzYSak1aFsqIoK49
 w4OD1zuTZFVOFKf3aR8SpTfllDkGfl12haGhGSyxlamtQXCF7uf/MqY5UJp8ZEDQU6wKtxs6q7
 izjWto7TYlVP17ofxef5bJVWPbgAAAA==
X-Change-ID: 20250821-dm-pcache-fix-32-bit-div-err-4f0695e94784
To: Dongsheng Yang <dongsheng.yang@linux.dev>, Zheng Gu <cengku@gmail.com>, 
 Mikulas Patocka <mpatocka@redhat.com>
Cc: dm-devel@lists.linux.dev, patches@lists.linux.dev, 
 Nathan Chancellor <nathan@kernel.org>
X-Mailer: b4 0.15-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=1477; i=nathan@kernel.org;
 h=from:subject:message-id; bh=9X3pFBb5yxZaxNWnSnAqLVpPYIODHpVZUQNs5W1xLws=;
 b=owGbwMvMwCUmm602sfCA1DTG02pJDBnLawV37YvdYx/S4D694MafI7Nv6DZMv/9v79mFslxR+
 e+5U55ndpSyMIhxMciKKbJUP1Y9bmg45yzjjVOTYOawMoEMYeDiFICJLGhnZLh1QLaNJ2Hpe7bJ
 mxdnNn4LrjylHqZZI92a3cj2Tdzt7mWG/05qvTkOHftvCNwuS+l87h1+bfsfu8o9+t7t/W4Lcvb
 r8QAA
X-Developer-Key: i=nathan@kernel.org; a=openpgp;
 fpr=2437CB76E544CB6AB3D9DFD399739260CB6CB716

When building for a 32-bit platform (such as ARCH=i386 allmodconfig),
there is a modpost error:

  ERROR: modpost: "__umoddi3" [drivers/md/dm-pcache/dm-pcache.ko] undefined!

Hacking up the driver Makefile to allow building into the kernel shows
that the division comes from get_kset_id(), which is inlined into
cache_key_append() in cache_key.c.

Use the helper div_u64_rem() to avoid emitting a libcall on 32-bit targets.

Fixes: fd5cc4922bef ("dm-pcache: add persistent cache target in device-mapper")
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---
 drivers/md/dm-pcache/cache.h | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/md/dm-pcache/cache.h b/drivers/md/dm-pcache/cache.h
index b3b361cc406e..b10e721ab1b7 100644
--- a/drivers/md/dm-pcache/cache.h
+++ b/drivers/md/dm-pcache/cache.h
@@ -373,7 +373,9 @@ static inline void *get_key_head_addr(struct pcache_cache *cache)
 
 static inline u32 get_kset_id(struct pcache_cache *cache, u64 off)
 {
-	return (off >> PCACHE_CACHE_SUBTREE_SIZE_SHIFT) % cache->n_ksets;
+	u32 rem;
+	div_u64_rem(off >> PCACHE_CACHE_SUBTREE_SIZE_SHIFT, cache->n_ksets, &rem);
+	return rem;
 }
 
 static inline struct pcache_cache_kset *get_kset(struct pcache_cache *cache, u32 kset_id)

---
base-commit: fd5cc4922bef4b3c3cd0452f38dcfd066322e9a9
change-id: 20250821-dm-pcache-fix-32-bit-div-err-4f0695e94784

Best regards,
--  
Nathan Chancellor <nathan@kernel.org>

