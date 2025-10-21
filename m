Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5D40274B30;
	Tue, 21 Oct 2025 19:59:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761076798; cv=none; b=geXKZ7daIyvavBEIyzQU2N2v3aqgt7ktfOL3b4+NB9wMh7Lt0Alcpf2p0ZQoHEyIfCpzt3JLs7PtYK4b5rHtuYbxIYgFI8WBpfKI70USflt5gA3cA3Ht4qqcwsTG0Ofw0YOpIKc/IwXHZKLjgtjvL3QFe8Ke7W4yjWxggfuKUsE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761076798; c=relaxed/simple;
	bh=dr7vos+97ZbW14yHpihcD9M0nWEw5OfzlOfFTwLao7g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l1HZrhUmc8at5TnbHB0jdb0oNN/UjOyLCdY1Y/W5fkfoIV8rG7bI3KX3M6VSA8ZeWVIfRi8f8EcCr9LLOhWucRn7d9bCj1eD9s3ggYLv8rQ+2b/DUbIoyNIO2eCpQqnqEAiIsgCzb+R/m2L7V0uf21iTo9Wp4t/pUoFlfxFqIOc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=o7a/Nhfw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o7a/Nhfw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B640C4CEF1;
	Tue, 21 Oct 2025 19:59:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761076798;
	bh=dr7vos+97ZbW14yHpihcD9M0nWEw5OfzlOfFTwLao7g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=o7a/NhfwprfXCCs0kO0rxS1PQPvQQFn647hHNTHDs57Q3r9jTq5bTm/InhcnnePck
	 /lvsFQ006JMzblINRFc/cZP+HFX8Maz7x4GOc1ir9VtDo4DC0hieB16eilHxFW6565
	 utR28CwBq0mty3Xu+xu2WNn8e/Mz8pWcMM0KFQRs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hao Ge <gehao@kylinos.cn>,
	Suren Baghdasaryan <surenb@google.com>,
	Harry Yoo <harry.yoo@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>
Subject: [PATCH 6.12 004/136] slab: reset slab->obj_ext when freeing and it is OBJEXTS_ALLOC_FAIL
Date: Tue, 21 Oct 2025 21:49:52 +0200
Message-ID: <20251021195036.063946102@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251021195035.953989698@linuxfoundation.org>
References: <20251021195035.953989698@linuxfoundation.org>
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
@@ -2038,8 +2038,15 @@ static inline void free_slab_obj_exts(st
 	struct slabobj_ext *obj_exts;
 
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
 
 	/*
 	 * obj_exts was created with __GFP_NO_OBJ_EXT flag, therefore its


