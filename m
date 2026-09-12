Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D112376BCD;
	Sat, 12 Sep 2026 13:25:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789219559; cv=none; b=ZJKRhQJMhgjgBXugPDUPkaGopHsPf0Bnr580YysFAAQXaFCqOQIUL5P9W2oShzLadqobVLW9ODNKBciaFnW611PH1MkSHg1yCa1hU1QsiU/eLSXQwQ1D54GYRSCgbkWGQsYTfPZFzaWE16LXsjytpLgqHAGehuMLccx3nXzsBkg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789219559; c=relaxed/simple;
	bh=cFNrBiBTq/j+ihiPmHT78WdRozwpFWLKVDESy3qkLdA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Pog9q5I9ySSG6wLn5csE80yZbgcP9I7WKujU8YlF6fSSA/r1E5zA1hE4Z9HJnntrDN+pKITdHuwBA2Cs34DcaG2FFXR7hcNMOW7ufyeep5B7pZsqI21qNJCiMzwF2XoQQjDyhi6EocJj9C6ngAn6RiHts/q87YhFY4zj7krXfDI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nRJdGoxE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nRJdGoxE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4160F1F000FF;
	Sat, 12 Sep 2026 13:25:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789219558;
	bh=oKIp14KoQzQc4e36vP3/HxNwtXz36T6nNBqzeNJSxIE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nRJdGoxEkx5C+GWOiQvkR/9MOqmJiY9dvyCevxInUj1JcVWf8sctiYVN4A+gYEZ2I
	 E8mPnT+3NAqfzcvH+l+WddcVtQdImRtKuUEkWzR7wa49PblFOd1ZdAiI5WvK7mrI75
	 Uf67knRfMTqgGE9vUT5dRiJg/BboVWTxiD8CYPzE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hao Ge <gehao@kylinos.cn>,
	Suren Baghdasaryan <surenb@google.com>,
	Harry Yoo <harry.yoo@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>
Subject: [PATCH 6.12 1374/1376] slab: reset slab->obj_ext when freeing and it is OBJEXTS_ALLOC_FAIL
Date: Sat, 12 Sep 2026 09:03:20 +0200
Message-ID: <20260912065638.156668605@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hao Ge <gehao@kylinos.cn>

commit 86f54f9b6c17d6567c69e3a6fed52fdf5d7dbe93 upstream.

If obj_exts allocation failed, slab->obj_exts is set to OBJEXTS_ALLOC_FAIL,
But we do not clear it when freeing the slab. Since OBJEXTS_ALLOC_FAIL and
MEMCG_DATA_OBJEXTS currently share the same bit position, during the
release of the associated folio, a VM_BUG_ON_FOLIO() check in
folio_memcg_kmem() is triggered because the OBJEXTS_ALLOC_FAIL flag was
not cleared, causing it to be interpreted as a kmem folio (non-slab)
with MEMCG_OBJEXTS_DATA flag set, which is invalid because
MEMCG_OBJEXTS_DATA is supposed to be set only on slabs.

Another problem that predates sharing the OBJEXTS_ALLOC_FAIL and
MEMCG_DATA_OBJEXTS bits is that on configurations with
is_check_pages_enabled(), the non-cleared bit in page->memcg_data will
trigger a free_page_is_bad() failure "page still charged to cgroup"

When freeing a slab, we clear slab->obj_exts if the obj_ext array has
been successfully allocated. So let's clear it also when the allocation
has failed.

Fixes: 09c46563ff6d ("codetag: debug: introduce OBJEXTS_ALLOC_FAIL to mark failed slab_ext allocations")
Fixes: 7612833192d5 ("slab: Reuse first bit for OBJEXTS_ALLOC_FAIL")
Link: https://lore.kernel.org/all/20251015141642.700170-1-hao.ge@linux.dev/
Cc: <stable@vger.kernel.org>
Signed-off-by: Hao Ge <gehao@kylinos.cn>
Reviewed-by: Suren Baghdasaryan <surenb@google.com>
Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/slub.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/mm/slub.c
+++ b/mm/slub.c
@@ -2161,8 +2161,15 @@ alloc_tagging_slab_free_hook(struct kmem
 		return;
 
 	obj_exts = slab_obj_exts(slab);
-	if (!obj_exts)
+	if (!obj_exts) {
+		/*
+		 * If obj_exts allocation failed, slab->obj_exts is set to
+		 * OBJEXTS_ALLOC_FAIL. In this case, we end up here and should
+		 * clear the flag.
+		 */
+		slab->obj_exts = 0;
 		return;
+	}
 
 	for (i = 0; i < objects; i++) {
 		unsigned int off = obj_to_index(s, slab, p[i]);


