Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BE237C0AB;
	Mon,  8 Apr 2024 13:39:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712583576; cv=none; b=dGIbZHbl5ojcF+uXfhz4/uGjQyVDGBoZb0nctfKeVbB5jVL4UKlVQX3m3YvQ+A3Zw4wgVpOdi3a5r154BRaSyL2Jst3/HZWsaeaGVDqxGguExhZ8v9N/9xGy0lpSnTeXeoxAsrAuTG83M08zH7KbnwVnjhUc40Z5CzZDswZ8jq0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712583576; c=relaxed/simple;
	bh=V3JpCMa86AIj6qslayMHkbMwuJR/cAHVta0EDLlXT5E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o6CYwVGxb+RysZ3yqcU+PHbxGwTLD4wk3vhA9Zfx0gR6TZc43fuGT71w0Vv5ksrgVN3TK67uKQviYmo208agppQ1NWmKzJh38garxhTXbK9SSZLdrO05GGa2BmnPM6gdgA6jVZmRZRlIeIznyq0MrRGFPjPJ5qgtGnqYO1pUhxw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pWnNnXTv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pWnNnXTv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6F2CC43390;
	Mon,  8 Apr 2024 13:39:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712583576;
	bh=V3JpCMa86AIj6qslayMHkbMwuJR/cAHVta0EDLlXT5E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pWnNnXTve9nsG2w9ozIPSTpNti7vv68PwpoX1BuwwOrTrsBgQpIDgYX4Ti7rwx0yb
	 dMH1hWk2C4Tfesq7YSLb8Ff60KdOkRWar1Z2dYouDvWd/TIM1XgGdkEHGk/uXriOX3
	 1CQuSuymbStXCo/E/6On86fimuN0OKmAC7VrjWv0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Collingbourne <pcc@google.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Alexander Potapenko <glider@google.com>,
	Marco Elver <elver@google.com>,
	Oscar Salvador <osalvador@suse.de>,
	Andrey Konovalov <andreyknvl@gmail.com>,
	Michal Hocko <mhocko@suse.com>,
	Omar Sandoval <osandov@fb.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 193/273] stackdepot: rename pool_index to pool_index_plus_1
Date: Mon,  8 Apr 2024 14:57:48 +0200
Message-ID: <20240408125315.310219564@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125309.280181634@linuxfoundation.org>
References: <20240408125309.280181634@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Collingbourne <pcc@google.com>

[ Upstream commit a6c1d9cb9a68bfa4512248419c4f4d880d19fe90 ]

Commit 3ee34eabac2a ("lib/stackdepot: fix first entry having a 0-handle")
changed the meaning of the pool_index field to mean "the pool index plus
1".  This made the code accessing this field less self-documenting, as
well as causing debuggers such as drgn to not be able to easily remain
compatible with both old and new kernels, because they typically do that
by testing for presence of the new field.  Because stackdepot is a
debugging tool, we should make sure that it is debugger friendly.
Therefore, give the field a different name to improve readability as well
as enabling debugger backwards compatibility.

This is needed in 6.9, which would otherwise become an odd release with
the new semantics and old name so debuggers wouldn't recognize the new
semantics there.

Fixes: 3ee34eabac2a ("lib/stackdepot: fix first entry having a 0-handle")
Link: https://lkml.kernel.org/r/20240402001500.53533-1-pcc@google.com
Link: https://linux-review.googlesource.com/id/Ib3e70c36c1d230dd0a118dc22649b33e768b9f88
Signed-off-by: Peter Collingbourne <pcc@google.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: Alexander Potapenko <glider@google.com>
Acked-by: Marco Elver <elver@google.com>
Acked-by: Oscar Salvador <osalvador@suse.de>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Omar Sandoval <osandov@fb.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/stackdepot.h | 7 +++----
 lib/stackdepot.c           | 4 ++--
 2 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/include/linux/stackdepot.h b/include/linux/stackdepot.h
index c4b5ad57c0660..bf0136891a0f2 100644
--- a/include/linux/stackdepot.h
+++ b/include/linux/stackdepot.h
@@ -44,10 +44,9 @@ typedef u32 depot_stack_handle_t;
 union handle_parts {
 	depot_stack_handle_t handle;
 	struct {
-		/* pool_index is offset by 1 */
-		u32 pool_index	: DEPOT_POOL_INDEX_BITS;
-		u32 offset	: DEPOT_OFFSET_BITS;
-		u32 extra	: STACK_DEPOT_EXTRA_BITS;
+		u32 pool_index_plus_1	: DEPOT_POOL_INDEX_BITS;
+		u32 offset		: DEPOT_OFFSET_BITS;
+		u32 extra		: STACK_DEPOT_EXTRA_BITS;
 	};
 };
 
diff --git a/lib/stackdepot.c b/lib/stackdepot.c
index ee4bbe6513aa4..ee830f14afb78 100644
--- a/lib/stackdepot.c
+++ b/lib/stackdepot.c
@@ -330,7 +330,7 @@ static struct stack_record *depot_pop_free_pool(void **prealloc, size_t size)
 	stack = current_pool + pool_offset;
 
 	/* Pre-initialize handle once. */
-	stack->handle.pool_index = pool_index + 1;
+	stack->handle.pool_index_plus_1 = pool_index + 1;
 	stack->handle.offset = pool_offset >> DEPOT_STACK_ALIGN;
 	stack->handle.extra = 0;
 	INIT_LIST_HEAD(&stack->hash_list);
@@ -441,7 +441,7 @@ static struct stack_record *depot_fetch_stack(depot_stack_handle_t handle)
 	const int pools_num_cached = READ_ONCE(pools_num);
 	union handle_parts parts = { .handle = handle };
 	void *pool;
-	u32 pool_index = parts.pool_index - 1;
+	u32 pool_index = parts.pool_index_plus_1 - 1;
 	size_t offset = parts.offset << DEPOT_STACK_ALIGN;
 	struct stack_record *stack;
 
-- 
2.43.0



