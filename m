Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 463963D34A5;
	Thu, 15 Jan 2026 17:51:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768499485; cv=none; b=BaB5Lri9X/HZPkuv7FSKlC4QOGOKBK7k5AJ7MpL2fb9YEgXybUVPklWpPmulLQ2CrjWMRijZsB/gnJ70YhjuCdRhz+YQFkpKc7uneBiknxX3/V1kM+1nwlv5duuWzmXaQrGVUu6tCQIal8wPjQ7lUZH/MnHjB6XxfQbeFDl5WxU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768499485; c=relaxed/simple;
	bh=t4N8ObFjz8yjZXr1fTBT3s8MZw/JdqFXERG7kw1AsPs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kmHkzjsECpib+H23DMoSejHllAxni2y/AItByi6TtqjVOzRNT5yP6bWNiRR7Svmfab+R4MToq4Mb9tyElhFRfvTGMKwpvNdBXluWGUJiFGYTpkMXYW0SQLzLzHQnOj6aFbyZvtDh/9T9LAElSJFrvsKTJ3SfB60EyjOdOOR+unE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LjUHBMGF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LjUHBMGF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81FA7C16AAE;
	Thu, 15 Jan 2026 17:51:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768499484;
	bh=t4N8ObFjz8yjZXr1fTBT3s8MZw/JdqFXERG7kw1AsPs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LjUHBMGF7Ebedv5XPcpoHv9PzsHKH90NcxxPPkp+b247oYHozCagcsmqhoi5DCiuZ
	 LBhatIXS+OcrlbT7IHce/HrWlWBWb6vwJwWJeJBYlqON+G87G1b9f3xe+XSRs2NtpC
	 T1/qzkAO6Hej8wEZWyphFufOO5J974HX89fZgU/g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+632cf32276a9a564188d@syzkaller.appspotmail.com,
	Chao Yu <chao@kernel.org>,
	Deepanshu Kartikey <kartikey406@gmail.com>,
	Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 5.10 244/451] f2fs: invalidate dentry cache on failed whiteout creation
Date: Thu, 15 Jan 2026 17:47:25 +0100
Message-ID: <20260115164239.719830988@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164230.864985076@linuxfoundation.org>
References: <20260115164230.864985076@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Deepanshu Kartikey <kartikey406@gmail.com>

commit d33f89b34aa313f50f9a512d58dd288999f246b0 upstream.

F2FS can mount filesystems with corrupted directory depth values that
get runtime-clamped to MAX_DIR_HASH_DEPTH. When RENAME_WHITEOUT
operations are performed on such directories, f2fs_rename performs
directory modifications (updating target entry and deleting source
entry) before attempting to add the whiteout entry via f2fs_add_link.

If f2fs_add_link fails due to the corrupted directory structure, the
function returns an error to VFS, but the partial directory
modifications have already been committed to disk. VFS assumes the
entire rename operation failed and does not update the dentry cache,
leaving stale mappings.

In the error path, VFS does not call d_move() to update the dentry
cache. This results in new_dentry still pointing to the old inode
(new_inode) which has already had its i_nlink decremented to zero.
The stale cache causes subsequent operations to incorrectly reference
the freed inode.

This causes subsequent operations to use cached dentry information that
no longer matches the on-disk state. When a second rename targets the
same entry, VFS attempts to decrement i_nlink on the stale inode, which
may already have i_nlink=0, triggering a WARNING in drop_nlink().

Example sequence:
1. First rename (RENAME_WHITEOUT): file2 → file1
   - f2fs updates file1 entry on disk (points to inode 8)
   - f2fs deletes file2 entry on disk
   - f2fs_add_link(whiteout) fails (corrupted directory)
   - Returns error to VFS
   - VFS does not call d_move() due to error
   - VFS cache still has: file1 → inode 7 (stale!)
   - inode 7 has i_nlink=0 (already decremented)

2. Second rename: file3 → file1
   - VFS uses stale cache: file1 → inode 7
   - Tries to drop_nlink on inode 7 (i_nlink already 0)
   - WARNING in drop_nlink()

Fix this by explicitly invalidating old_dentry and new_dentry when
f2fs_add_link fails during whiteout creation. This forces VFS to
refresh from disk on subsequent operations, ensuring cache consistency
even when the rename partially succeeds.

Reproducer:
1. Mount F2FS image with corrupted i_current_depth
2. renameat2(file2, file1, RENAME_WHITEOUT)
3. renameat2(file3, file1, 0)
4. System triggers WARNING in drop_nlink()

Fixes: 7e01e7ad746b ("f2fs: support RENAME_WHITEOUT")
Reported-by: syzbot+632cf32276a9a564188d@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=632cf32276a9a564188d
Suggested-by: Chao Yu <chao@kernel.org>
Link: https://lore.kernel.org/all/20251022233349.102728-1-kartikey406@gmail.com/ [v1]
Cc: stable@vger.kernel.org
Signed-off-by: Deepanshu Kartikey <kartikey406@gmail.com>
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/f2fs/namei.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/fs/f2fs/namei.c
+++ b/fs/f2fs/namei.c
@@ -1064,9 +1064,11 @@ static int f2fs_rename(struct inode *old
 	if (whiteout) {
 		set_inode_flag(whiteout, FI_INC_LINK);
 		err = f2fs_add_link(old_dentry, whiteout);
-		if (err)
+		if (err) {
+			d_invalidate(old_dentry);
+			d_invalidate(new_dentry);
 			goto put_out_dir;
-
+		}
 		spin_lock(&whiteout->i_lock);
 		whiteout->i_state &= ~I_LINKABLE;
 		spin_unlock(&whiteout->i_lock);


