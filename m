Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43F133BBFD8;
	Fri,  7 Aug 2026 15:29:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786116578; cv=none; b=gMzdLfvrNVY/StAZJPcujtvhOpjB2XQpnwVG5kSElMTmYte1VeDnMOVF/qSDJPu9JKsgDC5g1v+pICvm8bql8mFqXWwWnM1ojKQOlraZi3C+gAdAF9JPixHG5H/4UV2izl5CBjN8pGZR5kqRJGrwStSmrRvLUFKtCqFCj/WmVO8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786116578; c=relaxed/simple;
	bh=SUi9HMrfB8g4UB55O+qQ0Hck/e4myaxqUBapKGMiVqs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Mw0KaJcVQOFhuGlpnBi1CZo4mLS0BdSE4KM6QEEBI9Bomoe32Fgcj+HD5Y39/Mzyn3MSHUB1vxELeyyaXE6OvNAzJ+GCNbEbjRxsCSOI3Kfuo6TozVLOLOLgEvFjsjeqEmTYs94OwXhkkQ5vryttT6tvENLL4+kvIqLeigOopbc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qd2g0kWN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qd2g0kWN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0AF91F000E9;
	Fri,  7 Aug 2026 15:29:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786116577;
	bh=+HuWdyo2h6e/Jg9qpvrjDJVnn0FeePEXRFG2hYuGttg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qd2g0kWNaAa9uxwkpBMeavu2jRsrZ74G2yUueedBMIvGP8FxhdBWVsg3sNoKLgMSC
	 ETXfdZSYQLbjZNmF7+gX/JbdIPI6kEbxxapVsO1jy8hXfC/QED8HtrVPtcgABvOhxj
	 o5hsv4GXJF2l1oUdBP77UJfmLJFVVZ70serud6hM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
	"Harry Yoo (Oracle)" <harry@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 002/438] mm/slab: decouple SLAB_NO_SHEAVES from SLAB_NO_OBJ_EXT
Date: Fri,  7 Aug 2026 16:33:18 +0200
Message-ID: <20260807143428.063853652@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143428.008222056@linuxfoundation.org>
References: <20260807143428.008222056@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Harry Yoo (Oracle) <harry@kernel.org>

commit 982e31382d9a1a3c8c4e6a13702a53711f4efe9f upstream.

Bootstrap caches are created with SLAB_NO_OBJ_EXT to disallow sheaves
and obj_exts.

To allow disabling obj_exts while allowing sheaves, decouple
SLAB_NO_SHEAVES from SLAB_NO_OBJ_EXT. Bootstrap caches now have both
SLAB_NO_SHEAVES and SLAB_NO_OBJ_EXT.

No functional change intended.

Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Signed-off-by: Harry Yoo (Oracle) <harry@kernel.org>
Reviewed-by: Suren Baghdasaryan <surenb@google.com>
Link: https://patch.msgid.link/20260713-kmalloc-no-objext-v3-2-47c7bd138de7@kernel.org
Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Signed-off-by: Harry Yoo <harry@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/slab.h | 13 +++++++++++--
 mm/slub.c            | 10 ++++++----
 2 files changed, 17 insertions(+), 6 deletions(-)

diff --git a/include/linux/slab.h b/include/linux/slab.h
index 1a69255bb87f..fda7e24a762b 100644
--- a/include/linux/slab.h
+++ b/include/linux/slab.h
@@ -58,10 +58,13 @@ enum _slab_flag_bits {
 #endif
 	_SLAB_OBJECT_POISON,
 	_SLAB_CMPXCHG_DOUBLE,
+#ifdef CONFIG_SLAB_OBJ_EXT
 	_SLAB_NO_OBJ_EXT,
-#if defined(CONFIG_SLAB_OBJ_EXT) && defined(CONFIG_64BIT)
+#ifdef CONFIG_64BIT
 	_SLAB_OBJ_EXT_IN_OBJ,
 #endif
+#endif
+	_SLAB_NO_SHEAVES,
 	_SLAB_FLAGS_LAST_BIT
 };
 
@@ -239,8 +242,14 @@ enum _slab_flag_bits {
 #endif
 #define SLAB_TEMPORARY		SLAB_RECLAIM_ACCOUNT	/* Objects are short-lived */
 
-/* Slab created using create_boot_cache */
+/* Slab caches without obj_exts array */
+#ifdef CONFIG_SLAB_OBJ_EXT
 #define SLAB_NO_OBJ_EXT		__SLAB_FLAG_BIT(_SLAB_NO_OBJ_EXT)
+#else
+#define SLAB_NO_OBJ_EXT		__SLAB_FLAG_UNUSED
+#endif
+
+#define SLAB_NO_SHEAVES		__SLAB_FLAG_BIT(_SLAB_NO_SHEAVES)
 
 #if defined(CONFIG_SLAB_OBJ_EXT) && defined(CONFIG_64BIT)
 #define SLAB_OBJ_EXT_IN_OBJ	__SLAB_FLAG_BIT(_SLAB_OBJ_EXT_IN_OBJ)
diff --git a/mm/slub.c b/mm/slub.c
index 12ace2932927..b0e8c4ae2f37 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -7724,12 +7724,12 @@ static unsigned int calculate_sheaf_capacity(struct kmem_cache *s,
 		return 0;
 
 	/*
-	 * Bootstrap caches can't have sheaves for now (SLAB_NO_OBJ_EXT).
+	 * Bootstrap caches can't have sheaves for now (SLAB_NO_SHEAVES).
 	 * SLAB_NOLEAKTRACE caches (e.g., kmemleak's object_cache) must not
 	 * have sheaves to avoid recursion when sheaf allocation triggers
 	 * kmemleak tracking.
 	 */
-	if (s->flags & (SLAB_NO_OBJ_EXT | SLAB_NOLEAKTRACE))
+	if (s->flags & (SLAB_NO_SHEAVES | SLAB_NOLEAKTRACE))
 		return 0;
 
 	/*
@@ -8511,7 +8511,8 @@ void __init kmem_cache_init(void)
 
 	create_boot_cache(kmem_cache_node, "kmem_cache_node",
 			sizeof(struct kmem_cache_node),
-			SLAB_HWCACHE_ALIGN | SLAB_NO_OBJ_EXT, 0, 0);
+			SLAB_HWCACHE_ALIGN | SLAB_NO_SHEAVES | SLAB_NO_OBJ_EXT,
+			0, 0);
 
 	hotplug_node_notifier(slab_memory_callback, SLAB_CALLBACK_PRI);
 
@@ -8521,7 +8522,8 @@ void __init kmem_cache_init(void)
 	create_boot_cache(kmem_cache, "kmem_cache",
 			offsetof(struct kmem_cache, per_node) +
 				nr_node_ids * sizeof(struct kmem_cache_per_node_ptrs),
-			SLAB_HWCACHE_ALIGN | SLAB_NO_OBJ_EXT, 0, 0);
+			SLAB_HWCACHE_ALIGN | SLAB_NO_SHEAVES | SLAB_NO_OBJ_EXT,
+			0, 0);
 
 	kmem_cache = bootstrap(&boot_kmem_cache);
 	kmem_cache_node = bootstrap(&boot_kmem_cache_node);
-- 
2.53.0



