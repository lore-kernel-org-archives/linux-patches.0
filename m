Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A739B2FC00C;
	Sun, 15 Feb 2026 17:41:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771177292; cv=none; b=oQxrNJJSqhaEvbIJohHzCNpctfjbEh/tIe3tm8/8WNc3iMehBvy9LVZrsA2F8lQ41swO4L+za8GgL9rlMfsB6OQhRO+rkihvZpGOJLZqXPQ87pDvMgA17bn9SrIVaUUMz3ZB6o4hSnf41njMqvUlkUduogtSDz1VX6I9e+35Q3k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771177292; c=relaxed/simple;
	bh=nAx3UEsTfVcgjmVMxlSshKW1Gcw3BWPVkzJPmkjSftI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OWSDxVGZzKFamnMA1u5yhn3URuvLCHPOzYd39GiijvuRRcTFJzYgVvPROHjOq87Rbbd2PYRfWPkCau3R6Bb9fTs6Y+hmFs1uOUd3PxKhf8IH/JcloDY8tCwZbxdwSshGrU9SM/cNtMjXz6GohyF1kiIEkoH/X6yFDM/d1svEtB8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oqTFKDxI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oqTFKDxI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE71FC4CEF7;
	Sun, 15 Feb 2026 17:41:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771177292;
	bh=nAx3UEsTfVcgjmVMxlSshKW1Gcw3BWPVkzJPmkjSftI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oqTFKDxINPj4is0owGIZMY7rPLiscK6eRDdXUF3geo2BXoj6bnYd3I37h5lGXPVoI
	 fczYIwnqQaGOLChlLWey9nSFkkkp+6Qpq8lVRU2pDzVwibWjtyUyQbyQcNHwYCUvGT
	 2UeAF7ifKR1Ps21ZrIoZUW8wv7f4Qk2Z2gfsy2g++cCZMvKgRea5x45o+ZVPC5+sg3
	 UGnqA5pas5Vc+mAfbAQz1MWlS1ubRllDDdwmdFHF9aN8nUNK/h3ZtwELnPQIvpaelP
	 NGOglEahVvwAhyWulXFvrZafft1HNgK8dMIL8vHySQjPGAid9G/yaFWB0nSCu0Zj9M
	 ZkhDoa+QZnUcg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	linux-f2fs-devel@lists.sourceforge.net
Subject: [PATCH AUTOSEL 6.19-6.18] f2fs: fix to do sanity check on node footer in __write_node_folio()
Date: Sun, 15 Feb 2026 12:41:17 -0500
Message-ID: <20260215174120.2390402-9-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260215174120.2390402-1-sashal@kernel.org>
References: <20260215174120.2390402-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.19
Content-Transfer-Encoding: 8bit

From: Chao Yu <chao@kernel.org>

[ Upstream commit 0a736109c9d29de0c26567e42cb99b27861aa8ba ]

Add node footer sanity check during node folio's writeback, if sanity
check fails, let's shutdown filesystem to avoid looping to redirty
and writeback in .writepages.

Signed-off-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

So `sanity_check_node_footer` doesn't exist in 6.12.y. The fix would
need more substantial adaptation for older trees, but the core issue
(looping redirty on corrupted footer) still exists there - the old code
uses `f2fs_bug_on` which only triggers a WARN_ON (unless
CONFIG_F2FS_CHECK_FS is set) and then continues processing the corrupted
node.

## Analysis Summary

### What the commit does

The commit replaces `f2fs_bug_on(sbi, folio->index != nid)` in
`__write_node_folio()` with a proper call to
`sanity_check_node_footer()` + `f2fs_handle_critical_error()`.

### The bug

When a node folio has a corrupted footer (nid mismatch or other
inconsistency):

1. **Old behavior**: `f2fs_bug_on()` triggers either a `BUG_ON()`
   (kernel crash with `CONFIG_F2FS_CHECK_FS`) or just `WARN_ON` + sets
   `SBI_NEED_FSCK` and **continues execution**. In the WARN_ON case, the
   corrupted node gets processed and written. But more critically, if
   the node gets redirected to `redirty_out` or encounters another issue
   later, it enters an **infinite loop** of being redirtied and re-
   attempted for writeback in `.writepages`, since nothing stops the
   cycle.

2. **New behavior**: `sanity_check_node_footer()` detects the corruption
   more thoroughly (checking multiple footer fields, not just nid), and
   `f2fs_handle_critical_error()` shuts down the filesystem to **break
   the infinite writeback loop**.

