Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68E9C8801;
	Tue, 30 Apr 2024 11:11:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714475474; cv=none; b=ti/f/hhmH/2HctzlCkofxeGamNMKj214GMtv4A9e/Lv4gI8Sv2ao+e+62hwYPaYbROcbUftHs2vTLTWyXTfVLgMQbW7vbxhwLPl8YzL1dKF2uiwMokdaXctpHGoTMOnZX0CIG9S1zk+Eroen78FrmWbzfIUonVPV6aOjXT6fNpc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714475474; c=relaxed/simple;
	bh=l7hJm2E4iu4K7FZ9J+qI87juqw7S3rnOTKYdo9QzluU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AovozSBLDlvgjqCxO8BmknfvAcRveyoo3MWHYSlTIp16tPoyjYJekxPguac5OI4LmZgEiW+rnUQpvU02+XOt2MczTb502MzC4aJSahy9qac5yCWAXO+G1zYmUST6rP0YX+FdUSjeUTZbTLMYkL7BCMMcT+F1EFMTXqyk3Dc28eY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zOIc4qOU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zOIc4qOU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9395C2BBFC;
	Tue, 30 Apr 2024 11:11:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714475474;
	bh=l7hJm2E4iu4K7FZ9J+qI87juqw7S3rnOTKYdo9QzluU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zOIc4qOUUYC4q6PcI1XrZsrUPbjqN/aepWhKUGmpyi0loue57nAPkhIYgQArCvUE9
	 djqiIP6i8e7NTBMurN25Ucj2KD0x4m6WEqV6uzi+bay9EdeiLYQAeAxCHUrgSAm9zf
	 Q84jWNAZK50oW8PE42nP91JwKy0cAyTftt3OXAAk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 105/186] squashfs: convert to new timestamp accessors
Date: Tue, 30 Apr 2024 12:39:17 +0200
Message-ID: <20240430103101.082843463@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103058.010791820@linuxfoundation.org>
References: <20240430103058.010791820@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jeff Layton <jlayton@kernel.org>

[ Upstream commit a1f13ed8c74893ed31d41c5bca156a623b0e9a86 ]

Convert to using the new inode timestamp accessor functions.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
Link: https://lore.kernel.org/r/20231004185347.80880-68-jlayton@kernel.org
Signed-off-by: Christian Brauner <brauner@kernel.org>
Stable-dep-of: 9253c54e01b6 ("Squashfs: check the inode number is not the invalid value of zero")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/squashfs/inode.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/squashfs/inode.c b/fs/squashfs/inode.c
index c6e626b00546b..aa3411354e66d 100644
--- a/fs/squashfs/inode.c
+++ b/fs/squashfs/inode.c
@@ -59,9 +59,9 @@ static int squashfs_new_inode(struct super_block *sb, struct inode *inode,
 	i_uid_write(inode, i_uid);
 	i_gid_write(inode, i_gid);
 	inode->i_ino = le32_to_cpu(sqsh_ino->inode_number);
-	inode->i_mtime.tv_sec = le32_to_cpu(sqsh_ino->mtime);
-	inode->i_atime.tv_sec = inode->i_mtime.tv_sec;
-	inode_set_ctime(inode, inode->i_mtime.tv_sec, 0);
+	inode_set_mtime(inode, le32_to_cpu(sqsh_ino->mtime), 0);
+	inode_set_atime(inode, inode_get_mtime_sec(inode), 0);
+	inode_set_ctime(inode, inode_get_mtime_sec(inode), 0);
 	inode->i_mode = le16_to_cpu(sqsh_ino->mode);
 	inode->i_size = 0;
 
-- 
2.43.0



