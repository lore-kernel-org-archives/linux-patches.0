Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAAFB3E0091;
	Thu, 30 Jul 2026 14:52:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785423161; cv=none; b=RZXXGwJVR79iuQntHXiisCKlEsRXAkfpWb5ijjk1ivuU7BT/bxU++MSkM0pIqRAVN6fvWw39E1sCikjBXYd72MJRn3nEJIMjiBZcSRsatSh6m4HFG5aMXLJHCEhZkw4D/DWepSMbQfhfs7ZBK+de/p35/M9Krca3tXbnyvZLELQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785423161; c=relaxed/simple;
	bh=nWpib6+sDXCh+9f5f3rFfyDPpK6PXFDe1p/JuYHaG/Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oL9nQQz0HKLe8Dovni33bhz+SWX56LkkLD652IPvMUvWKnx+/6Mti2GBX0Vi3nFN9MLX6dzARErEWTG9wjSBpE+UfDqLVj7LTY71o9tmIC4oe+smc0/0VtDxn55xYF+osXk6y4867EvzgAaWVEaDnFvcwUMJr1IUknLd5QQ+TC4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WhCaM7KR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WhCaM7KR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 376F51F000E9;
	Thu, 30 Jul 2026 14:52:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785423159;
	bh=B0XeB/MY6j594dBQBclKjhVyy+AmXdEOsEf55UTsixM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WhCaM7KRUTMhLvuEgkpZc91s5TtWJAuUNIZycq3IO1lJyioWvSFuK5nW6zCS2kJ4R
	 +OtKs67ziLylsjCyLvkXzc+ohXqbL6rlTVV2OitzhnBRE0wuARe2vcM0zUvXRk0mD1
	 RVH5oGGUxXnRErbH+PANh7kryHlzx92UGflaAI1M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shengming Hu <hu.shengming@zte.com.cn>,
	"Harry Yoo (Oracle)" <harry@kernel.org>,
	"Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Subject: [PATCH 7.1 650/744] mm/slub: fix lost local objects when bulk remote free batch fills
Date: Thu, 30 Jul 2026 16:15:23 +0200
Message-ID: <20260730141458.085445254@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shengming Hu <hu.shengming@zte.com.cn>

commit af9ea231c0b4530edc389a3126a69e0699b7699d upstream.

In free_to_pcs_bulk(), when remote_objects[] fills to PCS_BATCH_MAX,
the code jumps to flush_remote to free the batch. If all remote entries
have already been compacted out of p[] via tail swaps while local objects
remain, the flush_remote path returns early since `i < size` no longer
holds. The leftover local objects are then neither cached in the sheaf
nor returned to the slab freelist, causing a memory leak.

For illustration:
 size = 64, local objects at p[0..31], remote objects at p[32..63]
 After scanning all remotes: i = 32, size = 32
 p[0..31] local objects are dropped.

Harry pointed out that, although the logic contains a real leak, it does
not appear to be triggerable with the current in-tree users. To hit this
path, at least PCS_BATCH_MAX objects, currently hardcoded to 32, need to
be collected in remote_objects[]. Looking at current kmem_cache_free_bulk()
users:

* maple_node has sheaf_capacity = 32
* skbuff_head_cache has sheaf_capacity = 28
* panthor and msm drivers have sheaf_capacity = 4

The sheaf capacity is, at least for now, derived purely from the object
size, with the user-requested capacity used as a minimum. Therefore, among
the current users, only maple_node has a sheaf_capacity large enough to
reach PCS_BATCH_MAX.

However, for the bug to trigger in maple_node, all objects in the sheaf
would have to be from remote nodes. In that case, there would be no local
objects left to leak. So this issue was found by code review rather than
from a runtime report, and it does not seem to be triggerable by current
users.

Still, the bug could become reachable with future users, a different sheaf
capacity, or a change to PCS_BATCH_MAX. Fix the logic by freeing a full
remote batch in place during the scan and then continuing to process the
compacted array. This keeps all local objects on the normal fast path,
while the tail path only handles any leftover partial remote batch. The
redundant next_remote_batch jump label is removed as well.

Fixes: 989b09b73978 ("slab: skip percpu sheaves for remote object freeing")
Signed-off-by: Shengming Hu <hu.shengming@zte.com.cn>
Link: https://patch.msgid.link/202607062139095043SOsLi6TIf403tcjPf8fm@zte.com.cn
Cc: stable@vger.kernel.org
Reviewed-by: Harry Yoo (Oracle) <harry@kernel.org>
Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/slub.c |   12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

--- a/mm/slub.c
+++ b/mm/slub.c
@@ -6066,7 +6066,6 @@ static void free_to_pcs_bulk(struct kmem
 	void *remote_objects[PCS_BATCH_MAX];
 	unsigned int remote_nr = 0;
 
-next_remote_batch:
 	while (i < size) {
 		struct slab *slab = virt_to_slab(p[i]);
 
@@ -6081,8 +6080,11 @@ next_remote_batch:
 		if (unlikely(!can_free_to_pcs(slab))) {
 			remote_objects[remote_nr] = p[i];
 			p[i] = p[--size];
-			if (++remote_nr >= PCS_BATCH_MAX)
-				goto flush_remote;
+			if (++remote_nr >= PCS_BATCH_MAX) {
+				__kmem_cache_free_bulk(s, remote_nr, &remote_objects[0]);
+				stat_add(s, FREE_SLOWPATH, remote_nr);
+				remote_nr = 0;
+			}
 			continue;
 		}
 
@@ -6166,10 +6168,6 @@ flush_remote:
 	if (remote_nr) {
 		__kmem_cache_free_bulk(s, remote_nr, &remote_objects[0]);
 		stat_add(s, FREE_SLOWPATH, remote_nr);
-		if (i < size) {
-			remote_nr = 0;
-			goto next_remote_batch;
-		}
 	}
 }
 


