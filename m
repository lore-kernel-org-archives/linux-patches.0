Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 822EA355034;
	Tue,  6 Jan 2026 17:23:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767720219; cv=none; b=SM/cCmgMtvFzkj2+gB0ch3eOhD2FPLlem0hFVpeHQME04kuBjE9e6KBmUBhgEHcUyvLfYCcabASa4jSUTHFQyTZ+ppuInDZTFS/i/xZ9QWNLkiFaPZjVFwGTVAgX5THh309lqhTouN2hP/FlQbjs0G9MX01XcjuaiQYsy3GOYVk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767720219; c=relaxed/simple;
	bh=NezV/Am3ukjLW3VJfz5Qq94Qg3QqhBEzS1jsAcopZv8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eFPx18CBezc/GmZDbAnvRyTOgb+owfIPpqIBVdwfzDn29D/GqScFNw/GQbLYeQ/wWOs4xrC2hANtaPm/xhkD8G7Ih84NJSacYPIxxwxqvW9RizDAFXnFzmC3n+fyfk3o61d+vTc9n54XqqD0EDG4+th/XpWGslL0fXsvKSKHzwY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QO3VIAtk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QO3VIAtk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0803C16AAE;
	Tue,  6 Jan 2026 17:23:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767720219;
	bh=NezV/Am3ukjLW3VJfz5Qq94Qg3QqhBEzS1jsAcopZv8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QO3VIAtklUU/os+nnD7AD+59mLPByshVaDxVefrie2eI1Czt0migZQttyyHs8geJQ
	 LHgwR5B5LaC+F79iG4Ta0xEFwFv7UKQqrnsJmWY3hOh/iZRPAcdRcC7jlP9mZi5yoM
	 xpJQpD7FYD/sW6bt9LsRjg9hOrSVaXq5KWLRXEyg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haibo Chen <haibo.chen@nxp.com>,
	Baokun Li <libaokun1@huawei.com>,
	Zhang Yi <yi.zhang@huawei.com>,
	Jan Kara <jack@suse.cz>,
	Theodore Tso <tytso@mit.edu>,
	stable@kernel.org
Subject: [PATCH 6.12 169/567] ext4: clear i_state_flags when alloc inode
Date: Tue,  6 Jan 2026 17:59:11 +0100
Message-ID: <20260106170457.578560628@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170451.332875001@linuxfoundation.org>
References: <20260106170451.332875001@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Haibo Chen <haibo.chen@nxp.com>

commit 4091c8206cfd2e3bb529ef260887296b90d9b6a2 upstream.

i_state_flags used on 32-bit archs, need to clear this flag when
alloc inode.
Find this issue when umount ext4, sometimes track the inode as orphan
accidently, cause ext4 mesg dump.

Fixes: acf943e9768e ("ext4: fix checks for orphan inodes")
Signed-off-by: Haibo Chen <haibo.chen@nxp.com>
Reviewed-by: Baokun Li <libaokun1@huawei.com>
Reviewed-by: Zhang Yi <yi.zhang@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Message-ID: <20251104-ext4-v1-1-73691a0800f9@nxp.com>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Cc: stable@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/ialloc.c |    1 -
 fs/ext4/inode.c  |    1 -
 fs/ext4/super.c  |    1 +
 3 files changed, 1 insertion(+), 2 deletions(-)

--- a/fs/ext4/ialloc.c
+++ b/fs/ext4/ialloc.c
@@ -1292,7 +1292,6 @@ got:
 					      sizeof(gen));
 	}
 
-	ext4_clear_state_flags(ei); /* Only relevant on 32-bit archs */
 	ext4_set_inode_state(inode, EXT4_STATE_NEW);
 
 	ei->i_extra_isize = sbi->s_want_extra_isize;
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -4878,7 +4878,6 @@ struct inode *__ext4_iget(struct super_b
 	ei->i_projid = make_kprojid(&init_user_ns, i_projid);
 	set_nlink(inode, le16_to_cpu(raw_inode->i_links_count));
 
-	ext4_clear_state_flags(ei);	/* Only relevant on 32-bit archs */
 	ei->i_inline_off = 0;
 	ei->i_dir_start_lookup = 0;
 	ei->i_dtime = le32_to_cpu(raw_inode->i_dtime);
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1418,6 +1418,7 @@ static struct inode *ext4_alloc_inode(st
 
 	inode_set_iversion(&ei->vfs_inode, 1);
 	ei->i_flags = 0;
+	ext4_clear_state_flags(ei);	/* Only relevant on 32-bit archs */
 	spin_lock_init(&ei->i_raw_lock);
 	ei->i_prealloc_node = RB_ROOT;
 	atomic_set(&ei->i_prealloc_active, 0);


