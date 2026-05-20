Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61C893ED5C8;
	Wed, 20 May 2026 16:55:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779296120; cv=none; b=PVTTJSHxFb+ma6OcSpHqXwJkWkxAn/8LKJrCXlCGSCAJaHc5tMZvUdREGEHKfJuqA/L6YuJs9Ir67nkMXFkWMa7ozDKxcGlemUF2MAbRC2bx2lbWwcAHNsvz11hadKvs83m11b6JQsEyna/jJDJDT6qgZThRaFansQ0/05GPBPo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779296120; c=relaxed/simple;
	bh=TCs3DEW1HFGv0Y/JYMW7olaOgIf6A3SfsD/vYhUkfC0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eouztU80CwAxHXCtZ0Ix5YGOYg671OAU+F4yOuTq/G+GqFLNTBP9M1YuD1eD7NFzMuMNxw0Ia+55BVnW4FRxJ7uCGR2O8PsofY+4rsNHKDQ1oJdWSKCsZDZbH+NZY39LFVL1VmlxGULtFt42mrtCidwiIxnh1SQt5fEE3TsFkSE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e7lyTnzz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e7lyTnzz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7A651F000E9;
	Wed, 20 May 2026 16:55:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779296118;
	bh=WeJdKgIlbVU4e+YOIZm/Wu4R5GXZx9lay+uuLzLPVuc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=e7lyTnzz1QW+Lf7rv9TawV5IRw7glMrsLlxnwj9+EuBm1RevUSXL+FxYTrtM5Uc9R
	 7i/69Mu19yskF+zcwosz82brBhjdmER3jXJKRXvy4YD7Hny7SX5ste/PgmIdzp2Msn
	 +OI3dIY/xCfr23zg4jfgnMmFQKztbu9Vd9FJSikY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dai Ngo <dai.ngo@oracle.com>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0677/1146] NFSD: fix nfs4_file access extra count in nfsd4_add_rdaccess_to_wrdeleg
Date: Wed, 20 May 2026 18:15:27 +0200
Message-ID: <20260520162203.509013796@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dai Ngo <dai.ngo@oracle.com>

[ Upstream commit b48f44f36e6607b2f818560f19deb86b4a9c717b ]

In nfsd4_add_rdaccess_to_wrdeleg, if fp->fi_fds[O_RDONLY] is already
set by another thread, __nfs4_file_get_access should not be called
to increment the nfs4_file access count since that was already done
by the thread that added READ access to the file. The extra fi_access
count in nfs4_file can prevent the corresponding nfsd_file from being
freed.

When stopping nfs-server service, these extra access counts trigger a
BUG in kmem_cache_destroy() that shows nfsd_file object remaining on
__kmem_cache_shutdown.

This problem can be reproduced by running the Git project's test
suite over NFS.

Fixes: 8072e34e1387 ("nfsd: fix nfsd_file reference leak in nfsd4_add_rdaccess_to_wrdeleg()")
Signed-off-by: Dai Ngo <dai.ngo@oracle.com>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4state.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/nfsd/nfs4state.c b/fs/nfsd/nfs4state.c
index 6b9c399b89dfb..1f49637dfc96f 100644
--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -6257,12 +6257,12 @@ nfsd4_add_rdaccess_to_wrdeleg(struct svc_rqst *rqstp, struct nfsd4_open *open,
 			return (false);
 		fp = stp->st_stid.sc_file;
 		spin_lock(&fp->fi_lock);
-		__nfs4_file_get_access(fp, NFS4_SHARE_ACCESS_READ);
 		if (!fp->fi_fds[O_RDONLY]) {
+			__nfs4_file_get_access(fp, NFS4_SHARE_ACCESS_READ);
 			fp->fi_fds[O_RDONLY] = nf;
+			fp->fi_rdeleg_file = nfsd_file_get(fp->fi_fds[O_RDONLY]);
 			nf = NULL;
 		}
-		fp->fi_rdeleg_file = nfsd_file_get(fp->fi_fds[O_RDONLY]);
 		spin_unlock(&fp->fi_lock);
 		if (nf)
 			nfsd_file_put(nf);
-- 
2.53.0



