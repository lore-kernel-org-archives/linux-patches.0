Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F273F34AB0D;
	Tue, 26 Aug 2025 14:05:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756217102; cv=none; b=CtGbJex8fvoxwM1dX15mGEVGQjV4OA3L1KqjUi0IjYFtVy/iAjmmDjYZGPrq1Com2lohCduoFf5V1QMR9/zfmkIcxfN70UO5ZPO6GQDA+LmSArogv5ByPFyYbzPxEjoSL8zGkPDGz8QRw5vfwNNWUBN1qn9QHxc+2SWUsbjgp3A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756217102; c=relaxed/simple;
	bh=Pnd2NPc2YXEV6vaCT2dUbOc/GDpM6ek8h+4Js4zo3u8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RFYxly8fRRbhSctKlwK33lSExyIur6+pb1HO60NrSQx7WJHgDFyEnDLj3zbo5yWvDGTh2oP2rCMkfuliTmQFKzCNiZ/cj+y2sKsYlJbLZ3/9NnYEY8N06ppYGsJYnOJ359Q5CNFzsim3jmW6ZwxmuNgrEecBvrexam22LQviSWI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KbySk2es; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KbySk2es"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8543CC4CEF1;
	Tue, 26 Aug 2025 14:05:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756217101;
	bh=Pnd2NPc2YXEV6vaCT2dUbOc/GDpM6ek8h+4Js4zo3u8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KbySk2esXCgXhiQHsVdUoUCoRuvkqggKrzfU9Jo5NyQNpPdagV/M3I5fRg9NzJUyO
	 m7YdMDz4iGSMGW0D7HDcf+27PHMiOgYfv8Yy/DImeIbT6CJJj/nsbXRSa5F5v00JpX
	 XH4GyRhUUC6eeCuPpUlPy7X/0Qmouc4mV8B5XzqM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+895c23f6917da440ed0d@syzkaller.appspotmail.com,
	Jan Kara <jack@suse.cz>,
	Christian Brauner <brauner@kernel.org>
Subject: [PATCH 5.10 017/523] isofs: Verify inode mode when loading from disk
Date: Tue, 26 Aug 2025 13:03:47 +0200
Message-ID: <20250826110925.011526202@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110924.562212281@linuxfoundation.org>
References: <20250826110924.562212281@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1492,9 +1492,16 @@ static int isofs_read_inode(struct inode
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


