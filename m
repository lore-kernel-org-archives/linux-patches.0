Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CD7E1D5AD4;
	Mon, 13 Apr 2026 16:36:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776098169; cv=none; b=Xx885/idKrtO0SWKJ6IqtC48F3Ki25+GKQdCyKBxvN5LATip23Lh39X41r0dXZCd3bX6rkKo8RzJ7w6aXDkWkXTrC9hrlWZUr9pZBlB7e1G2g9HzgV/X0DXlqsQcTnBTEwih4BTSKBPWHXBmAXHQj/GTNaqR5IDqb1/+mAZxMJs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776098169; c=relaxed/simple;
	bh=XeKFcsn5wAoHTlIaTRZpo1v5B/o2NLcYFRAyyEhv6rY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iKw5Yc8zN10bjdYfYk2X4HOg7CMJpaOu8Hpt559RnS1Qu9PtaJ2lyDx2G9m3ErVzqUXsdRT3mLKeqba7gN7Nv29NaLUrGFc7nmt6vQAU0Jhznp2N2mqVIEpJ4746M587hfXBp1IPQ7LBzLZtS2MJF/pOqJdNs/WbsH+n6iAThEA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sSbjhAG0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sSbjhAG0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 963A4C2BCAF;
	Mon, 13 Apr 2026 16:36:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776098168;
	bh=XeKFcsn5wAoHTlIaTRZpo1v5B/o2NLcYFRAyyEhv6rY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sSbjhAG0CEKiW5a1V9EaotxlDI3aFgFAmwWvZ90rrZZVxNr0Pnob20glWerbzFI67
	 O+nzNG1qK7+9S0K7WCUcXwP8SBYXdjCwP5LyVAtvvJ6Z+Fo0zNXyaWhnRRLu5orj+H
	 HUNh4TjJK05ccR7QvBGNO3aSe8aAceuHJm5qAFRE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	ZhengYuan Huang <gality369@gmail.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 403/570] btrfs: reject root items with drop_progress and zero drop_level
Date: Mon, 13 Apr 2026 17:58:54 +0200
Message-ID: <20260413155845.565882139@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155830.386096114@linuxfoundation.org>
References: <20260413155830.386096114@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: ZhengYuan Huang <gality369@gmail.com>

[ Upstream commit b17b79ff896305fd74980a5f72afec370ee88ca4 ]

[BUG]
When recovering relocation at mount time, merge_reloc_root() and
btrfs_drop_snapshot() both use BUG_ON(level == 0) to guard against
an impossible state: a non-zero drop_progress combined with a zero
drop_level in a root_item, which can be triggered:

