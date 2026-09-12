Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C452B373BF2;
	Sat, 12 Sep 2026 12:38:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789216711; cv=none; b=CjV+7CCXJad3YgZ58FlBbJwq6mg3V56rWODdO32Nhg96MEVQS6qNlTJuCyKIrLrYciQrKYCOjA5CQrKtuluWI1QOTjBU4PLgHXyGYb4bG+AZ2ElsqrQ/eyR/yqR9qWgSx32GAVIY1TvNsR27JWsQ+LwkfLNuTH0/Dj9WjbF1RBE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789216711; c=relaxed/simple;
	bh=ANu17FUVisPXOYHHbAYv7PJbTUyCRcqU22V6dTNHBgM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j+lX+TOA6tqI89fwci9Th+XkLpMQxNumilofEaKh6HoCggGjX8Wtai+0BnQGw7NHny9EGmzMEv5KkL3FGZkYLZ5C+pWpF2cKCeAPjXrV2gEItWTsAFcPQp3z29z0zpV6UcLZpbDvH7B33wS4EgjP4UYG7lbR5EKrSV0zLJXGSn0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ADc+J+/q; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ADc+J+/q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7CFC1F000FF;
	Sat, 12 Sep 2026 12:38:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789216710;
	bh=I6rX0fU8+DARci7xts5XtUFzCSfTaP18capOvV8CPDU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ADc+J+/q+tNkc3C5oEvS+pu1wx5mtvBx2ne+zLMr6KkpRgYcH22MKNjXrX5+x0AZr
	 N2W0Js0PAlJg1+5qMb09YU+niW7JP1zbhXIMziaX6NC6L2uKtJkFJujdOR2n3Ol0zi
	 THFKJP/U1xlV8EcwJb8M4T28/86J8sWYLs4cf2Z8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexei Starovoitov <ast@kernel.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Harry Yoo <harry.yoo@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0750/1376] slab: Reuse first bit for OBJEXTS_ALLOC_FAIL
Date: Sat, 12 Sep 2026 08:52:56 +0200
Message-ID: <20260912065624.257684514@linuxfoundation.org>
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

From: Alexei Starovoitov <ast@kernel.org>

[ Upstream commit 7612833192d56af86061de8ab51989b75daf5b0d ]

Since the combination of valid upper bits in slab->obj_exts with
OBJEXTS_ALLOC_FAIL bit can never happen,
use OBJEXTS_ALLOC_FAIL == (1ull << 0) as a magic sentinel
instead of (1ull << 2) to free up bit 2.

Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Stable-dep-of: 4c6eb712a91f ("wifi: ath12k: fix stride mismatch in mac_phy_caps_parse()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/memcontrol.h | 10 ++++++++--
 mm/slub.c                  |  2 +-
 2 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index e1b41554a5fb3..e4c24c94b9ef0 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -344,17 +344,23 @@ enum page_memcg_data_flags {
 	__NR_MEMCG_DATA_FLAGS  = (1UL << 2),
 };
 
+#define __OBJEXTS_ALLOC_FAIL	MEMCG_DATA_OBJEXTS
 #define __FIRST_OBJEXT_FLAG	__NR_MEMCG_DATA_FLAGS
 
 #else /* CONFIG_MEMCG */
 
+#define __OBJEXTS_ALLOC_FAIL	(1UL << 0)
 #define __FIRST_OBJEXT_FLAG	(1UL << 0)
 
 #endif /* CONFIG_MEMCG */
 
 enum objext_flags {
-	/* slabobj_ext vector failed to allocate */
-	OBJEXTS_ALLOC_FAIL = __FIRST_OBJEXT_FLAG,
+	/*
+	 * Use bit 0 with zero other bits to signal that slabobj_ext vector
+	 * failed to allocate. The same bit 0 with valid upper bits means
+	 * MEMCG_DATA_OBJEXTS.
+	 */
+	OBJEXTS_ALLOC_FAIL = __OBJEXTS_ALLOC_FAIL,
 	/* the next bit after the last actual flag */
 	__NR_OBJEXTS_FLAGS  = (__FIRST_OBJEXT_FLAG << 1),
 };
diff --git a/mm/slub.c b/mm/slub.c
index f3868bad83dbb..620e31869c624 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -1958,7 +1958,7 @@ static inline void handle_failed_objexts_alloc(unsigned long obj_exts,
 	 * objects with no tag reference. Mark all references in this
 	 * vector as empty to avoid warnings later on.
 	 */
-	if (obj_exts & OBJEXTS_ALLOC_FAIL) {
+	if (obj_exts == OBJEXTS_ALLOC_FAIL) {
 		unsigned int i;
 
 		for (i = 0; i < objects; i++)
-- 
2.53.0



