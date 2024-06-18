Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF06C158DB8;
	Tue, 18 Jun 2024 13:13:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718716417; cv=none; b=hVkHezC7DuyG6GAYocB1o1XVNKVeqWuUosCCxs2WUnHfdrfACGqA3PxEZ+WXOk6oKrrHgbQRXkLxDsYLj9bO2K2o5KRkDQgg5IxVf0XOle0mF0AvjCdQDFTvx6remzKxuSRaiKLk1EgslcAlbKk0hSwC0X4uRJoIRdYX+WPmW+s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718716417; c=relaxed/simple;
	bh=tkZ939r76b69imn3SE2W6W0VdEkdF67vM3M38pRdTZY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e4+CF3QHbsDS2HOBN4dyaAvJhPY/bS6i8VbIl0/4llU8QUIPryHmvFFkl1fqliMu5+ameb+3tRNy9TiEYo1yCx8TLQg+Qoz9jazm1d94kEnY7lKLcLhiN9NLPmPFv3pQBj29jHb3dzr2Zkyk5cNXXKZOo6L02bPldLLDHYXFMLE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=exz5OpJ4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="exz5OpJ4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4E56C3277B;
	Tue, 18 Jun 2024 13:13:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718716417;
	bh=tkZ939r76b69imn3SE2W6W0VdEkdF67vM3M38pRdTZY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=exz5OpJ4ifku38rf5E3LNKIhJyJh5R+CbWmi31wZgEhnjAISgevMh5VFblUPu0p/A
	 pr0mlRTdw+VFZENF/OAdxDszthKwrGPSfzzP7+fEJNHiqrrdAn5ywuApOch6uHVa5g
	 6xLJm53a/E1EGhGN94ZQd0ri1vyUyaepskBUP9BA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 639/770] nfsd: clean up mounted_on_fileid handling
Date: Tue, 18 Jun 2024 14:38:12 +0200
Message-ID: <20240618123431.954495033@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240618123407.280171066@linuxfoundation.org>
References: <20240618123407.280171066@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jeff Layton <jlayton@kernel.org>

[ Upstream commit 6106d9119b6599fa23dc556b429d887b4c2d9f62 ]

We only need the inode number for this, not a full rack of attributes.
Rename this function make it take a pointer to a u64 instead of
struct kstat, and change it to just request STATX_INO.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
[ cel: renamed get_mounted_on_ino() ]
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4xdr.c | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/fs/nfsd/nfs4xdr.c b/fs/nfsd/nfs4xdr.c
index b9398b7b3539a..b5ca83045d6e9 100644
--- a/fs/nfsd/nfs4xdr.c
+++ b/fs/nfsd/nfs4xdr.c
@@ -2769,9 +2769,10 @@ static __be32 fattr_handle_absent_fs(u32 *bmval0, u32 *bmval1, u32 *bmval2, u32
 }
 
 
-static int get_parent_attributes(struct svc_export *exp, struct kstat *stat)
+static int nfsd4_get_mounted_on_ino(struct svc_export *exp, u64 *pino)
 {
 	struct path path = exp->ex_path;
+	struct kstat stat;
 	int err;
 
 	path_get(&path);
@@ -2779,8 +2780,10 @@ static int get_parent_attributes(struct svc_export *exp, struct kstat *stat)
 		if (path.dentry != path.mnt->mnt_root)
 			break;
 	}
-	err = vfs_getattr(&path, stat, STATX_BASIC_STATS, AT_STATX_SYNC_AS_STAT);
+	err = vfs_getattr(&path, &stat, STATX_INO, AT_STATX_SYNC_AS_STAT);
 	path_put(&path);
+	if (!err)
+		*pino = stat.ino;
 	return err;
 }
 
@@ -3277,22 +3280,21 @@ nfsd4_encode_fattr(struct xdr_stream *xdr, struct svc_fh *fhp,
 		*p++ = cpu_to_be32(stat.btime.tv_nsec);
 	}
 	if (bmval1 & FATTR4_WORD1_MOUNTED_ON_FILEID) {
-		struct kstat parent_stat;
 		u64 ino = stat.ino;
 
 		p = xdr_reserve_space(xdr, 8);
 		if (!p)
                 	goto out_resource;
 		/*
-		 * Get parent's attributes if not ignoring crossmount
-		 * and this is the root of a cross-mounted filesystem.
+		 * Get ino of mountpoint in parent filesystem, if not ignoring
+		 * crossmount and this is the root of a cross-mounted
+		 * filesystem.
 		 */
 		if (ignore_crossmnt == 0 &&
 		    dentry == exp->ex_path.mnt->mnt_root) {
-			err = get_parent_attributes(exp, &parent_stat);
+			err = nfsd4_get_mounted_on_ino(exp, &ino);
 			if (err)
 				goto out_nfserr;
-			ino = parent_stat.ino;
 		}
 		p = xdr_encode_hyper(p, ino);
 	}
-- 
2.43.0



