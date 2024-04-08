Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E2F7762E5;
	Mon,  8 Apr 2024 13:54:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712584486; cv=none; b=PhluhpiTVhXbLtuw1+g2yaTlTfw9eJMSwRtgRLzH2JqWSiLu5ryYl79KH/2zDuX6DeymTICUoOHLPk+9wrQ4Ha5ApfWVsQ6q51Y0FZJlUak3V0KAqOlD7nule0dTca+h8VUp/5xcRm2KDXWslfiZgBdEAMRU5Bw/F6repc2p5G4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712584486; c=relaxed/simple;
	bh=146dG95hfu5cDdbG8LCtviTfjXdKHXonrdiLhzEeNBs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kmwkMzQjtgFf5tHJers8FjB2yf8y9dw9F245kQDxD6tIHBPEDfXGQtQhZehWcHzz+a/wkmxEZv1deqweTxv0n9F18s/Bm8zaHUkEO1cE2gHQOXpWSE1DoYu2pbLoK3qtmL8QRG76ni25szoYOQamLt1Rh1TfUPSHFxGS9SsrGHo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u+uSW6sK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u+uSW6sK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAECEC43390;
	Mon,  8 Apr 2024 13:54:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712584486;
	bh=146dG95hfu5cDdbG8LCtviTfjXdKHXonrdiLhzEeNBs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u+uSW6sKjTMGbvyypu9JkMq07OIv5ZD71lWA7c1yM9+yc3UnVmISQ0cf7r5NPyW7u
	 BMLfFpYzHGYcqAg5CQ4F3xXXWTINMzpyVUlgF8WcbIT8/glEFS+733fTXDBFlNvv6/
	 vgtgJpYDVV4Bk8O61WsNDbs8Qd+StlHNUZ+MxKuw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.15 424/690] nfsd: clean up mounted_on_fileid handling
Date: Mon,  8 Apr 2024 14:54:50 +0200
Message-ID: <20240408125414.958670349@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125359.506372836@linuxfoundation.org>
References: <20240408125359.506372836@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jeff Layton <jlayton@kernel.org>

[ Upstream commit 6106d9119b6599fa23dc556b429d887b4c2d9f62 ]

We only need the inode number for this, not a full rack of attributes.
Rename this function make it take a pointer to a u64 instead of
struct kstat, and change it to just request STATX_INO.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
[ cel: renamed get_mounted_on_ino() ]
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 fs/nfsd/nfs4xdr.c | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/fs/nfsd/nfs4xdr.c b/fs/nfsd/nfs4xdr.c
index 0f30d93577e7b..3ad9b41c51730 100644
--- a/fs/nfsd/nfs4xdr.c
+++ b/fs/nfsd/nfs4xdr.c
@@ -2772,9 +2772,10 @@ static __be32 fattr_handle_absent_fs(u32 *bmval0, u32 *bmval1, u32 *bmval2, u32
 }
 
 
-static int get_parent_attributes(struct svc_export *exp, struct kstat *stat)
+static int nfsd4_get_mounted_on_ino(struct svc_export *exp, u64 *pino)
 {
 	struct path path = exp->ex_path;
+	struct kstat stat;
 	int err;
 
 	path_get(&path);
@@ -2782,8 +2783,10 @@ static int get_parent_attributes(struct svc_export *exp, struct kstat *stat)
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
 
@@ -3280,22 +3283,21 @@ nfsd4_encode_fattr(struct xdr_stream *xdr, struct svc_fh *fhp,
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



