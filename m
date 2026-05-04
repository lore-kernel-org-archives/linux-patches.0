Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E832B3DE43B;
	Mon,  4 May 2026 14:19:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777904355; cv=none; b=rQSNdbN8gyo/ok6xPgHpa/ddK7Rf8iVqUQ1+aoknQCGDT2JexMyILEmbZainvcPQ+IBW9p1NttaryaMy72Uk3ke83sM7mxYI02zt4gAOOhlfp/+e2flZ2U3M4dfGzFVQR2GnKGYw4FveDhMnwrY8SqZmib8RXbsNPMBsarTeblA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777904355; c=relaxed/simple;
	bh=s8OMDDjMv/geGGIANevtAJv+aTBSGmjT4bfNRw2o/8o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fEyTrVQG9iMyq1X9F1ZCQaeGjWYFsKgRWJMRfqWOEc75XgmZgqq3ZnD7frmRYrjJpvKsfZ0jJiL2y5pcNe401cUxcO/4synE4aFRrZEb/ncmatlPUkV1ytgraLWKaNgiBShk+L6dK9cfD4C4/noS8SNaniL2vJQG0s+QQE1Al4g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=raFhwxuY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="raFhwxuY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 809CDC2BCB8;
	Mon,  4 May 2026 14:19:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777904354;
	bh=s8OMDDjMv/geGGIANevtAJv+aTBSGmjT4bfNRw2o/8o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=raFhwxuYLAwZ1GK5dNb6cmga752ClfDzqODlVxxMfrcmLi05979vC/hZ6qv3bh5F0
	 0POfFWQDVM9IrxwRhvH6hZuzloEpZRbV1Gk4FmH3IRAPqnldfVJCtBLnI3QlpcefVC
	 OC8hOAkmC3scODi5asQwpzzvUE1Q4oDv3pbh6Teo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Harry Yoo (Oracle)" <harry@kernel.org>,
	"Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Subject: [PATCH 6.18 273/275] mm/slab: return NULL early from kmalloc_nolock() in NMI on UP
Date: Mon,  4 May 2026 15:53:33 +0200
Message-ID: <20260504135153.172596885@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135142.929052779@linuxfoundation.org>
References: <20260504135142.929052779@linuxfoundation.org>
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

From: Harry Yoo (Oracle) <harry@kernel.org>

commit 5b31044e649e3e54c2caef135c09b371c2fbcd08 upstream.

On UP kernels (!CONFIG_SMP), spin_trylock() is a no-op that
unconditionally succeeds even when the lock is already held. As a
result, kmalloc_nolock() called from NMI context can re-enter the slab
allocator and acquire n->list_lock that the interrupted context is
already holding, corrupting slab state.

With CONFIG_DEBUG_SPINLOCK on UP, the following BUG is triggered with
the slub_kunit test module:

  BUG: spinlock trylock failure on UP on CPU#0, kunit_try_catch/243
  [...]
  Call Trace:
   <NMI>
   dump_stack_lvl+0x3f/0x60
   do_raw_spin_trylock+0x41/0x50
   _raw_spin_trylock+0x24/0x50
   get_from_partial_node+0x120/0x4d0
   ___slab_alloc+0x8a/0x4c0
   kmalloc_nolock_noprof+0x164/0x310
   [...]
   </NMI>

Fix this by returning NULL early when invoked from NMI on a UP kernel.

Link: https://lore.kernel.org/linux-mm/ad_cqe51pvr1WaDg@hyeyoo
Cc: stable@vger.kernel.org
Fixes: af92793e52c3 ("slab: Introduce kmalloc_nolock() and kfree_nolock().")
Signed-off-by: Harry Yoo (Oracle) <harry@kernel.org>
Link: https://patch.msgid.link/20260427-nolock-api-fix-v2-2-a6b83a92d9a4@kernel.org
Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/slub.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/mm/slub.c
+++ b/mm/slub.c
@@ -5752,6 +5752,11 @@ void *kmalloc_nolock_noprof(size_t size,
 		 * sleeping lock on RT.
 		 */
 		return NULL;
+
+	/* On UP, spin_trylock() always succeeds even when it is locked */
+	if (!IS_ENABLED(CONFIG_SMP) && in_nmi())
+		return NULL;
+
 retry:
 	if (unlikely(size > KMALLOC_MAX_CACHE_SIZE))
 		return NULL;


