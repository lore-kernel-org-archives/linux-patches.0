Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64D7831E107;
	Mon, 27 Oct 2025 19:21:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761592896; cv=none; b=r0LeDuwnd/vx+BPB+jEss80f/Phl7QlUdwv9aCqLvklWptbipt0bu1hr/YIAy7VYKMrqEp1w6+EaZNL84SR3aDCJg7DdlZ47H5lAk3BFExkZWwoLKDx7Jdi5/yXdW19fyPSP+MvKHaYJHp74j7AghWvUxjmgGkY1yFGzwuTVXzw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761592896; c=relaxed/simple;
	bh=UdUUICPW08+421B06NX5nQk2HphcQsCkfAg29zvECOs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E2IEoeyIK9gj43N49lVpCwPv+TcY06htLx11Hx318U8OB2TEkrRpuLUv1omDIgHYptF0AqxwrHYoVPlv28p3150uU/zcfZM4xRWpgt6KKaDPXZmsC8Fo+KUsGKVrlvrLiPkMFFERBYkGBhPaFerLD9gW4aSi66wkYZ2x84kXxNw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qmE43Ket; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qmE43Ket"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC8B8C4CEF1;
	Mon, 27 Oct 2025 19:21:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761592896;
	bh=UdUUICPW08+421B06NX5nQk2HphcQsCkfAg29zvECOs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qmE43KetMbfXhv6u19m4zcmum4BYPmZytUmSKFd/T63dgo1HXFXvdmFygk78MmmiV
	 eeAN1guHj18OaujB20O5QOsOpW29s7qEASPaZmf7iHgEkgXXh8CfJ6nm1HjNzYlC1C
	 GHO/+FEuOFEqzJAbCwSy9Wtzeq4ZCzMnIUYkEAeE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Suren Baghdasaryan <surenb@google.com>,
	Hao Ge <gehao@kylinos.cn>,
	Harry Yoo <harry.yoo@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>
Subject: [PATCH 6.12 053/117] slab: Avoid race on slab->obj_exts in alloc_slab_obj_exts
Date: Mon, 27 Oct 2025 19:36:19 +0100
Message-ID: <20251027183455.445639400@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183453.919157109@linuxfoundation.org>
References: <20251027183453.919157109@linuxfoundation.org>
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

commit 6ed8bfd24ce1cb31742b09a3eb557cd008533eec upstream.

If two competing threads enter alloc_slab_obj_exts() and one of them
fails to allocate the object extension vector, it might override the
valid slab->obj_exts allocated by the other thread with
OBJEXTS_ALLOC_FAIL. This will cause the thread that lost this race and
expects a valid pointer to dereference a NULL pointer later on.

Update slab->obj_exts atomically using cmpxchg() to avoid
slab->obj_exts overrides by racing threads.

Thanks for Vlastimil and Suren's help with debugging.

Fixes: f7381b911640 ("slab: mark slab->obj_exts allocation failures unconditionally")
Cc: <stable@vger.kernel.org>
Suggested-by: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Hao Ge <gehao@kylinos.cn>
Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
Reviewed-by: Suren Baghdasaryan <surenb@google.com>
Link: https://patch.msgid.link/20251021010353.1187193-1-hao.ge@linux.dev
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/slub.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/mm/slub.c
+++ b/mm/slub.c
@@ -1943,7 +1943,7 @@ static inline void mark_objexts_empty(st
 
 static inline void mark_failed_objexts_alloc(struct slab *slab)
 {
-	slab->obj_exts = OBJEXTS_ALLOC_FAIL;
+	cmpxchg(&slab->obj_exts, 0, OBJEXTS_ALLOC_FAIL);
 }
 
 static inline void handle_failed_objexts_alloc(unsigned long obj_exts,
@@ -2008,6 +2008,7 @@ int alloc_slab_obj_exts(struct slab *sla
 #ifdef CONFIG_MEMCG
 	new_exts |= MEMCG_DATA_OBJEXTS;
 #endif
+retry:
 	old_exts = READ_ONCE(slab->obj_exts);
 	handle_failed_objexts_alloc(old_exts, vec, objects);
 	if (new_slab) {
@@ -2017,8 +2018,7 @@ int alloc_slab_obj_exts(struct slab *sla
 		 * be simply assigned.
 		 */
 		slab->obj_exts = new_exts;
-	} else if ((old_exts & ~OBJEXTS_FLAGS_MASK) ||
-		   cmpxchg(&slab->obj_exts, old_exts, new_exts) != old_exts) {
+	} else if (old_exts & ~OBJEXTS_FLAGS_MASK) {
 		/*
 		 * If the slab is already in use, somebody can allocate and
 		 * assign slabobj_exts in parallel. In this case the existing
@@ -2027,6 +2027,9 @@ int alloc_slab_obj_exts(struct slab *sla
 		mark_objexts_empty(vec);
 		kfree(vec);
 		return 0;
+	} else if (cmpxchg(&slab->obj_exts, old_exts, new_exts) != old_exts) {
+		/* Retry if a racing thread changed slab->obj_exts from under us. */
+		goto retry;
 	}
 
 	kmemleak_not_leak(vec);


