Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B62C337110;
	Fri, 17 Oct 2025 15:26:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760714802; cv=none; b=fAZHnETArhojSLNucUI8pJBBjnthQvQSv9ATk2ERlO6R+mQFvOVcndoU8Bw0LLoKkgaQUL9P8XSWbWGK2Yx7x9QT1ulYwhTB9jNUsYx4Q1PlLC/e3FdXJgwGOPSmajkx6pz+VxI5Vx4m7suNWGtRPtvnSZzALKYnl+xjPi8bkpc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760714802; c=relaxed/simple;
	bh=Kt30bplBa9QnXuGK2Snj8Enaf+jGRn44ezra9aDxZI4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OdDbBOV6mRkCz5JtDmhhs9CywEqKt5HKPOsIyNf0Vu7JuYevqUBIib4dGwgzdMlr3d/5m1OM4AxbMhDluUTGN/UxKvT2qev1Q63+b28ACDt+ZnxqbOoRHGiBs1zz5vQQWhrykqa1lBN6j7k4h2YdcUU86bH3/32OHy85zbB+GtI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZXbQf7ZS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZXbQf7ZS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 035CAC4CEE7;
	Fri, 17 Oct 2025 15:26:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760714802;
	bh=Kt30bplBa9QnXuGK2Snj8Enaf+jGRn44ezra9aDxZI4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZXbQf7ZSU13vCR+FbTz9sOG0dJJ7ix+fOZltlSW3aernEQ49X45/161IRwU0AsCI+
	 k0+EqRHole9Ut5T6Co+NrlvDrzRuddINhbWK5RPYJRxk4yur8FMiUCenBi7HgqLWwx
	 4eOm8ioxz7DH/yMSjMoW54cd1Xl+P7HQnp/XYpUM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	NeilBrown <neilb@suse.de>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 244/277] NFSD: Replace use of NFSD_MAY_LOCK in nfsd4_lock()
Date: Fri, 17 Oct 2025 16:54:11 +0200
Message-ID: <20251017145156.055132341@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145147.138822285@linuxfoundation.org>
References: <20251017145147.138822285@linuxfoundation.org>
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

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit 6640556b0c80edc66d6f50abe53f00311a873536 ]

NFSv4 LOCK operations should not avoid the set of authorization
checks that apply to all other NFSv4 operations. Also, the
"no_auth_nlm" export option should apply only to NLM LOCK requests.
It's not necessary or sensible to apply it to NFSv4 LOCK operations.

Instead, set no permission bits when calling fh_verify(). Subsequent
stateid processing handles authorization checks.

Reported-by: NeilBrown <neilb@suse.de>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Stable-dep-of: 898374fdd7f0 ("nfsd: unregister with rpcbind when deleting a transport")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/nfs4state.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -7998,11 +7998,9 @@ nfsd4_lock(struct svc_rqst *rqstp, struc
 	if (check_lock_length(lock->lk_offset, lock->lk_length))
 		 return nfserr_inval;
 
-	if ((status = fh_verify(rqstp, &cstate->current_fh,
-				S_IFREG, NFSD_MAY_LOCK))) {
-		dprintk("NFSD: nfsd4_lock: permission denied!\n");
+	status = fh_verify(rqstp, &cstate->current_fh, S_IFREG, 0);
+	if (status != nfs_ok)
 		return status;
-	}
 	sb = cstate->current_fh.fh_dentry->d_sb;
 
 	if (lock->lk_is_new) {


