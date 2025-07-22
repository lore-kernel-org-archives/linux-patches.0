Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5ABA1239E91;
	Tue, 22 Jul 2025 14:09:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753193350; cv=none; b=fPc6jy0dRqOsCePVErunWBwjlvogj1NTdTFJ1CZ7VLHIMmU3GhdJ4yxA3XUOda+brBqcWKfKHAdYzx7MTnx41dj7yM1qYiOmaAGHKxAwKD8cZGiIn8jC32POGnFS8oeMFsES4912hZh2Kxv+P6AE+IuEuC9FfyroHYL8GgIAqsE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753193350; c=relaxed/simple;
	bh=t3qgTA9ptIV8NhoE/8kK2281CmbqeS0OJutbb2GNGPI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r/wSjhjgK1aZohqWu0qJLXUfqT4xc8nK7JIXEYBbA4WiH6a+vOiH1wj5F6xV6XRXDZRcv3xuTVbXfp1qwj+s47d2G9Fn4AHl0HwjZhvqmG+TreZfmRLfEDc0EU5iB0LdZoIP+79ZMCeyCXBPCsJ6uqIlQwdcqiacVgP9wggEows=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1eNsarWy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1eNsarWy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 875B0C4CEEB;
	Tue, 22 Jul 2025 14:09:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753193349;
	bh=t3qgTA9ptIV8NhoE/8kK2281CmbqeS0OJutbb2GNGPI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1eNsarWyeob4hwTuWXWW+0zo9XkcWkYg093lUCrBpuZLotL8UZWWG5WbVEfA2WvBj
	 BcfuC5M/f4Hw0Kag31IUdMewx0jjR5jt65kHt9mgDtzWGWcQN/gWI5OTDaWo72LtIi
	 vURmq8F8K1my7PPCG9wySFdlpIJtq6emgb3sSfzM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+895c23f6917da440ed0d@syzkaller.appspotmail.com,
	Jan Kara <jack@suse.cz>,
	Christian Brauner <brauner@kernel.org>
Subject: [PATCH 6.15 063/187] isofs: Verify inode mode when loading from disk
Date: Tue, 22 Jul 2025 15:43:53 +0200
Message-ID: <20250722134348.096567964@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250722134345.761035548@linuxfoundation.org>
References: <20250722134345.761035548@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1440,9 +1440,16 @@ static int isofs_read_inode(struct inode
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


