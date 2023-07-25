Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F0F31ED38
	for <patches@lists.linux.dev>; Tue, 25 Jul 2023 11:24:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 212F9C433C7;
	Tue, 25 Jul 2023 11:24:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690284299;
	bh=kAdIPoXISoq456+JMhGrPGLjtPKRLYA7ZLrqhBGAkkY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Dj35ZwaNFyZ2u22OvoPMx/SrlaEUgCbt50TGjUUIisaQsBnpaVN8NgUrlXp8xSiJJ
	 3H4u3YDkLYuoBttdqugKOebGk+9cf+Zr+D5P5JHJ3TvsmVFu8I+zKZJfDyVKq9S4hf
	 UMQ6gup3cw3KNNeAvFbxivfDDaylc20dNqhd69dk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Christian Brauner <brauner@kernel.org>
Subject: [PATCH 5.10 306/509] fs: no need to check source
Date: Tue, 25 Jul 2023 12:44:05 +0200
Message-ID: <20230725104607.750970311@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230725104553.588743331@linuxfoundation.org>
References: <20230725104553.588743331@linuxfoundation.org>
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
@@ -4394,8 +4394,7 @@ int vfs_rename(struct inode *old_dir, st
 			d_exchange(old_dentry, new_dentry);
 	}
 out:
-	if (source)
-		inode_unlock(source);
+	inode_unlock(source);
 	if (target)
 		inode_unlock(target);
 	dput(new_dentry);