------------[ cut here ]------------
kernel BUG at fs/btrfs/relocation.c:1545!
Oops: invalid opcode: 0000 [#1] SMP KASAN NOPTI
CPU: 1 UID: 0 PID: 283 ... Tainted: 6.18.0+ #16 PREEMPT(voluntary)
Tainted: [O]=OOT_MODULE, [E]=UNSIGNED_MODULE
Hardware name: QEMU Ubuntu 24.04 PC v2, BIOS 1.16.3-debian-1.16.3-2
RIP: 0010:merge_reloc_root+0x1266/0x1650 fs/btrfs/relocation.c:1545
Code: ffff0000 00004589 d7e9acfa ffffe8a1 79bafebe 02000000
Call Trace:
 merge_reloc_roots+0x295/0x890 fs/btrfs/relocation.c:1861
 btrfs_recover_relocation+0xd6e/0x11d0 fs/btrfs/relocation.c:4195
 btrfs_start_pre_rw_mount+0xa4d/0x1810 fs/btrfs/disk-io.c:3130
 open_ctree+0x5824/0x5fe0 fs/btrfs/disk-io.c:3640
 btrfs_fill_super fs/btrfs/super.c:987 [inline]
 btrfs_get_tree_super fs/btrfs/super.c:1951 [inline]
 btrfs_get_tree_subvol fs/btrfs/super.c:2094 [inline]
 btrfs_get_tree+0x111c/0x2190 fs/btrfs/super.c:2128
 vfs_get_tree+0x9a/0x370 fs/super.c:1758
 fc_mount fs/namespace.c:1199 [inline]
 do_new_mount_fc fs/namespace.c:3642 [inline]
 do_new_mount fs/namespace.c:3718 [inline]
 path_mount+0x5b8/0x1ea0 fs/namespace.c:4028
 do_mount fs/namespace.c:4041 [inline]
 __do_sys_mount fs/namespace.c:4229 [inline]
 __se_sys_mount fs/namespace.c:4206 [inline]
 __x64_sys_mount+0x282/0x320 fs/namespace.c:4206
 ...
RIP: 0033:0x7f969c9a8fde
Code: 0f1f4000 48c7c2b0 fffffff7 d8648902 b8ffffff ffc3660f
---[ end trace 0000000000000000 ]---

The bug is reproducible on 7.0.0-rc2-next-20260310 with our dynamic
metadata fuzzing tool that corrupts btrfs metadata at runtime.

[CAUSE]
A non-zero drop_progress.objectid means an interrupted
btrfs_drop_snapshot() left a resume point on disk, and in that case
drop_level must be greater than 0 because the checkpoint is only
saved at internal node levels.

Although this invariant is enforced when the kernel writes the root
item, it is not validated when the root item is read back from disk.
That allows on-disk corruption to provide an invalid state with
drop_progress.objectid != 0 and drop_level == 0.

When relocation recovery later processes such a root item,
merge_reloc_root() reads drop_level and hits BUG_ON(level == 0). The
same invalid metadata can also trigger the corresponding BUG_ON() in
btrfs_drop_snapshot().

[FIX]
Fix this by validating the root_item invariant in tree-checker when
reading root items from disk: if drop_progress.objectid is non-zero,
drop_level must also be non-zero. Reject such malformed metadata with
-EUCLEAN before it reaches merge_reloc_root() or btrfs_drop_snapshot()
and triggers the BUG_ON.

After the fix, the same corruption is correctly rejected by tree-checker
and the BUG_ON is no longer triggered.

Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: ZhengYuan Huang <gality369@gmail.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/tree-checker.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/fs/btrfs/tree-checker.c b/fs/btrfs/tree-checker.c
index b0afa47032104..e370ad75072c7 100644
--- a/fs/btrfs/tree-checker.c
+++ b/fs/btrfs/tree-checker.c
@@ -1187,6 +1187,23 @@ static int check_root_item(struct extent_buffer *leaf, struct btrfs_key *key,
 			    btrfs_root_drop_level(&ri), BTRFS_MAX_LEVEL - 1);
 		return -EUCLEAN;
 	}
+	/*
+	 * If drop_progress.objectid is non-zero, a btrfs_drop_snapshot() was
+	 * interrupted and the resume point was recorded in drop_progress and
+	 * drop_level.  In that case drop_level must be >= 1: level 0 is the
+	 * leaf level and drop_snapshot never saves a checkpoint there (it
+	 * only records checkpoints at internal node levels in DROP_REFERENCE
+	 * stage).  A zero drop_level combined with a non-zero drop_progress
+	 * objectid indicates on-disk corruption and would cause a BUG_ON in
+	 * merge_reloc_root() and btrfs_drop_snapshot() at mount time.
+	 */
+	if (unlikely(btrfs_disk_key_objectid(&ri.drop_progress) != 0 &&
+		     btrfs_root_drop_level(&ri) == 0)) {
+		generic_err(leaf, slot,
+			    "invalid root drop_level 0 with non-zero drop_progress objectid %llu",
+			    btrfs_disk_key_objectid(&ri.drop_progress));
+		return -EUCLEAN;
+	}
 
 	/* Flags check */
 	if (unlikely(btrfs_root_flags(&ri) & ~valid_root_flags)) {
-- 
2.53.0



