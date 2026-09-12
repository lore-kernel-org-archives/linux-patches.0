Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0A4F42A144;
	Sat, 12 Sep 2026 17:06:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789232767; cv=none; b=edLszGHLqIKEu31yHBnauMx82VcLPfVqnW1n5F7s99CdvNiI1ESdF4B2uD/ziEiC2hU5XSayDn3vVSnHspEK+TRoUfgvVy5QxjIeXFsPW6ktwZvElBbHvijEA13EHjeSdA6cdUl+IYq7lP+dlM7GVFIHYgYk2xtMa24EDdYwP6U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789232767; c=relaxed/simple;
	bh=VIvTiqEW7OG9wyJ92t4xErteyhOKn61bdK4aN6azagA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rP72ZIKBmCanh0OdmFzPXsA4UMLOQThh+rr+nXI9I0dGWqLLe0eofZvUYWHgUkyKuZh8bBFeu/9u5zavjjwz1ye4e56W5aX24Bvf+s61yrgiyZE1NcDQw7COLIJtV89ZWSKQF1uTrcT6yboJnMVpGLN/RMS5O846LoNcukkYZnc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SqFN7C2K; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SqFN7C2K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 641FD1F000FF;
	Sat, 12 Sep 2026 17:06:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789232766;
	bh=/YvB6lsm1lzC/N8fHNFCWF6S+syl8z54JwgH3aAPLQQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SqFN7C2KKC+dcheUj0mhxWOgkbOnG0XD2ZUmHvhRjUzjhDaZSdzOQCbXKxhf7T/6T
	 n47wTFHvWGtPCdI5zG+2navrRxL5lJfiUwSRHkQ3VTTKpKRKE+Y8JtSLysxpCEmuN1
	 bovdVtIGFG/RVnKplfaajAloJBNGJa8fHRWJe0vg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mike Snitzer <snitzer@kernel.org>,
	Chuck Lever <cel@kernel.org>
Subject: [PATCH 5.15 034/935] NFSD: remove flawed WARN_ON_ONCE from nfsd_mode_check
Date: Sat, 12 Sep 2026 08:51:04 +0200
Message-ID: <20260912065527.622566282@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -70,10 +70,8 @@ nfsd_mode_check(struct svc_rqst *rqstp,
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
 	/*


