Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 681D541A766;
	Fri,  4 Sep 2026 06:07:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788502055; cv=none; b=t9uziHNlznfrnNboWZJM13tssU2at6lXyXpMKoOBuBf8uCtuhwgzTwJoPoV+NM7xt60kiUIgusS6S30+05VJ0b5EXdg5/guTjbnjzkpA2JC4lDa73bSUTqpyYm0om2HGy8umZDnPsrpkZ74/nkepcXlkVUqMCfm3nEZbvxr5/Xo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788502055; c=relaxed/simple;
	bh=vlPbUAPXYmdI5hOnURERUJujeWJapbiXTnlheO0DgYU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q0urevosC4Tk6v4pf6apxYRFrH/BwYHnhsngG7ZVcwHNxxnEKg5gm9BC8gKVwFyl6r0ZkJrOB0N2N+NDZeYA15dNcBEx2bw8A5hVTXa2DY5799qDTEGvujy+q0J85PE39yQKKpLo+3dI8KUhaLHTmJzGPmcfS3fEvkTU32+BRc4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zw8f47ds; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zw8f47ds"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 712721F00A3D;
	Fri,  4 Sep 2026 06:07:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788502054;
	bh=3zqkH8RpGWZdnbIIm3TIShX9XHyBrqMMnMH6F6hsmhA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zw8f47dsWBj+fdX3fUDcs0BkeBR2YxDXSbNzmldqEUtTNrk19jkoW4UnjlF0nUXpe
	 vseh9gH6ecIgUIt6m9UIGmGqWCwESMp+N85kTfiwGtzhBmw9AhK2eh43pnsxB3YQAR
	 bEmgVgO7J7Y+6PwM+hyoLzqknPkCqVHCQ0Jc+ncs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mike Snitzer <snitzer@kernel.org>,
	Chuck Lever <cel@kernel.org>
Subject: [PATCH 6.12 072/403] NFSD: remove flawed WARN_ON_ONCE from nfsd_mode_check
Date: Fri,  4 Sep 2026 06:57:55 +0200
Message-ID: <20260904045736.472113460@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045734.806166532@linuxfoundation.org>
References: <20260904045734.806166532@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mike Snitzer <snitzer@kernel.org>

commit aa0cf48a448c5a9fe1a1e880899ecd589ce39e6e upstream.

The header for commit e75b23f9e323 ("nfsd: check d_can_lookup in
fh_verify of directories") details the assumption that justified
adding the WARN_ON_ONCE to nfsd_mode_check(), that assumption is
invalid (in the case of NFS reexport).

When NFSD exports an NFS filesystem it is very possible for
nfsd_mode_check() to encounter a @dentry that doesn't have
i_op->lookup (see nfs_fhget()'s NFS_ATTR_FATTR_MOUNTPOINT and
NFS_ATTR_FATTR_V4_REFERRAL handling, and d_flags_for_inode()).

So remove nfsd_mode_check()'s WARN_ON_ONCE(). The nfserr_notdir
return on that branch must stay. It guards the subsequent
lookup_one_unlocked() -> __lookup_slow() path, which calls
inode->i_op->lookup() with no NULL check, so returning nfserr_notdir
is what keeps a client LOOKUP into such a @dentry from dereferencing
a NULL method pointer.

Fixes: e75b23f9e323 ("nfsd: check d_can_lookup in fh_verify of directories")
Cc: stable@vger.kernel.org
Signed-off-by: Mike Snitzer <snitzer@kernel.org>
Link: https://patch.msgid.link/20260612191410.50177-1-snitzer@kernel.org
Signed-off-by: Chuck Lever <cel@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/nfsfh.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/fs/nfsd/nfsfh.c
+++ b/fs/nfsd/nfsfh.c
@@ -69,10 +69,8 @@ nfsd_mode_check(struct dentry *dentry, u
 	if (requested == 0) /* the caller doesn't care */
 		return nfs_ok;
 	if (mode == requested) {
-		if (mode == S_IFDIR && !d_can_lookup(dentry)) {
-			WARN_ON_ONCE(1);
+		if (mode == S_IFDIR && !d_can_lookup(dentry))
 			return nfserr_notdir;
-		}
 		return nfs_ok;
 	}
 	if (mode == S_IFLNK) {


