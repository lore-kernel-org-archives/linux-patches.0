Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9982D4746AC;
	Tue, 21 Jul 2026 21:03:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784667835; cv=none; b=lUuEBJTF3Ay0pCB5X/eh8uF1h+jBmJuKEnCjN+nYeQPjFxnurOWWFFvnDcqAZKt14FkrMOuogPMRl40YHZhTxE2CyXEQrb35mIya9Po7U8h8s6VWL4BcQM6z3baBqgMtqbNBIw7ouqAuVoiMSJ4x9vRvTBQVOSGvTjrL/U4Ml5Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784667835; c=relaxed/simple;
	bh=LuMYLDe7uhv1aNN2iyZr0M+2dVn6nSogoyPOP9CKfz8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bomhB4+yUGVwfNQgXl6s1C+pZBhFd0FuSgDNzkiCyT60LQr0xH9ze1FWMNJHhXFDFFlc5VZ56mtlhpuA2DnjujbBgQloJljEIp3+7e+c/xCIZtIPAnODpLdwpT3mv5V/7/yxDH3npUV1753rEVr8ZYk+IujtMdxvDlja/b9M5NU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GFnVkle2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GFnVkle2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BCB71F00A3A;
	Tue, 21 Jul 2026 21:03:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784667829;
	bh=GnCTCVpuHbvH0XCXyP3fccIVCWHzj4dcRz3S/KVJuBQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GFnVkle2g7+Qm4Va6/EgkvC0GU5tRGP9Rk4iiDVxqbR1umwKNS3kgIMr1J8KZNaEf
	 6L+r1F05cCK3CtsumsuWTSBlzEPjXv+8RtdEb9edOpY4Y4nUOzwPqwRaQWF6FdEgNF
	 tE3NARM/p+QXYS0tfWcZcXtBdJyc6an+X7HOj4CE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Harry Yoo (Oracle)" <harry@kernel.org>,
	Hao Li <hao.li@linux.dev>,
	"Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1210/1266] mm/slab: do not limit zeroing to orig_size when only red zoning is enabled
Date: Tue, 21 Jul 2026 17:27:27 +0200
Message-ID: <20260721152508.878012251@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>

[ Upstream commit 648927ceb84021a25a0fbd5673740956f318d534 ]

When init (zeroing) on allocation is requested, for kmalloc() we
generally have to zero the full object size even if a smaller size is
requested, in order to provide krealloc()'s __GFP_ZERO guarantees.

But if we track the requested size, krealloc() uses that information to
do the right thing, so we can zero only the requested size. With red
zoning also enabled, any extra size became part of the red zone, so it
must not be zeroed and thus we must zero only the requested size.

However the current check is imprecise, and will trigger also when only
SLAB_RED_ZONE is enabled without SLAB_STORE_USER (which enables tracking
the requested size). This means enabling red zoning alone can compromise
krealloc()'s __GFP_ZERO contract.

Fix this by using slub_debug_orig_size() instead, which is the exact
check for whether the requested size is tracked. We don't need to care
if red zoning is also enabled or not. Also update and expand the
comment accordingly.

Fixes: 9ce67395f5a0 ("mm/slub: only zero requested size of buffer for kzalloc when debug enabled")
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260610-slab_alloc_flags-v2-1-7190909db118@kernel.org
Reviewed-by: Harry Yoo (Oracle) <harry@kernel.org>
Reviewed-by: Hao Li <hao.li@linux.dev>
Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/slab.h |   17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

--- a/mm/slab.h
+++ b/mm/slab.h
@@ -734,14 +734,17 @@ static inline void slab_post_alloc_hook(
 	flags &= gfp_allowed_mask;
 
 	/*
-	 * For kmalloc object, the allocated memory size(object_size) is likely
-	 * larger than the requested size(orig_size). If redzone check is
-	 * enabled for the extra space, don't zero it, as it will be redzoned
-	 * soon. The redzone operation for this extra space could be seen as a
-	 * replacement of current poisoning under certain debug option, and
-	 * won't break other sanity checks.
+	 * For kmalloc object, the allocated size (object_size) can be larger
+	 * than the requested size (orig_size). We however need to zero the
+	 * whole object_size to handle possible later krealloc() with
+	 *__GFP_ZERO properly.
+	 *
+	 * But if we keep track of the requested size, krealloc() uses that
+	 * information. Additionally if red zoning is enabled, the extra space
+	 * is also red zone, so we should not overwrite it. So limit zeroing to
+	 * orig_size if we track it.
 	 */
-	if (kmem_cache_debug_flags(s, SLAB_STORE_USER | SLAB_RED_ZONE) &&
+	if (kmem_cache_debug_flags(s, SLAB_STORE_USER) &&
 	    (s->flags & SLAB_KMALLOC))
 		zero_size = orig_size;
 


