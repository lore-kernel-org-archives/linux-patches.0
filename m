Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 319813D6CA5;
	Wed, 20 May 2026 16:36:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779295020; cv=none; b=DC/u5oQ50agCrqAmQdB9ethJcA+5fuh8+feZk1moXZEJRQvVKLRc46NPiv2V8q1dGR0cjFWfsS6tZO7OKdKDgG2Y0iEHwb3PwhF3TaNDmO3hOHViHsB0oEsSXjJOSVM02ppGLFll1M0Of5J+H4G9uZcT2t/u/INkvct+mf+1P3c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779295020; c=relaxed/simple;
	bh=yQqRJmJxvKPSlzpKNzFGBAU7sx+KMa8Q9o6GWwCKPCY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r7jUNqrsXMwWxsHviozgHjpmAGSmJmb+PPhhv5hp6V3FbC8R5nwPlmNidZESC3echoVgaGhroPC0ULTk5dKEWqYUu+uY1/mFrbi+z0d0v+hToVY8gTwEgzf0xDWsXOLW7W9O8tl9EoTaBjMgjRu5EtlSj4QQgNWLriub6CGQnj4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Qtyu6WX0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Qtyu6WX0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B9291F000E9;
	Wed, 20 May 2026 16:36:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779295018;
	bh=iIz8d4j0jiCOb2WaYUMETKJKK66BivvfxKI9qbm6yO0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Qtyu6WX0H0Hua2v5ntyntLCvNmkDc+41W6sti7b3mj/3gy0xdABKGKKWOBBt5A2yO
	 /uRJFKaWMm881hl2MzYNl5rQziq9zwaT42LQvdXs4m5ifO1dtctZDey/bhFhoSeVsh
	 Pv0t2ETbDJEZ90qO1OIsNjE9h6Lylzj0goJMMj0Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konstantin Khorenko <khorenko@virtuozzo.com>,
	Thomas Weissschuh <linux@weissschuh.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0209/1146] net: fix skb_ext_total_length() BUILD_BUG_ON with CONFIG_GCOV_PROFILE_ALL
Date: Wed, 20 May 2026 18:07:39 +0200
Message-ID: <20260520162152.996407792@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Konstantin Khorenko <khorenko@virtuozzo.com>

[ Upstream commit c0b4382c86e3d92f79b71c9ed55654db520d7b36 ]

When CONFIG_GCOV_PROFILE_ALL=y is enabled, the kernel fails to build:

  In file included from <command-line>:
  In function 'skb_extensions_init',
      inlined from 'skb_init' at net/core/skbuff.c:5214:2:
  ././include/linux/compiler_types.h:706:45: error: call to
    '__compiletime_assert_1490' declared with attribute error:
    BUILD_BUG_ON failed: skb_ext_total_length() > 255

CONFIG_GCOV_PROFILE_ALL adds -fprofile-arcs -ftest-coverage
-fno-tree-loop-im to CFLAGS globally. GCC inserts branch profiling
counters into the skb_ext_total_length() loop and, combined with
-fno-tree-loop-im (which disables loop invariant motion), cannot
constant-fold the result.
BUILD_BUG_ON requires a compile-time constant and fails.

The issue manifests in kernels with 5+ SKB extension types enabled
(e.g., after addition of SKB_EXT_CAN, SKB_EXT_PSP). With 4 extensions
GCC can still unroll and fold the loop despite GCOV instrumentation;
with 5+ it gives up.

Mark skb_ext_total_length() with __no_profile to prevent GCOV from
inserting counters into this function. Without counters the loop is
"clean" and GCC can constant-fold it even with -fno-tree-loop-im active.
This allows BUILD_BUG_ON to work correctly while keeping GCOV profiling
for the rest of the kernel.

This also removes the CONFIG_KCOV_INSTRUMENT_ALL preprocessor guard
introduced by d6e5794b06c0. That guard was added as a precaution because
KCOV instrumentation was also suspected of inhibiting constant folding.
However, KCOV uses -fsanitize-coverage=trace-pc, which inserts
lightweight trace callbacks that do not interfere with GCC's constant
folding or loop optimization passes. Only GCOV's -fprofile-arcs combined
with -fno-tree-loop-im actually prevents the compiler from evaluating
the loop at compile time. The guard is therefore unnecessary and can be
safely removed.

Fixes: 96ea3a1e2d31 ("can: add CAN skb extension infrastructure")
Signed-off-by: Konstantin Khorenko <khorenko@virtuozzo.com>
Reviewed-by: Thomas Weissschuh <linux@weissschuh.net>
Link: https://patch.msgid.link/20260410162150.3105738-2-khorenko@virtuozzo.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/skbuff.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 43ee86dcf2eaf..59fb4b2bb8217 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -5142,7 +5142,7 @@ static const u8 skb_ext_type_len[] = {
 #endif
 };
 
-static __always_inline unsigned int skb_ext_total_length(void)
+static __always_inline __no_profile unsigned int skb_ext_total_length(void)
 {
 	unsigned int l = SKB_EXT_CHUNKSIZEOF(struct skb_ext);
 	int i;
@@ -5156,9 +5156,7 @@ static __always_inline unsigned int skb_ext_total_length(void)
 static void skb_extensions_init(void)
 {
 	BUILD_BUG_ON(SKB_EXT_NUM > 8);
-#if !IS_ENABLED(CONFIG_KCOV_INSTRUMENT_ALL)
 	BUILD_BUG_ON(skb_ext_total_length() > 255);
-#endif
 
 	skbuff_ext_cache = kmem_cache_create("skbuff_ext_cache",
 					     SKB_EXT_ALIGN_VALUE * skb_ext_total_length(),
-- 
2.53.0



