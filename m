Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42A2B310650;
	Mon, 13 Oct 2025 15:36:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760369788; cv=none; b=ezcgxmBcKargpuSrDjN+D90X8XCxO9sk7wJ8NwpgXrBGYz+RBeTWK2TGpRYG+5rUscH+1Jbbh2r2xfV5Q8d4r3vUKJSI/Zq+Q27GWMpSlDDbYSCGhvBru+ORQZwnRWg1l9wbSA6CMahDtiJGNO/V+3Nl83fmQIv7+DJEG01einc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760369788; c=relaxed/simple;
	bh=2JP9fn9ENeDPveAsIb3k1WhEXd9/6xMUnNNW7utVzTY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IsB/pAIQMEN1c0AS84sxHLzm7w9DuW+Yhr1erSIvGYXQbA+pJ5/G3A21lxXo3uVv4wVYg7/lzpSpEaBaN53QGR68cD5RugJXQgmEwyoPOZnluE7Cwqp4IggeEWThqTVrrp99sJJvXlQuafQ4BVF5upaHytg66iGrdgN/JRcQT6I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=o1w/i2LQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o1w/i2LQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7ED4CC4CEE7;
	Mon, 13 Oct 2025 15:36:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760369787;
	bh=2JP9fn9ENeDPveAsIb3k1WhEXd9/6xMUnNNW7utVzTY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=o1w/i2LQ5ntah21V35oHGoRLEGHv1YAzj0V1zYtv0TK+Oz3DqAHAXFs7DcMKsbmgu
	 a/1WbXjbHiqYgatUGlWD93Pp6aALdYEDAA9zMkBMlTTGGpXTVh3x/r3GRK2W1ixSX6
	 yWjTbMUHBomFh9dNR1PNPq/7SMndVSrtV5/64244=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daeho Jeong <daehojeong@google.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 368/563] f2fs: fix to avoid migrating empty section
Date: Mon, 13 Oct 2025 16:43:49 +0200
Message-ID: <20251013144424.609605351@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/gc.c | 16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/fs/f2fs/gc.c b/fs/f2fs/gc.c
index c0f209f746882..5734e03864685 100644
--- a/fs/f2fs/gc.c
+++ b/fs/f2fs/gc.c
@@ -1794,6 +1794,13 @@ static int do_garbage_collect(struct f2fs_sb_info *sbi,
 		struct folio *sum_folio = filemap_get_folio(META_MAPPING(sbi),
 					GET_SUM_BLOCK(sbi, segno));
 
+		if (is_cursec(sbi, GET_SEC_FROM_SEG(sbi, segno))) {
+			f2fs_err(sbi, "%s: segment %u is used by log",
+							__func__, segno);
+			f2fs_bug_on(sbi, 1);
+			goto skip;
+		}
+
 		if (get_valid_blocks(sbi, segno, false) == 0)
 			goto freed;
 		if (gc_type == BG_GC && __is_large_section(sbi) &&
@@ -1805,7 +1812,7 @@ static int do_garbage_collect(struct f2fs_sb_info *sbi,
 
 		sum = folio_address(sum_folio);
 		if (type != GET_SUM_TYPE((&sum->footer))) {
-			f2fs_err(sbi, "Inconsistent segment (%u) type [%d, %d] in SSA and SIT",
+			f2fs_err(sbi, "Inconsistent segment (%u) type [%d, %d] in SIT and SSA",
 				 segno, type, GET_SUM_TYPE((&sum->footer)));
 			f2fs_stop_checkpoint(sbi, false,
 				STOP_CP_REASON_CORRUPTED_SUMMARY);
@@ -2068,6 +2075,13 @@ int f2fs_gc_range(struct f2fs_sb_info *sbi,
 			.iroot = RADIX_TREE_INIT(gc_list.iroot, GFP_NOFS),
 		};
 
+		/*
+		 * avoid migrating empty section, as it can be allocated by
+		 * log in parallel.
+		 */
+		if (!get_valid_blocks(sbi, segno, true))
+			continue;
+
 		if (is_cursec(sbi, GET_SEC_FROM_SEG(sbi, segno)))
 			continue;
 
-- 
2.51.0



