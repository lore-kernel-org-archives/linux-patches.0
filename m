Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B1D78F57
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:55:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92047C433C7;
	Sun, 16 Jul 2023 20:55:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689540954;
	bh=YylVmHeRS2GMQ3cH0vBDkmRfvHoxdfIKog+38ItbStg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=H3E6sahYOWZynIi/naP+m+8PUh+y1OtY5KPnmY/9r8vBIhWDEOao0f+b3rbaMP1Xq
	 JYPSeGjc764VUK+SrxRa/KuCqhXvw5gyFNBBN8xAYgD0ssZ2kupgdxZROocVjI1TSn
	 3+4qTdNRkDuJYhvOIVP0Y7CsmtSsXFdJQVDaW8gk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ted Tso <tytso@mit.edu>,
	Jan Kara <jack@suse.cz>,
	Christian Brauner <brauner@kernel.org>
Subject: [PATCH 6.1 547/591] ext4: Remove ext4 locking of moved directory
Date: Sun, 16 Jul 2023 21:51:26 +0200
Message-ID: <20230716194938.012236236@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194923.861634455@linuxfoundation.org>
References: <20230716194923.861634455@linuxfoundation.org>
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

commit 3658840cd363f2be094f5dfd2f0b174a9055dd0f upstream.

Remove locking of moved directory in ext4_rename2(). We will take care
of it in VFS instead. This effectively reverts commit 0813299c586b
("ext4: Fix possible corruption when moving a directory") and followup
fixes.

CC: Ted Tso <tytso@mit.edu>
CC: stable@vger.kernel.org
Signed-off-by: Jan Kara <jack@suse.cz>
Message-Id: <20230601105830.13168-1-jack@suse.cz>
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/namei.c |   17 ++---------------
 1 file changed, 2 insertions(+), 15 deletions(-)

--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -3834,19 +3834,10 @@ static int ext4_rename(struct user_names
 			return retval;
 	}
 
-	/*
-	 * We need to protect against old.inode directory getting converted
-	 * from inline directory format into a normal one.
-	 */
-	if (S_ISDIR(old.inode->i_mode))
-		inode_lock_nested(old.inode, I_MUTEX_NONDIR2);
-
 	old.bh = ext4_find_entry(old.dir, &old.dentry->d_name, &old.de,
 				 &old.inlined);
-	if (IS_ERR(old.bh)) {
-		retval = PTR_ERR(old.bh);
-		goto unlock_moved_dir;
-	}
+	if (IS_ERR(old.bh))
+		return PTR_ERR(old.bh);
 
 	/*
 	 *  Check for inode number is _not_ due to possible IO errors.
@@ -4043,10 +4034,6 @@ release_bh:
 	brelse(old.bh);
 	brelse(new.bh);
 
-unlock_moved_dir:
-	if (S_ISDIR(old.inode->i_mode))
-		inode_unlock(old.inode);
-
 	return retval;
 }
 


