Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BE5B1CF5C6;
	Wed,  2 Oct 2024 13:51:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727877089; cv=none; b=egeC/Db9Ls/GWqDl7LM+xQyeQOZz3LurPznGM+laqrP1ssYYm+4+s3Hwh/qzSg+UggnAJSRsvuXauUR1CqH79RXlJlCdwXp7vU88a3N+9VVMoXP3uKU5a7ZPvH3ELy6RDwPeJE+3UDKhJS5SPCDBlgoPzl+D6AYp4vxbZ2WMs8s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727877089; c=relaxed/simple;
	bh=YVm31YF47dzZgU0j1DM2bCu6h4Qini0mn5owKJlGBSs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X4HngqfM+lkZKWrOUTXBUC5O6W3NHgO9Ws+p0n6Xx7zIiKzZYN4D7U7mQoIEr7GhggMZ0cQ6z5ZsswqapyInjUzU2zzJo+RcrH/cHre4XCLngftZL8cd9setSY0zugewX0H5AM5TqJBUbSO8cmHA7rhTrl6eOldQMbsG0wrdx80=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kY578s9w; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kY578s9w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7740AC4CEC2;
	Wed,  2 Oct 2024 13:51:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727877088;
	bh=YVm31YF47dzZgU0j1DM2bCu6h4Qini0mn5owKJlGBSs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kY578s9wLq2kF3pHPQdwID3u93sm65jZN/Oe+njpUbfUHouzNBBjSBCGs2DjipH9/
	 uq+tTG23ciN31RDb3Cre5U4Y+dZyYzAwXwrE8Gy+8Y6T6KKXRPsoSFkibEkhl2rOpX
	 GCmUneevabD5P77P8gfXmes4ZVVPo/Oltagaxq8U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 6.11 629/695] f2fs: fix to wait dio completion
Date: Wed,  2 Oct 2024 15:00:27 +0200
Message-ID: <20241002125847.623886472@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chao Yu <chao@kernel.org>

commit 96cfeb0389530ae32ade8a48ae3ae1ac3b6c009d upstream.

It should wait all existing dio write IOs before block removal,
otherwise, previous direct write IO may overwrite data in the
block which may be reused by other inode.

Cc: stable@vger.kernel.org
Signed-off-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/f2fs/file.c |   13 +++++++++++++
 1 file changed, 13 insertions(+)

--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -1055,6 +1055,13 @@ int f2fs_setattr(struct mnt_idmap *idmap
 				return err;
 		}
 
+		/*
+		 * wait for inflight dio, blocks should be removed after
+		 * IO completion.
+		 */
+		if (attr->ia_size < old_size)
+			inode_dio_wait(inode);
+
 		f2fs_down_write(&fi->i_gc_rwsem[WRITE]);
 		filemap_invalidate_lock(inode->i_mapping);
 
@@ -1891,6 +1898,12 @@ static long f2fs_fallocate(struct file *
 	if (ret)
 		goto out;
 
+	/*
+	 * wait for inflight dio, blocks should be removed after IO
+	 * completion.
+	 */
+	inode_dio_wait(inode);
+
 	if (mode & FALLOC_FL_PUNCH_HOLE) {
 		if (offset >= inode->i_size)
 			goto out;


