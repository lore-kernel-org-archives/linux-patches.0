Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3196018C00E;
	Wed,  6 Nov 2024 12:27:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730896039; cv=none; b=EN3ujn/IrlIDVpJWnn0z+tfvP0qFof4EgcYHdonYGqJVjssEB1TwEobWx4568iLYSlwc/9e3mHzzxhiw/6Oae4iS3ZJ8b2C6mADztr0PzNl36/eUsgHD+YygLEyZpK16u38Kng1/w8j3Ju9jUQchk1Q+mXC6xBJ3j5FZIhm5LIY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730896039; c=relaxed/simple;
	bh=pV/fp3eXixlYQmCBcbqyfulmE1ZwveJvTErODiawG1A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kMj8q0HjSapmu+dDN1kuHVNVIXhGTIZfBnVxzJKnEOo68l3JPktDoCDSOzENmTj0prrBvlBo8RooBZ4LppVdJZynaACRhEZ71y401B72V6mDCe759y0Gy/EZnSYd2qXxSp2S9Mlea/D79dWsx70uwHvWv/6vy3L5OPSf7sZjcYo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=To/5HS90; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="To/5HS90"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC35EC4CECD;
	Wed,  6 Nov 2024 12:27:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730896039;
	bh=pV/fp3eXixlYQmCBcbqyfulmE1ZwveJvTErODiawG1A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=To/5HS90zzzXceI65vFUep7CkKBAbfGgq9tjYH45lI77dtr6ftaxPcs/uy4gh0ucL
	 FbZ57UljXhaNVJXpEGFw6TiCxp4BKVfFZS3EN8gJzsC1r1FBi+Q0LEr6LIm7Daslu4
	 t3cofZ8RoDvlBlqA3iIk9BKPfG6w2ApoiE4HfCN4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Paulo Alcantara (Red Hat)" <pc@manguebit.com>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 068/245] smb: client: fix parsing of device numbers
Date: Wed,  6 Nov 2024 13:02:01 +0100
Message-ID: <20241106120320.879494555@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120319.234238499@linuxfoundation.org>
References: <20241106120319.234238499@linuxfoundation.org>
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

From: Paulo Alcantara <pc@manguebit.com>

[ Upstream commit 663f295e35594f4c2584fc68c28546b747b637cd ]

Report correct major and minor numbers from special files created with
NFS reparse points.

Signed-off-by: Paulo Alcantara (Red Hat) <pc@manguebit.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/reparse.c | 6 +++---
 fs/smb/client/reparse.h | 9 +--------
 2 files changed, 4 insertions(+), 11 deletions(-)

diff --git a/fs/smb/client/reparse.c b/fs/smb/client/reparse.c
index 7429b96a6ae5e..a4e25b99411ec 100644
--- a/fs/smb/client/reparse.c
+++ b/fs/smb/client/reparse.c
@@ -497,7 +497,7 @@ static void wsl_to_fattr(struct cifs_open_info_data *data,
 		else if (!strncmp(name, SMB2_WSL_XATTR_MODE, nlen))
 			fattr->cf_mode = (umode_t)le32_to_cpu(*(__le32 *)v);
 		else if (!strncmp(name, SMB2_WSL_XATTR_DEV, nlen))
-			fattr->cf_rdev = wsl_mkdev(v);
+			fattr->cf_rdev = reparse_mkdev(v);
 	} while (next);
 out:
 	fattr->cf_dtype = S_DT(fattr->cf_mode);
@@ -518,13 +518,13 @@ bool cifs_reparse_point_to_fattr(struct cifs_sb_info *cifs_sb,
 			if (le16_to_cpu(buf->ReparseDataLength) != sizeof(buf->InodeType) + 8)
 				return false;
 			fattr->cf_mode |= S_IFCHR;
-			fattr->cf_rdev = reparse_nfs_mkdev(buf);
+			fattr->cf_rdev = reparse_mkdev(buf->DataBuffer);
 			break;
 		case NFS_SPECFILE_BLK:
 			if (le16_to_cpu(buf->ReparseDataLength) != sizeof(buf->InodeType) + 8)
 				return false;
 			fattr->cf_mode |= S_IFBLK;
-			fattr->cf_rdev = reparse_nfs_mkdev(buf);
+			fattr->cf_rdev = reparse_mkdev(buf->DataBuffer);
 			break;
 		case NFS_SPECFILE_FIFO:
 			fattr->cf_mode |= S_IFIFO;
diff --git a/fs/smb/client/reparse.h b/fs/smb/client/reparse.h
index 2c0644bc4e65a..158e7b7aae646 100644
--- a/fs/smb/client/reparse.h
+++ b/fs/smb/client/reparse.h
@@ -18,14 +18,7 @@
  */
 #define IO_REPARSE_TAG_INTERNAL ((__u32)~0U)
 
-static inline dev_t reparse_nfs_mkdev(struct reparse_posix_data *buf)
-{
-	u64 v = le64_to_cpu(*(__le64 *)buf->DataBuffer);
-
-	return MKDEV(v >> 32, v & 0xffffffff);
-}
-
-static inline dev_t wsl_mkdev(void *ptr)
+static inline dev_t reparse_mkdev(void *ptr)
 {
 	u64 v = le64_to_cpu(*(__le64 *)ptr);
 
-- 
2.43.0



