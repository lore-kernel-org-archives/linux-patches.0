Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B868B4B7A3F;
	Thu, 17 Sep 2026 15:28:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789658889; cv=none; b=hXKKvXDXNK41TteRNvJ4qj9Qgc7M2VrW37SDn2VtDldBCWdaX+zFv/U77yg5A4C3Q2FognPx2KAQ8lCRXB+dO96S+mEjb0rzMsnug6x/pIEe5nVVu5BIfiobfuuGYIHWgzRlG+lTJ8h/Jz4bSm75FZgivjE8GcszOmfrNgtvFfo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789658889; c=relaxed/simple;
	bh=OROch/maSjJRxmOP3gD55HrbMITVSNLwKMiU/ogkHAY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aa2apnH+Elzz3s6relomlHi37tpbiMHZ2qQfRnKD9BhAFKL46Nef4knBlRSgfQVSkeskeLbsEAZM2UbCK42oWe9HVIT+hwMnGqb2bD9EUjBsC5Xy2gROiQn7I2xR4ZHBNj0/MbVQTSLo9Gj3r9bomx6foDo6v26XKy2xhkFgRsE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Jf8Xnlk9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Jf8Xnlk9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E858B1F0089A;
	Thu, 17 Sep 2026 15:28:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789658883;
	bh=Ujm5IWNrVEsrkyv11Q8oCwtB7BLOJHDPVmPgfEPePZc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Jf8Xnlk9XpRMe8jt28mYUu+Xjw3UZw/CNvV/itmqD0zadx01LGjWYlRc1oPn7FN3m
	 xoLZxOqvYtqLyvfF+hGzWBp+A5pUpoKftSfCR8+8ehLedFytV0vtVNzwRrpetPJYnH
	 xm3x+oZOeVYwLwNQoh5RCl8MvTiNRXTGl2Ubji4A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Huiwen He <hehuiwen@kylinos.cn>,
	Namjae Jeon <linkinjeon@kernel.org>,
	ChenXiaoSong <chenxiaosong@kylinos.cn>,
	Paulo Alcantara <pc@manguebit.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 070/733] smb/client: invalidate fscache for fallocate range operations
Date: Thu, 17 Sep 2026 16:06:18 +0100
Message-ID: <20260917151352.602486256@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Huiwen He <hehuiwen@kylinos.cn>

[ Upstream commit 448ba0ae65ca61064183564d2983c9aa59bd6ba7 ]

smb3_zero_range(), smb3_punch_hole(), smb3_insert_range(), and
smb3_collapse_range() modify file contents through server-side range
operations. These operations discard the affected page cache, but leave
the FS-Cache cookie valid, so a later read may return data cached before
the range operation.

Fix this by invalidating FS-Cache after outstanding I/O has completed
and before modifying the file on the server.

Run the following as root on a CIFS mount with fsc enabled and an active
CacheFiles backend:

        bash -c '
                MNT=/mnt/cifs
                FILE="$MNT/repro"

                # Generate four 1 MiB random blocks: [A][B][C][D].
                dd if=/dev/urandom of=/tmp/src bs=1M count=4 status=none

                # Expected contents after zeroing B: [A][zero][C][D].
                cp /tmp/src /tmp/expected
                dd if=/dev/zero of=/tmp/expected bs=1M seek=1 count=1 \
                        conv=notrunc status=none
                cp /tmp/src "$FILE"

                # Populate FS-Cache, then discard the page cache.
                sync
                echo 1 > /proc/sys/vm/drop_caches
                cat "$FILE" > /dev/null
                sync
                echo 1 > /proc/sys/vm/drop_caches

                fallocate --zero-range -o 1M -l 1M "$FILE"

                if cmp -s /tmp/expected "$FILE"; then
                        echo "readback: OK"
                else
                        echo "readback: STALE DATA"
                fi
        '

Before this change, the readback differs from /tmp/expected:

        readback: STALE DATA

After this change, it matches:

        readback: OK

Fixes: 30175628bf7f ("[SMB3] Enable fallocate -z support for SMB3 mounts")
Fixes: 31742c5a3317 ("enable fallocate punch hole ("fallocate -p") for SMB3")
Fixes: 5476b5dd82c8 ("cifs: add support for FALLOC_FL_COLLAPSE_RANGE")
Fixes: 7fe6fe95b936 ("cifs: add FALLOC_FL_INSERT_RANGE support")
Signed-off-by: Huiwen He <hehuiwen@kylinos.cn>
Suggested-by: Namjae Jeon <linkinjeon@kernel.org>
Reviewed-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
Reviewed-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Paulo Alcantara <pc@manguebit.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/smb2ops.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index 9b662635fa134..5f616384c75c0 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -3549,6 +3549,9 @@ static long smb3_zero_range(struct file *file, struct cifs_tcon *tcon,
 	if (keep_size == false && !CIFS_CACHE_READ(cifsi))
 		goto zero_range_exit;
 
+	fscache_invalidate(cifs_inode_cookie(inode), NULL,
+			   i_size_read(inode), 0);
+
 	rc = smb3_zero_data(file, tcon, offset, len, xid);
 	if (rc < 0)
 		goto zero_range_exit;
@@ -3618,6 +3621,8 @@ static long smb3_punch_hole(struct file *file, struct cifs_tcon *tcon,
 	 */
 	truncate_pagecache_range(inode, offset, offset + len - 1);
 	netfs_wait_for_outstanding_io(inode);
+	fscache_invalidate(cifs_inode_cookie(inode), NULL,
+			   i_size_read(inode), 0);
 
 	cifs_dbg(FYI, "Offset %lld len %lld\n", offset, len);
 
@@ -4035,6 +4040,7 @@ static long smb3_collapse_range(struct file *file, struct cifs_tcon *tcon,
 	 * moving data on the server, so subsequent reads do not see stale data.
 	 */
 	truncate_pagecache_range(inode, round_down(off, PAGE_SIZE), -1);
+	fscache_invalidate(cifs_inode_cookie(inode), NULL, old_eof, 0);
 
 	spin_lock(&inode->i_lock);
 	netfs_write_zero_point(inode, old_eof);
@@ -4109,6 +4115,7 @@ static long smb3_insert_range(struct file *file, struct cifs_tcon *tcon,
 	 * moving data on the server, so subsequent reads do not see stale data.
 	 */
 	truncate_pagecache_range(inode, round_down(off, PAGE_SIZE), -1);
+	fscache_invalidate(cifs_inode_cookie(inode), NULL, old_eof, 0);
 
 	rc = SMB2_set_eof(xid, tcon, cfile->fid.persistent_fid,
 			  cfile->fid.volatile_fid, cfile->pid, new_eof);
-- 
2.53.0



