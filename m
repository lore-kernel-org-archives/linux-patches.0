Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793216084;
	b=cDT+qMqEbI1VMdLhranP+/4Qxidp3XMknXqts1rLbWUOs2cIOrv4l7en4UwyFm4Q5esL
	 L0OtyCu15TLxotphaM+7XUN1lWcb1TYWRDEpcXR86/7JgcuxQ8kZ/2jdqR0ta3c1ES+mE
	 wHaLTJTiV5zsde1FVs9n/ps3venAACJsauiTN7rfXMoxdcqZp62Mb1IDjMzu2ynE4sXk1
	 MYheB1n8OFfYGlTtF1ggIi/bY+A+BisMhAhbcJsbmHjahbINcDWI2zIUKE2oEzFPHnnsa
	 /++TEZnPuUZpPL6aimD5Y7iZHiE1fcbFKnJEesfj7SwepKPupEF7U25JW+KGMZUWJ9A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793216084;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=d5/TLweTaMJhWIHq2f0yhTMA37OZscBGGoc+eIQzUW0=;
	b=g5W0uH5HI0oRlKOsHjNY4k4VSOivSEI2UiOQVXudj7VhlqxNQ6JMsfBOfCER+W3qAndX
	 xPzwj8qqgCotNeZtPu0oR0jbhZ6WqxMwyCIOq5WHMSmZHtB8ChKjhNzgq22/Kq8UTYjXZ
	 jFx59n/OvNFUsJDvPv6JElCgyzDyOkUHUgK8LW1RK3/BQrZsff5WjMVgaHKHsMbHPbg+8
	 2gSLRqqRW5SbDdtjzLK3w4++Diop/p4uMG3lwEy3ecsOAuPNSbYd09+IXK2UtKpBDDzvq
	 xsyYOG5EUiJYn6upVDhqIWD7QFhm6lAxdQ+CFLv/mxNO0CtcXHjqlmy2V/YVPEzXw8g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=m73mEDBf;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76C6C606A31A;
	Wed, 28 Oct 2026 19:34:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=m73mEDBf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C299C1F01825;
	Wed, 28 Oct 2026 19:34:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793216084;
	bh=d5/TLweTaMJhWIHq2f0yhTMA37OZscBGGoc+eIQzUW0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=m73mEDBfkodQ3Mowmuq4phuylXQd0f5XTmWaoObbPFoqUGCnXA/+Ltj+a8/x6q+eC
	 CxZsBw6dulwGdYH2WKUf18JpQJ5uUyRlOxAaLeLG37rxcGxx/2D3CB2Q3QtZX+3hAE
	 qRVpGtrJ0iXOa+uSzmoIqWWJifo2PRsTIbuX4Jes=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Mason <clm@meta.com>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1435/1887] NFSD: check truncate permission under inode lock
Date: Wed, 28 Oct 2026 17:58:51 +0100
Message-ID: <20261028170532.115051216@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
 fs/nfsd/vfs.c | 32 +++++++++++++++++++++-----------
 1 file changed, 21 insertions(+), 11 deletions(-)

diff --git a/fs/nfsd/vfs.c b/fs/nfsd/vfs.c
index ec28429c29462..4ae834b9db878 100644
--- a/fs/nfsd/vfs.c
+++ b/fs/nfsd/vfs.c
@@ -413,20 +413,22 @@ nfsd_sanitize_attrs(struct inode *inode, struct iattr *iap)
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
 
-		err = nfsd_permission(rqstp, fhp->fh_export, fhp->fh_dentry,
-				NFSD_MAY_TRUNC | NFSD_MAY_OWNER_OVERRIDE);
-		if (err)
-			return err;
-	}
-	return nfserrno(get_write_access(inode));
+	return nfsd_permission(rqstp, fhp->fh_export, fhp->fh_dentry,
+			       NFSD_MAY_TRUNC | NFSD_MAY_OWNER_OVERRIDE);
+}
+
+static __be32
+nfsd_get_write_access(struct svc_fh *fhp)
+{
+	return nfserrno(get_write_access(d_inode(fhp->fh_dentry)));
 }
 
 static int __nfsd_setattr(struct dentry *dentry, struct iattr *iap)
@@ -548,12 +550,20 @@ nfsd_setattr(struct svc_rqst *rqstp, struct svc_fh *fhp,
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
+		if (err) {
+			inode_unlock(inode);
+			put_write_access(inode);
+			return err;
+		}
+	}
 	fh_fill_pre_attrs(fhp);
 	for (retries = 1;;) {
 		struct iattr attrs;
-- 
2.53.0



