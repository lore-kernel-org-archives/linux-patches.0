Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8F42168C5
	for <patches@lists.linux.dev>; Mon,  8 May 2023 10:47:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15A8DC433EF;
	Mon,  8 May 2023 10:47:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683542870;
	bh=N7LKGteunCULXdsapzmXF+r7V2rn0cyLKYEhbCrEXBo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PQijG47ZqmnfoNOAssncCg01l58RtSxSlwXiJXE0mPnc3B4jyVb04Ntv100Y7wTFI
	 ZsahSmKcRmcdTpvx1ON9kpheonfXjpCH/pK6gC0I7qwLgKkiDv+FO6G78QXy0ar6Pb
	 byExsJlc2Vpk88orcY5L6IG2adlir+djaVSuXs64=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bharath SM <bharathsm@microsoft.com>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 575/663] SMB3: Close deferred file handles in case of handle lease break
Date: Mon,  8 May 2023 11:46:41 +0200
Message-Id: <20230508094447.935336967@linuxfoundation.org>
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

[ Upstream commit d906be3fa571f6fc9381911304a0eca99f1b6951 ]

We should not cache deferred file handles if we dont have
handle lease on a file. And we should immediately close all
deferred handles in case of handle lease break.

Fixes: 9e31678fb403 ("SMB3: fix lease break timeout when multiple deferred close handles for the same file.")
Signed-off-by: Bharath SM <bharathsm@microsoft.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/cifs/file.c | 16 ++++++++++++++++
 fs/cifs/misc.c |  2 +-
 2 files changed, 17 insertions(+), 1 deletion(-)

diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index a53ddc81b698c..bef7c335ccc6e 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -5096,6 +5096,8 @@ void cifs_oplock_break(struct work_struct *work)
 	struct TCP_Server_Info *server = tcon->ses->server;
 	int rc = 0;
 	bool purge_cache = false;
+	struct cifs_deferred_close *dclose;
+	bool is_deferred = false;
 
 	wait_on_bit(&cinode->flags, CIFS_INODE_PENDING_WRITERS,
 			TASK_UNINTERRUPTIBLE);
@@ -5131,6 +5133,20 @@ void cifs_oplock_break(struct work_struct *work)
 		cifs_dbg(VFS, "Push locks rc = %d\n", rc);
 
 oplock_break_ack:
+	/*
+	 * When oplock break is received and there are no active
+	 * file handles but cached, then schedule deferred close immediately.
+	 * So, new open will not use cached handle.
+	 */
+	spin_lock(&CIFS_I(inode)->deferred_lock);
+	is_deferred = cifs_is_deferred_close(cfile, &dclose);
+	spin_unlock(&CIFS_I(inode)->deferred_lock);
+
+	if (!CIFS_CACHE_HANDLE(cinode) && is_deferred &&
+			cfile->deferred_close_scheduled && delayed_work_pending(&cfile->deferred)) {
+		cifs_close_deferred_file(cinode);
+	}
+
 	/*
 	 * releasing stale oplock after recent reconnect of smb session using
 	 * a now incorrect file handle is not a data integrity issue but do
diff --git a/fs/cifs/misc.c b/fs/cifs/misc.c
index dc97013469748..ee0a3c3f6b1d6 100644
--- a/fs/cifs/misc.c
+++ b/fs/cifs/misc.c
@@ -764,7 +764,7 @@ cifs_close_deferred_file(struct cifsInodeInfo *cifs_inode)
 	spin_unlock(&cifs_inode->open_file_lock);
 
 	list_for_each_entry_safe(tmp_list, tmp_next_list, &file_head, list) {
-		_cifsFileInfo_put(tmp_list->cfile, true, false);
+		_cifsFileInfo_put(tmp_list->cfile, false, false);
 		list_del(&tmp_list->list);
 		kfree(tmp_list);
 	}
-- 
2.39.2



