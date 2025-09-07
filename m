Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 840371A704B;
	Sun,  7 Sep 2025 20:36:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757277407; cv=none; b=haDZckB94RONo3UhgCo+/nzXJ5NALjCG1JcUhm/xCOIOYNPPc2kM+KNh1YJ3vcnxfsXzRFtBVa6hLExyyItXNqGu1CW1Xwbz0vbapcR05oPZ0N/NcX7qpn1iwg7w116FVfI69EYxYocbNhltsIDDASjKM1+k1ziY6vqhIvNYe8A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757277407; c=relaxed/simple;
	bh=dE/k1xIctG58nRFz7cy3Y2+KHm5uHjy4Wjhd/pAAlu4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IaxXgsmPzmzHtQFqdd6N3s69Ubdp8sAmzgUi+UxduB+labUBsvxZAlB2N2sZykVAV1pfqbt5rhjVt+Xfi9ZQVX7oChrYSZPoC6aggAvt3+3u5Q8pGNZFwVCtX0MWF+uQ1Z72k0w6spgBdwkgaAHY74WyxxBjUvN0ZoiuoLjnHR4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=q2YjS/U6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q2YjS/U6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04BF3C4CEF0;
	Sun,  7 Sep 2025 20:36:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757277407;
	bh=dE/k1xIctG58nRFz7cy3Y2+KHm5uHjy4Wjhd/pAAlu4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=q2YjS/U6d6mLZ6y4nWfE1hJWcS3/93UKZ6PP/kcatKIvUoXfpZaiGCv+V5XpOsBfO
	 lDfzH9O5FnzwLIIF9MWhXHLBl73lOywK8v0ctJLasQKFXiYNiiuqoAK4cjCS1I4UCR
	 dY1AlNdBMT+dqQE42Vq2CSijUlYPtLqwZHSveW8c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hyesoo Yu <hyesoo.yu@samsung.com>,
	Harry Yoo <harry.yoo@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 138/175] mm: slub: call WARN() when detecting a slab corruption
Date: Sun,  7 Sep 2025 21:58:53 +0200
Message-ID: <20250907195618.113509693@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195614.892725141@linuxfoundation.org>
References: <20250907195614.892725141@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hyesoo Yu <hyesoo.yu@samsung.com>

[ Upstream commit 3f6f32b14ab35452d2ed52f7821cf2829923c98d ]

If a slab object is corrupted or an error occurs in its internal
validation, continuing after restoration may cause other side effects.
At this point, it is difficult to debug because the problem occurred in
the past. It is useful to use WARN() to catch errors at the point of
issue because WARN() could trigger panic for system debugging when
panic_on_warn is enabled. WARN() is added where to detect the error on
slab_err and object_err.

It makes sense to only do the WARN() after printing the logs. slab_err
is splited to __slab_err that calls the WARN() and it is called after
printing logs.

