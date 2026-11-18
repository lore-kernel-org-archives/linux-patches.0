Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795038593;
	b=AIK8JD+Vzm0DsMcib0IobTcY70O0pELLPvAZcEzGJnxehXF7eHmrnKtT5YpGZSlklLWW
	 UiSb7A9jdlQ4nImOsAMzUkP6HcT5aH4lzHTiQIE5l8fICxQH+eEfMvqAekaEMCmkZQ4Xn
	 3OyxZxM+NcL4g4/tMMpsHARtm13Buhb9w5dVfcl7IElCWwRjO3bfLcO4FweOqdafXBxZR
	 309F2t/SysSJcEV0pyIZpr+d3MxrTwFn1Bq6IURlvjYdE140q1CxLSEt+zUZEPzNexRYr
	 I9z8z/K7cF8xg33+o9bMnomNphbG6GqtHtrS9Xp81KXpg3JUyK/t0BJtF+DVUzi4EDQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795038593;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=2dSdg3ZAz6yqvkRO9Xryn8pSZyZ4BhDIA2Gvn9h1/94=;
	b=G4eW4hfBhnOk59zQ2otstFL+tnVecDBMU7DhLgfOPAzfBC3Tqg1weD2FS8Ku+jhlsyXi
	 GKbaGHIIzPQaWOtJrwNV+zcJy/j2Cs801e0nAKOdRhk9DfDkIi3otxurH90z/6gH2AdGi
	 XMs+M7zCADVQeVVp2GDCPiPiTlyy8qCB1A7LUaOeA4Tdq6q/cpuCd+sfWgq9kS3kJVB93
	 WkAV+KqzybrPkMHbAf1JJXl6ExrMaTpyyvqjLiIgakz533DGHPKGh/MvRj2MKodAQYPFx
	 2OVE27rSG4Y3zOhf6TuCulKwWRaCt/jROQiTdeoU5nhokWFqKaooXR8OSkRt/kxaG/w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qOrdcPRt;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4432560A2606;
	Wed, 18 Nov 2026 21:49:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qOrdcPRt
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D1A81F000C6;
	Wed, 18 Nov 2026 21:49:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795038593;
	bh=2dSdg3ZAz6yqvkRO9Xryn8pSZyZ4BhDIA2Gvn9h1/94=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qOrdcPRttoCTCc+Ohd/ChwQvpwa7jDMGgzjrPegbM1uS4uUv2voP7V/qT3A807Vf/
	 u95zDecjijO3xWI0uBHrInXuRL/w6tiZ1cQFQlqwxNdxoA6wb68ZV2lACWt46HXuri
	 FSp/G6Y3seiFbhe+fuyPZRXc+dUVK7c8DuXkP6PY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Giorgi Kobakhia <gkobakhi@asu.edu>,
	Andrew Morton <akpm@linux-foundation.org>,
	Xiang Mei <xmei5@asu.edu>,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1799/3318] ocfs2: fix array out of bound access in __ocfs2_find_path()
Date: Wed, 18 Nov 2026 15:40:21 +0100
Message-ID: <20261118150415.826862587@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Giorgi Kobakhia <gkobakhi@asu.edu>

[ Upstream commit 6193ce7896afb52a321a0063c8b6a45e477a84e2 ]

__ocfs2_find_path() walks down the extent tree and records path by calling
find_path_ins(), which appends entry to path->p_node[].  It only has 5
spots.

A corrupted ocfs2 image whose extent block is pointing to itself causes
__ocfs2_find_path() descent endlessly, writing past the end of
path->p_node[] array.

 UBSAN: array-index-out-of-bounds in fs/ocfs2/alloc.c:677:14
 index 5 is out of range for type 'ocfs2_path_item [5]'
 Call Trace:
  <TASK>
  find_path_ins (fs/ocfs2/alloc.c:677 fs/ocfs2/alloc.c:1914)
  __ocfs2_find_path.constprop.0 (fs/ocfs2/alloc.c:1882)
  ocfs2_commit_truncate (fs/ocfs2/alloc.c:1924 fs/ocfs2/alloc.c:7286)
  ocfs2_truncate_file (fs/ocfs2/file.c:515)
  ocfs2_setattr (fs/ocfs2/file.c:1224)
  notify_change (fs/attr.c:556)
  do_truncate (fs/open.c:68)
  do_ftruncate (fs/open.c:194 (discriminator 1))
  ksys_ftruncate (fs/open.c:206)
  __x64_sys_ftruncate (fs/open.c:211 fs/open.c:209 fs/open.c:209)

Commit a406aff8c051 ("ocfs2: validate l_tree_depth to avoid out-of-bounds
access") already restricts el->l_tree_depth to be less than
OCFS2_MAX_PATH_DEPTH, which is equal to 5.  However, does not handle the
infinite descent case.

Check if the el->l_tree_depth decreases on each descent.  Maximum descents
are restricted to 4 and the path->p_node[] array does not overflow.

Link: https://lore.kernel.org/20260922202159.2421642-1-gkobakhi@asu.edu
Fixes: dcd0538ff4e8 ("ocfs2: sparse b-tree support")
Signed-off-by: Giorgi Kobakhia <gkobakhi@asu.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Tested-by: Xiang Mei <xmei5@asu.edu>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Assisted-by: LLM
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ocfs2/alloc.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
index 038cee19dfad3..7e48626dfa9bc 100644
--- a/fs/ocfs2/alloc.c
+++ b/fs/ocfs2/alloc.c
@@ -1789,6 +1789,7 @@ static int __ocfs2_find_path(struct ocfs2_caching_info *ci,
 	int i, ret = 0;
 	u32 range;
 	u64 blkno;
+	u32 prev_depth = OCFS2_MAX_PATH_DEPTH;
 	struct buffer_head *bh = NULL;
 	struct ocfs2_extent_block *eb;
 	struct ocfs2_extent_list *el;
@@ -1796,14 +1797,16 @@ static int __ocfs2_find_path(struct ocfs2_caching_info *ci,
 
 	el = root_el;
 	while (el->l_tree_depth) {
-		if (unlikely(le16_to_cpu(el->l_tree_depth) >= OCFS2_MAX_PATH_DEPTH)) {
+		if (unlikely(le16_to_cpu(el->l_tree_depth) >= prev_depth)) {
 			ocfs2_error(ocfs2_metadata_cache_get_super(ci),
-				    "Owner %llu has invalid tree depth %u in extent list\n",
+				    "Owner %llu has invalid tree depth %u in extent list (max %u)\n",
 				    (unsigned long long)ocfs2_metadata_cache_owner(ci),
-				    le16_to_cpu(el->l_tree_depth));
+				    le16_to_cpu(el->l_tree_depth), prev_depth - 1);
 			ret = -EROFS;
 			goto out;
 		}
+		prev_depth = le16_to_cpu(el->l_tree_depth);
+
 		if (!el->l_next_free_rec || !el->l_count) {
 			ocfs2_error(ocfs2_metadata_cache_get_super(ci),
 				    "Owner %llu has empty extent list at depth %u\n"
-- 
2.53.0



