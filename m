Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF47613A897;
	Thu, 23 May 2024 13:20:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716470423; cv=none; b=HdZ/wB7Vte0yblJy4cnxY9kmm20ha24/TKVQVMjo7Y1thVMxDXueI83AW4hKPgF8y2UkRqx8uI09nX6gmzgroBAXkqrUM6ebGIK0MUHHe7T1EOs9rfv7/iaOaXBZcgjFZgZNJ5UWzWkZGlCt/xcLlMjzTCBU1OEBwTVWBc7Nr/k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716470423; c=relaxed/simple;
	bh=zEeCXbC7KL2UEZgyrAVsPPHW75J9t92xo9FQCyYcQfU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M+ZHDyznv/sC1p7fbdxRhbW/i2xndCmA13DSDx6YQvhtiXLXhL9oWsUz45g04/XFWd25LvoWe1PovozQH7S27q35j0R34w8PtEfUdygs/UxnAFi40jB2GIVWs1Z+HMUtai/D5cxWwvwWLPCkMj3M+gUGAjMqk+2i7hUSIx+YjM4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WHB02+LR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WHB02+LR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1C29C4AF08;
	Thu, 23 May 2024 13:20:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716470423;
	bh=zEeCXbC7KL2UEZgyrAVsPPHW75J9t92xo9FQCyYcQfU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WHB02+LRIToOT+37bstVkaA0zBBAKVKDLtxjRlDJ7p/CfCSA5RnUnPKVVK7EiTYc4
	 8Xw5ajI0doPAt5wCt/n49k7XAg5ubaAP7orhENuvqzrSiXgWX5I7ABA7SkPu3hoSWv
	 Rt6TTfuhHPcZoB0dCrlYHu0b8yk60WQu9Ekc9cmM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Dave Chinner <dchinner@redhat.com>,
	Leah Rumancik <leah.rumancik@gmail.com>
Subject: [PATCH 6.1 30/45] xfs: allow inode inactivation during a ro mount log recovery
Date: Thu, 23 May 2024 15:13:21 +0200
Message-ID: <20240523130333.632228345@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240523130332.496202557@linuxfoundation.org>
References: <20240523130332.496202557@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Darrick J. Wong" <djwong@kernel.org>

[ Upstream commit 76e589013fec672c3587d6314f2d1f0aeddc26d9 ]

In the next patch, we're going to prohibit log recovery if the primary
superblock contains an unrecognized rocompat feature bit even on
readonly mounts.  This requires removing all the code in the log
mounting process that temporarily disables the readonly state.

Unfortunately, inode inactivation disables itself on readonly mounts.
Clearing the iunlinked lists after log recovery needs inactivation to
run to free the unreferenced inodes, which (AFAICT) is the only reason
why log mounting plays games with the readonly state in the first place.

Therefore, change the inactivation predicates to allow inactivation
during log recovery of a readonly mount.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Leah Rumancik <leah.rumancik@gmail.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/xfs_inode.c |   14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1652,8 +1652,11 @@ xfs_inode_needs_inactive(
 	if (VFS_I(ip)->i_mode == 0)
 		return false;
 
-	/* If this is a read-only mount, don't do this (would generate I/O) */
-	if (xfs_is_readonly(mp))
+	/*
+	 * If this is a read-only mount, don't do this (would generate I/O)
+	 * unless we're in log recovery and cleaning the iunlinked list.
+	 */
+	if (xfs_is_readonly(mp) && !xlog_recovery_needed(mp->m_log))
 		return false;
 
 	/* If the log isn't running, push inodes straight to reclaim. */
@@ -1713,8 +1716,11 @@ xfs_inactive(
 	mp = ip->i_mount;
 	ASSERT(!xfs_iflags_test(ip, XFS_IRECOVERY));
 
-	/* If this is a read-only mount, don't do this (would generate I/O) */
-	if (xfs_is_readonly(mp))
+	/*
+	 * If this is a read-only mount, don't do this (would generate I/O)
+	 * unless we're in log recovery and cleaning the iunlinked list.
+	 */
+	if (xfs_is_readonly(mp) && !xlog_recovery_needed(mp->m_log))
 		goto out;
 
 	/* Metadata inodes require explicit resource cleanup. */


