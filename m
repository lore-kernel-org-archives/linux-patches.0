Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792774338;
	b=upii1d18q54DjhCUxjKIwmC5u01vWPgYsgF/QlVzwN/VHz7/vlvruyBaMs8dwAd2RLhR
	 ze0a45D2za8kvcie5GDeKhxxm9eeBEtT7B5QJh7T2W9lNwvJMzLl8dmGj1+3F8fmldNOF
	 qiZcP+2bEFkoPR4BghXaXs9+/mX2afV2KC4agKjsmEk6UHgC6lLGd3dfC4F2nz0+b4PCK
	 MTAarRL+h8j6OeVwYtWu7hi7X6Af1pnEEhkRbW9GcWvay1Hrcay7R1q6NCp6f+lEdvFY7
	 3nHsim73CQ/+DhWr0lMgUZ1+zr2KTLY9QAqy5vTlsoNO/DNC98LDD6OWYZDxQ35WJ4Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792774338;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=RP7AcwlL/eTDIP4eoPS5GolXGswhLCjfbbgtGq6djBI=;
	b=WZHyTc2Qn2zuWeMik6MPi7vroAZI+mb2vhJaAbjB5jCpBWJSeRjVo3xMAHpdI/3Z/Q6X
	 DL7ctRd8R8lUD42K81WeguwwdZzGf+i+4T4kdgS2FZVMsqAtFtJnY3ONwlZ+0rEQQp6dK
	 ISuw8strOQKeFVcDaz5c/hIUAm9I2XsXqWbNjMUdh+LHHEYTQ+Q4rmruGL4Hp9t/y4AaD
	 3iWyuWFLpQarAdwTaR8m2kdJWua5JCMlLKD2btZZyWaEfMqQkiHc+HlRO43Fn6m1Z5Wus
	 +KT1oJ4H4C9f/NBpcY+lBzE2T+AzEagMFidzNpQpZ0mgty7Odn9jVjkPNPCyMMEvtjA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Krh9l0BF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55CAC606A31A;
	Fri, 23 Oct 2026 16:52:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Krh9l0BF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A80141F01825;
	Fri, 23 Oct 2026 16:52:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792774338;
	bh=RP7AcwlL/eTDIP4eoPS5GolXGswhLCjfbbgtGq6djBI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Krh9l0BFeJ7zkgt8rVNHW1d5DMuTyBNbgpYyPWufvRuvNAmM2W+Y8Nmyt4oKYQb0v
	 YLK8uHM4oeMdsXN2mmCH8PF4+fCoyiI3cQ+LHI3ufET8VObOZqGvPz1cJCLxB8Y8y2
	 5gwM1SIpSDzYSFxMGXWkjMZ30htLI/SgIkuJtohY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Huiwen He <hehuiwen@kylinos.cn>,
	ChenXiaoSong <chenxiaosong@kylinos.cn>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 175/193] smb/client: refresh allocation size after duplicate extents
Date: Fri, 23 Oct 2026 18:37:32 +0200
Message-ID: <20261023163718.356054618@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261023163714.201276352@linuxfoundation.org>
References: <20261023163714.201276352@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Huiwen He <hehuiwen@kylinos.cn>

[ Upstream commit 5906d0e82e8e07d756f3ed1abfac8f8cea2c20dc ]

FSCTL_DUPLICATE_EXTENTS_TO_FILE changes the target file extents on the
server, but the client does not refresh the target AllocationSize/i_blocks.
Callers can observe or use the wrong st_blocks value immediately after the
clone, before a later attribute revalidation corrects it.

For example, create a reflinked file with a leading hole:

        xfs_io -f -c "pwrite -S 0x61 0 64k" src
        touch dst
        chmod 600 dst
        xfs_io -c "reflink src 0 1m 64k" dst
        mkswap dst
        swapon dst

The file still has a hole after mkswap:

        /mnt/scratch/dst:
          [0..7]:       allocated
          [8..2047]:    hole
          [2048..2175]: allocated

The server also reports only the allocated ranges:

        server dst size=1114112 blocks=144

but the client reported EOF-derived blocks:

        client dst size=1114112 blocks=2176

and swapon succeeded:

        swapon_result=success
        /mnt/scratch/dst 1.1M 0B -1

