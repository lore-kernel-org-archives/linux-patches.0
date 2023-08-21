Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E537311703
	for <patches@lists.linux.dev>; Mon, 21 Aug 2023 20:05:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67737C433C7;
	Mon, 21 Aug 2023 20:05:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1692648309;
	bh=KI5Z3AUjxG6zC8s5ncD7Sqllh4UZAiGOE9keJPjbYyc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BMfdGcYsz3wXOkL+aXQvsa/YyYj1agqeRQiEmyHROH5qMu7SDqDgrX9EAQ6daMK7L
	 zFDFY3wW7krNQ0KPu7zSajilAFWDHsGUV5GYmhx9ouCvL7Ju4xQ8YlIjJXoEKOWm4b
	 UzICy8WsTxsqnFVMQBR/9kUyCDwQEPS2Dgi6Yuto=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bharath SM <bharathsm@microsoft.com>,
	Shyam Prasad N <sprasad@microsoft.com>,
	"Paulo Alcantara (SUSE)" <pc@manguebit.com>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 091/234] cifs: fix potential oops in cifs_oplock_break
Date: Mon, 21 Aug 2023 21:40:54 +0200
Message-ID: <20230821194132.825278331@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230821194128.754601642@linuxfoundation.org>
References: <20230821194128.754601642@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Steve French <stfrench@microsoft.com>

[ Upstream commit e8f5f849ffce24490eb9449e98312b66c0dba76f ]

With deferred close we can have closes that race with lease breaks,
and so with the current checks for whether to send the lease response,
oplock_response(), this can mean that an unmount (kill_sb) can occur
just before we were checking if the tcon->ses is valid.  See below:

[Fri Aug  4 04:12:50 2023] RIP: 0010:cifs_oplock_break+0x1f7/0x5b0 [cifs]
[Fri Aug  4 04:12:50 2023] Code: 7d a8 48 8b 7d c0 c0 e9 02 48 89 45 b8 41 89 cf e8 3e f5 ff ff 4c 89 f7 41 83 e7 01 e8 82 b3 03 f2 49 8b 45 50 48 85 c0 74 5e <48> 83 78 60 00 74 57 45 84 ff 75 52 48 8b 43 98 48 83 eb 68 48 39
[Fri Aug  4 04:12:50 2023] RSP: 0018:ffffb30607ddbdf8 EFLAGS: 00010206
[Fri Aug  4 04:12:50 2023] RAX: 632d223d32612022 RBX: ffff97136944b1e0 RCX: 0000000080100009
[Fri Aug  4 04:12:50 2023] RDX: 0000000000000001 RSI: 0000000080100009 RDI: ffff97136944b188
[Fri Aug  4 04:12:50 2023] RBP: ffffb30607ddbe58 R08: 0000000000000001 R09: ffffffffc08e0900
[Fri Aug  4 04:12:50 2023] R10: 0000000000000001 R11: 000000000000000f R12: ffff97136944b138
[Fri Aug  4 04:12:50 2023] R13: ffff97149147c000 R14: ffff97136944b188 R15: 0000000000000000
[Fri Aug  4 04:12:50 2023] FS:  0000000000000000(0000) GS:ffff9714f7c00000(0000) knlGS:0000000000000000
[Fri Aug  4 04:12:50 2023] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[Fri Aug  4 04:12:50 2023] CR2: 00007fd8de9c7590 CR3: 000000011228e000 CR4: 0000000000350ef0
[Fri Aug  4 04:12:50 2023] Call Trace:
[Fri Aug  4 04:12:50 2023]  <TASK>
[Fri Aug  4 04:12:50 2023]  process_one_work+0x225/0x3d0
[Fri Aug  4 04:12:50 2023]  worker_thread+0x4d/0x3e0
[Fri Aug  4 04:12:50 2023]  ? process_one_work+0x3d0/0x3d0
[Fri Aug  4 04:12:50 2023]  kthread+0x12a/0x150
[Fri Aug  4 04:12:50 2023]  ? set_kthread_struct+0x50/0x50
[Fri Aug  4 04:12:50 2023]  ret_from_fork+0x22/0x30
[Fri Aug  4 04:12:50 2023]  </TASK>

