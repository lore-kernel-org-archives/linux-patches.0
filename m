Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD31526B96A;
	Fri, 17 Oct 2025 15:43:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760715800; cv=none; b=RQ7w0Qy7XkAluGsSSXMZ/cMhVxHp708C3xWXu7673DTmGKjLmOuObQu1L2nuTw+F6wnk+3SSVtJoMZkwadJqjYFmRBtof/ckPK0UHsdPmS6K4YA+QjlGBO8R4d1LcvXlksA01aFt8BS/+c+nM6vEUgAcR6Zd4eZMwdtgZCFGgD0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760715800; c=relaxed/simple;
	bh=0MD3Ul0TKWwwqwQd4nkP/huX8q0fp0AzYk6uHYdReyM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pkshsnWbVamc3Yr1ujBBlG2eK+72Mwr3jdeZDhlQM3O5weS5KpKxlSivDZMytRsDKAieE8WdWSYvd5ZzlgxlIi/aQ+niw4qsNEjB9P4Xo38MV4ktpqWAPiiaamOXHso9drrPaXLJHuWTCpvyKEfUZ7if7OAe3VNoKRsL9XtyAGU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JgbxKPaZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JgbxKPaZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2AE2C4CEE7;
	Fri, 17 Oct 2025 15:43:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760715800;
	bh=0MD3Ul0TKWwwqwQd4nkP/huX8q0fp0AzYk6uHYdReyM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JgbxKPaZ4oUXlbKkUBbOwRqOXoJKX/gvjd2d4uFtT4pMVcljvSbIUkRDeGm2RM3jC
	 7N3B0iqvJAq1IFdNuWQVhTgMDw1cN/nNpzZLQEaF41zba9DratJvH46JqlZadQBlct
	 O17FNYEhhUS7EhkabAuopah7TWBx34Sf3pTgFm5E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@suse.cz>
Subject: [PATCH 6.17 308/371] slab: prevent warnings when slab obj_exts vector allocation fails
Date: Fri, 17 Oct 2025 16:54:43 +0200
Message-ID: <20251017145213.220244790@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145201.780251198@linuxfoundation.org>
References: <20251017145201.780251198@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Suren Baghdasaryan <surenb@google.com>

commit 4038016397da5c1cebb10e7c85a36d06123724a8 upstream.

When object extension vector allocation fails, we set slab->obj_exts to
OBJEXTS_ALLOC_FAIL to indicate the failure. Later, once the vector is
successfully allocated, we will use this flag to mark codetag references
stored in that vector as empty to avoid codetag warnings.

slab_obj_exts() used to retrieve the slab->obj_exts vector pointer checks
slab->obj_exts for being either NULL or a pointer with MEMCG_DATA_OBJEXTS
bit set. However it does not handle the case when slab->obj_exts equals
OBJEXTS_ALLOC_FAIL. Add the missing condition to avoid extra warning.

Fixes: 09c46563ff6d ("codetag: debug: introduce OBJEXTS_ALLOC_FAIL to mark failed slab_ext allocations")
Reported-by: Shakeel Butt <shakeel.butt@linux.dev>
Closes: https://lore.kernel.org/all/jftidhymri2af5u3xtcqry3cfu6aqzte3uzlznhlaylgrdztsi@5vpjnzpsemf5/
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Cc: stable@vger.kernel.org # v6.10+
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/slab.h |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/mm/slab.h
+++ b/mm/slab.h
@@ -526,8 +526,12 @@ static inline struct slabobj_ext *slab_o
 	unsigned long obj_exts = READ_ONCE(slab->obj_exts);
 
 #ifdef CONFIG_MEMCG
-	VM_BUG_ON_PAGE(obj_exts && !(obj_exts & MEMCG_DATA_OBJEXTS),
-							slab_page(slab));
+	/*
+	 * obj_exts should be either NULL, a valid pointer with
+	 * MEMCG_DATA_OBJEXTS bit set or be equal to OBJEXTS_ALLOC_FAIL.
+	 */
+	VM_BUG_ON_PAGE(obj_exts && !(obj_exts & MEMCG_DATA_OBJEXTS) &&
+		       obj_exts != OBJEXTS_ALLOC_FAIL, slab_page(slab));
 	VM_BUG_ON_PAGE(obj_exts & MEMCG_DATA_KMEM, slab_page(slab));
 #endif
 	return (struct slabobj_ext *)(obj_exts & ~OBJEXTS_FLAGS_MASK);


