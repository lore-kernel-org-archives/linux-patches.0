Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D76D32DF73;
	Mon,  8 Apr 2024 13:07:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712581659; cv=none; b=ucc1rvuNQ/ebvD/dOQ8t9OL1xon6pHpGUkhk6ocgDWpJUQjdpwn4jZyohfUUlL3iH84n8MmFuu4bFEnllJ/gLGsRNpwl9ierzUsn9Eih/Pvos/hiAv5IG+k8jvRBhNKTZNEO1DsGqU+9R8Z9y1hNJsVeiFDGOlvSO+DLE0fpWFs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712581659; c=relaxed/simple;
	bh=wM2WjcUBwqFwBdQGfPq5mYTe5v6LBssnj5mD1RmirZw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Hp/ItKaMqRgZCP47qtZNHWfm5kxRfJniieuXqm/iKKEO6bUMsTY3Z8LKnuEEGrOF7ZpNtWSjV/X0SUrdIYabI/pleLxbAvBT+S/fCyuzvlVq6mfcz37y5i6PrEIPl/kbRVK9lS3DG2b1o2aSHbujeZkLhI2zGjLR7b3byP4keXE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XR5X9FdK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XR5X9FdK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A816C433F1;
	Mon,  8 Apr 2024 13:07:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712581659;
	bh=wM2WjcUBwqFwBdQGfPq5mYTe5v6LBssnj5mD1RmirZw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XR5X9FdKFfaoJohFf3xl/ySWRYT2MLpqP4E8kTo7BohvyxLKwEvLpL4wTkAbSCZCp
	 81HqiC3cyRmD5FfNXSaT7CYFRdp6Gl9RSDDfP1swsxJ1l9QSRhfD8owAL+LHjUwOZD
	 xctjoiN9T1C8pyFQIISVTkgmTned+plTWnQSBO48=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Kara <jack@suse.cz>,
	Jeff Layton <jlayton@kernel.org>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 008/273] nfsd: Fix error cleanup path in nfsd_rename()
Date: Mon,  8 Apr 2024 14:54:43 +0200
Message-ID: <20240408125309.540966674@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125309.280181634@linuxfoundation.org>
References: <20240408125309.280181634@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jan Kara <jack@suse.cz>

[ Upstream commit 9fe6e9e7b58944037714442384075c17cfde1c56 ]

Commit a8b0026847b8 ("rename(): avoid a deadlock in the case of parents
having no common ancestor") added an error bail out path. However this
path does not drop the remount protection that has been acquired. Fix
the cleanup path to properly drop the remount protection.

Fixes: a8b0026847b8 ("rename(): avoid a deadlock in the case of parents having no common ancestor")
Signed-off-by: Jan Kara <jack@suse.cz>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Acked-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/vfs.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/nfsd/vfs.c b/fs/nfsd/vfs.c
index b7c7a9273ea01..4ed1e83defa23 100644
--- a/fs/nfsd/vfs.c
+++ b/fs/nfsd/vfs.c
@@ -1833,7 +1833,7 @@ nfsd_rename(struct svc_rqst *rqstp, struct svc_fh *ffhp, char *fname, int flen,
 	trap = lock_rename(tdentry, fdentry);
 	if (IS_ERR(trap)) {
 		err = (rqstp->rq_vers == 2) ? nfserr_acces : nfserr_xdev;
-		goto out;
+		goto out_want_write;
 	}
 	err = fh_fill_pre_attrs(ffhp);
 	if (err != nfs_ok)
@@ -1903,6 +1903,7 @@ nfsd_rename(struct svc_rqst *rqstp, struct svc_fh *ffhp, char *fname, int flen,
 	}
 out_unlock:
 	unlock_rename(tdentry, fdentry);
+out_want_write:
 	fh_drop_write(ffhp);
 
 	/*
-- 
2.43.0



