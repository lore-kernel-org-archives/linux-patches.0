Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76A3D2E973E;
	Tue, 17 Jun 2025 15:49:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750175361; cv=none; b=QUtXuRldHlB7XsNA3kZkNuSzvcoARitG44k5W3lzcLV2F6ituCoGVdikGGfnO4NjMrSpBEfnJMXfIcbUBof3RKZi9IpN9kGuhduPdZCJ9q3OsNwyUARL9DFSFNW0ITKnzEYXb74ZTP37t0VodptblU8r9G1KAjiMie2K7OVPcBk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750175361; c=relaxed/simple;
	bh=5ckzj0Fq6CmJ5K1BzeZVb2OoRANcwWvwXVg3O/e9wH0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sn4POfRRCxiaM9ePJfUApQPLlCV8HRE0OI1W6xeJaXcBOVksGP8SvqbNjasnT/QxIyNzzFYoA2VdshxCAWsQhkFSZeJEg6d1uxffpIN5AiZWVh3WftiFLQa6a7xMfPctQyTY6ZRpYw7Lkveqc9cdpkXTMITOsh5Xk9e2x67urvs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MZZ0Yu+X; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MZZ0Yu+X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D18FCC4CEE3;
	Tue, 17 Jun 2025 15:49:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750175361;
	bh=5ckzj0Fq6CmJ5K1BzeZVb2OoRANcwWvwXVg3O/e9wH0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MZZ0Yu+XJIRfc6Yi+YGWmR1uXx0Ex0Q7VD6n+GqBA2xadkRt7wWexBLepxUPxJO/7
	 gcw6qjT+Kpe+ObleHnZ4DqXKNTYmeZsc0hc+bgTE98B3tSu5fcv36lBdcIQ9CJjp39
	 ERTWIfQU8qYiCREPEOhM8+vp7cLe0QhEE8NmsOqU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"yohan.joung" <yohan.joung@sk.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 119/512] f2fs: prevent the current section from being selected as a victim during GC
Date: Tue, 17 Jun 2025 17:21:25 +0200
Message-ID: <20250617152424.405969939@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152419.512865572@linuxfoundation.org>
References: <20250617152419.512865572@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: yohan.joung <yohan.joung@sk.com>

[ Upstream commit d26fecb03e1f1069480d41fa2a6cea87ebbb89b8 ]

When selecting a victim using next_victim_seg in a large section, the
selected section might already have been cleared and designated as the
new current section, making it actively in use.
This behavior causes inconsistency between the SIT and SSA.

F2FS-fs (dm-54): Inconsistent segment (70961) type [0, 1] in SSA and SIT
Call trace:
dump_backtrace+0xe8/0x10c
show_stack+0x18/0x28
dump_stack_lvl+0x50/0x6c
dump_stack+0x18/0x28
f2fs_stop_checkpoint+0x1c/0x3c
do_garbage_collect+0x41c/0x271c
f2fs_gc+0x27c/0x828
gc_thread_func+0x290/0x88c
kthread+0x11c/0x164
ret_from_fork+0x10/0x20

issue scenario
segs_per_sec=2
- seg#0 and seg#1 are all dirty
- all valid blocks are removed in seg#1
- gc select this sec and next_victim_seg=seg#0
- migrate seg#0, next_victim_seg=seg#1
- checkpoint -> sec(seg#0, seg#1)  becomes free
- allocator assigns sec(seg#0, seg#1) to curseg
- gc tries to migrate seg#1

Fixes: e3080b0120a1 ("f2fs: support subsectional garbage collection")
Signed-off-by: yohan.joung <yohan.joung@sk.com>
Signed-off-by: Chao Yu <chao@kernel.org>
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/segment.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/f2fs/segment.h b/fs/f2fs/segment.h
index 25d3cda9bd5a3..05a342933f98f 100644
--- a/fs/f2fs/segment.h
+++ b/fs/f2fs/segment.h
@@ -488,6 +488,11 @@ static inline void __set_test_and_free(struct f2fs_sb_info *sbi,
 
 	free_i->free_sections++;
 
+	if (GET_SEC_FROM_SEG(sbi, sbi->next_victim_seg[BG_GC]) == secno)
+		sbi->next_victim_seg[BG_GC] = NULL_SEGNO;
+	if (GET_SEC_FROM_SEG(sbi, sbi->next_victim_seg[FG_GC]) == secno)
+		sbi->next_victim_seg[FG_GC] = NULL_SEGNO;
+
 unlock_out:
 	spin_unlock(&free_i->segmap_lock);
 }
-- 
2.39.5



