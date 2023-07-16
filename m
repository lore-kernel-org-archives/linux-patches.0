Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68A4D8F5B
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:29:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC1A4C433C7;
	Sun, 16 Jul 2023 20:29:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689539349;
	bh=Gfh2ziAuAO7opn0cpoE+254++AdfDLfaXW+ofUC+4+M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qTCgJiXs8uy/muvrElF5UlPo4LbsVNd8C5z7MEmuPCsiP/TA5+i5WjYmpnbcXwH3j
	 xT4cFzQ3SX3cq2UKzrvc6yPo3OgNuMbaLWWCTe3KgKcuBZzTqHq4yF7vp3AYWjluvZ
	 DHZ5dpUMkha3fzNxDIsWZRYysQSsSVvesDgAmhVY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Christian Brauner <brauner@kernel.org>
Subject: [PATCH 6.4 776/800] fs: no need to check source
Date: Sun, 16 Jul 2023 21:50:29 +0200
Message-ID: <20230716195007.173360499@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194949.099592437@linuxfoundation.org>
References: <20230716194949.099592437@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jan Kara <jack@suse.cz>

commit 66d8fc0539b0d49941f313c9509a8384e4245ac1 upstream.

The @source inode must be valid. It is even checked via IS_SWAPFILE()
above making it pretty clear. So no need to check it when we unlock.

What doesn't need to exist is the @target inode. The lock_two_inodes()
helper currently swaps the @inode1 and @inode2 arguments if @inode1 is
NULL to have consistent lock class usage. However, we know that at least
for vfs_rename() that @inode1 is @source and thus is never NULL as per
above. We also know that @source is a different inode than @target as
that is checked right at the beginning of vfs_rename(). So we know that
@source is valid and locked and that @target is locked. So drop the
check whether @source is non-NULL.

Fixes: 28eceeda130f ("fs: Lock moved directories")
Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Closes: https://lore.kernel.org/r/202307030026.9sE2pk2x-lkp@intel.com
Message-Id: <20230703-vfs-rename-source-v1-1-37eebb29b65b@kernel.org>
[brauner: use commit message from patch I sent concurrently]
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/namei.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/fs/namei.c
+++ b/fs/namei.c
@@ -4872,8 +4872,7 @@ int vfs_rename(struct renamedata *rd)
 			d_exchange(old_dentry, new_dentry);
 	}
 out:
-	if (source)
-		inode_unlock(source);
+	inode_unlock(source);
 	if (target)
 		inode_unlock(target);
 	dput(new_dentry);


