Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9455D168C5
	for <patches@lists.linux.dev>; Mon,  8 May 2023 10:47:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6E90C433EF;
	Mon,  8 May 2023 10:47:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683542864;
	bh=aiT/1/I0dWK5SUBMQewo+ZK2ooa7XQGqTvjSek7ZkI8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tcb3PodxpvggJBgR6CGbolWgBZM99T3HpM15tCbiVJu5+prUUzjMu8xNlE/XMFarc
	 0OXnumh/WckzEvc+E8lLnBR4KdyUgWUy6EMbLda486UBGrUwdGJf5zV73lflVMo+Vo
	 v9EqrQS/kt3ZEjD2JLweUMM/sDufBQE2buAbn+w4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bharath SM <bharathsm@microsoft.com>,
	Ronnie Sahlberg <lsahlber@redhat.com>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>,
	Paulo Alcantara <pc@manguebit.com>
Subject: [PATCH 6.2 574/663] SMB3: Add missing locks to protect deferred close file list
Date: Mon,  8 May 2023 11:46:40 +0200
Message-Id: <20230508094447.889343785@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094428.384831245@linuxfoundation.org>
References: <20230508094428.384831245@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Bharath SM <bharathsm@microsoft.com>

[ Upstream commit ab9ddc87a9055c4bebd6524d5d761d605d52e557 ]

cifs_del_deferred_close function has a critical section which modifies
the deferred close file list. We must acquire deferred_lock before
calling cifs_del_deferred_close function.

Fixes: ca08d0eac020 ("cifs: Fix memory leak on the deferred close")
Signed-off-by: Bharath SM <bharathsm@microsoft.com>
Acked-off-by: Paulo Alcantara (SUSE) <pc@manguebit.com>
Acked-by: Ronnie Sahlberg <lsahlber@redhat.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/cifs/misc.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/cifs/misc.c b/fs/cifs/misc.c
index 2fae6b08314d9..dc97013469748 100644
--- a/fs/cifs/misc.c
+++ b/fs/cifs/misc.c
@@ -749,7 +749,9 @@ cifs_close_deferred_file(struct cifsInodeInfo *cifs_inode)
 	list_for_each_entry(cfile, &cifs_inode->openFileList, flist) {
 		if (delayed_work_pending(&cfile->deferred)) {
 			if (cancel_delayed_work(&cfile->deferred)) {
+				spin_lock(&cifs_inode->deferred_lock);
 				cifs_del_deferred_close(cfile);
+				spin_unlock(&cifs_inode->deferred_lock);
 
 				tmp_list = kmalloc(sizeof(struct file_list), GFP_ATOMIC);
 				if (tmp_list == NULL)
@@ -780,7 +782,9 @@ cifs_close_all_deferred_files(struct cifs_tcon *tcon)
 	list_for_each_entry(cfile, &tcon->openFileList, tlist) {
 		if (delayed_work_pending(&cfile->deferred)) {
 			if (cancel_delayed_work(&cfile->deferred)) {
+				spin_lock(&CIFS_I(d_inode(cfile->dentry))->deferred_lock);
 				cifs_del_deferred_close(cfile);
+				spin_unlock(&CIFS_I(d_inode(cfile->dentry))->deferred_lock);
 
 				tmp_list = kmalloc(sizeof(struct file_list), GFP_ATOMIC);
 				if (tmp_list == NULL)
@@ -815,7 +819,9 @@ cifs_close_deferred_file_under_dentry(struct cifs_tcon *tcon, const char *path)
 		if (strstr(full_path, path)) {
 			if (delayed_work_pending(&cfile->deferred)) {
 				if (cancel_delayed_work(&cfile->deferred)) {
+					spin_lock(&CIFS_I(d_inode(cfile->dentry))->deferred_lock);
 					cifs_del_deferred_close(cfile);
+					spin_unlock(&CIFS_I(d_inode(cfile->dentry))->deferred_lock);
 
 					tmp_list = kmalloc(sizeof(struct file_list), GFP_ATOMIC);
 					if (tmp_list == NULL)
-- 
2.39.2



