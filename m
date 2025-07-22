Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 130F028B507;
	Tue, 22 Jul 2025 13:59:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753192775; cv=none; b=SHC5jAWL46+FTVInSS2ddSBissUKjhHg22wWbZY5zInard+tIN0AMP80yhFWPmdn77xVAyr0uZVu8mi4QQOr6tBhW4u1NT/TJc/O+jBMCJRkJc5YTHFrOR0f4FSMVw6dOc7yZb6tTVo+atVmdEXdeGA9kfyhBvxFgefZ1EpBdGw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753192775; c=relaxed/simple;
	bh=j64YICOWRmYmCfZBTuQxKGimVbf7D7IzmJaorTkLfG8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HQr3ZVPkECHuOa2VngLy1h5y8tklYKc7LuF3sCRM0yIha6bt2ANbjXVkJVqzd0wFTvPXQqvJOFFMwba9MrqLBI5B5pE7SRRSJbgHkfGTdVzSZ+TKqp6MI7egdBwDi3rBT1CT3WS58smj29aHwpfxyi1B5G2VliEr4Y3j1M8+5H4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=STGxep9F; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="STGxep9F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89B74C4CEEB;
	Tue, 22 Jul 2025 13:59:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753192775;
	bh=j64YICOWRmYmCfZBTuQxKGimVbf7D7IzmJaorTkLfG8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=STGxep9FBSuO6KXdHDqhSJAfjbW0mjXOzX0ReSyhq7seotHNxobAKdJMWT5rP8Okx
	 Ko3fr6IrH2YMymsCjSGG640aMoir29JHcvsksjzhFpbu6f2ny2ZVY/Jo6ItEAYMWvH
	 VyJNuE7TYXZew4ie5gX/cT1Ef6Nq3qFOxJUd77L0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+895c23f6917da440ed0d@syzkaller.appspotmail.com,
	Jan Kara <jack@suse.cz>,
	Christian Brauner <brauner@kernel.org>
Subject: [PATCH 6.12 053/158] isofs: Verify inode mode when loading from disk
Date: Tue, 22 Jul 2025 15:43:57 +0200
Message-ID: <20250722134342.711249445@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250722134340.596340262@linuxfoundation.org>
References: <20250722134340.596340262@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


