Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D0084DDB40;
	Thu, 17 Sep 2026 15:28:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789658888; cv=none; b=I1Rn5pj4epqxHe284e1iZRiQ2zbjpoMr99J8In42J4OV8VB3GduOc7sdU6LryGESW08+oUKmIbKECSbEsycI03HolBZtHr1XutKdt0ZDImUxlZN6V4RQH2TFK89+KwZ0OpBcS/s8RNzvDBcLJ6zj9eI5XJxUMztib3HHHEBfAS4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789658888; c=relaxed/simple;
	bh=TcgFVOOR/EmJt7+W6r2272oHaehX3jzC0ji9/jv+a3A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Quhkp7YnoOWeLpeilbns/XAZ89uCNySjVPgawOsfwQxnqqP4unCQFDJAOFuMxZe9mWxRdqOu9Bs/lIJikES7HwwKUARdZ7zeq8CfaR+wiQAOamd/Vj8zPFiakSgnXjqvctk3/wHjA6hqme8/ORUBWKb8LziwnX5ad7BANs5+pUI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YLuhRRlR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YLuhRRlR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC8FF1F000FF;
	Thu, 17 Sep 2026 15:27:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789658880;
	bh=bQYoyMK4+zB6WMTyTS8QQsEJNfWBxsHrliHWKATqzWE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YLuhRRlRYAMcSSPgkOwlmiEAluqGMA/ql4mYi/pyabogwvP8DUHKIUJYb2VhyDfSB
	 acFvrNGEn8114EkDySZumcogS1jwTHpy5NQ8V37b2ER2qRxQockFbJWdbY21jMuvtB
	 4/AGaTJ+q6qa4kO+pzyFH3A6deZDWWXFEEbAVf8Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Huiwen He <hehuiwen@kylinos.cn>,
	ChenXiaoSong <chenxiaosong@kylinos.cn>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Paulo Alcantara <pc@manguebit.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 069/733] smb/client: fix stale page cache in insert/collapse range
Date: Thu, 17 Sep 2026 16:06:17 +0100
Message-ID: <20260917151352.573237075@linuxfoundation.org>
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
 fs/smb/client/smb2ops.c | 23 ++++++++++++++++++-----
 1 file changed, 18 insertions(+), 5 deletions(-)

diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index ae4e855f80500..9b662635fa134 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -4023,15 +4023,22 @@ static long smb3_collapse_range(struct file *file, struct cifs_tcon *tcon,
 	}
 
 	filemap_invalidate_lock(inode->i_mapping);
-	rc = filemap_write_and_wait_range(inode->i_mapping, off, old_eof - 1);
+	rc = filemap_write_and_wait_range(inode->i_mapping,
+					  round_down(off, PAGE_SIZE),
+					  old_eof - 1);
 	if (rc < 0)
 		goto out_2;
 
-	truncate_pagecache_range(inode, off, old_eof);
+	netfs_wait_for_outstanding_io(inode);
+	/*
+	 * Invalidate cached folios from the page containing off to EOF before
+	 * moving data on the server, so subsequent reads do not see stale data.
+	 */
+	truncate_pagecache_range(inode, round_down(off, PAGE_SIZE), -1);
+
 	spin_lock(&inode->i_lock);
 	netfs_write_zero_point(inode, old_eof);
 	spin_unlock(&inode->i_lock);
-	netfs_wait_for_outstanding_io(inode);
 
 	rc = __smb2_copychunk_range(xid, cfile, cfile, off + len,
 				    old_eof - off - len, off);
@@ -4091,11 +4098,17 @@ static long smb3_insert_range(struct file *file, struct cifs_tcon *tcon,
 		goto out;
 
 	filemap_invalidate_lock(inode->i_mapping);
-	rc = filemap_write_and_wait_range(inode->i_mapping, off, new_eof - 1);
+	rc = filemap_write_and_wait_range(inode->i_mapping,
+					  round_down(off, PAGE_SIZE),
+					  old_eof - 1);
 	if (rc < 0)
 		goto out_2;
-	truncate_pagecache_range(inode, off, old_eof);
 	netfs_wait_for_outstanding_io(inode);
+	/*
+	 * Invalidate cached folios from the page containing off to EOF before
+	 * moving data on the server, so subsequent reads do not see stale data.
+	 */
+	truncate_pagecache_range(inode, round_down(off, PAGE_SIZE), -1);
 
 	rc = SMB2_set_eof(xid, tcon, cfile->fid.persistent_fid,
 			  cfile->fid.volatile_fid, cfile->pid, new_eof);
-- 
2.53.0



