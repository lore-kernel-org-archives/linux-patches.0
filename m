Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D503C44AB9D;
	Tue, 21 Jul 2026 21:41:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784670104; cv=none; b=nTbduZY03YnYi7P6DH/DGtRThPA3hjzxaQqZdGM5wIDT7/vsDbL7WE/yyce7yR91gIULyhAEnClb0N6JuyV9RnFdrK2KDj5BkhpF532xEflLJHth7YAUtJKiLXWHoO8VH6eg3deOn/T/DDYraqpM8mds5HwnwGYZ1S6pC9Sru80=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784670104; c=relaxed/simple;
	bh=vfx7AGJM/J8Yj4CSzR0mijeAPsuQt2DUIObF3GTW6jk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mS7Mfo+xNe4QHs/pcODKDjiPykG+xaS4SE+mx5NFCxY1LL3ih8/gxyzyrTBVhdKmm2b8ZhJOuprZjhTCLdnbMH/lr5SaT1aL4ql5yX1Lw+uaeqEhchAPe7t2SsEj+ZW8kYDDfVzvkD8LN1VlH264CKYeAxR3Sl7u3x53d5siEXo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qjAbvpDq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qjAbvpDq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EDF71F000E9;
	Tue, 21 Jul 2026 21:41:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784670102;
	bh=Q2aQUUzFfLe6JIWaVn8LSaBiGmWpZuZ8R9OTomrt6nc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qjAbvpDqEeX8dY+/mpQiWMfghoIMIZjOD/B+q4gtZlzOkq1pnQR3JiEtnZQSXbvbX
	 EwDwZ7m7kwB5Sy9J1EdHK6mJEy7aSp5d17u4LEZMS4LcgCJQi4jEYbYuZpGkKZV3R9
	 2SO1vR6hOOL+LkWFSHiIFqXPI6gPdswbrJ+Q987Q=
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
Subject: [PATCH 6.1 0807/1067] ocfs2: avoid moving extents to occupied clusters
Date: Tue, 21 Jul 2026 17:23:28 +0200
Message-ID: <20260721152442.610678631@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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


