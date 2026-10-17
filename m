Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1606F3A1A3B;
	Sat, 17 Oct 2026 17:58:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792259904; cv=none; b=Tfsueiavx+bFFBxdJmyff7/n4RUJoRTc0UtULN8sQjQTPwHuvrkPI2qRV+/8ziU19GhWi13Y+FaAmU/wydFsJsAGRVrd0Q+v3G+YYik90hTmhDoMS2/OKTjrwBCCDaqiFOA5i/T0TqiA7ps/bxM1Besv7MeHCAwt5Bj1JQ6xUPM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792259904; c=relaxed/simple;
	bh=iwc8Hq2YTkiFnv+eN9bkvfvguMiLyiGxTOoGr7/GYyE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UkuOVUKSX6hnCLFWch2dJN2PQBHF4xVrPu48Qcz1mfkyReByfeVnChiNQAqLtSuuWc0zB98xH/HigJNnz01PYCDGJgpqxCtTgOYuyrGgZYl6Y22l91EQuRAaXl18VZezvAtoeeihdEie4B/CYOGYOe8HZ/43V496yYxrejihl3E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W3oJqavF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W3oJqavF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A0621F000C4;
	Sat, 17 Oct 2026 17:58:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792259902;
	bh=R1z2269eJhmFA4U0/2c4seipIGuDWFkp6HUEVJnINvA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=W3oJqavF8BrQQEbRTumH8esnd7x8X5+D3sNYuSD1h/oj/jXeanivic35jI9rg1Xbp
	 qFKNJoPuw7WPApgKXkG1QQfyRmbV1D1PQMnRepFxWJq3QROpXK2Xp8eUvRd7jOR0DZ
	 taSShoKAKtk1b//UOFNZ0w546g1ebpuHi4ttngSU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Mason <clm@meta.com>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1327/1674] NFSD: check truncate permission under inode lock
Date: Sat, 17 Oct 2026 17:59:59 +0200
Message-ID: <20261017160505.207967268@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit b778e0e0a16759f22a70579c3cf8d254a40d4a7f ]

nfsd_setattr() checks whether a size update needs NFSD_MAY_TRUNC
before it takes inode_lock(). The comparison uses the file size sampled
by that unlocked read, but the actual ATTR_SIZE update is applied later
under inode_lock() by notify_change().

This leaves a TOCTOU window for append-only files. If a client sends a
SETATTR that does not shrink the file at the time of the unlocked
sample, a concurrent append can extend the file before nfsd_setattr()
takes inode_lock(). notify_change() then applies a real truncation
without the NFSD_MAY_TRUNC check that rejects IS_APPEND(inode). The VFS
truncate syscall paths perform their own append-only checks before
calling notify_change(), so NFSD must make this decision against the
locked size it is about to change.

Split the write-count acquisition from the truncation permission check.
Keep get_write_access() before the locked setattr work, then recheck
whether the requested size is below i_size_read(inode) after inode_lock()
has been acquired and before notify_change(ATTR_SIZE). This also avoids
the plain unlocked inode->i_size load.

Fixes: 783112f7401f ("nfsd: special case truncates some more")
Cc: stable@vger.kernel.org
Assisted-by: kres:claude-opus-4-7
Reported-by: Chris Mason <clm@meta.com>
Signed-off-by: Jeff Layton <jlayton@kernel.org>
Link: https://patch.msgid.link/20260530-nfsd-fixes-v2-6-f27e8eb4d974@kernel.org
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/vfs.c | 30 ++++++++++++++++++------------
 1 file changed, 18 insertions(+), 12 deletions(-)

diff --git a/fs/nfsd/vfs.c b/fs/nfsd/vfs.c
index 14a29c229cbbc..4da93e691e00d 100644
--- a/fs/nfsd/vfs.c
+++ b/fs/nfsd/vfs.c
@@ -417,21 +417,22 @@ nfsd_sanitize_attrs(struct inode *inode, struct iattr *iap)
 }
 
 static __be32
-nfsd_get_write_access(struct svc_rqst *rqstp, struct svc_fh *fhp,
-		struct iattr *iap)
+nfsd_may_truncate(struct svc_rqst *rqstp, struct svc_fh *fhp,
+		  struct iattr *iap)
 {
 	struct inode *inode = d_inode(fhp->fh_dentry);
 
-	if (iap->ia_size < inode->i_size) {
-		__be32 err;
+	if (iap->ia_size >= i_size_read(inode))
+		return nfs_ok;
 
-		err = nfsd_permission(&rqstp->rq_cred,
-				      fhp->fh_export, fhp->fh_dentry,
-				      NFSD_MAY_TRUNC | NFSD_MAY_OWNER_OVERRIDE);
-		if (err)
-			return err;
-	}
-	return nfserrno(get_write_access(inode));
+	return nfsd_permission(&rqstp->rq_cred, fhp->fh_export, fhp->fh_dentry,
+			       NFSD_MAY_TRUNC | NFSD_MAY_OWNER_OVERRIDE);
+}
+
+static __be32
+nfsd_get_write_access(struct svc_fh *fhp)
+{
+	return nfserrno(get_write_access(d_inode(fhp->fh_dentry)));
 }
 
 static int __nfsd_setattr(struct dentry *dentry, struct iattr *iap)
@@ -548,12 +549,17 @@ nfsd_setattr(struct svc_rqst *rqstp, struct svc_fh *fhp,
 	 * setattr call.
 	 */
 	if (size_change) {
-		err = nfsd_get_write_access(rqstp, fhp, iap);
+		err = nfsd_get_write_access(fhp);
 		if (err)
 			return err;
 	}
 
 	inode_lock(inode);
+	if (size_change) {
+		err = nfsd_may_truncate(rqstp, fhp, iap);
+		if (err)
+			goto out_unlock;
+	}
 	err = fh_fill_pre_attrs(fhp);
 	if (err)
 		goto out_unlock;
-- 
2.53.0



