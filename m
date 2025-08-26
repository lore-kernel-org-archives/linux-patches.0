Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83F1113FD86;
	Tue, 26 Aug 2025 13:36:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756215399; cv=none; b=XBe5KQZYATl56aZDRCvSGQrr2/dUHcjTxaz9T/jllUy8Dhymv0+TwfZAH4tW2krm5kbeVM00SViFPoUJ1Tc5PJ/mCg2XHW30FNvI8/GcYb/sAljpk0adRJX9uLYiIxqxfIaS10vHezkbGqlWlSSqoFRhg6g40K3ffA//jZBAC6o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756215399; c=relaxed/simple;
	bh=JGGxjXHREq8PlJfTU3YfCSQ5XMUafKxUyfYlC7t6m20=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RInMfuBA3uqscChH2FXBoaxsYvN5XZEk+ssa2DR5lJdyqyPb0C9isVDh46IwNITL7m9jHaPZjpiK1ZjpmVs84yuSShQHsgszmWIRlpVxFAhEVKNt/OnsC6sQEHuthdHKcY0shguqrjq3oh6k0+xDST+BbWs3B/gr2uBaZeJY26s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yJblggRo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yJblggRo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A07F1C4CEF1;
	Tue, 26 Aug 2025 13:36:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756215396;
	bh=JGGxjXHREq8PlJfTU3YfCSQ5XMUafKxUyfYlC7t6m20=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yJblggRo3OZWYZ45LAlj/B6D4ttf+g0KnG7Q6dfQRjgWvPbPyICVt+6Rt1t9wlj6h
	 ueXX3LR5HzUpIZHtH1+fggbJzkKCyVDAj7EkWALkfdKRPunmQZf5KaY843jqgReN/U
	 0kh0PjBOiQqOQV+8wCrPyvGeKxFM0tBNxc7Y3X9I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+895c23f6917da440ed0d@syzkaller.appspotmail.com,
	Jan Kara <jack@suse.cz>,
	Christian Brauner <brauner@kernel.org>
Subject: [PATCH 5.15 018/644] isofs: Verify inode mode when loading from disk
Date: Tue, 26 Aug 2025 13:01:49 +0200
Message-ID: <20250826110946.960582134@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110946.507083938@linuxfoundation.org>
References: <20250826110946.507083938@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1493,9 +1493,16 @@ static int isofs_read_inode(struct inode
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


