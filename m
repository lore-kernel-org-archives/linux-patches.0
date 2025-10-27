Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFF9B3218B2;
	Mon, 27 Oct 2025 19:27:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761593278; cv=none; b=Z+276kEwrbTEwTSgsKUOyVIRiUpFAkxC9wftoQVe3iOz8zidsTp8bmzRahh8KDmzLnm9LmhZIn1m8wNGWzTTeWLAe2pWk4tcnlglpuq1wGB3EAUQ4Ns6ffnC9Mfe23dD7G65ilPC8OZl5Og+5WQjMa118T6gDdYSp4bmqG3+mxw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761593278; c=relaxed/simple;
	bh=QytsNCxqG5uNu8l39xYibnu1QbZ0s70S7FW1hi67cMY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lIwGWN9u/gC868Kddl6u0j6Qj/0UAW/ll62aIMlKw2y9r5ILFrNoJseYDIgalcKhtQ9zgoHz5C180MMfuvEnq4Z9O9b50c9JPOO8XX9oE6P3xp2QSJ7a96NYHQVIU+bCVp4+VeUIzroLQiQER+MKzDmnYZVSaDSDibbSJKwfhPc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=U6177fm4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U6177fm4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72F6AC4CEF1;
	Mon, 27 Oct 2025 19:27:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761593277;
	bh=QytsNCxqG5uNu8l39xYibnu1QbZ0s70S7FW1hi67cMY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=U6177fm4IPQFbrvmRJcdj58i7MLsCavJgRlw/2S528kKNv5DmrlCAEXA+LWb6hXb1
	 nb0e1RO+dPVeQ4vY8TFbMaI5rXV0rPAqzJKMuINPVt4TZ0H/Tikz4uzBJqAcStXrBj
	 M5ECNe8/Xdpa3c0B0LaO9/0w1G/RX3vutZ1LtAZw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Suren Baghdasaryan <surenb@google.com>,
	Hao Ge <gehao@kylinos.cn>,
	Harry Yoo <harry.yoo@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>
Subject: [PATCH 6.17 082/184] slab: Avoid race on slab->obj_exts in alloc_slab_obj_exts
Date: Mon, 27 Oct 2025 19:36:04 +0100
Message-ID: <20251027183517.107241183@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183514.934710872@linuxfoundation.org>
References: <20251027183514.934710872@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hao Ge <gehao@kylinos.cn>

commit 6ed8bfd24ce1cb31742b09a3eb557cd008533eec upstream.

If two competing threads enter alloc_slab_obj_exts() and one of them
fails to allocate the object extension vector, it might override the
valid slab->obj_exts allocated by the other thread with
OBJEXTS_ALLOC_FAIL. This will cause the thread that lost this race and
expects a valid pointer to dereference a NULL pointer later on.

Update slab->obj_exts atomically using cmpxchg() to avoid
slab->obj_exts overrides by racing threads.

Thanks for Vlastimil and Suren's help with debugging.

Fixes: f7381b911640 ("slab: mark slab->obj_exts allocation failures unconditionally")
Cc: <stable@vger.kernel.org>
Suggested-by: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Hao Ge <gehao@kylinos.cn>
Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
Reviewed-by: Suren Baghdasaryan <surenb@google.com>
Link: https://patch.msgid.link/20251021010353.1187193-1-hao.ge@linux.dev
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/slub.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/mm/slub.c
+++ b/mm/slub.c
@@ -1978,7 +1978,7 @@ static inline void mark_objexts_empty(st
 
 static inline void mark_failed_objexts_alloc(struct slab *slab)
 {
-	slab->obj_exts = OBJEXTS_ALLOC_FAIL;
+	cmpxchg(&slab->obj_exts, 0, OBJEXTS_ALLOC_FAIL);
 }
 
 static inline void handle_failed_objexts_alloc(unsigned long obj_exts,
@@ -2043,6 +2043,7 @@ int alloc_slab_obj_exts(struct slab *sla
 #ifdef CONFIG_MEMCG
 	new_exts |= MEMCG_DATA_OBJEXTS;
 #endif
+retry:
 	old_exts = READ_ONCE(slab->obj_exts);
 	handle_failed_objexts_alloc(old_exts, vec, objects);
 	if (new_slab) {
@@ -2052,8 +2053,7 @@ int alloc_slab_obj_exts(struct slab *sla
 		 * be simply assigned.
 		 */
 		slab->obj_exts = new_exts;
-	} else if ((old_exts & ~OBJEXTS_FLAGS_MASK) ||
-		   cmpxchg(&slab->obj_exts, old_exts, new_exts) != old_exts) {
+	} else if (old_exts & ~OBJEXTS_FLAGS_MASK) {
 		/*
 		 * If the slab is already in use, somebody can allocate and
 		 * assign slabobj_exts in parallel. In this case the existing
@@ -2062,6 +2062,9 @@ int alloc_slab_obj_exts(struct slab *sla
 		mark_objexts_empty(vec);
 		kfree(vec);
 		return 0;
+	} else if (cmpxchg(&slab->obj_exts, old_exts, new_exts) != old_exts) {
+		/* Retry if a racing thread changed slab->obj_exts from under us. */
+		goto retry;
 	}
 
 	kmemleak_not_leak(vec);


