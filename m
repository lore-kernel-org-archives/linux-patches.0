Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A28A1A0724;
	Mon, 14 Oct 2024 14:35:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728916516; cv=none; b=BVbs2O+21+I6YvgASh85LBNIl/IABUF+5FjtAUj4cgsOJSE+mc6ssWdVtb2aROBNBf/umtGbLbvU2egE9SjglMwenJLFgP3p2+y/i5FY5/i3i4E75z3TOIPLV6bvsDvtyR3GkDDtDqxQtYvSSTPV+hcf/gQAOYdA7NqZxBoQOjE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728916516; c=relaxed/simple;
	bh=0tDraqkuVFhgYaChb/eBYalSv7102RH1deb1EPAVjks=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SfOzBYFqLSOzft1VDpWMG4sYjUC7sxRx/QHqek0GVwjNDkaHHhUTLit6A7Y3Yf0YJu5Qt5d5nYQ+7v4BpDxczXCEi+6DxhFXP3Cr/PO8iRsNTYsORYwgIZ9PvcZAbTNcT44F2Ek8qigrwQE7IL+FPkiCNmFOAwgYHCxUAyCZJTw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lGhLknNd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lGhLknNd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0949C4CEC3;
	Mon, 14 Oct 2024 14:35:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728916516;
	bh=0tDraqkuVFhgYaChb/eBYalSv7102RH1deb1EPAVjks=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lGhLknNdAhIxUc1wSXgeQoHBiB5qQG/ynx/XDwyqTqrOrm5zcAB6KWV6qqeBlYEuA
	 ad/FBZvR3sqWZPumktgpZcIP8Py42unI1R5TeSxup4ZOsJoX3dWl96sXZjzsY02RiN
	 thz+Gx8Uds4XQ+WeV3XAI3HBd4l2wAYX1se83IKc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luca Stefani <luca.stefani.ge1@gmail.com>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 6.11 207/214] btrfs: add cancellation points to trim loops
Date: Mon, 14 Oct 2024 16:21:10 +0200
Message-ID: <20241014141053.054450350@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141044.974962104@linuxfoundation.org>
References: <20241014141044.974962104@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luca Stefani <luca.stefani.ge1@gmail.com>

commit 69313850dce33ce8c24b38576a279421f4c60996 upstream.

There are reports that system cannot suspend due to running trim because
the task responsible for trimming the device isn't able to finish in
time, especially since we have a free extent discarding phase, which can
trim a lot of unallocated space. There are no limits on the trim size
(unlike the block group part).

Since trime isn't a critical call it can be interrupted at any time,
in such cases we stop the trim, report the amount of discarded bytes and
return an error.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=219180
Link: https://bugzilla.suse.com/show_bug.cgi?id=1229737
CC: stable@vger.kernel.org # 5.15+
Signed-off-by: Luca Stefani <luca.stefani.ge1@gmail.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/extent-tree.c      |    7 ++++++-
 fs/btrfs/free-space-cache.c |    4 ++--
 fs/btrfs/free-space-cache.h |    6 ++++++
 3 files changed, 14 insertions(+), 3 deletions(-)

--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -1316,6 +1316,11 @@ static int btrfs_issue_discard(struct bl
 		start += bytes_to_discard;
 		bytes_left -= bytes_to_discard;
 		*discarded_bytes += bytes_to_discard;
+
+		if (btrfs_trim_interrupted()) {
+			ret = -ERESTARTSYS;
+			break;
+		}
 	}
 
 	return ret;
@@ -6470,7 +6475,7 @@ static int btrfs_trim_free_extents(struc
 		start += len;
 		*trimmed += bytes;
 
-		if (fatal_signal_pending(current)) {
+		if (btrfs_trim_interrupted()) {
 			ret = -ERESTARTSYS;
 			break;
 		}
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -3809,7 +3809,7 @@ next:
 		if (async && *total_trimmed)
 			break;
 
-		if (fatal_signal_pending(current)) {
+		if (btrfs_trim_interrupted()) {
 			ret = -ERESTARTSYS;
 			break;
 		}
@@ -4000,7 +4000,7 @@ next:
 		}
 		block_group->discard_cursor = start;
 
-		if (fatal_signal_pending(current)) {
+		if (btrfs_trim_interrupted()) {
 			if (start != offset)
 				reset_trimming_bitmap(ctl, offset);
 			ret = -ERESTARTSYS;
--- a/fs/btrfs/free-space-cache.h
+++ b/fs/btrfs/free-space-cache.h
@@ -10,6 +10,7 @@
 #include <linux/list.h>
 #include <linux/spinlock.h>
 #include <linux/mutex.h>
+#include <linux/freezer.h>
 #include "fs.h"
 
 struct inode;
@@ -56,6 +57,11 @@ static inline bool btrfs_free_space_trim
 	return (info->trim_state == BTRFS_TRIM_STATE_TRIMMING);
 }
 
+static inline bool btrfs_trim_interrupted(void)
+{
+	return fatal_signal_pending(current) || freezing(current);
+}
+
 /*
  * Deltas are an effective way to populate global statistics.  Give macro names
  * to make it clear what we're doing.  An example is discard_extents in


