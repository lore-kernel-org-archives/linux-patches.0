Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE9391DF24B;
	Wed,  6 Nov 2024 12:25:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730895954; cv=none; b=WuPum9yNTq4Sb+OCG5hBH8EoqWPmPeu4eht2a3pFF+EuQXZPXtyYYHPBTuTYp4G8AwQ7IlruC1hFwy2XkT10rzND0eSN/aQ6UWxS42ymGU+4Ga3X9VyXIupqhE7AKXXH6vX7f0ye2XfmPjjotDrBbwGpO11NZmzorhzCLe8NoYs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730895954; c=relaxed/simple;
	bh=KePHUj2f/ZWIPHroLTvUsfbyFhVZr799O7g3fzSShCA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eqX+ny0PsA9+ZMn8Eh2D/RLz6GrtFnc4V+g4fXc8DY7qPQMWYR6qpQ0fQMML+b8gbdnTdDPE0FXxy4CPJ8G8Ys4dwyWGWc73h/jIwIXtAzuY0px/01rt+Cu4a/O0WWcx1ZqqXKYYbBJrIwV80unwr2XESvq++gMMt0mbpX11Xco=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M5zVfEfR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M5zVfEfR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74356C4CECD;
	Wed,  6 Nov 2024 12:25:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730895953;
	bh=KePHUj2f/ZWIPHroLTvUsfbyFhVZr799O7g3fzSShCA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=M5zVfEfRnhnOtzqkXz8WJi7lj2tIeQPl9CQYgHL4vnbjXV0zwxpF0FdTMY4TGFRQC
	 G17fgoGYx6xPNsIpC8e2dFeyW9bCQ4jOsSh9O98P6Cg6usZMuXA9VK4A8xrUWVPTsB
	 /GerCZw1ADe4cBoUjsVH3QMwYnyIUMn/XU/JNkOM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pei Xiao <xiaopei01@kylinos.cn>,
	Vlastimil Babka <vbabka@suse.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 005/245] slub/kunit: fix a WARNING due to unwrapped __kmalloc_cache_noprof
Date: Wed,  6 Nov 2024 13:00:58 +0100
Message-ID: <20241106120319.376694538@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120319.234238499@linuxfoundation.org>
References: <20241106120319.234238499@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pei Xiao <xiaopei01@kylinos.cn>

[ Upstream commit 2b059d0d1e624adc6e69a754bc48057f8bf459dc ]

'modprobe slub_kunit' will have a warning as shown below. The root cause
is that __kmalloc_cache_noprof was directly used, which resulted in no
alloc_tag being allocated. This caused current->alloc_tag to be null,
leading to a warning in alloc_tag_add_check.

Let's add an alloc_hook layer to __kmalloc_cache_noprof specifically
within lib/slub_kunit.c, which is the only user of this internal slub
function outside kmalloc implementation itself.

[58162.947016] WARNING: CPU: 2 PID: 6210 at
./include/linux/alloc_tag.h:125 alloc_tagging_slab_alloc_hook+0x268/0x27c
[58162.957721] Call trace:
[58162.957919]  alloc_tagging_slab_alloc_hook+0x268/0x27c
[58162.958286]  __kmalloc_cache_noprof+0x14c/0x344
[58162.958615]  test_kmalloc_redzone_access+0x50/0x10c [slub_kunit]
[58162.959045]  kunit_try_run_case+0x74/0x184 [kunit]
[58162.959401]  kunit_generic_run_threadfn_adapter+0x2c/0x4c [kunit]
[58162.959841]  kthread+0x10c/0x118
[58162.960093]  ret_from_fork+0x10/0x20
[58162.960363] ---[ end trace 0000000000000000 ]---

Signed-off-by: Pei Xiao <xiaopei01@kylinos.cn>
Fixes: a0a44d9175b3 ("mm, slab: don't wrap internal functions with alloc_hooks()")
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/slub_kunit.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/slub_kunit.c b/lib/slub_kunit.c
index e6667a28c0149..af5b9c41d5b30 100644
--- a/lib/slub_kunit.c
+++ b/lib/slub_kunit.c
@@ -140,7 +140,7 @@ static void test_kmalloc_redzone_access(struct kunit *test)
 {
 	struct kmem_cache *s = test_kmem_cache_create("TestSlub_RZ_kmalloc", 32,
 				SLAB_KMALLOC|SLAB_STORE_USER|SLAB_RED_ZONE);
-	u8 *p = __kmalloc_cache_noprof(s, GFP_KERNEL, 18);
+	u8 *p = alloc_hooks(__kmalloc_cache_noprof(s, GFP_KERNEL, 18));
 
 	kasan_disable_current();
 
-- 
2.43.0



