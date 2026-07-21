Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 046352EBB8D;
	Tue, 21 Jul 2026 20:54:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784667285; cv=none; b=ttqWbKFrA/QET0fyeDWYqgVmwRbXW/Ggvcab2fKeMTboS5P6ayxyiPPg34R2X9NRQaK2QlI0b+47OQ+nfzCZsckWovMTrM/M/CLx3WgkAnGfiBrAk/gGd+EjzOqdOOfWFT9CKYlWPvlWxHsnrQUwhB0b5orDcYdJp35GCxf5v/Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784667285; c=relaxed/simple;
	bh=8z2HBngCFf9iI+UvntdV48/6CP5/6YrCWyc3lltjSPs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=umoz2lCqIanzA7jH9e0tzpItqhHvStExjY3FFv1aZkdBW2GqtPY6HlblKeEzBV9HW2uw0jodm0Mv67nEiM9Pvh9Xk5RDJLjIJuox6lDSgmB8tA8+nFT+QdehEscrQjU7VaYuW8J3IgAH4ixxjYTaojo9YFEuVHNqZhZjx4lRCGI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MqlvM9Jm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MqlvM9Jm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72CE91F000E9;
	Tue, 21 Jul 2026 20:54:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784667283;
	bh=27pHSoiX7MImWkCa2sHoeaYc6uyBH/1G5LpGL/kqkB0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MqlvM9JmhW10bICPQhlhVk7XVNcjCUI0pcd/z35Pd6tpD7vSYlO2t7SpqCFN7/W6a
	 NuSIPqfZMGdsHVQ6nrNkvrs2ppOlzqx6IeI+JF9VNb095LMnM4N4H5cJg2EvR4WBU+
	 wSoljnVyyyQQns1hZ5SxaHGJDVewwG3aU0aO6V7U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kyle Zeng <kylebot@openai.com>,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	Junxiao Bi <junxiao.bi@oracle.com>,
	Changwei Ge <gechangwei@live.cn>,
	Jun Piao <piaojun@huawei.com>,
	Heming Zhao <heming.zhao@suse.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.6 1002/1266] ocfs2: avoid moving extents to occupied clusters
Date: Tue, 21 Jul 2026 17:23:59 +0200
Message-ID: <20260721152504.250798158@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kyle Zeng <kylebot@openai.com>

commit 22920541c35a9f23f219038ba5874c843a7c4419 upstream.

For non-auto OCFS2_IOC_MOVE_EXT operations, userspace supplies a physical
me_goal.  ocfs2_move_extent() initializes new_phys_cpos from that goal and
expects ocfs2_probe_alloc_group() to replace it with a free run in the
target block group.

The probe currently leaves *phys_cpos unchanged if the scan reaches the
end of the group without finding a free run.  An occupied goal at the last
bit can therefore survive the probe and be passed to
__ocfs2_move_extent(), which copies file data into a cluster still owned
by another inode before the bitmap is updated.

When the probe does find a free run, it also subtracts move_len from the
ending bit.  The start of an N-bit run ending at i is i - N + 1, so the
current calculation can report the bit immediately before the free run.

Clear *phys_cpos before scanning and use the correct free-run start.
Callers already treat a zero result as -ENOSPC, so failed probes no longer
continue with an occupied caller-controlled goal.

Link: https://lore.kernel.org/20260611213510.16956-1-kylebot@openai.com
Fixes: e6b5859cccfa ("Ocfs2/move_extents: helper to probe a proper region to move in an alloc group.")
Fixes: 236b9254f8d1 ("ocfs2: fix non-auto defrag path not working issue")
Assisted-by: Codex:gpt-5.5
Signed-off-by: Kyle Zeng <kylebot@openai.com>
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Jun Piao <piaojun@huawei.com>
Cc: Heming Zhao <heming.zhao@suse.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ocfs2/move_extents.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/fs/ocfs2/move_extents.c
+++ b/fs/ocfs2/move_extents.c
@@ -534,6 +534,8 @@ static void ocfs2_probe_alloc_group(stru
 	u32 base_cpos = ocfs2_blocks_to_clusters(inode->i_sb,
 						 le64_to_cpu(gd->bg_blkno));
 
+	*phys_cpos = 0;
+
 	for (i = base_bit; i < le16_to_cpu(gd->bg_bits); i++) {
 
 		used = ocfs2_test_bit(i, (unsigned long *)gd->bg_bitmap);
@@ -555,7 +557,7 @@ static void ocfs2_probe_alloc_group(stru
 			last_free_bits++;
 
 		if (last_free_bits == move_len) {
-			i -= move_len;
+			i = i - move_len + 1;
 			*goal_bit = i;
 			*phys_cpos = base_cpos + i;
 			break;


