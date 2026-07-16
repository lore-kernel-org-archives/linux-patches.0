Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D34931ED7C;
	Thu, 16 Jul 2026 14:09:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784210987; cv=none; b=oqO7SHSClkkjGOvmJnyRAd32AOFxgKTVppRFNp2XiAE33g29+YHxSGN8KDUvbRfRtn4WBSFVjhjV4JgP6SKrQvxA/vXQt1VMGzIIKOAotHpMTqg8+rTDx6vNCLDl7M+0iutbSM/mt3a/XLhVBCq6NkQH+GUxuLIWHSRXoqKbc6I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784210987; c=relaxed/simple;
	bh=dfzZdNcKqGWlFg/qKLde1Gz7uYlcrhJMXLSNtfVmfy4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H4OMoOvOm3HzW09Y0cfrZ6weZxYzXzW9sNrPOys7nKrOhnarqSN6vCNXDMgrazTZgY1QD32MaCchEILGBWW7yBjsrGZsCAsZdLk/N95FBp/7ZrK+dAkUapJJN78FTXGgLxggm7Wr71fr47HUwTtFdXLnDWzZNLpupKftE/1RJIE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wPgZoPHO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wPgZoPHO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91B091F00A3A;
	Thu, 16 Jul 2026 14:09:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784210986;
	bh=Gp3dtMf6xg9/8Ynyu4h9T6DrFABX2D5UqHSIPwNqihA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wPgZoPHOUKvM1B4WRPNqrBjBfpIqEHsgCUIy7H3ZzveXu/tv7KcWzAM6G8VJRHlsz
	 A5/5LZqCE499I4lCaS5eIKKWDrxiwf8f9DeKx4Fz/9lpVc3ffWYYLLA8bbXDonPxXc
	 qd7B4lvlCHi9pp+DHJM046SP3Q5T6kg19dFbUh8Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Harry Yoo (Oracle)" <harry@kernel.org>,
	Hao Li <hao.li@linux.dev>,
	"Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Subject: [PATCH 6.18 256/480] mm/slab: do not limit zeroing to orig_size when only red zoning is enabled
Date: Thu, 16 Jul 2026 15:30:03 +0200
Message-ID: <20260716133050.353204158@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133044.672218725@linuxfoundation.org>
References: <20260716133044.672218725@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vlastimil Babka (SUSE) <vbabka@kernel.org>

commit 648927ceb84021a25a0fbd5673740956f318d534 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/slub.c |   18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

--- a/mm/slub.c
+++ b/mm/slub.c
@@ -5004,15 +5004,17 @@ bool slab_post_alloc_hook(struct kmem_ca
 	gfp_t init_flags = flags & gfp_allowed_mask;
 
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
-	    (s->flags & SLAB_KMALLOC))
+	if (slub_debug_orig_size(s))
 		zero_size = orig_size;
 
 	/*


