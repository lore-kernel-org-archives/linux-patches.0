Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B66A61C289;
	Wed,  3 Jan 2024 16:57:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x1W9HfV0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AD66C433C7;
	Wed,  3 Jan 2024 16:57:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1704301034;
	bh=AGXZqoo03mAJK3a58t1+5+JMyeuMbs23HoODtslh39w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=x1W9HfV0XxWmBWt9YIaGCTJRl/40LxEr3TqQPEw89XBEg4vd4i+uSbBPMNAJFu6TH
	 neG1/Gdg44zDRmeceRr/3rmec3y4TRtq0dAVeGXtIhJatcuEzdXWr6J5JUjdGUxnyK
	 g6c2koL4gHH0mwdtBnV/MilXWmwXUMqB9rOTz8+s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 021/100] ksmbd: call putname after using the last component
Date: Wed,  3 Jan 2024 17:54:10 +0100
Message-ID: <20240103164859.259982292@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240103164856.169912722@linuxfoundation.org>
References: <20240103164856.169912722@linuxfoundation.org>
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

From: Namjae Jeon <linkinjeon@kernel.org>

[ Upstream commit 6fe55c2799bc29624770c26f98ba7b06214f43e0 ]

last component point filename struct. Currently putname is called after
vfs_path_parent_lookup(). And then last component is used for
lookup_one_qstr_excl(). name in last component is freed by previous
calling putname(). And It cause file lookup failure when testing
generic/464 test of xfstest.

Fixes: 74d7970febf7 ("ksmbd: fix racy issue from using ->d_parent and ->d_name")
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/vfs.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/fs/smb/server/vfs.c b/fs/smb/server/vfs.c
index 5d2bb58d77e80..ebcd5a312f10d 100644
--- a/fs/smb/server/vfs.c
+++ b/fs/smb/server/vfs.c
@@ -87,12 +87,14 @@ static int ksmbd_vfs_path_lookup_locked(struct ksmbd_share_config *share_conf,
 	err = vfs_path_parent_lookup(filename, flags,
 				     &parent_path, &last, &type,
 				     root_share_path);
-	putname(filename);
-	if (err)
+	if (err) {
+		putname(filename);
 		return err;
+	}
 
 	if (unlikely(type != LAST_NORM)) {
 		path_put(&parent_path);
+		putname(filename);
 		return -ENOENT;
 	}
 
@@ -109,12 +111,14 @@ static int ksmbd_vfs_path_lookup_locked(struct ksmbd_share_config *share_conf,
 	path->dentry = d;
 	path->mnt = share_conf->vfs_path.mnt;
 	path_put(&parent_path);
+	putname(filename);
 
 	return 0;
 
 err_out:
 	inode_unlock(parent_path.dentry->d_inode);
 	path_put(&parent_path);
+	putname(filename);
 	return -ENOENT;
 }
 
-- 
2.43.0



