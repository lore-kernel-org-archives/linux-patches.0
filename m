Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 631AC315785;
	Mon,  4 May 2026 14:19:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777904352; cv=none; b=hr5fk0g5ybDu9hL/ZAw2HmYA/be9COIySrxfA1AF3HV53kO0VSd0qjgxFWBeWme2lsClHd5p/5KqNU2szXj0VBc/XhVvmR3sXxPSCEUzxR9twvNtfrMyf1OtJjoD2H7kfiRLvAV9Nr6DyGyQmn+HfCKEWBl5ywPq+7Hw0j99crA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777904352; c=relaxed/simple;
	bh=JHAwbQjf+H6aZQl69lHPOT7vY6jZhgMU1CZ5ADXFoec=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cY7b99U6yZUP1dFOGewZQRhrRgDI2rTpSRF3nB55hEIBAjhnES6J2r4AFz3Axmnsq+wI9J/I9oS/iouQQ3CTGPW3X0lb2FOY1izf8cjfJqddHhGtG6r3bb3VAdhOQwhTKzcGTh+ZMb0VRB4NPpeOVreJhsotb5Kv/QKcFnTvi8o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gHPpHvzC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gHPpHvzC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE1E4C2BCB8;
	Mon,  4 May 2026 14:19:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777904352;
	bh=JHAwbQjf+H6aZQl69lHPOT7vY6jZhgMU1CZ5ADXFoec=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gHPpHvzCTrQ/RZmyZtlG0AWIexWuSw7JBzsNA+TJfnL96y2QXT3HELwfK+YOfZAAt
	 M7rDKS2Qyf9Hj8aPb3f93fgdpKrZ5PSpb5Q3Qg3e38Ah8uvy8hkfr6fQsguhqqdxh9
	 BDv+8kFbFPKR6poF5kb4NCPeDqysnjZF1i+dhiio=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Harry Yoo (Oracle)" <harry@kernel.org>,
	"Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Subject: [PATCH 6.18 272/275] mm/page_alloc: return NULL early from alloc_frozen_pages_nolock() in NMI on UP
Date: Mon,  4 May 2026 15:53:32 +0200
Message-ID: <20260504135153.136894128@linuxfoundation.org>
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

commit 620b46ed6ae17c8438d889c8c0cfddab36a1476c upstream.

On UP kernels (!CONFIG_SMP), spin_trylock() is a no-op that
unconditionally succeeds even when the lock is already held. As a
result, alloc_frozen_pages_nolock() called from NMI context can
re-enter rmqueue() and acquire the zone lock that the interrupted
context is already holding, corrupting the freelists.

With CONFIG_DEBUG_SPINLOCK on UP, the following BUG is triggered with
the slub_kunit test module:

  BUG: spinlock trylock failure on UP on CPU#0, kunit_try_catch/243
  [...]
  Call Trace:
   <NMI>
   dump_stack_lvl+0x3f/0x60
   do_raw_spin_trylock+0x41/0x50
   _raw_spin_trylock+0x24/0x50
   rmqueue.isra.0+0x2a9/0xa70
   get_page_from_freelist+0xeb/0x450
   alloc_frozen_pages_nolock_noprof+0x111/0x1e0
   allocate_slab+0x42a/0x500
   ___slab_alloc+0xa7/0x4c0
   kmalloc_nolock_noprof+0x164/0x310
   [...]
   </NMI>

Fix this by returning NULL early when invoked from NMI on a UP kernel.

Link: https://lore.kernel.org/linux-mm/ad_cqe51pvr1WaDg@hyeyoo
Cc: stable@vger.kernel.org
Fixes: d7242af86434 ("mm: Introduce alloc_frozen_pages_nolock()")
Signed-off-by: Harry Yoo (Oracle) <harry@kernel.org>
Link: https://patch.msgid.link/20260427-nolock-api-fix-v2-1-a6b83a92d9a4@kernel.org
Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/page_alloc.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -7641,6 +7641,11 @@ struct page *alloc_frozen_pages_nolock_n
 	 */
 	if (IS_ENABLED(CONFIG_PREEMPT_RT) && (in_nmi() || in_hardirq()))
 		return NULL;
+
+	/* On UP, spin_trylock() always succeeds even when it is locked */
+	if (!IS_ENABLED(CONFIG_SMP) && in_nmi())
+		return NULL;
+
 	if (!pcp_allowed_order(order))
 		return NULL;
 


