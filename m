Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CA5B2D8771;
	Tue, 31 Mar 2026 17:10:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774977007; cv=none; b=eRVYFpP2Hd0PQB/fq9zU2xQ4wfJNEX0s2Q95Y6RalHWFIQdHrvKOtcdGxEnmj0FeMRmAv9AQvbomp7uAMJYThydTHh+drH70d7QvlUk/dVTLVLA8i4rSg9tqRWZ2jgaPXZADlR3svk6Cdu+6jwI5ssk45bERuLMMAbO+c/W38qw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774977007; c=relaxed/simple;
	bh=I+JKLcYUt8jt7mdURaysE0kS79S/q4nWCMYiCtl9m94=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CakTaDTmMuvJEQ0z7pqKR+C61heweTfJBMi0yXHhfJoeGNgAeIvYuONaXVrDdcCxhivOy9BPa029Pj0r4OYsev9l7FUxu5xx3cRl0bwAlpLIHhWJuwddyAdIfKlOR7GsRtALNF7GQR6VAvoxllT8xaUBOz66M+1l57NRMbXym2E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YSKsEyWZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YSKsEyWZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96F43C19423;
	Tue, 31 Mar 2026 17:10:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774977006;
	bh=I+JKLcYUt8jt7mdURaysE0kS79S/q4nWCMYiCtl9m94=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YSKsEyWZmYbirfwHO8tjsC9Md+Zna7sHMMidcSRqiQjl+en46ylX8iygPszlybt9x
	 NjkQSMkp7t0gdMnO+6D+Ywr7sMD74W0qq7MrcXM0iQj5E+Xy0Tp31aCH08Hhnp7wDl
	 1EoD7kCT89DS+vElnA3NYQy5ol7om2KFiUgpLGfc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	Baokun Li <libaokun@linux.alibaba.com>,
	Zhang Yi <yi.zhang@huawei.com>,
	Jan Kara <jack@suse.cz>,
	Theodore Tso <tytso@mit.edu>,
	stable@kernel.org
Subject: [PATCH 6.18 270/309] ext4: fix iloc.bh leak in ext4_fc_replay_inode() error paths
Date: Tue, 31 Mar 2026 18:22:53 +0200
Message-ID: <20260331161803.501149099@linuxfoundation.org>
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

From: Baokun Li <libaokun@linux.alibaba.com>

commit ec0a7500d8eace5b4f305fa0c594dd148f0e8d29 upstream.

During code review, Joseph found that ext4_fc_replay_inode() calls
ext4_get_fc_inode_loc() to get the inode location, which holds a
reference to iloc.bh that must be released via brelse().

However, several error paths jump to the 'out' label without
releasing iloc.bh:

 - ext4_handle_dirty_metadata() failure
 - sync_dirty_buffer() failure
 - ext4_mark_inode_used() failure
 - ext4_iget() failure

Fix this by introducing an 'out_brelse' label placed just before
the existing 'out' label to ensure iloc.bh is always released.

Additionally, make ext4_fc_replay_inode() propagate errors
properly instead of always returning 0.

Reported-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Fixes: 8016e29f4362 ("ext4: fast commit recovery path")
Signed-off-by: Baokun Li <libaokun@linux.alibaba.com>
Reviewed-by: Zhang Yi <yi.zhang@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Link: https://patch.msgid.link/20260323060836.3452660-1-libaokun@linux.alibaba.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Cc: stable@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/fast_commit.c |   13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

--- a/fs/ext4/fast_commit.c
+++ b/fs/ext4/fast_commit.c
@@ -1613,19 +1613,21 @@ static int ext4_fc_replay_inode(struct s
 	/* Immediately update the inode on disk. */
 	ret = ext4_handle_dirty_metadata(NULL, NULL, iloc.bh);
 	if (ret)
-		goto out;
+		goto out_brelse;
 	ret = sync_dirty_buffer(iloc.bh);
 	if (ret)
-		goto out;
+		goto out_brelse;
 	ret = ext4_mark_inode_used(sb, ino);
 	if (ret)
-		goto out;
+		goto out_brelse;
 
 	/* Given that we just wrote the inode on disk, this SHOULD succeed. */
 	inode = ext4_iget(sb, ino, EXT4_IGET_NORMAL);
 	if (IS_ERR(inode)) {
 		ext4_debug("Inode not found.");
-		return -EFSCORRUPTED;
+		inode = NULL;
+		ret = -EFSCORRUPTED;
+		goto out_brelse;
 	}
 
 	/*
@@ -1642,13 +1644,14 @@ static int ext4_fc_replay_inode(struct s
 	ext4_inode_csum_set(inode, ext4_raw_inode(&iloc), EXT4_I(inode));
 	ret = ext4_handle_dirty_metadata(NULL, NULL, iloc.bh);
 	sync_dirty_buffer(iloc.bh);
+out_brelse:
 	brelse(iloc.bh);
 out:
 	iput(inode);
 	if (!ret)
 		blkdev_issue_flush(sb->s_bdev);
 
-	return 0;
+	return ret;
 }
 
 /*


