Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD1293ACF06;
	Wed,  4 Feb 2026 15:19:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770218353; cv=none; b=kOUB7qQvE1fUqYBZWimJ/L5Viw5wgGLyDxlijmUoe4iFHUpOQX3O/cgZ+6JCtosI92/f5IDbRTkD5pMkOls5A+edZPsTMv0BkeoAjeMDMvfVdtcATCrIl63Gd/pgBWNbQIFx0qLECP7/M+o5NK23S28uwgalRu0gXR11RA7fWh0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770218353; c=relaxed/simple;
	bh=IKIJEQ5OFo0XgMxH+A0D660rb6QFLBhvl6vdGIkf6x0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZS3lEjm+0YfMp98y9ukHnniHxJ2i51ih2wwsOjfdg3+1KJyrzRJfWDhk0VyXhgLBBNH0L/NgJuvGNyzoBcu6CuUkAGXWVL5NYdcHfesH1kOt4uwhyufvZa2LK8UluMFNmEQo5mxT9kOqCc+2JkdIBPDmO0W24R3RANlDXALm+Kw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TkXo5vjw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TkXo5vjw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B7CAC116C6;
	Wed,  4 Feb 2026 15:19:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770218353;
	bh=IKIJEQ5OFo0XgMxH+A0D660rb6QFLBhvl6vdGIkf6x0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TkXo5vjwpnv+oplgv0LJSu/FzdUpbZD1Yn/w1Emt5lJUvC8TiOKKB2BEw+1Ef581J
	 YueOB88j8E21ItB6xhZhqlwu2dSJ7XnLYAhKy8JZcL2xNXpGn6hdGjS/drojD8feuI
	 TPcgZpelNWIVYGmYZJNhCg0lYz5/KfPWI3jFbw0Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pimyn Girgis <pimyn@google.com>,
	Alexander Potapenko <glider@google.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	Marco Elver <elver@google.com>,
	Ernesto Martnez Garca <ernesto.martinezgarcia@tugraz.at>,
	Kees Cook <kees@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 276/280] mm/kfence: randomize the freelist on initialization
Date: Wed,  4 Feb 2026 15:40:50 +0100
Message-ID: <20260204143919.636646321@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143909.614719725@linuxfoundation.org>
References: <20260204143909.614719725@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pimyn Girgis <pimyn@google.com>

[ Upstream commit 870ff19251bf3910dda7a7245da826924045fedd ]

Randomize the KFENCE freelist during pool initialization to make
allocation patterns less predictable.  This is achieved by shuffling the
order in which metadata objects are added to the freelist using
get_random_u32_below().

Additionally, ensure the error path correctly calculates the address range
to be reset if initialization fails, as the address increment logic has
been moved to a separate loop.

Link: https://lkml.kernel.org/r/20260120161510.3289089-1-pimyn@google.com
Fixes: 0ce20dd84089 ("mm: add Kernel Electric-Fence infrastructure")
Signed-off-by: Pimyn Girgis <pimyn@google.com>
Reviewed-by: Alexander Potapenko <glider@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Marco Elver <elver@google.com>
Cc: Ernesto Martnez Garca <ernesto.martinezgarcia@tugraz.at>
Cc: Greg KH <gregkh@linuxfoundation.org>
Cc: Kees Cook <kees@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
[ replaced kfence_metadata_init with kfence_metadata ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/kfence/core.c |   23 +++++++++++++++++++----
 1 file changed, 19 insertions(+), 4 deletions(-)

--- a/mm/kfence/core.c
+++ b/mm/kfence/core.c
@@ -542,7 +542,7 @@ static unsigned long kfence_init_pool(vo
 {
 	unsigned long addr = (unsigned long)__kfence_pool;
 	struct page *pages;
-	int i;
+	int i, rand;
 
 	if (!arch_kfence_init_pool())
 		return addr;
@@ -590,19 +590,34 @@ static unsigned long kfence_init_pool(vo
 		INIT_LIST_HEAD(&meta->list);
 		raw_spin_lock_init(&meta->lock);
 		meta->state = KFENCE_OBJECT_UNUSED;
-		meta->addr = addr; /* Initialize for validation in metadata_to_pageaddr(). */
-		list_add_tail(&meta->list, &kfence_freelist);
+		/* Use addr to randomize the freelist. */
+		meta->addr = i;
 
 		/* Protect the right redzone. */
-		if (unlikely(!kfence_protect(addr + PAGE_SIZE)))
+		if (unlikely(!kfence_protect(addr + 2 * i * PAGE_SIZE + PAGE_SIZE)))
 			goto reset_slab;
+	}
+
+	for (i = CONFIG_KFENCE_NUM_OBJECTS; i > 0; i--) {
+		rand = get_random_u32_below(i);
+		swap(kfence_metadata[i - 1].addr, kfence_metadata[rand].addr);
+	}
 
+	for (i = 0; i < CONFIG_KFENCE_NUM_OBJECTS; i++) {
+		struct kfence_metadata *meta_1 = &kfence_metadata[i];
+		struct kfence_metadata *meta_2 = &kfence_metadata[meta_1->addr];
+
+		list_add_tail(&meta_2->list, &kfence_freelist);
+	}
+	for (i = 0; i < CONFIG_KFENCE_NUM_OBJECTS; i++) {
+		kfence_metadata[i].addr = addr;
 		addr += 2 * PAGE_SIZE;
 	}
 
 	return 0;
 
 reset_slab:
+	addr += 2 * i * PAGE_SIZE;
 	for (i = 0; i < KFENCE_POOL_SIZE / PAGE_SIZE; i++) {
 		struct slab *slab = page_slab(nth_page(pages, i));
 


