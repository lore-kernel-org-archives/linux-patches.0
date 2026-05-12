Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 846DF3C0A1A;
	Tue, 12 May 2026 17:48:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778608121; cv=none; b=CuV1KBdjugVbJiF46cPFqcRaXAZoGRg56HCjv9OqP8obq+cMXN9uN3u2ZFZZBplflvGH9daigm3a0uEEdCL7nf7gA9loaQpSHC/bjZ9zygq850Ta0Ss/77HpNNJVFSporOca97oUQhTkFCxXeNCkTwkuuY3bMgLlmmf5I0C/QCE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778608121; c=relaxed/simple;
	bh=x32BXy56QJ32nOYGgiyMLY417o9i08240Eej2MVzdEw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SCWrWh0IazMOTwyv03qsTMQ8XWSS/4DBXQT8W/YISI4xflYxTZNRvu3wJyG2nGWrHrF0ZbRzFQDESXJSXkVVgA5MayoE1w6SzjEw2jpOqCwKSJNcxtOFr/dZ4Zr/OdBvaJAFK1snyNw2x2bjoLAyYsTW8eCvaPVSWlvEV4qerVA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IXrvOXQZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IXrvOXQZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 184F4C2BCC7;
	Tue, 12 May 2026 17:48:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778608121;
	bh=x32BXy56QJ32nOYGgiyMLY417o9i08240Eej2MVzdEw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IXrvOXQZy2+J9kyl/Jawt18S+ylq3bY9axZdHRsoCHwy3u/oDbtzrlwqe0/wfOKEk
	 kXFNq+j/QmaLIXp45mAnKKP/gVgKyzLsANuaTGfT9DZWSKO1FyTU/gxJTWmMP4fpcX
	 Vxlk4fRhqXs2O7dYTpZ5CkAtwu5Nw0gTkVppbmYs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cen Zhang <zzzccc427@gmail.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 6.12 164/206] f2fs: add READ_ONCE() for i_blocks in f2fs_update_inode()
Date: Tue, 12 May 2026 19:40:16 +0200
Message-ID: <20260512173936.336658673@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173932.810559588@linuxfoundation.org>
References: <20260512173932.810559588@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Cen Zhang <zzzccc427@gmail.com>

commit 5471834a96fb697874be2ca0b052e74bcf3c23d1 upstream.

f2fs_update_inode() reads inode->i_blocks without holding i_lock to
serialize it to the on-disk inode, while concurrent truncate or
allocation paths may modify i_blocks under i_lock.  Since blkcnt_t is
u64, this risks torn reads on 32-bit architectures.

Following the approach in ext4_inode_blocks_set(), add READ_ONCE() to prevent
potential compiler-induced tearing.

Fixes: 19f99cee206c ("f2fs: add core inode operations")
Cc: stable@vger.kernel.org
Signed-off-by: Cen Zhang <zzzccc427@gmail.com>
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/f2fs/inode.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/f2fs/inode.c
+++ b/fs/f2fs/inode.c
@@ -663,7 +663,7 @@ void f2fs_update_inode(struct inode *ino
 	ri->i_uid = cpu_to_le32(i_uid_read(inode));
 	ri->i_gid = cpu_to_le32(i_gid_read(inode));
 	ri->i_links = cpu_to_le32(inode->i_nlink);
-	ri->i_blocks = cpu_to_le64(SECTOR_TO_BLOCK(inode->i_blocks) + 1);
+	ri->i_blocks = cpu_to_le64(SECTOR_TO_BLOCK(READ_ONCE(inode->i_blocks)) + 1);
 
 	if (!f2fs_is_atomic_file(inode) ||
 			is_inode_flag_set(inode, FI_ATOMIC_COMMITTED))