### Why it matters

- **Infinite loop / soft lockup**: Without this fix, a corrupted node
  footer causes the kernel to loop endlessly trying to write the page,
  consuming CPU and potentially hanging the system.
- **Filesystem corruption defense**: On corrupted or fuzzed images, the
  old code would continue operating on inconsistent data.
- **Small, surgical fix**: Only 5 lines changed (1 insertion, 1 deletion
  effectively), replacing an assertion with a proper error handling
  path.

### Dependencies

The fix calls `sanity_check_node_footer()` (introduced in v6.15-rc1 by
commit 1cf6b5670af1f) and `f2fs_handle_critical_error()` +
`STOP_CP_REASON_CORRUPTED_NID`.

Crucially, `sanity_check_node_footer()` was **already backported** to
6.17.y and 6.18.y as part of commit c18ecd99e0c70's backport. Both
`f2fs_handle_critical_error` and `STOP_CP_REASON_CORRUPTED_NID` also
exist in these stable trees.

### Risk assessment

- **Very low risk**: The change replaces a debug assertion with proper
  error handling + filesystem shutdown. The error path (`goto
  redirty_out`) already exists and is well-tested.
- **Applies cleanly** to 6.17.y and 6.18.y (minor context difference
  with `f2fs_down_read` vs `f2fs_down_read_trace` but that's outside the
  hunk).
- For older trees (6.12.y and below), `sanity_check_node_footer()`
  doesn't exist, so a more complex backport would be needed.

## Verification

- **git show 0a736109c9d29**: Confirmed the actual commit is +5/-1
  lines, single file change in fs/f2fs/node.c
- **git show 1cf6b5670af1f**: Confirmed this is the prerequisite that
  introduced `sanity_check_node_footer()`, first appeared in v6.15-rc1
- **git tag --contains 1cf6b5670af1f**: Confirmed first release is
  v6.15-rc1
- **git show v6.17.13:fs/f2fs/node.c**: Confirmed
  `sanity_check_node_footer` exists (line 1503), and `f2fs_bug_on(sbi,
  folio->index != nid)` still present (the buggy line) at line 1754
- **git show v6.18.10:fs/f2fs/node.c**: Same -
  `sanity_check_node_footer` exists and the buggy `f2fs_bug_on` line is
  present
- **git show v6.17.13:fs/f2fs/f2fs.h**: Confirmed
  `f2fs_handle_critical_error` is declared
- **git show v6.17.13:include/linux/f2fs_fs.h**: Confirmed
  `STOP_CP_REASON_CORRUPTED_NID` exists
- **git show v6.18.10**: Same confirmations for both dependencies
- **git show v6.12.71:fs/f2fs/node.c**: Confirmed
  `sanity_check_node_footer` does NOT exist in 6.12.y (would need more
  work)
- **f2fs_bug_on definition** (fs/f2fs/f2fs.h:34-40): Confirmed that
  without CONFIG_F2FS_CHECK_FS, it's just WARN_ON + SBI_NEED_FSCK,
  allowing execution to continue
- **git show 186098f34b8a5**: Confirmed that c18ecd99e0c70 was
  backported to 6.17.y (combined with prerequisites), establishing
  `sanity_check_node_footer` in stable

This is a small, surgical fix that prevents an infinite writeback loop
on corrupted f2fs node footers. It replaces a weak assertion with proper
error handling and filesystem shutdown. All dependencies exist in 6.17.y
and 6.18.y stable trees. The fix is clearly correct, fixes a real bug
(system hang), and is appropriately scoped.

**YES**

 fs/f2fs/node.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c
index 482a362f26254..a963c4165bc4b 100644
--- a/fs/f2fs/node.c
+++ b/fs/f2fs/node.c
@@ -1751,7 +1751,11 @@ static bool __write_node_folio(struct folio *folio, bool atomic, bool *submitted
 
 	/* get old block addr of this node page */
 	nid = nid_of_node(folio);
-	f2fs_bug_on(sbi, folio->index != nid);
+
+	if (sanity_check_node_footer(sbi, folio, nid, NODE_TYPE_REGULAR)) {
+		f2fs_handle_critical_error(sbi, STOP_CP_REASON_CORRUPTED_NID);
+		goto redirty_out;
+	}
 
 	if (f2fs_get_node_info(sbi, nid, &ni, !do_balance))
 		goto redirty_out;
-- 
2.51.0

