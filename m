Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31FFB3B5842;
	Mon, 23 Mar 2026 15:12:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774278721; cv=none; b=kltQFI/fWuEpuViILfq1K5qG6ClMXlP5wWay0cv/AmYeB1UMfNFuLg6k4RMKqiX3n4sNFX7cSGQsD07GH2bABHKvo4O5WWhT4Odx2ASGOsaJwK5huzyKdsH5mOhF+/7+NDKirrnYCkvS766AlXgz4bgdKE1n8mWLK9h8clfDvRw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774278721; c=relaxed/simple;
	bh=t1YyZk5P6xxkRjw1P2VoJ70h2UpOJjKgEukxlLDjxr8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c8Ei40ZxyMAMj0PBnbBp6UCea6a9vVg19ULt7gZhpjV8NHkARFrLEYkptZkOMw1EDwqHO0MV8gAqwgkg8gR6vH56s0Q7f9SYUqroM5SdDq89tKo/fOkJltdNyM8EcFqF3f42G1CkFnuR3YP4VjflvHvMaELsr9jj2sh/ndZPKic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YHhix/O5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YHhix/O5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC5F6C4CEF7;
	Mon, 23 Mar 2026 15:12:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774278721;
	bh=t1YyZk5P6xxkRjw1P2VoJ70h2UpOJjKgEukxlLDjxr8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YHhix/O5nTESAMwWE0yHXKV+er97zKVC3I7OKkNaT3eeyAwH/g/UtmSIKYO1Hf8H0
	 ptnDIMXQXa0QvYSsWxwwu3m/ltuCuh1ri99wdWdtVtLqZSLrYSAlHdSlaeMSxhudJd
	 tNMCo4Ku/2MROJZxMDnwamZ21ZrKyb0CBoq6IrlM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org,
	"stable@vger.kernel.org, Chao Yu" <chao@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daeho Jeong <daehojeong@google.com>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Robert Garcia <rob_garcia@163.com>
Subject: [PATCH 6.6 398/567] f2fs: fix to avoid migrating empty section
Date: Mon, 23 Mar 2026 14:45:18 +0100
Message-ID: <20260323134543.708606112@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134533.749096647@linuxfoundation.org>
References: <20260323134533.749096647@linuxfoundation.org>
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

From: Chao Yu <chao@kernel.org>

[ Upstream commit d625a2b08c089397d3a03bff13fa8645e4ec7a01 ]

It reports a bug from device w/ zufs:

F2FS-fs (dm-64): Inconsistent segment (173822) type [1, 0] in SSA and SIT
F2FS-fs (dm-64): Stopped filesystem due to reason: 4

Thread A				Thread B
- f2fs_expand_inode_data
 - f2fs_allocate_pinning_section
  - f2fs_gc_range
   - do_garbage_collect w/ segno #x
					- writepage
					 - f2fs_allocate_data_block
					  - new_curseg
					   - allocate segno #x

The root cause is: fallocate on pinning file may race w/ block allocation
as above, result in do_garbage_collect() from fallocate() may migrate
segment which is just allocated by a log, the log will update segment type
in its in-memory structure, however GC will get segment type from on-disk
SSA block, once segment type changes by log, we can detect such
inconsistency, then shutdown filesystem.

In this case, on-disk SSA shows type of segno #173822 is 1 (SUM_TYPE_NODE),
however segno #173822 was just allocated as data type segment, so in-memory
SIT shows type of segno #173822 is 0 (SUM_TYPE_DATA).

Change as below to fix this issue:
- check whether current section is empty before gc
- add sanity checks on do_garbage_collect() to avoid any race case, result
in migrating segment used by log.
- btw, it fixes misc issue in printed logs: "SSA and SIT" -> "SIT and SSA".

Fixes: 9703d69d9d15 ("f2fs: support file pinning for zoned devices")
Cc: Daeho Jeong <daehojeong@google.com>
Signed-off-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
[ Use IS_CURSEC instead of is_cursec according to
commit c1cfc87e49525 ("f2fs: introduce is_cur{seg,sec}()"). ]
Signed-off-by: Robert Garcia <rob_garcia@163.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/f2fs/gc.c |   16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

--- a/fs/f2fs/gc.c
+++ b/fs/f2fs/gc.c
@@ -1742,6 +1742,13 @@ static int do_garbage_collect(struct f2f
 					GET_SUM_BLOCK(sbi, segno));
 		f2fs_put_page(sum_page, 0);
 
+		if (IS_CURSEC(sbi, GET_SEC_FROM_SEG(sbi, segno))) {
+			f2fs_err(sbi, "%s: segment %u is used by log",
+							__func__, segno);
+			f2fs_bug_on(sbi, 1);
+			goto skip;
+		}
+
 		if (get_valid_blocks(sbi, segno, false) == 0)
 			goto freed;
 		if (gc_type == BG_GC && __is_large_section(sbi) &&
@@ -1752,7 +1759,7 @@ static int do_garbage_collect(struct f2f
 
 		sum = page_address(sum_page);
 		if (type != GET_SUM_TYPE((&sum->footer))) {
-			f2fs_err(sbi, "Inconsistent segment (%u) type [%d, %d] in SSA and SIT",
+			f2fs_err(sbi, "Inconsistent segment (%u) type [%d, %d] in SIT and SSA",
 				 segno, type, GET_SUM_TYPE((&sum->footer)));
 			set_sbi_flag(sbi, SBI_NEED_FSCK);
 			f2fs_stop_checkpoint(sbi, false,
@@ -2005,6 +2012,13 @@ int f2fs_gc_range(struct f2fs_sb_info *s
 			.iroot = RADIX_TREE_INIT(gc_list.iroot, GFP_NOFS),
 		};
 
+		/*
+		 * avoid migrating empty section, as it can be allocated by
+		 * log in parallel.
+		 */
+		if (!get_valid_blocks(sbi, segno, true))
+			continue;
+
 		do_garbage_collect(sbi, segno, &gc_list, FG_GC,
 						dry_run_sections == 0);
 		put_gc_inode(&gc_list);


