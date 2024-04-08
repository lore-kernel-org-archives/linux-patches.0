Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 523EC7D3EC;
	Mon,  8 Apr 2024 13:46:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712584013; cv=none; b=FDFGeVmveUZkDWObdG/PR/21EoJg+Tz5/KdEy9njAJSn4HzFqj3+LeivP5/kZXnw+/VUhlp0Rehgp5LiyKCcRDM9NpSgWGK0/qVyBx+15xBKnIY+O/l9G4GMHOfvuOJ3uv/Pzi3ve+uWcSYmjki1XJESK+A6XXDQTKXKMArw1kc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712584013; c=relaxed/simple;
	bh=K2vNajf/FaxCzy6dQ1ud/CFY6mCRUQVsDqS3Hbyz++U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=isxxl8s71aMRWCC/DEOEgisIe5sqIT7kAkQHjuzwDSUuuyYA8V8ldKrsAFl2Jg5UQgZ5tP1NIsKhkJbPCkPtCP3WJqXCvrYBfr/Rd91YD5Lyk9hHCqI/DV2TKNIlQvh8rf05ODBL4qPYECiqt/ZggMnqJkXMEyG8DGUHMQ/OGs8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u9ELfq9Q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u9ELfq9Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA7A4C433F1;
	Mon,  8 Apr 2024 13:46:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712584013;
	bh=K2vNajf/FaxCzy6dQ1ud/CFY6mCRUQVsDqS3Hbyz++U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u9ELfq9QZR810/UwTAy7HlilXfShKBeyp69Ki6+LNAX8JkKdUMgmB6YqKPQnnp5xC
	 os53Y3z1SivblCB5qSIC3q0fik06OXo5AxszbXAlihmJncSIR3WhloS3n9XOVvvD5Z
	 lemrK5u5Ka7Q0n0qKNn3WJgQhBLg3towuUE+ihE0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.15 320/690] NFSD: Clean up nfsd_open_verified()
Date: Mon,  8 Apr 2024 14:53:06 +0200
Message-ID: <20240408125411.203885686@linuxfoundation.org>
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

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit f4d84c52643ae1d63a8e73e2585464470e7944d1 ]

Its only caller always passes S_IFREG as the @type parameter. As an
additional clean-up, add a kerneldoc comment.

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 fs/nfsd/filecache.c |  4 ++--
 fs/nfsd/vfs.c       | 15 ++++++++++++---
 fs/nfsd/vfs.h       |  2 +-
 3 files changed, 15 insertions(+), 6 deletions(-)

diff --git a/fs/nfsd/filecache.c b/fs/nfsd/filecache.c
index b1afe6db589f2..0f6553b316f58 100644
--- a/fs/nfsd/filecache.c
+++ b/fs/nfsd/filecache.c
@@ -976,8 +976,8 @@ nfsd_file_acquire(struct svc_rqst *rqstp, struct svc_fh *fhp,
 
 	nf->nf_mark = nfsd_file_mark_find_or_create(nf);
 	if (nf->nf_mark)
-		status = nfsd_open_verified(rqstp, fhp, S_IFREG,
-				may_flags, &nf->nf_file);
+		status = nfsd_open_verified(rqstp, fhp, may_flags,
+					    &nf->nf_file);
 	else
 		status = nfserr_jukebox;
 	/*
diff --git a/fs/nfsd/vfs.c b/fs/nfsd/vfs.c
index 9dd14c0eaebd1..6689ad5bb790d 100644
--- a/fs/nfsd/vfs.c
+++ b/fs/nfsd/vfs.c
@@ -834,14 +834,23 @@ nfsd_open(struct svc_rqst *rqstp, struct svc_fh *fhp, umode_t type,
 	return err;
 }
 
+/**
+ * nfsd_open_verified - Open a regular file for the filecache
+ * @rqstp: RPC request
+ * @fhp: NFS filehandle of the file to open
+ * @may_flags: internal permission flags
+ * @filp: OUT: open "struct file *"
+ *
+ * Returns an nfsstat value in network byte order.
+ */
 __be32
-nfsd_open_verified(struct svc_rqst *rqstp, struct svc_fh *fhp, umode_t type,
-		int may_flags, struct file **filp)
+nfsd_open_verified(struct svc_rqst *rqstp, struct svc_fh *fhp, int may_flags,
+		   struct file **filp)
 {
 	__be32 err;
 
 	validate_process_creds();
-	err = __nfsd_open(rqstp, fhp, type, may_flags, filp);
+	err = __nfsd_open(rqstp, fhp, S_IFREG, may_flags, filp);
 	validate_process_creds();
 	return err;
 }
diff --git a/fs/nfsd/vfs.h b/fs/nfsd/vfs.h
index f99794b033a55..26347d76f44a0 100644
--- a/fs/nfsd/vfs.h
+++ b/fs/nfsd/vfs.h
@@ -86,7 +86,7 @@ __be32		nfsd_setxattr(struct svc_rqst *rqstp, struct svc_fh *fhp,
 int 		nfsd_open_break_lease(struct inode *, int);
 __be32		nfsd_open(struct svc_rqst *, struct svc_fh *, umode_t,
 				int, struct file **);
-__be32		nfsd_open_verified(struct svc_rqst *, struct svc_fh *, umode_t,
+__be32		nfsd_open_verified(struct svc_rqst *, struct svc_fh *,
 				int, struct file **);
 __be32		nfsd_splice_read(struct svc_rqst *rqstp, struct svc_fh *fhp,
 				struct file *file, loff_t offset,
-- 
2.43.0



