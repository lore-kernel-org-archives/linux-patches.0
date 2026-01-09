Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA93035BDAB;
	Fri,  9 Jan 2026 12:41:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767962470; cv=none; b=jY9q+/XaUBLcftWe3ERagL5vD5BZxehLO9iz1V0sg0gQqQLJYDdmVE2XnYt8TqiUOEhiHDYpTjH2K7ooWEDYXjfGjEUdyXHE5tElvqrvLuO+Fx/8XF3RqyflcavILoIDBsYSozlcdNz3wATRIR/4BZP0Ra+IV5/JVHkfdQPBLo0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767962470; c=relaxed/simple;
	bh=Htxq+vCHFmiJcmsABreXXBoCsSS534GChM4WvVTErj4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OWQtsjiGyWrd3KINuGe+sB1irhphZ+daTq9Qqo+SKQ8wv+0I2CS7WAV7EDRYSfxDDR/MOOMB7EEBRDzm8Bd4CwxU5s5MZNaz1Q3PWWbBO9ltr1JXJt43jbvWv72cD0y1PIzeqJFTApXJCEMNyTcNSVz7tZ2hOT4O4ZoWN3cvPaw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IBwQ1w2K; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IBwQ1w2K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 614B1C4CEF1;
	Fri,  9 Jan 2026 12:41:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767962470;
	bh=Htxq+vCHFmiJcmsABreXXBoCsSS534GChM4WvVTErj4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IBwQ1w2KkGQAAl9PktbE4b02PkWbjQ5GQWjvoOBj+pCHTN1O4JkhfSNDjoAmVv0sg
	 coM+LDMfqcLFeEcb5+exAbHVvQl6TJirciUI0KHhg/hSmXUQfPG/wiUmm4koi76b4E
	 G0iUUA8eruj/WTuCftR1xrMa+D3i5rDhz4Vxygr4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+632cf32276a9a564188d@syzkaller.appspotmail.com,
	Chao Yu <chao@kernel.org>,
	Deepanshu Kartikey <kartikey406@gmail.com>,
	Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 6.1 349/634] f2fs: invalidate dentry cache on failed whiteout creation
Date: Fri,  9 Jan 2026 12:40:27 +0100
Message-ID: <20260109112130.656816357@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112117.407257400@linuxfoundation.org>
References: <20260109112117.407257400@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1028,9 +1028,11 @@ static int f2fs_rename(struct user_names
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