Signed-off-by: Hyesoo Yu <hyesoo.yu@samsung.com>
Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Stable-dep-of: b4efccec8d06 ("mm/slub: avoid accessing metadata when pointer is invalid in object_err()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/slub.c |   47 +++++++++++++++++++++++++++++------------------
 1 file changed, 29 insertions(+), 18 deletions(-)

--- a/mm/slub.c
+++ b/mm/slub.c
@@ -1036,7 +1036,7 @@ static void slab_bug(struct kmem_cache *
 	vaf.fmt = fmt;
 	vaf.va = &args;
 	pr_err("=============================================================================\n");
-	pr_err("BUG %s (%s): %pV\n", s->name, print_tainted(), &vaf);
+	pr_err("BUG %s (%s): %pV\n", s ? s->name : "<unknown>", print_tainted(), &vaf);
 	pr_err("-----------------------------------------------------------------------------\n\n");
 	va_end(args);
 }
@@ -1095,8 +1095,6 @@ static void print_trailer(struct kmem_ca
 		/* Beginning of the filler is the free pointer */
 		print_section(KERN_ERR, "Padding  ", p + off,
 			      size_from_object(s) - off);
-
-	dump_stack();
 }
 
 static void object_err(struct kmem_cache *s, struct slab *slab,
@@ -1108,6 +1106,8 @@ static void object_err(struct kmem_cache
 	slab_bug(s, "%s", reason);
 	print_trailer(s, slab, object);
 	add_taint(TAINT_BAD_PAGE, LOCKDEP_NOW_UNRELIABLE);
+
+	WARN_ON(1);
 }
 
 static bool freelist_corrupted(struct kmem_cache *s, struct slab *slab,
@@ -1124,6 +1124,17 @@ static bool freelist_corrupted(struct km
 	return false;
 }
 
+static void __slab_err(struct slab *slab)
+{
+	if (slab_in_kunit_test())
+		return;
+
+	print_slab_info(slab);
+	add_taint(TAINT_BAD_PAGE, LOCKDEP_NOW_UNRELIABLE);
+
+	WARN_ON(1);
+}
+
 static __printf(3, 4) void slab_err(struct kmem_cache *s, struct slab *slab,
 			const char *fmt, ...)
 {
@@ -1137,9 +1148,7 @@ static __printf(3, 4) void slab_err(stru
 	vsnprintf(buf, sizeof(buf), fmt, args);
 	va_end(args);
 	slab_bug(s, "%s", buf);
-	print_slab_info(slab);
-	dump_stack();
-	add_taint(TAINT_BAD_PAGE, LOCKDEP_NOW_UNRELIABLE);
+	__slab_err(slab);
 }
 
 static void init_object(struct kmem_cache *s, void *object, u8 val)
@@ -1312,9 +1321,10 @@ slab_pad_check(struct kmem_cache *s, str
 	while (end > fault && end[-1] == POISON_INUSE)
 		end--;
 
-	slab_err(s, slab, "Padding overwritten. 0x%p-0x%p @offset=%tu",
-			fault, end - 1, fault - start);
+	slab_bug(s, "Padding overwritten. 0x%p-0x%p @offset=%tu",
+		 fault, end - 1, fault - start);
 	print_section(KERN_ERR, "Padding ", pad, remainder);
+	__slab_err(slab);
 
 	restore_bytes(s, "slab padding", POISON_INUSE, fault, end);
 }
@@ -1630,12 +1640,12 @@ static inline int free_consistency_check
 			slab_err(s, slab, "Attempt to free object(0x%p) outside of slab",
 				 object);
 		} else if (!slab->slab_cache) {
-			pr_err("SLUB <none>: no slab for object 0x%p.\n",
-			       object);
-			dump_stack();
-		} else
+			slab_err(NULL, slab, "No slab cache for object 0x%p",
+				 object);
+		} else {
 			object_err(s, slab, object,
-					"page slab pointer corrupt.");
+				   "page slab pointer corrupt.");
+		}
 		return 0;
 	}
 	return 1;
@@ -5450,14 +5460,14 @@ static int calculate_sizes(struct kmem_c
 	return !!oo_objects(s->oo);
 }
 
-static void list_slab_objects(struct kmem_cache *s, struct slab *slab,
-			      const char *text)
+static void list_slab_objects(struct kmem_cache *s, struct slab *slab)
 {
 #ifdef CONFIG_SLUB_DEBUG
 	void *addr = slab_address(slab);
 	void *p;
 
-	slab_err(s, slab, text, s->name);
+	if (!slab_add_kunit_errors())
+		slab_bug(s, "Objects remaining on __kmem_cache_shutdown()");
 
 	spin_lock(&object_map_lock);
 	__fill_map(object_map, s, slab);
@@ -5472,6 +5482,8 @@ static void list_slab_objects(struct kme
 		}
 	}
 	spin_unlock(&object_map_lock);
+
+	__slab_err(slab);
 #endif
 }
 
@@ -5492,8 +5504,7 @@ static void free_partial(struct kmem_cac
 			remove_partial(n, slab);
 			list_add(&slab->slab_list, &discard);
 		} else {
-			list_slab_objects(s, slab,
-			  "Objects remaining in %s on __kmem_cache_shutdown()");
+			list_slab_objects(s, slab);
 		}
 	}
 	spin_unlock_irq(&n->list_lock);


