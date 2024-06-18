Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D53873461;
	Tue, 18 Jun 2024 12:53:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718715218; cv=none; b=B3kcSa0POckrQs35UiHd0Yc0bMu/xdPcqs+z0u9/G4fWt8WhjrL1WuMNnNqFxrCDp1ODixE1KUHqkaZsMa8QdqnRO6Pw3oNNmpu90NjWbFjvpKTNGqd5htehDOs/BLSUwsMDxDDAyaaeGfnQtHWkgCZLmVeG6wqmQk3xlA3FE1E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718715218; c=relaxed/simple;
	bh=SGQ1OV1wfiemWWZFIlA8wTO+1WhdYkBmfq2F1FjvAEY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BRL2hmj2gfuEKfNv63jYt3GqVJW9B1kxX3i/clYM3FPEkpCmqz84nsUpx1gMFjhN7T/o/9Yo9bFVBiTY7cOmo+Ca2QQpnyz4QawbPDy1gy40AdLjjzYLgCxrjwuVPyBNbOZwl6BVk0w8nUa2whY9Nj7z7QpAELmWzoPAqZiRAY0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0gQRXmIs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0gQRXmIs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D397CC3277B;
	Tue, 18 Jun 2024 12:53:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718715218;
	bh=SGQ1OV1wfiemWWZFIlA8wTO+1WhdYkBmfq2F1FjvAEY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0gQRXmIsu1fW5iUPxA/nEwhaTr60yW30lcZIrcjgTj+5yV+RB796EcwFZsnVe6KTx
	 NTDQSNi482zrYYvdvyL5tDraY+u7JSMAS7toldXki8+WfCxTNv31DNlhGZKrVEUkaM
	 GJDXwNcMuoTTFXKXLIiMKRHTjErYkGACWK5KPQPc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 234/770] NFSD: Clean up after updating NFSv2 ACL encoders
Date: Tue, 18 Jun 2024 14:31:27 +0200
Message-ID: <20240618123416.312932986@linuxfoundation.org>
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

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit 83d0b84572775a29f800de67a1b9b642a5376bc3 ]

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfsxdr.c | 64 ------------------------------------------------
 fs/nfsd/xdr.h    |  1 -
 2 files changed, 65 deletions(-)

diff --git a/fs/nfsd/nfsxdr.c b/fs/nfsd/nfsxdr.c
index 1fed3a8deb183..b800cfefcab7a 100644
--- a/fs/nfsd/nfsxdr.c
+++ b/fs/nfsd/nfsxdr.c
@@ -201,64 +201,6 @@ svcxdr_decode_sattr(struct svc_rqst *rqstp, struct xdr_stream *xdr,
 	return true;
 }
 
-static __be32 *
-encode_fattr(struct svc_rqst *rqstp, __be32 *p, struct svc_fh *fhp,
-	     struct kstat *stat)
-{
-	struct user_namespace *userns = nfsd_user_namespace(rqstp);
-	struct dentry	*dentry = fhp->fh_dentry;
-	int type;
-	struct timespec64 time;
-	u32 f;
-
-	type = (stat->mode & S_IFMT);
-
-	*p++ = htonl(nfs_ftypes[type >> 12]);
-	*p++ = htonl((u32) stat->mode);
-	*p++ = htonl((u32) stat->nlink);
-	*p++ = htonl((u32) from_kuid_munged(userns, stat->uid));
-	*p++ = htonl((u32) from_kgid_munged(userns, stat->gid));
-
-	if (S_ISLNK(type) && stat->size > NFS_MAXPATHLEN) {
-		*p++ = htonl(NFS_MAXPATHLEN);
-	} else {
-		*p++ = htonl((u32) stat->size);
-	}
-	*p++ = htonl((u32) stat->blksize);
-	if (S_ISCHR(type) || S_ISBLK(type))
-		*p++ = htonl(new_encode_dev(stat->rdev));
-	else
-		*p++ = htonl(0xffffffff);
-	*p++ = htonl((u32) stat->blocks);
-	switch (fsid_source(fhp)) {
-	default:
-	case FSIDSOURCE_DEV:
-		*p++ = htonl(new_encode_dev(stat->dev));
-		break;
-	case FSIDSOURCE_FSID:
-		*p++ = htonl((u32) fhp->fh_export->ex_fsid);
-		break;
-	case FSIDSOURCE_UUID:
-		f = ((u32*)fhp->fh_export->ex_uuid)[0];
-		f ^= ((u32*)fhp->fh_export->ex_uuid)[1];
-		f ^= ((u32*)fhp->fh_export->ex_uuid)[2];
-		f ^= ((u32*)fhp->fh_export->ex_uuid)[3];
-		*p++ = htonl(f);
-		break;
-	}
-	*p++ = htonl((u32) stat->ino);
-	*p++ = htonl((u32) stat->atime.tv_sec);
-	*p++ = htonl(stat->atime.tv_nsec ? stat->atime.tv_nsec / 1000 : 0);
-	time = stat->mtime;
-	lease_get_mtime(d_inode(dentry), &time); 
-	*p++ = htonl((u32) time.tv_sec);
-	*p++ = htonl(time.tv_nsec ? time.tv_nsec / 1000 : 0); 
-	*p++ = htonl((u32) stat->ctime.tv_sec);
-	*p++ = htonl(stat->ctime.tv_nsec ? stat->ctime.tv_nsec / 1000 : 0);
-
-	return p;
-}
-
 /**
  * svcxdr_encode_fattr - Encode NFSv2 file attributes
  * @rqstp: Context of a completed RPC transaction
@@ -328,12 +270,6 @@ svcxdr_encode_fattr(struct svc_rqst *rqstp, struct xdr_stream *xdr,
 	return true;
 }
 
-/* Helper function for NFSv2 ACL code */
-__be32 *nfs2svc_encode_fattr(struct svc_rqst *rqstp, __be32 *p, struct svc_fh *fhp, struct kstat *stat)
-{
-	return encode_fattr(rqstp, p, fhp, stat);
-}
-
 /*
  * XDR decode functions
  */
diff --git a/fs/nfsd/xdr.h b/fs/nfsd/xdr.h
index 8bcdc37398ab5..c67ad02b9a028 100644
--- a/fs/nfsd/xdr.h
+++ b/fs/nfsd/xdr.h
@@ -168,7 +168,6 @@ void nfssvc_release_diropres(struct svc_rqst *rqstp);
 void nfssvc_release_readres(struct svc_rqst *rqstp);
 
 /* Helper functions for NFSv2 ACL code */
-__be32 *nfs2svc_encode_fattr(struct svc_rqst *rqstp, __be32 *p, struct svc_fh *fhp, struct kstat *stat);
 bool svcxdr_decode_fhandle(struct xdr_stream *xdr, struct svc_fh *fhp);
 bool svcxdr_encode_stat(struct xdr_stream *xdr, __be32 status);
 bool svcxdr_encode_fattr(struct svc_rqst *rqstp, struct xdr_stream *xdr,
-- 
2.43.0