So EOF-derived i_blocks can let a sparse reflinked file pass the CIFS
swapfile hole check.

Fix this by querying FILE_ALL_INFORMATION on the target handle after a
successful duplicate extents request. Update i_blocks from AllocationSize
and keep the refreshed target inode attributes valid so a following stat
does not immediately revalidate again.

If the query fails, mark the cached inode attributes stale so a later
getattr can refresh them.

This also fixes the xfstests generic/370 regression introduced by the
i_blocks accounting change, as tested on a Samba "vfs objects = btrfs"
share.

Fixes: 99cd0a6eeb6c ("smb/client: do not account EOF extension as allocation")
Signed-off-by: Huiwen He <hehuiwen@kylinos.cn>
Reviewed-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
Signed-off-by: Steve French <stfrench@microsoft.com>
Stable-dep-of: 53676a5e2823 ("cifs: add revalidation on FSCTL failure in smb2_duplicate_extents()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/cifsfs.c  |   10 +++++++---
 fs/smb/client/smb2ops.c |   30 ++++++++++++++++++++++++++++++
 2 files changed, 37 insertions(+), 3 deletions(-)

--- a/fs/smb/client/cifsfs.c
+++ b/fs/smb/client/cifsfs.c
@@ -1463,9 +1463,13 @@ static loff_t cifs_remap_file_range(stru
 			target_cifsi->netfs.zero_point = new_size;
 	}
 
-	/* force revalidate of size and timestamps of target file now
-	   that target is updated on the server */
-	CIFS_I(target_inode)->time = 0;
+	/*
+	 * On success, duplicate_extents already updated the target inode attrs
+	 * or marked them stale if the refresh failed.  On failure, mark attrs
+	 * stale because EOF may have changed before the clone failed.
+	 */
+	if (rc)
+		CIFS_I(target_inode)->time = 0;
 unlock:
 	/* although unlocking in the reverse order from locking is not
 	   strictly necessary here it is a little cleaner to be consistent */
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -2271,10 +2271,14 @@ smb2_duplicate_extents(const unsigned in
 			u64 len, u64 dest_off)
 {
 	int rc;
+	int qrc;
 	unsigned int ret_data_len;
 	struct inode *inode;
+	struct smb2_file_all_info file_inf;
 	struct duplicate_extents_to_file dup_ext_buf;
+	struct timespec64 ts;
 	struct cifs_tcon *tcon = tlink_tcon(trgtfile->tlink);
+	u64 asize;
 
 	/* server fileays advertise duplicate extent support with this flag */
 	if ((le32_to_cpu(tcon->fsAttrInfo.Attributes) &
@@ -2309,6 +2313,32 @@ smb2_duplicate_extents(const unsigned in
 	if (ret_data_len > 0)
 		cifs_dbg(FYI, "Non-zero response length in duplicate extents\n");
 
+	if (rc == 0) {
+		qrc = SMB2_query_info(xid, tcon, trgtfile->fid.persistent_fid,
+				      trgtfile->fid.volatile_fid, &file_inf);
+		spin_lock(&inode->i_lock);
+		if (qrc == 0) {
+			asize = le64_to_cpu(file_inf.AllocationSize);
+			CIFS_I(inode)->time = jiffies;
+			if (file_inf.LastWriteTime) {
+				ts = cifs_NTtimeToUnix(file_inf.LastWriteTime);
+				inode_set_mtime_to_ts(inode, ts);
+			}
+			if (file_inf.ChangeTime) {
+				ts = cifs_NTtimeToUnix(file_inf.ChangeTime);
+				inode_set_ctime_to_ts(inode, ts);
+			}
+			if (file_inf.LastAccessTime) {
+				ts = cifs_NTtimeToUnix(file_inf.LastAccessTime);
+				inode_set_atime_to_ts(inode, ts);
+			}
+			inode->i_blocks = CIFS_INO_BLOCKS(asize);
+		} else {
+			CIFS_I(inode)->time = 0; /* force reval */
+		}
+		spin_unlock(&inode->i_lock);
+	}
+
 duplicate_extents_out:
 	if (rc)
 		trace_smb3_clone_err(xid, srcfile->fid.volatile_fid,


