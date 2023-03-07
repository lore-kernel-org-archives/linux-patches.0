Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74779BA3E
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 17:47:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDD2FC433D2;
	Tue,  7 Mar 2023 17:47:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678211259;
	bh=70y1U63keAodOZJFq4PorxI2kI6/zEqyIpIvlOXZUuE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FlO5iv8UvxoRoy4f0iSJaHoINqtX07p37BfTq5mIs/Zmbu8NqTho/SVks6iR99INW
	 KMELv8yRDMcp1KGR9g22ywO+/dMaYisa3ofrDJYvfc/raf0uMEfXPd3xsji4LJj5V7
	 kSF5UP9rZSbxBH7o9JT/Nr098l4Ds77L9iO4MHRo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Randall Huang <huangrandall@google.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 6.2 0805/1001] f2fs: retry to update the inode page given data corruption
Date: Tue,  7 Mar 2023 17:59:37 +0100
Message-Id: <20230307170056.665594541@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jaegeuk Kim <jaegeuk@kernel.org>

commit 3aa51c61cb4a4dcb40df51ac61171e9ac5a35321 upstream.

If the storage gives a corrupted node block due to short power failure and
reset, f2fs stops the entire operations by setting the checkpoint failure flag.

Let's give more chances to live by re-issuing IOs for a while in such critical
path.

Cc: stable@vger.kernel.org
Suggested-by: Randall Huang <huangrandall@google.com>
Suggested-by: Chao Yu <chao@kernel.org>
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/f2fs/inode.c |   13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

--- a/fs/f2fs/inode.c
+++ b/fs/f2fs/inode.c
@@ -714,18 +714,19 @@ void f2fs_update_inode_page(struct inode
 {
 	struct f2fs_sb_info *sbi = F2FS_I_SB(inode);
 	struct page *node_page;
+	int count = 0;
 retry:
 	node_page = f2fs_get_node_page(sbi, inode->i_ino);
 	if (IS_ERR(node_page)) {
 		int err = PTR_ERR(node_page);
 
-		if (err == -ENOMEM) {
-			cond_resched();
+		/* The node block was truncated. */
+		if (err == -ENOENT)
+			return;
+
+		if (err == -ENOMEM || ++count <= DEFAULT_RETRY_IO_COUNT)
 			goto retry;
-		} else if (err != -ENOENT) {
-			f2fs_stop_checkpoint(sbi, false,
-					STOP_CP_REASON_UPDATE_INODE);
-		}
+		f2fs_stop_checkpoint(sbi, false, STOP_CP_REASON_UPDATE_INODE);
 		return;
 	}
 	f2fs_update_inode(inode, node_page);


