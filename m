Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 204CD34F47E;
	Tue, 26 Aug 2025 13:57:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756216677; cv=none; b=HSQifJN1BA3FRvBVRZL3T+u80iYKN//B2PIGEVC8EQwGmKIU04amJRUOzUW3TDBFXlTg0I9i9fOEyp3B1xzT4DYBxuPKDJ+TCeT/AXSXf0wU+Pc5pWtydI0+yvgQ82S7E/uOx4GPMdMNDd1ByuJMFxlwZTTLtI421PkjtL+hxoE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756216677; c=relaxed/simple;
	bh=3LumM3OukdiUQMV2h2n+pE51f+4YfurPYD3zpSAODiU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TQLIWYTIa0Xn7R9HhyMtSNh6msiNJZGYTODUuqVuKNs+h01+rfBLOkJtSOn1/2Da/9LcsZJYWprrKG7EYpEYOeXla14B5XETMmdYU62Y+VRvkNWq6g01YtYqLprKUmxsCJhO+KyOL4fsg/sJ/xVnyk+jxIgHhZ6aXYuMmYmwMg8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xIgXkvgB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xIgXkvgB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A827FC4CEF1;
	Tue, 26 Aug 2025 13:57:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756216677;
	bh=3LumM3OukdiUQMV2h2n+pE51f+4YfurPYD3zpSAODiU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xIgXkvgB69/36qf9U0c1IO0EhsxajohFtQ4typtPdLtj7o6pI5NVshhFg2kAXygUh
	 oRQgzd8qtiCXlJ2duW/BdDUWTDGIA7xyTnlt5hlJMF+bdk6WonQlYy+dP4TxQpNT33
	 Bzh9PrSZCJDglQnOp7mqnckRCJhTP5M0wAy9UnaI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Theodore Tso <tytso@mit.edu>
Subject: [PATCH 5.15 470/644] ext4: dont try to clear the orphan_present feature block device is r/o
Date: Tue, 26 Aug 2025 13:09:21 +0200
Message-ID: <20250826110958.128952567@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110946.507083938@linuxfoundation.org>
References: <20250826110946.507083938@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Theodore Ts'o <tytso@mit.edu>

commit c5e104a91e7b6fa12c1dc2d8bf84abb7ef9b89ad upstream.

When the file system is frozen in preparation for taking an LVM
snapshot, the journal is checkpointed and if the orphan_file feature
is enabled, and the orphan file is empty, we clear the orphan_present
feature flag.  But if there are pending inodes that need to be removed
the orphan_present feature flag can't be cleared.

The problem comes if the block device is read-only.  In that case, we
can't process the orphan inode list, so it is skipped in
ext4_orphan_cleanup().  But then in ext4_mark_recovery_complete(),
this results in the ext4 error "Orphan file not empty on read-only fs"
firing and the file system mount is aborted.

Fix this by clearing the needs_recovery flag in the block device is
read-only.  We do this after the call to ext4_load_and_init-journal()
since there are some error checks need to be done in case the journal
needs to be replayed and the block device is read-only, or if the
block device containing the externa journal is read-only, etc.

Cc: stable@kernel.org
Link: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=1108271
Cc: stable@vger.kernel.org
Fixes: 02f310fcf47f ("ext4: Speedup ext4 orphan inode handling")
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/super.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -4669,6 +4669,8 @@ static int ext4_fill_super(struct super_
 		err = ext4_load_journal(sb, es, parsed_opts.journal_devnum);
 		if (err)
 			goto failed_mount3a;
+		if (bdev_read_only(sb->s_bdev))
+		    needs_recovery = 0;
 	} else if (test_opt(sb, NOLOAD) && !sb_rdonly(sb) &&
 		   ext4_has_feature_journal_needs_recovery(sb)) {
 		ext4_msg(sb, KERN_ERR, "required journal recovery "


