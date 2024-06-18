Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7E621A2FCF;
	Tue, 18 Jun 2024 13:14:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718716446; cv=none; b=fG5pDHSl2UKaw+WTwFQ5B640/U0iHxFdsKXydtT+qKlwfjISPVyDkhHU6Clf6fbhN6dW/3e8syVkLMwVCN1shZXdzkoGbtxWZUZhRT6VfH8Nwaiy+cRQUdp2LhBhDK5VhyCPQMmwezvracPq98KN45+ivi7nhaOhy3XGVkvuvhk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718716446; c=relaxed/simple;
	bh=3jMo+n5Q8kBwpMr1BERr5n7ovKW3bWcre3EV2LPJ/10=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ajDgy3GybfT/1sVLphb6cyj70n410XivIQTkZqFHNgRdzOfh2jo2xl7sDcXE9zn0pX/4lTZ2sFpLuYl+qVkVMjsP1G2HoKwvgkF1A0UPsIT33xG+pUHu1KFRx1kBT/VPViO8/vm9dXuFeUIw+IcMPVKcQMa8IiU+33n5AH7g/M8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RrY7WiaZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RrY7WiaZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 501B3C4AF1D;
	Tue, 18 Jun 2024 13:14:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718716446;
	bh=3jMo+n5Q8kBwpMr1BERr5n7ovKW3bWcre3EV2LPJ/10=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RrY7WiaZsVWJCdatj5W3PLjjyjwtb1EXe683sw6MHBN1CA9RLUEoqDWdtPS8X+62t
	 7E2dw1wwtreQGT3uiN/AXBS4rFnkG0JXUkyMFWFrPAZhR82gqjyOiGAgBphvgIVwmU
	 i4HTdP84Zj7zLnnqqZhoWHjmUg/e1PNyc/irOzdY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	NeilBrown <neilb@suse.de>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 618/770] NFSD: only call fh_unlock() once in nfsd_link()
Date: Tue, 18 Jun 2024 14:37:51 +0200
Message-ID: <20240618123431.142108415@linuxfoundation.org>
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

From: NeilBrown <neilb@suse.de>

[ Upstream commit e18bcb33bc5b69bccc2b532075aa00bb49cc01c5 ]

On non-error paths, nfsd_link() calls fh_unlock() twice.  This is safe
because fh_unlock() records that the unlock has been done and doesn't
repeat it.
However it makes the code a little confusing and interferes with changes
that are planned for directory locking.

So rearrange the code to ensure fh_unlock() is called exactly once if
fh_lock() was called.

Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: NeilBrown <neilb@suse.de>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/vfs.c | 19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

diff --git a/fs/nfsd/vfs.c b/fs/nfsd/vfs.c
index 6b8e1826956bf..dd945099ae6b5 100644
--- a/fs/nfsd/vfs.c
+++ b/fs/nfsd/vfs.c
@@ -1557,9 +1557,10 @@ nfsd_link(struct svc_rqst *rqstp, struct svc_fh *ffhp,
 	dirp = d_inode(ddir);
 
 	dnew = lookup_one_len(name, ddir, len);
-	host_err = PTR_ERR(dnew);
-	if (IS_ERR(dnew))
-		goto out_nfserr;
+	if (IS_ERR(dnew)) {
+		err = nfserrno(PTR_ERR(dnew));
+		goto out_unlock;
+	}
 
 	dold = tfhp->fh_dentry;
 
@@ -1578,17 +1579,17 @@ nfsd_link(struct svc_rqst *rqstp, struct svc_fh *ffhp,
 		else
 			err = nfserrno(host_err);
 	}
-out_dput:
 	dput(dnew);
-out_unlock:
-	fh_unlock(ffhp);
+out_drop_write:
 	fh_drop_write(tfhp);
 out:
 	return err;
 
-out_nfserr:
-	err = nfserrno(host_err);
-	goto out_unlock;
+out_dput:
+	dput(dnew);
+out_unlock:
+	fh_unlock(ffhp);
+	goto out_drop_write;
 }
 
 static void
-- 
2.43.0



