Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 414E8569E
	for <patches@lists.linux.dev>; Sun, 28 May 2023 19:13:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C31A4C433EF;
	Sun, 28 May 2023 19:13:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1685301197;
	bh=6oshVciF23uQHCikDHNmKnGQsl2XchcwdwEeZTu0m3Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kAapAi3yAX6sndeqbSLMSvcXI6MFe7oTvsATwPXdEf6kqXGuk1SZY91vTnSBzgjRn
	 VPs7fhvOQRCm6x8jHBz5aZe5r+vYQ4bsP+QTdIkc0ZrWyhCyTHNy5B9AqBOh/lnKtv
	 vxrra3u+3yLZW+zdSjV2JI5nhkhqYAN1P27XIMYY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot <syzbot+e2787430e752a92b8750@syzkaller.appspotmail.com>,
	syzbot <syzbot+4913dca2ea6e4d43f3f1@syzkaller.appspotmail.com>,
	Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
	Viacheslav Dubeyko <slava@dubeyko.com>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 06/86] fs: hfsplus: remove WARN_ON() from hfsplus_cat_{read,write}_inode()
Date: Sun, 28 May 2023 20:09:40 +0100
Message-Id: <20230528190828.790869511@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230528190828.564682883@linuxfoundation.org>
References: <20230528190828.564682883@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>

[ Upstream commit 81b21c0f0138ff5a499eafc3eb0578ad2a99622c ]

syzbot is hitting WARN_ON() in hfsplus_cat_{read,write}_inode(), for
crafted filesystem image can contain bogus length. There conditions are
not kernel bugs that can justify kernel to panic.

Reported-by: syzbot <syzbot+e2787430e752a92b8750@syzkaller.appspotmail.com>
Link: https://syzkaller.appspot.com/bug?extid=e2787430e752a92b8750
Reported-by: syzbot <syzbot+4913dca2ea6e4d43f3f1@syzkaller.appspotmail.com>
Link: https://syzkaller.appspot.com/bug?extid=4913dca2ea6e4d43f3f1
Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Reviewed-by: Viacheslav Dubeyko <slava@dubeyko.com>
Message-Id: <15308173-5252-d6a3-ae3b-e96d46cb6f41@I-love.SAKURA.ne.jp>
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/hfsplus/inode.c | 28 +++++++++++++++++++++++-----
 1 file changed, 23 insertions(+), 5 deletions(-)

diff --git a/fs/hfsplus/inode.c b/fs/hfsplus/inode.c
index ccb2a94c2032a..4924a489c8ac0 100644
--- a/fs/hfsplus/inode.c
+++ b/fs/hfsplus/inode.c
@@ -488,7 +488,11 @@ int hfsplus_cat_read_inode(struct inode *inode, struct hfs_find_data *fd)
 	if (type == HFSPLUS_FOLDER) {
 		struct hfsplus_cat_folder *folder = &entry.folder;
 
-		WARN_ON(fd->entrylength < sizeof(struct hfsplus_cat_folder));
+		if (fd->entrylength < sizeof(struct hfsplus_cat_folder)) {
+			pr_err("bad catalog folder entry\n");
+			res = -EIO;
+			goto out;
+		}
 		hfs_bnode_read(fd->bnode, &entry, fd->entryoffset,
 					sizeof(struct hfsplus_cat_folder));
 		hfsplus_get_perms(inode, &folder->permissions, 1);
@@ -508,7 +512,11 @@ int hfsplus_cat_read_inode(struct inode *inode, struct hfs_find_data *fd)
 	} else if (type == HFSPLUS_FILE) {
 		struct hfsplus_cat_file *file = &entry.file;
 
-		WARN_ON(fd->entrylength < sizeof(struct hfsplus_cat_file));
+		if (fd->entrylength < sizeof(struct hfsplus_cat_file)) {
+			pr_err("bad catalog file entry\n");
+			res = -EIO;
+			goto out;
+		}
 		hfs_bnode_read(fd->bnode, &entry, fd->entryoffset,
 					sizeof(struct hfsplus_cat_file));
 
@@ -539,6 +547,7 @@ int hfsplus_cat_read_inode(struct inode *inode, struct hfs_find_data *fd)
 		pr_err("bad catalog entry used to create inode\n");
 		res = -EIO;
 	}
+out:
 	return res;
 }
 
@@ -547,6 +556,7 @@ int hfsplus_cat_write_inode(struct inode *inode)
 	struct inode *main_inode = inode;
 	struct hfs_find_data fd;
 	hfsplus_cat_entry entry;
+	int res = 0;
 
 	if (HFSPLUS_IS_RSRC(inode))
 		main_inode = HFSPLUS_I(inode)->rsrc_inode;
@@ -565,7 +575,11 @@ int hfsplus_cat_write_inode(struct inode *inode)
 	if (S_ISDIR(main_inode->i_mode)) {
 		struct hfsplus_cat_folder *folder = &entry.folder;
 
-		WARN_ON(fd.entrylength < sizeof(struct hfsplus_cat_folder));
+		if (fd.entrylength < sizeof(struct hfsplus_cat_folder)) {
+			pr_err("bad catalog folder entry\n");
+			res = -EIO;
+			goto out;
+		}
 		hfs_bnode_read(fd.bnode, &entry, fd.entryoffset,
 					sizeof(struct hfsplus_cat_folder));
 		/* simple node checks? */
@@ -590,7 +604,11 @@ int hfsplus_cat_write_inode(struct inode *inode)
 	} else {
 		struct hfsplus_cat_file *file = &entry.file;
 
-		WARN_ON(fd.entrylength < sizeof(struct hfsplus_cat_file));
+		if (fd.entrylength < sizeof(struct hfsplus_cat_file)) {
+			pr_err("bad catalog file entry\n");
+			res = -EIO;
+			goto out;
+		}
 		hfs_bnode_read(fd.bnode, &entry, fd.entryoffset,
 					sizeof(struct hfsplus_cat_file));
 		hfsplus_inode_write_fork(inode, &file->data_fork);
@@ -611,5 +629,5 @@ int hfsplus_cat_write_inode(struct inode *inode)
 	set_bit(HFSPLUS_I_CAT_DIRTY, &HFSPLUS_I(inode)->flags);
 out:
 	hfs_find_exit(&fd);
-	return 0;
+	return res;
 }
-- 
2.39.2



