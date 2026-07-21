Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BB9E356746;
	Tue, 21 Jul 2026 19:56:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784663762; cv=none; b=EDAvgW/ZWjQA22LbaKWUM6m7KX0vVhP4yMoDum5hmgpPto/S6J+cfvtmm8xbopNsZkQJQMxj+SWmJFqiTjK454uoum40fLFNnrKBrWqaJUbyiO7hKa9exhHQpOJgsKPY5DDVy1SYQK0O9zFU7jFo4sihqF72mOUFJeY1dAmJU1E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784663762; c=relaxed/simple;
	bh=ZA2Xu3l5NB5owSaXb4qltRtyQ5FKE9DUX1M5VRPod2A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XuYc9KztoPH9TeN2ljpiii9x4Jv+zyHkcT8JwfWnlnPi5e4G4/8kfPwG4QA1FMyEslx+Tk+PWywpHmCUngDdaPN3tmkkib0EFIT75H1ZI7QaYKlSVKPa1Fs5WpRO0atATxlecyOSTMXCA5bGWpJWfON5cY37xQaCoF3VqUoECIg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KYKOB0La; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KYKOB0La"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4C551F000E9;
	Tue, 21 Jul 2026 19:56:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784663761;
	bh=lx89w3nybLWkgNyjRUsxUyvVj7sl/kkxlmhcxhOTsls=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KYKOB0LaTthqF2+C1jEem9+ytOKltmxq44ofd2mC69g8AWFX4y8k3Ktrc+u0ikF2M
	 1LfASOlDu+0GQ6QJKAVD55AHIdXFaZe0V2uJbrid3xqzrTV0QLRI7fOHAFINX1Jr9W
	 8ry2fdzBNHTdU1dI0NlqzH39N90WYNXiElnm056k=
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
Subject: [PATCH 6.12 0945/1276] ocfs2: avoid moving extents to occupied clusters
Date: Tue, 21 Jul 2026 17:23:08 +0200
Message-ID: <20260721152507.180818264@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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


