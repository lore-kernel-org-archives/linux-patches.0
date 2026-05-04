Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 787961ADC83;
	Mon,  4 May 2026 14:07:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777903621; cv=none; b=PBa7wllls+ryc6CGso2HaKJXRIc12VPWA1wFwGHuEZdv4shBHKkyA0RDtm6nlYNHLUcpKYn4TMBCWfUEpBNdgwJInouENYXurDAbrUWpRGOXVBE8yyaATzE7mCgbyphUSVY79TsyzaibcRvH9VTC9rqy5yYQZujA6jnUlAo1W3E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777903621; c=relaxed/simple;
	bh=gsWmpGXsYvb/kHn81N/qngiMGTOzZzdCkigtj3bzLXs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SusPMzbIdkqoVYboNICh3HKECHccSwF3el57ZDyJQeUehTVWUteH0kFW1sQPUuktddGH5YCmp/MbHxXbDWP3RdxjM6/FMaMBdE4aQkBEZkp2la4fUeqQ7mEZqE7/+YLtenI/YdPbF448JYEnor1zN35EilDPQFe13wvHvWy4kSU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sCTVfJmc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sCTVfJmc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EC6BC2BCB8;
	Mon,  4 May 2026 14:07:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777903621;
	bh=gsWmpGXsYvb/kHn81N/qngiMGTOzZzdCkigtj3bzLXs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sCTVfJmchhfg52M87xteWh4g2u57qRorCxB4dmUGMVPu34bmKvGERwQxFWKDaXp5f
	 +D7bydlQBorQclgD3oZ8c25NF9zsie4tlkj8JfERVA8Cou+rp8cHv589b0WNGnwS5N
	 Ef3Zhh9vnpvnrkdIbqP9bMbNrg/TwGI+CJrS/0jk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Harry Yoo (Oracle)" <harry@kernel.org>,
	"Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Subject: [PATCH 7.0 304/307] mm/page_alloc: return NULL early from alloc_frozen_pages_nolock() in NMI on UP
Date: Mon,  4 May 2026 15:53:09 +0200
Message-ID: <20260504135154.211569333@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135142.814938198@linuxfoundation.org>
References: <20260504135142.814938198@linuxfoundation.org>
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
@@ -7806,6 +7806,11 @@ struct page *alloc_frozen_pages_nolock_n
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
 


