Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCBBD8F5B
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:27:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EBB6C433C8;
	Sun, 16 Jul 2023 20:27:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689539271;
	bh=lpHgPp03kY/XegNE/KXUK0Tdog9lw2oHIt6IAqdQ92g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nk5AHSp07ofPbBWSBeKMwAQfUOmNJiqp4dX2Yb20+NKqi8j50/ZSromcx5MOZ6ZsK
	 ZR5UZHh9BVV/l+tcQExHBxbT+0fFUv0eZdvmsHQQVyIjZ4jXxyIoIB9YnTvXER+clZ
	 I18ZSRmvgMYGTriDiMQsfahasoXW7vfCq218ceqo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Kara <jack@suse.cz>,
	Christian Brauner <brauner@kernel.org>
Subject: [PATCH 6.4 748/800] Revert "udf: Protect rename against modification of moved directory"
Date: Sun, 16 Jul 2023 21:50:01 +0200
Message-ID: <20230716195006.495963506@linuxfoundation.org>
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

commit 7517ce5dc4d6963ef9ace2acb3f081ef8cd8a1e3 upstream.

This reverts commit f950fd0529130a617b3da526da9fb6a896ce87c2. The
locking is going to be provided by vfs_rename() in the following
patches.

CC: stable@vger.kernel.org
Signed-off-by: Jan Kara <jack@suse.cz>
Message-Id: <20230601105830.13168-2-jack@suse.cz>
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/udf/namei.c |   14 ++------------
 1 file changed, 2 insertions(+), 12 deletions(-)

--- a/fs/udf/namei.c
+++ b/fs/udf/namei.c
@@ -793,11 +793,6 @@ static int udf_rename(struct mnt_idmap *
 			if (!empty_dir(new_inode))
 				goto out_oiter;
 		}
-		/*
-		 * We need to protect against old_inode getting converted from
-		 * ICB to normal directory.
-		 */
-		inode_lock_nested(old_inode, I_MUTEX_NONDIR2);
 		retval = udf_fiiter_find_entry(old_inode, &dotdot_name,
 					       &diriter);
 		if (retval == -ENOENT) {
@@ -806,10 +801,8 @@ static int udf_rename(struct mnt_idmap *
 				old_inode->i_ino);
 			retval = -EFSCORRUPTED;
 		}
-		if (retval) {
-			inode_unlock(old_inode);
+		if (retval)
 			goto out_oiter;
-		}
 		has_diriter = true;
 		tloc = lelb_to_cpu(diriter.fi.icb.extLocation);
 		if (udf_get_lb_pblock(old_inode->i_sb, &tloc, 0) !=
@@ -889,7 +882,6 @@ static int udf_rename(struct mnt_idmap *
 			       udf_dir_entry_len(&diriter.fi));
 		udf_fiiter_write_fi(&diriter, NULL);
 		udf_fiiter_release(&diriter);
-		inode_unlock(old_inode);
 
 		inode_dec_link_count(old_dir);
 		if (new_inode)
@@ -901,10 +893,8 @@ static int udf_rename(struct mnt_idmap *
 	}
 	return 0;
 out_oiter:
-	if (has_diriter) {
+	if (has_diriter)
 		udf_fiiter_release(&diriter);
-		inode_unlock(old_inode);
-	}
 	udf_fiiter_release(&oiter);
 
 	return retval;


