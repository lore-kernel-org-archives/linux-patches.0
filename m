Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E4D83A542B;
	Sat, 17 Oct 2026 18:12:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792260763; cv=none; b=OHb+7XMmyIsEHHMS1KFAt24Q1fpcCcB+mt68bKnDA7jyxFYydg36JpZXfbD31MWVAsnGHd8mgR5BPOZKgWW8BtmobVYYMvj1v9aM2b76S2iWoiwL9eRt/BwST53k6S/9aQtuwmlQrae+VtQeW5Z+WQV+oQraQLNNcWLOYupy9kE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792260763; c=relaxed/simple;
	bh=ztbznIGYXloT6DofN81bqt3Twe5gzCzzYYi76EtGHGg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t+HpB9gNQMBXkUYiI9tZ/tGX/wmX2wyYujarR0XxbwveYzIiuxLZiqYb7K45yeVGxvQKJfh5TvtB2DZjJindO80hYMSAe0Ln+4peG9+gP73v4Kvd5G0ScxlXl+7YV8WhQ6CcnIYLP1vvPuixwVWvumHXgPh0zdaF56n55AsO6Xs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0liFmUQM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0liFmUQM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F28F1F000C4;
	Sat, 17 Oct 2026 18:12:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792260762;
	bh=c0xq/DCw9rhI5Q7QiakP2KetduF6BK0kxg61gYusVZw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0liFmUQMxzwl+4XOvZJktR3I+0PylD1FQJDSeBAvsqPU5esN8YMl5JkLAsSpa7IsH
	 Z4Fldf+uymqKgn4pnUoyBZtACFRjPtCuJr4O8g2qX/0xE1fjrpspqeEz2TF81awpYA
	 J7erNRq1/slkdaH4KiS88nNRaC4QSvG9fKXvkgEU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Huiwen He <hehuiwen@kylinos.cn>,
	ChenXiaoSong <chenxiaosong@kylinos.cn>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Paulo Alcantara <pc@manguebit.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1652/1674] smb/client: fix stale page cache in insert/collapse range
Date: Sat, 17 Oct 2026 18:05:24 +0200
Message-ID: <20261017160513.476604598@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Huiwen He <hehuiwen@kylinos.cn>

[ Upstream commit 01261a6fa48b62f5ead8e88aaca1e27cb9ab9032 ]

smb3_insert_range() and smb3_collapse_range() use
truncate_pagecache_range() to invalidate the affected page cache.
However, if off or old_eof is not page-aligned, the boundary pages are
only partially zeroed and remain uptodate. As a result, the client may
return stale data after a successful insert/collapse range operation.

For example, with 4K pages:

    page 0          page 1          page 2
    0------4K       4K------8K      8K------12K
       ^                                ^
    off=2K                       old_eof=10K

Page 1 is removed from the page cache, while the boundary pages are
only partially zeroed. After COPYCHUNK moves the data on the server,
these cached pages may still return stale data.

This can be reproduced on a CIFS mount:

    bash -c '
            FILE=/mnt/scratch/repro

            # Use a 6 KiB file so EOF is not page-aligned.
            dd if=/dev/urandom of=/tmp/src bs=1K count=6 status=none

            # Expected: a 4 KiB hole followed by the original data.
            rm -f /tmp/expected
            truncate -s 4K /tmp/expected
            cat /tmp/src >> /tmp/expected

            cp /tmp/src "$FILE"

            # Prime the page cache before moving data on the server.
            cat "$FILE" > /dev/null

            fallocate --insert-range -o 0 -l 4K "$FILE"

            if cmp -s /tmp/expected "$FILE"; then
                    echo "readback: OK"
            else
                    echo "readback: STALE DATA"
            fi
    '

Fix this by writing back dirty data and discarding the page cache from
the start of the page containing off to EOF before moving data on the
server.

Fixes: 9c8b7a293f50 ("smb3: fix temporary data corruption in insert range")
Fixes: fa30a81f255a ("smb3: fix temporary data corruption in collapse range")
Signed-off-by: Huiwen He <hehuiwen@kylinos.cn>
Reviewed-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
Reviewed-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Paulo Alcantara <pc@manguebit.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/smb2ops.c | 20 ++++++++++++++++----
 1 file changed, 16 insertions(+), 4 deletions(-)

diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index a55c4745fd63c..3efd0fff38dd1 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -3703,11 +3703,17 @@ static long smb3_collapse_range(struct file *file, struct cifs_tcon *tcon,
 	}
 
 	filemap_invalidate_lock(inode->i_mapping);
-	rc = filemap_write_and_wait_range(inode->i_mapping, off, old_eof - 1);
+	rc = filemap_write_and_wait_range(inode->i_mapping,
+					  round_down(off, PAGE_SIZE),
+					  old_eof - 1);
 	if (rc < 0)
 		goto out_2;
 
-	truncate_pagecache_range(inode, off, old_eof);
+	/*
+	 * Invalidate cached folios from the page containing off to EOF before
+	 * moving data on the server, so subsequent reads do not see stale data.
+	 */
+	truncate_pagecache_range(inode, round_down(off, PAGE_SIZE), -1);
 	fscache_invalidate(cifs_inode_cookie(inode), NULL, old_eof, 0);
 
 	rc = smb2_copychunk_range(xid, cfile, cfile, off + len,
@@ -3762,10 +3768,16 @@ static long smb3_insert_range(struct file *file, struct cifs_tcon *tcon,
 		goto out;
 
 	filemap_invalidate_lock(inode->i_mapping);
-	rc = filemap_write_and_wait_range(inode->i_mapping, off, new_eof - 1);
+	rc = filemap_write_and_wait_range(inode->i_mapping,
+					  round_down(off, PAGE_SIZE),
+					  old_eof - 1);
 	if (rc < 0)
 		goto out_2;
-	truncate_pagecache_range(inode, off, old_eof);
+	/*
+	 * Invalidate cached folios from the page containing off to EOF before
+	 * moving data on the server, so subsequent reads do not see stale data.
+	 */
+	truncate_pagecache_range(inode, round_down(off, PAGE_SIZE), -1);
 	fscache_invalidate(cifs_inode_cookie(inode), NULL, old_eof, 0);
 
 	rc = SMB2_set_eof(xid, tcon, cfile->fid.persistent_fid,
-- 
2.53.0