To fix this change the ordering of the checks before sending the oplock_response
to first check if the openFileList is empty.

Fixes: da787d5b7498 ("SMB3: Do not send lease break acknowledgment if all file handles have been closed")
Suggested-by: Bharath SM <bharathsm@microsoft.com>
Reviewed-by: Bharath SM <bharathsm@microsoft.com>
Reviewed-by: Shyam Prasad N <sprasad@microsoft.com>
Signed-off-by: Paulo Alcantara (SUSE) <pc@manguebit.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/file.c | 23 ++++++++++++++++-------
 1 file changed, 16 insertions(+), 7 deletions(-)

diff --git a/fs/smb/client/file.c b/fs/smb/client/file.c
index d554bca7e07eb..4e9d26d4404ab 100644
--- a/fs/smb/client/file.c
+++ b/fs/smb/client/file.c
@@ -4878,9 +4878,11 @@ void cifs_oplock_break(struct work_struct *work)
 	struct cifsFileInfo *cfile = container_of(work, struct cifsFileInfo,
 						  oplock_break);
 	struct inode *inode = d_inode(cfile->dentry);
+	struct cifs_sb_info *cifs_sb = CIFS_SB(inode->i_sb);
 	struct cifsInodeInfo *cinode = CIFS_I(inode);
-	struct cifs_tcon *tcon = tlink_tcon(cfile->tlink);
-	struct TCP_Server_Info *server = tcon->ses->server;
+	struct cifs_tcon *tcon;
+	struct TCP_Server_Info *server;
+	struct tcon_link *tlink;
 	int rc = 0;
 	bool purge_cache = false, oplock_break_cancelled;
 	__u64 persistent_fid, volatile_fid;
@@ -4889,6 +4891,12 @@ void cifs_oplock_break(struct work_struct *work)
 	wait_on_bit(&cinode->flags, CIFS_INODE_PENDING_WRITERS,
 			TASK_UNINTERRUPTIBLE);
 
+	tlink = cifs_sb_tlink(cifs_sb);
+	if (IS_ERR(tlink))
+		goto out;
+	tcon = tlink_tcon(tlink);
+	server = tcon->ses->server;
+
 	server->ops->downgrade_oplock(server, cinode, cfile->oplock_level,
 				      cfile->oplock_epoch, &purge_cache);
 
@@ -4938,18 +4946,19 @@ void cifs_oplock_break(struct work_struct *work)
 	/*
 	 * MS-SMB2 3.2.5.19.1 and 3.2.5.19.2 (and MS-CIFS 3.2.5.42) do not require
 	 * an acknowledgment to be sent when the file has already been closed.
-	 * check for server null, since can race with kill_sb calling tree disconnect.
 	 */
 	spin_lock(&cinode->open_file_lock);
-	if (tcon->ses && tcon->ses->server && !oplock_break_cancelled &&
-					!list_empty(&cinode->openFileList)) {
+	/* check list empty since can race with kill_sb calling tree disconnect */
+	if (!oplock_break_cancelled && !list_empty(&cinode->openFileList)) {
 		spin_unlock(&cinode->open_file_lock);
-		rc = tcon->ses->server->ops->oplock_response(tcon, persistent_fid,
-						volatile_fid, net_fid, cinode);
+		rc = server->ops->oplock_response(tcon, persistent_fid,
+						  volatile_fid, net_fid, cinode);
 		cifs_dbg(FYI, "Oplock release rc = %d\n", rc);
 	} else
 		spin_unlock(&cinode->open_file_lock);
 
+	cifs_put_tlink(tlink);
+out:
 	cifs_done_oplock_break(cinode);
 }
 
-- 
2.40.1



