Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F291F223E60;
	Thu, 12 Dec 2024 15:50:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734018633; cv=none; b=ZIaoI2EGmMnkxvsHP325/oT9V+UUs+ho06Vd/Zb/5kwQNqs98dBzPqfqHwP5xt5Yo72wO4gy0OVW+7p9L7Q8aBVzVEKRfFsTiKQUGEwkbxI3EbG2FmBNzlGdbh3+iOyxS9iL0emRrpsGXR1tJ5wQ77L71A9/aj5tjG0jni3Sgg0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734018633; c=relaxed/simple;
	bh=YW/YT5U8raztpbZILhHtTYHo9Op8Hwa8hqW1dM3xf9s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ERYrSJx6bqAulk7Aal7/A16tjamWPu8zAAQ1VkhgTF7TVUWowTQLvr6TvJxAt7fWo63jyggnTvwA4iNtYSgxXDgOMdsBVQPavLOUS0cjRc09l6wtVx/3ukooyjkbsdJ3iD7GHj3iAm/F8qkTR5rB7IJMF7qoACRjEIX1USkXWhM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RF0N5CYJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RF0N5CYJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 626F6C4CECE;
	Thu, 12 Dec 2024 15:50:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734018632;
	bh=YW/YT5U8raztpbZILhHtTYHo9Op8Hwa8hqW1dM3xf9s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RF0N5CYJHQiUmqE816Jvq+wnPvT0o5SZUinBN75kqTk3v1VVNrlvFKgtatr6d5uI6
	 zyIuAbl/c525LFfXee8zy0i/mRMXtlsJNeKWapBSG1Z8BDVG3SosdnGmYV6gumQRNb
	 1nmb/KBnaR8u+obtYVv71NrGbH3wnUaUm0U0KpCc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luca Stefani <luca.stefani.ge1@gmail.com>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 6.6 345/356] btrfs: add cancellation points to trim loops
Date: Thu, 12 Dec 2024 16:01:04 +0100
Message-ID: <20241212144258.198566801@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144244.601729511@linuxfoundation.org>
References: <20241212144244.601729511@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
 fs/btrfs/free-space-cache.h |    7 +++++++
 3 files changed, 15 insertions(+), 3 deletions(-)

--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -1319,6 +1319,11 @@ static int btrfs_issue_discard(struct bl
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
@@ -6097,7 +6102,7 @@ static int btrfs_trim_free_extents(struc
 		start += len;
 		*trimmed += bytes;
 
-		if (fatal_signal_pending(current)) {
+		if (btrfs_trim_interrupted()) {
 			ret = -ERESTARTSYS;
 			break;
 		}
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -3808,7 +3808,7 @@ next:
 		if (async && *total_trimmed)
 			break;
 
-		if (fatal_signal_pending(current)) {
+		if (btrfs_trim_interrupted()) {
 			ret = -ERESTARTSYS;
 			break;
 		}
@@ -3999,7 +3999,7 @@ next:
 		}
 		block_group->discard_cursor = start;
 
-		if (fatal_signal_pending(current)) {
+		if (btrfs_trim_interrupted()) {
 			if (start != offset)
 				reset_trimming_bitmap(ctl, offset);
 			ret = -ERESTARTSYS;
--- a/fs/btrfs/free-space-cache.h
+++ b/fs/btrfs/free-space-cache.h
@@ -6,6 +6,8 @@
 #ifndef BTRFS_FREE_SPACE_CACHE_H
 #define BTRFS_FREE_SPACE_CACHE_H
 
+#include <linux/freezer.h>
+
 /*
  * This is the trim state of an extent or bitmap.
  *
@@ -43,6 +45,11 @@ static inline bool btrfs_free_space_trim
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


