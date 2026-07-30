Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1853431488;
	Thu, 30 Jul 2026 14:38:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785422334; cv=none; b=Dh34/zuuFliR3cFRs7Ih2xUTJ9CNFj6VvC6ph7HHmg9c06/Vs9v//w2D+RekwlS86On8fQxA5iamG4pPNXQQ8Glg97IIk8BGWTo3NBHDQfJO5NHqgynmIk0kLAGXFa8NjX6Nk0dWBuF6qAvAtAlYXjrWuy6G+aqcM3FiTWlRfR0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785422334; c=relaxed/simple;
	bh=HPzBsE1PO+gpD7WM8k2ZkE9/tPX3ScUbVYqthi96Fgc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kshR4otP9FXgdX7/fIlFGC1YV7VUCNbv1wDlQYFZ1fOMn26ksN2DI+R//oxYy9Qu7W2YSs/6iD0Y1n8N95RG9quuMC50MDMJpx7rtUe8GwQqTbbgH7s6fg37jGdBfxpPUAFZvXp0y128s0CBmYt4ealbHLXQ1LarxZYmuK5Ecko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=o9YRQHIh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o9YRQHIh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EC821F000E9;
	Thu, 30 Jul 2026 14:38:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785422332;
	bh=VJLkqQJh7dYOXona05xcefxj8WHQkzMb8xCdfefMGi8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=o9YRQHIhukWB9d8UrkNhxMzAnoON8wbnsCqFoRhgAzym4M/UnxI20Beon4V4crtVw
	 e5nLMe57yvvNE71f8S22vyuhAai0MWnFIYUpjU9noyfjyOgg8Loa9Tbn1zt2N3xDYX
	 B+vEufJuZF7gDlSpTX9jw+JSw58zLD26uurZl3ao=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthew Brost <matthew.brost@intel.com>,
	Matthew Auld <matthew.auld@intel.com>,
	=?UTF-8?q?Thomas=20Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>
Subject: [PATCH 7.1 401/744] drm/xe: Fix PTE index in xe_vm_populate_pgtable() for chunked binds
Date: Thu, 30 Jul 2026 16:11:14 +0200
Message-ID: <20260730141452.814467392@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthew Brost <matthew.brost@intel.com>

commit 34a4dd45cf210c04fee773b0dbc350aec285f03c upstream.

xe_vm_populate_pgtable() indexed the source PTE array (update->pt_entries)
by the per-call loop counter, assuming each call starts at the first entry
of the update. That holds for the CPU bind path
(xe_migrate_update_pgtables_cpu), which populates a whole update in a single
call, but not for the GPU bind path: write_pgtable() splits an update into
MAX_PTE_PER_SDI (510) sized MI_STORE_DATA_IMM chunks, invoking the populate
callback once per chunk with an advancing qword_ofs but a fresh command-
buffer destination pointer.

As a result, every chunk after the first re-read pt_entries from index 0
instead of from its true offset, so PTEs beyond the first 510 entries of a
single update were programmed with the wrong physical pages, shifting the
mapping by exactly MAX_PTE_PER_SDI pages.

This stayed latent because a single update only exceeds 510 qwords when a
large (e.g. 2M) region is bound as individual 4K PTEs rather than a single
huge-page entry, which happens when the backing store is sufficiently
fragmented. It was surfaced by the BO defrag path, which deliberately
rebinds such fragmented ranges via the GPU bind path, producing
deterministic data corruption offset by 510 pages.

Index pt_entries by the chunk's absolute offset relative to update->ofs so
both the CPU and GPU paths pick the correct entries.

Fixes: dd08ebf6c352 ("drm/xe: Introduce a new DRM driver for Intel GPUs")
Cc: stable@vger.kernel.org
Assisted-by: GitHub_Copilot:claude-opus-4.8
Signed-off-by: Matthew Brost <matthew.brost@intel.com>
Reviewed-by: Matthew Auld <matthew.auld@intel.com>
Link: https://patch.msgid.link/20260702012434.3861171-1-matthew.brost@intel.com
(cherry picked from commit e6f2d0b757c4fb577a513c577140109d1d292a9a)
Signed-off-by: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/xe/xe_pt.c |   14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/xe/xe_pt.c
+++ b/drivers/gpu/drm/xe/xe_pt.c
@@ -1025,12 +1025,22 @@ xe_vm_populate_pgtable(struct xe_migrate
 	u64 *ptr = data;
 	u32 i;
 
+	/*
+	 * @qword_ofs is the absolute entry offset within the page table, while
+	 * @ptes is indexed relative to @update->ofs (its first entry). The GPU
+	 * path (write_pgtable) splits a single update into MAX_PTE_PER_SDI-sized
+	 * chunks, calling this with an advancing @qword_ofs but a fresh @data
+	 * pointer per chunk, so translate back into a @ptes index rather than
+	 * assuming the chunk starts at ptes[0].
+	 */
 	for (i = 0; i < num_qwords; i++) {
+		u32 idx = qword_ofs - update->ofs + i;
+
 		if (map)
 			xe_map_wr(tile_to_xe(tile), map, (qword_ofs + i) *
-				  sizeof(u64), u64, ptes[i].pte);
+				  sizeof(u64), u64, ptes[idx].pte);
 		else
-			ptr[i] = ptes[i].pte;
+			ptr[i] = ptes[idx].pte;
 	}
 }
 


