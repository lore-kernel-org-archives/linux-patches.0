Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 808AB3E0091;
	Thu, 30 Jul 2026 14:53:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785423186; cv=none; b=AQnujQcEhN9vrE0Wy2HudpohF1HdrB3axO/0goc+qVWhsPyCuOfwt89PmnRi2u0EXOSmA5Cv1nUZF5yc1fgTk8EOamM8qj0kpv4lLhrmuLwPSdTgB3FEE7DCFUnu/jwknTbVrbFW0RmS7i0rreD9X6YCwsdTP3++QLKu3iIJOXc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785423186; c=relaxed/simple;
	bh=JQH4HnIEgj6AemA5TkmeyoB492Jwjii0VBsEaCQnif8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g4SvgLnh+ugNnh92D5vvuvW2jBp0+3AC/73mlWAhF8SSPDa/mIptdeXzSyxjxQi0JppT+0Qh5XkV5xYRlxr6ICSSj8jE7Ud3CeJGgKJLDnoezOeTJYs97fYB//a7d6gFAuMmGVs5aOD6TiVh6O0OdQn67K2HNpjexjjRwuMTF6k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aDVAfzTq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aDVAfzTq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D52AB1F000E9;
	Thu, 30 Jul 2026 14:53:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785423185;
	bh=uIDKKgFIGWYbMkUlYeyHUYUc0GD0F8E7jegkrdOsIYw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aDVAfzTqIr2gnEpsLdg3f4bKzrgbhe4hiqtmsU2KLTiZVB/TYm/d4xwBXBS8bJK+P
	 KkI4Lf+byvc4pjjcJG+r5+I8gF26LLZisPYXuxTVe49AzGFROQAeiKHRgLqCBk6JmH
	 S6pv9/yym4IAteqG1tFaGsJoSaHf0B+DL3LC/Svc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Harry Yoo (Oracle)" <harry@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	"Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Subject: [PATCH 7.1 651/744] mm/slab: fix a memory leak due to bootstrapping sheaves twice
Date: Thu, 30 Jul 2026 16:15:24 +0200
Message-ID: <20260730141458.106747227@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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

commit 1dba91a0493b7ffe9cbbcf7a8df1b361ddcac515 upstream.

When kmalloc caches are aliased, multiple cache pointers reference
the same kmem_cache. As a result, iterating over kmalloc indices and
bootstrapping sheaves can bootstrap the same cache more than once and
leak memory.

Currently, this could happen when the architecture specifies
minimum alignment for slab caches that is larger than
ARCH_KMALLOC_MINALIGN.

Bootstrap sheaves only when the cache does not have them already.
Add a warning when bootstrap_cache_sheaves() is called for a cache
that already has sheaves enabled.

Fixes: 913ffd3a1bf5 ("slab: handle kmalloc sheaves bootstrap")
Cc: stable@vger.kernel.org
Signed-off-by: Harry Yoo (Oracle) <harry@kernel.org>
Reviewed-by: Suren Baghdasaryan <surenb@google.com>
Link: https://patch.msgid.link/20260713-kmalloc-no-objext-v3-1-47c7bd138de7@kernel.org
Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/slub.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/mm/slub.c
+++ b/mm/slub.c
@@ -8423,6 +8423,8 @@ static void __init bootstrap_cache_sheav
 	bool failed = false;
 	int node, cpu;
 
+	VM_WARN_ON_ONCE(cache_has_sheaves(s));
+
 	capacity = calculate_sheaf_capacity(s, &empty_args);
 
 	/* capacity can be 0 due to debugging or SLUB_TINY */
@@ -8473,8 +8475,11 @@ static void __init bootstrap_kmalloc_she
 
 	for (type = KMALLOC_NORMAL; type <= KMALLOC_RANDOM_END; type++) {
 		for (int idx = 0; idx < KMALLOC_SHIFT_HIGH + 1; idx++) {
-			if (kmalloc_caches[type][idx])
-				bootstrap_cache_sheaves(kmalloc_caches[type][idx]);
+			struct kmem_cache *s = kmalloc_caches[type][idx];
+
+			/* Do not bootstrap twice when caches are aliased */
+			if (s && !cache_has_sheaves(s))
+				bootstrap_cache_sheaves(s);
 		}
 	}
 }


