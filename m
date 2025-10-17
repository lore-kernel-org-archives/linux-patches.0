Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF89633506F;
	Fri, 17 Oct 2025 15:23:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760714600; cv=none; b=gxt7qYw9R1UL/qwwecnItse9a4Mz15qd2uUaoSz4NXf5y5SnvZV2hFS9AQ25jerjQYjHKydeDtAbljv6+mm8X3fl8p4fFfKH5lLTaDORRyp/SmLLD3uGS++XlCJfd0t+u+tRlzCop1wpDrm9s0rEEhiuayAtCtBTZpQT74RZZ3Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760714600; c=relaxed/simple;
	bh=DeLTXT9bCgUVw2AIYNmMe3bKezOQI4GW+OsfhvfGJDg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QWUsncIJvuiTu5RS7KJzejH3cLejNNJYX3A5k5rwhb69uU2bLpu4jNOt1O9yVMUH065QX+N3PiuMcxpUqf+9ovTM3ocQJZ7ROh56waMNJ4NsAo05jigjohTlBJwaI6A/BPyh5E1cblEMV/JFAW3ugLLTiAmdXO7uevMi4/DD+V0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TKgdrtWr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TKgdrtWr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5132C4CEFE;
	Fri, 17 Oct 2025 15:23:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760714600;
	bh=DeLTXT9bCgUVw2AIYNmMe3bKezOQI4GW+OsfhvfGJDg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TKgdrtWrywAGU73I3F3upZUSOz86CBxW7N3jFh2lIYuscuhixI8i4FkcmhPPnze4f
	 1Dji3XOlQmHXtW4rGYDyRcsxkG6GfKJDbquFPxkwsgCU5lqgvqK3ZBXjGepSWyKEN6
	 AQKuPsTFsS46We17PPLxDrG9tOYP5+Fb2V3jvgaM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@suse.cz>
Subject: [PATCH 6.12 200/277] slab: prevent warnings when slab obj_exts vector allocation fails
Date: Fri, 17 Oct 2025 16:53:27 +0200
Message-ID: <20251017145154.423127012@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145147.138822285@linuxfoundation.org>
References: <20251017145147.138822285@linuxfoundation.org>
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
@@ -572,8 +572,12 @@ static inline struct slabobj_ext *slab_o
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


