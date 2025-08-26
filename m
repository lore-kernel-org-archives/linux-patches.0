Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3F1C340DA7;
	Tue, 26 Aug 2025 14:29:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756218549; cv=none; b=r00qMG4dTvGdzMlgVdjDxtPT1nPt+qn3+l9Umnu204fI5a8puYQkF1UEwqOc4TVGHZiE5vBbL0jb2XG2iQtEPTX8vyHnRxMLrOXSkS8Vh6NKwvFzc9umj9u4wsv9pff8hxuxUvauHu8mP5bbezohC1Tdck4SAFFaTxtwZo41VQM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756218549; c=relaxed/simple;
	bh=M9Ik9PxyWcpjSt8zCugrARBvN4XI1L0bk5rBPT1F1SQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DDZU0LhmZ05WDlF6vX9/6528uCpn6ovmM1Yv14mq34nw2rIVXG6OzmQimLUiosy29Y9T1br3NiESbReR09/poK42o/+e/m9N0uozFIYqDHeddkR4I65vAvXFROSfH89umeXUsQVA+Ym9IjbDeOJY0keqRmPg7TpJWWdhIxt6XO0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WMxoBQRO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WMxoBQRO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD092C4CEF1;
	Tue, 26 Aug 2025 14:29:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756218549;
	bh=M9Ik9PxyWcpjSt8zCugrARBvN4XI1L0bk5rBPT1F1SQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WMxoBQROI0J4ccQtuCUlrsd8XdUi1+Pg6NC2ww2KDcWm9f+LV9CqxJfn4bFcSXmBK
	 XGWXpWkEfureN3DJwGTSPMR3pXEFTkwOc5sWThC59VU3jnOMIag6aQmZGonI6HpdMB
	 9MQNpMU1UG1OdNwIL6547+My4r924QHGtcKSJx38=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+895c23f6917da440ed0d@syzkaller.appspotmail.com,
	Jan Kara <jack@suse.cz>,
	Christian Brauner <brauner@kernel.org>
Subject: [PATCH 5.4 015/403] isofs: Verify inode mode when loading from disk
Date: Tue, 26 Aug 2025 13:05:41 +0200
Message-ID: <20250826110906.185157040@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110905.607690791@linuxfoundation.org>
References: <20250826110905.607690791@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jan Kara <jack@suse.cz>

commit 0a9e7405131380b57e155f10242b2e25d2e51852 upstream.

Verify that the inode mode is sane when loading it from the disk to
avoid complaints from VFS about setting up invalid inodes.

Reported-by: syzbot+895c23f6917da440ed0d@syzkaller.appspotmail.com
CC: stable@vger.kernel.org
Signed-off-by: Jan Kara <jack@suse.cz>
Link: https://lore.kernel.org/20250709095545.31062-2-jack@suse.cz
Acked-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/isofs/inode.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/fs/isofs/inode.c
+++ b/fs/isofs/inode.c
@@ -1499,9 +1499,16 @@ static int isofs_read_inode(struct inode
 		inode->i_op = &page_symlink_inode_operations;
 		inode_nohighmem(inode);
 		inode->i_data.a_ops = &isofs_symlink_aops;
-	} else
+	} else if (S_ISCHR(inode->i_mode) || S_ISBLK(inode->i_mode) ||
+		   S_ISFIFO(inode->i_mode) || S_ISSOCK(inode->i_mode)) {
 		/* XXX - parse_rock_ridge_inode() had already set i_rdev. */
 		init_special_inode(inode, inode->i_mode, inode->i_rdev);
+	} else {
+		printk(KERN_DEBUG "ISOFS: Invalid file type 0%04o for inode %lu.\n",
+			inode->i_mode, inode->i_ino);
+		ret = -EIO;
+		goto fail;
+	}
 
 	ret = 0;
 out:


