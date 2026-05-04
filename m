Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 512AF3DE42E;
	Mon,  4 May 2026 14:07:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777903624; cv=none; b=M9VOBLx05yoQ1LJKa+6mhAVUy3Gctzl4LiAiUHV1bln8whEQg8C36kFX378wi6EaeJkc9d9PM5rUJzP7Kk9TFJVDaAj7zepIh0K2xX54TyXiQY/3vulMhpzXfljv4olOfvIcxxQj84Mpizk0dQKUZqRqRyUitKM7QilbAYsakis=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777903624; c=relaxed/simple;
	bh=saf4FuTt+kIUGEAFUHI2ARmM1oren+kqbyMDmcsaV7E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JOJadJcnx2xPhG7RMphcMXuR7RyEAZjKZPPQjhpmjqEdYLte1apWdybuTdfuzqYKiOG/MYwvI148hrONU2TISGyRHbfT2Fs51MkhcMRZJMDv+ODz296UUUGC3qQr55AFZF7S6mx4vBkkFyfFTYGtiL3phEe+1GpUaenlHY1BSwI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UdTw/Odf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UdTw/Odf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0050C2BCB8;
	Mon,  4 May 2026 14:07:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777903624;
	bh=saf4FuTt+kIUGEAFUHI2ARmM1oren+kqbyMDmcsaV7E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UdTw/Odf88s36xcahW+Bxtwjs9Nfdk9nNEkzbdgcuk/WXR8E5sS/3yXSafMGUBLmt
	 1WPeSa6Fyspzhtr6s5BAZlRR3darFJZf2niszxVyCvNAxL3WXWZEd+qWebuaYrh6HD
	 G9VvzzRy/EFv9liSXeZIu0AKakoE9GZE1Xl0sDck=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Harry Yoo (Oracle)" <harry@kernel.org>,
	"Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Subject: [PATCH 7.0 305/307] mm/slab: return NULL early from kmalloc_nolock() in NMI on UP
Date: Mon,  4 May 2026 15:53:10 +0200
Message-ID: <20260504135154.247965613@linuxfoundation.org>
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
 mm/slub.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/mm/slub.c
+++ b/mm/slub.c
@@ -5304,6 +5304,10 @@ void *kmalloc_nolock_noprof(size_t size,
 	if (IS_ENABLED(CONFIG_PREEMPT_RT) && (in_nmi() || in_hardirq()))
 		return NULL;
 
+	/* On UP, spin_trylock() always succeeds even when it is locked */
+	if (!IS_ENABLED(CONFIG_SMP) && in_nmi())
+		return NULL;
+
 retry:
 	if (unlikely(size > KMALLOC_MAX_CACHE_SIZE))
 		return NULL;


