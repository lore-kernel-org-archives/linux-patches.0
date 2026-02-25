Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB728248881;
	Wed, 25 Feb 2026 01:38:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983485; cv=none; b=n+Oq36DALPHZ8AJigtJjHG3iVUp+bupXpn6Gbsa+wRZAKoZ71gh9AByp3/rZmd/oiF4X/LFI8e1pOGuFNHZQKNk7IpbskRNnvz9JRBLUh0cNJcED6jxRsA1Pl2sZ3/xVGbovFMAG+6FfDq12Y1ItiAou75Edm+3UXZPCmdTYN+0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983485; c=relaxed/simple;
	bh=zVuLJ8VHl0yp3dK/zoVSN2az0KJiXGD+GthM0P6qj4s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WOGcDtHRIqNL6jml4/WGwMDRbet4NnXcszhuhwoj0Yc8IwTqwQmO0f/yGb73erJSBLHAu8p2uKLOOwdGDueazg4bqaula5gSwAwp7ZI+KLrE7HhkIfAlHAOJXi6GZ5mlQ5akNIkUZvPbe95gtrDZMyYJesct7f0gL4OryVdZ+pg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Vc511V2K; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Vc511V2K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9ADACC116D0;
	Wed, 25 Feb 2026 01:38:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983485;
	bh=zVuLJ8VHl0yp3dK/zoVSN2az0KJiXGD+GthM0P6qj4s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Vc511V2K9xXklk4RobnfTDC/JddQOVnipJny2JMAD3bh64AFzuvjiJ4t9bvchv8Nf
	 JoRFhx+zErEFS/w9SqMM1eqdOiBFrnCCzCJWEU54WUzpuEeo6yw3NyC7iB33lyJvo9
	 as4ez2/bjxM3J+z4Syju5LdeLy8vE/CqwT2HqybM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Amir Goldstein <amir73il@gmail.com>,
	Chuck Lever <chuck.lever@oracle.com>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 598/781] nfsd: do not allow exporting of special kernel filesystems
Date: Tue, 24 Feb 2026 17:21:47 -0800
Message-ID: <20260225012414.463312134@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Amir Goldstein <amir73il@gmail.com>

[ Upstream commit b3c78bc53630d14a5770451ede3a30e7052f3b8b ]

pidfs and nsfs recently gained support for encode/decode of file handles
via name_to_handle_at(2)/open_by_handle_at(2).

These special kernel filesystems have custom ->open() and ->permission()
export methods, which nfsd does not respect and it was never meant to be
used for exporting those filesystems by nfsd.

Therefore, do not allow nfsd to export filesystems with custom ->open()
or ->permission() methods.

Fixes: b3caba8f7a34a ("pidfs: implement file handle support")
Fixes: 5222470b2fbb3 ("nsfs: support file handles")
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Link: https://patch.msgid.link/20260129100212.49727-3-amir73il@gmail.com
Reviewed-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/export.c         | 8 +++++---
 include/linux/exportfs.h | 9 +++++++++
 2 files changed, 14 insertions(+), 3 deletions(-)

diff --git a/fs/nfsd/export.c b/fs/nfsd/export.c
index 2a1499f2ad196..09fe268fe2c76 100644
--- a/fs/nfsd/export.c
+++ b/fs/nfsd/export.c
@@ -427,7 +427,8 @@ static int check_export(const struct path *path, int *flags, unsigned char *uuid
 	 *       either a device number (so FS_REQUIRES_DEV needed)
 	 *       or an FSID number (so NFSEXP_FSID or ->uuid is needed).
 	 * 2:  We must be able to find an inode from a filehandle.
-	 *       This means that s_export_op must be set.
+	 *       This means that s_export_op must be set and comply with
+	 *       the requirements for remote filesystem export.
 	 * 3: We must not currently be on an idmapped mount.
 	 */
 	if (!(inode->i_sb->s_type->fs_flags & FS_REQUIRES_DEV) &&
@@ -437,8 +438,9 @@ static int check_export(const struct path *path, int *flags, unsigned char *uuid
 		return -EINVAL;
 	}
 
-	if (!exportfs_can_decode_fh(inode->i_sb->s_export_op)) {
-		dprintk("exp_export: export of invalid fs type.\n");
+	if (!exportfs_may_export(inode->i_sb->s_export_op)) {
+		dprintk("exp_export: export of invalid fs type (%s).\n",
+			inode->i_sb->s_type->name);
 		return -EINVAL;
 	}
 
diff --git a/include/linux/exportfs.h b/include/linux/exportfs.h
index f0cf2714ec52d..9bd93d6bd9a49 100644
--- a/include/linux/exportfs.h
+++ b/include/linux/exportfs.h
@@ -317,6 +317,15 @@ static inline bool exportfs_can_decode_fh(const struct export_operations *nop)
 	return nop && nop->fh_to_dentry;
 }
 
+static inline bool exportfs_may_export(const struct export_operations *nop)
+{
+	/*
+	 * Do not allow nfs export for filesystems with custom ->open() or
+	 * ->permission() ops, which nfsd does not respect (e.g. pidfs, nsfs).
+	 */
+	return exportfs_can_decode_fh(nop) && !nop->open && !nop->permission;
+}
+
 static inline bool exportfs_can_encode_fh(const struct export_operations *nop,
 					  int fh_flags)
 {
-- 
2.51.0



