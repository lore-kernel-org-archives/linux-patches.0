Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 621FA30AABE;
	Tue, 31 Mar 2026 17:07:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774976877; cv=none; b=ph12X19+3zUBb1oXnYWzOSVPLug5Oid56QFteJtPAWgTwenrULrLz8tgGrKupn5IyDlpHufCQ67TexCTTMYzYTCyQFMIMG57FlZQYU4+NAmkHKJ9W1L6A7a/oMkbq7hdD+uuD83QBIZ603Ovq8gs9VHupQPaQkd+J/sqWDsaaJU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774976877; c=relaxed/simple;
	bh=fiF4x6KpwYFHTSL9jNU7iuQC3BN5XfBIfpbWOdVyO7U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KZYYa1VWz6KDyO19hE5IcVe0bPJVmD7oVToYM5qNUFqLMDRtZ0jW+/vqYNWn018rbp2HgFx4V9+8P27xmdEmtE2U4dylSSv4+TNDABrekG7w+xQELHQHd5y6t8SW9GG5h5Zr+kVTtrbJcc8/07DCpVZ3Tm2Zohl0qqvEs60NKm0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2VJQ9WP3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2VJQ9WP3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECCC1C19424;
	Tue, 31 Mar 2026 17:07:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774976877;
	bh=fiF4x6KpwYFHTSL9jNU7iuQC3BN5XfBIfpbWOdVyO7U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2VJQ9WP3ECJw6aYN3vKv+nyT0kyo4qXfi+s1Sx5FU1iL4FvSnGMKEq+jDIL1D/Jnq
	 r1t9ozg9O03XbgDrxXMpeWRQCEqcTgZ06BF21gd55HuwSsUlXIpR4xZxhIvBccyMQ4
	 8ANlpsniTUZjj0W+FlEgIK4RIt0wqM/NddizhU9c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ye Bin <yebin10@huawei.com>,
	Jan Kara <jack@suse.cz>,
	Theodore Tso <tytso@mit.edu>,
	stable@kernel.org
Subject: [PATCH 6.18 262/309] ext4: test if inodes all dirty pages are submitted to disk
Date: Tue, 31 Mar 2026 18:22:45 +0200
Message-ID: <20260331161803.210154552@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161753.468533260@linuxfoundation.org>
References: <20260331161753.468533260@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ye Bin <yebin10@huawei.com>

commit 73bf12adbea10b13647864cd1c62410d19e21086 upstream.

The commit aa373cf55099 ("writeback: stop background/kupdate works from
livelocking other works") introduced an issue where unmounting a filesystem
in a multi-logical-partition scenario could lead to batch file data loss.
This problem was not fixed until the commit d92109891f21 ("fs/writeback:
bail out if there is no more inodes for IO and queued once"). It took
considerable time to identify the root cause. Additionally, in actual
production environments, we frequently encountered file data loss after
normal system reboots. Therefore, we are adding a check in the inode
release flow to verify whether all dirty pages have been flushed to disk,
in order to determine whether the data loss is caused by a logic issue in
the filesystem code.

Signed-off-by: Ye Bin <yebin10@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Link: https://patch.msgid.link/20260303012242.3206465-1-yebin@huaweicloud.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Cc: stable@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/inode.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -184,6 +184,14 @@ void ext4_evict_inode(struct inode *inod
 	if (EXT4_I(inode)->i_flags & EXT4_EA_INODE_FL)
 		ext4_evict_ea_inode(inode);
 	if (inode->i_nlink) {
+		/*
+		 * If there's dirty page will lead to data loss, user
+		 * could see stale data.
+		 */
+		if (unlikely(!ext4_emergency_state(inode->i_sb) &&
+		    mapping_tagged(&inode->i_data, PAGECACHE_TAG_DIRTY)))
+			ext4_warning_inode(inode, "data will be lost");
+
 		truncate_inode_pages_final(&inode->i_data);
 
 		goto no_delete;


