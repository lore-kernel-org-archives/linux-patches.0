Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B63C392811
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:51:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301096; cv=none; b=j2Td+j5oByvu1FnIZgrdZsWS7OxNYD0DBKgL7ssitgi+2/dup3d/oF591I6nDnSYyD2PGzpAyCHYtQflevbZtdzsq2aSmS5gLBpyvKRY5eVeYi9dRtCkRcl4o3Yi7AhGuGUJS1ee40YIDNIcQYHgBw46ckr4k+lyENfvo0r8jtA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301096; c=relaxed/simple;
	bh=aWekrkEU8xXR9pKPyKkGVUhqPeF2RkHNBsPv3Yj+yxw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H9P9ZwjzmjQM3F/KCcj2CM6VBtViqn/UpuWg0aj0wCD1W8nOBeBrAP0IWZyIUHFfyn2ZJf7olJdDh89ebriuKlMBUBq1LZ3NtYtf+Abv6IT2O9TeqneT3vHdUoyeF+IhILLUmFvMmAYZ9uuB3GlnckorlP/SQz2Ro6T/099+0/Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KG+KhipG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KG+KhipG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 679DBC19424;
	Sat, 28 Feb 2026 17:51:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301095;
	bh=aWekrkEU8xXR9pKPyKkGVUhqPeF2RkHNBsPv3Yj+yxw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KG+KhipG8uln+n6H0U3vH2IbG6YBz1FWt4uyoT/pCrpFepoTIf1lKm8sbdh8KOy9E
	 XVeMkl4kocCGrQPgtOGK+7x2FXY7rJxRqT0bzEn8r8dxA57Q9cmwGEPBpJ8s6Qzvxe
	 H8++WzqPJhwqBaNekeYfDD6aJZnN5kLwTRM8EiV+c4tJt3k0iKfKwx0z4DiFb40dhz
	 VsMPk5NALefpa0RGdDMrhqJay7Jx+JezeVaeSfpiyJBjHaPGb7/Ue/53JrABXRNE6+
	 Cvuy+UaPs8jZHXgxQexOQmLOz73eRozjvAFt9hM4Oldz8eS6+5vICUbA3FYV0qWPSe
	 P5H7A/QGoiyIA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Li Chen <me@linux.beauty>,
	Theodore Ts'o <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 247/752] ext4: mark group add fast-commit ineligible
Date: Sat, 28 Feb 2026 12:39:18 -0500
Message-ID: <20260228174750.1542406-247-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Li Chen <me@linux.beauty>

[ Upstream commit 89b4336fd5ec78f51f9d3a1d100f3ffa3228e604 ]

Fast commits only log operations that have dedicated replay support.
Online resize via EXT4_IOC_GROUP_ADD updates the superblock and group
descriptor metadata without going through the fast commit tracking
paths.
In practice these operations are rare and usually followed by further
updates, but mixing them into a fast commit makes the overall
semantics harder to reason about and risks replay gaps if new call
sites appear.

Teach ext4 to mark the filesystem fast-commit ineligible when
ext4_ioctl_group_add() adds new block groups.
This forces those transactions to fall back to a full commit,
ensuring that the filesystem geometry updates are captured by the
normal journal rather than partially encoded in fast commit TLVs.
This change should not affect common workloads but makes online
resize via GROUP_ADD safer and easier to reason about under fast
commit.

Testing:
1. prepare:
    dd if=/dev/zero of=/root/fc_resize.img bs=1M count=0 seek=256
    mkfs.ext4 -O fast_commit -F /root/fc_resize.img
    mkdir -p /mnt/fc_resize && mount -t ext4 -o loop /root/fc_resize.img /mnt/fc_resize
2. Ran a helper that issues EXT4_IOC_GROUP_ADD on the mounted
   filesystem and checked the resize ineligible reason:
    ./group_add_helper /mnt/fc_resize
    cat /proc/fs/ext4/loop0/fc_info
   shows "Resize": > 0.
3. Fsynced a file on the resized filesystem and verified that the fast
   commit stats report at least one ineligible commit:
    touch /mnt/fc_resize/file
    /root/fsync_file /mnt/fc_resize/file
    sync
    cat /proc/fs/ext4/loop0/fc_info
   shows fc stats ineligible > 0.

Signed-off-by: Li Chen <me@linux.beauty>
Link: https://patch.msgid.link/20251211115146.897420-5-me@linux.beauty
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/ioctl.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/ext4/ioctl.c b/fs/ext4/ioctl.c
index 3dec26c939fde..d26914fa0cb46 100644
--- a/fs/ext4/ioctl.c
+++ b/fs/ext4/ioctl.c
@@ -966,6 +966,7 @@ static long ext4_ioctl_group_add(struct file *file,
 
 	err = ext4_group_add(sb, input);
 	if (EXT4_SB(sb)->s_journal) {
+		ext4_fc_mark_ineligible(sb, EXT4_FC_REASON_RESIZE, NULL);
 		jbd2_journal_lock_updates(EXT4_SB(sb)->s_journal);
 		err2 = jbd2_journal_flush(EXT4_SB(sb)->s_journal, 0);
 		jbd2_journal_unlock_updates(EXT4_SB(sb)->s_journal);
-- 
2.51.0

