Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40F8A42046;
	Mon,  8 Apr 2024 13:52:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712584351; cv=none; b=Uazf5xo4IQZeZX585yQkjnewoI1wvIIAqBj1bcHf7BXQb6NUVon1RFEvuY6sVGhDCs7xj20gApiuqmSlIv6lBzrmtcrCODfqazJF0O7gO9toFqgmNVILMWv5dlGv4sCUrOqVy/86hQOIaMrwa7O2fS4h7aHJnx8svAGAnqxm6wg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712584351; c=relaxed/simple;
	bh=tXkVuyBvxZAiNFT1fqSNiOw4RVdmfsja1K7aE4o+FFc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Kctw4b5NH00lqfC1X6c/VEIIRkONThhWnGXAJxW2Vstc+FodrAfH6zS2KN7Hd3nfiZZPy7d4pKnkEwBVT29Ll8lltZyNgDKOJGpPneYMlRBB0yLZWBVgduRDsKuYGjAFl6gLQxFyJ4G/2nmjL4ZwkocfYzl7El7LGBDZipT3uuQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lo6rJFoK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lo6rJFoK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD28DC433F1;
	Mon,  8 Apr 2024 13:52:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712584351;
	bh=tXkVuyBvxZAiNFT1fqSNiOw4RVdmfsja1K7aE4o+FFc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lo6rJFoKDz1O2Dks66Flu9GbWHmXPdjzxxDSSVaQG5HgtkbIBjJecoVugtm6usvpz
	 YvpP4JKy/r6Cy5YQWagrwoDMl3kpU4zhcksPyBxz6mwbOBVoqMs10XUF0iY8/sXaV/
	 YWN6CkQy4WVItSxSxrp+pDSCruncPxVHOfRFnUfA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	NeilBrown <neilb@suse.de>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.15 408/690] NFSD: always drop directory lock in nfsd_unlink()
Date: Mon,  8 Apr 2024 14:54:34 +0200
Message-ID: <20240408125414.356486731@linuxfoundation.org>
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

From: NeilBrown <neilb@suse.de>

[ Upstream commit b677c0c63a135a916493c064906582e9f3ed4802 ]

Some error paths in nfsd_unlink() allow it to exit without unlocking the
directory.  This is not a problem in practice as the directory will be
locked with an fh_put(), but it is untidy and potentially confusing.

This allows us to remove all the fh_unlock() calls that are immediately
after nfsd_unlink() calls.

Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: NeilBrown <neilb@suse.de>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 fs/nfsd/nfs3proc.c | 2 --
 fs/nfsd/nfs4proc.c | 4 +---
 fs/nfsd/vfs.c      | 7 +++++--
 3 files changed, 6 insertions(+), 7 deletions(-)

diff --git a/fs/nfsd/nfs3proc.c b/fs/nfsd/nfs3proc.c
index c7c2c7db30f54..fbdc109fbd067 100644
--- a/fs/nfsd/nfs3proc.c
+++ b/fs/nfsd/nfs3proc.c
@@ -490,7 +490,6 @@ nfsd3_proc_remove(struct svc_rqst *rqstp)
 	fh_copy(&resp->fh, &argp->fh);
 	resp->status = nfsd_unlink(rqstp, &resp->fh, -S_IFDIR,
 				   argp->name, argp->len);
-	fh_unlock(&resp->fh);
 	return rpc_success;
 }
 
@@ -511,7 +510,6 @@ nfsd3_proc_rmdir(struct svc_rqst *rqstp)
 	fh_copy(&resp->fh, &argp->fh);
 	resp->status = nfsd_unlink(rqstp, &resp->fh, S_IFDIR,
 				   argp->name, argp->len);
-	fh_unlock(&resp->fh);
 	return rpc_success;
 }
 
diff --git a/fs/nfsd/nfs4proc.c b/fs/nfsd/nfs4proc.c
index fb2487ceac46e..26cd2479e30cf 100644
--- a/fs/nfsd/nfs4proc.c
+++ b/fs/nfsd/nfs4proc.c
@@ -1002,10 +1002,8 @@ nfsd4_remove(struct svc_rqst *rqstp, struct nfsd4_compound_state *cstate,
 		return nfserr_grace;
 	status = nfsd_unlink(rqstp, &cstate->current_fh, 0,
 			     remove->rm_name, remove->rm_namelen);
-	if (!status) {
-		fh_unlock(&cstate->current_fh);
+	if (!status)
 		set_change_info(&remove->rm_cinfo, &cstate->current_fh);
-	}
 	return status;
 }
 
diff --git a/fs/nfsd/vfs.c b/fs/nfsd/vfs.c
index 90bd6968fbf68..4b1304fe718fd 100644
--- a/fs/nfsd/vfs.c
+++ b/fs/nfsd/vfs.c
@@ -1754,12 +1754,12 @@ nfsd_unlink(struct svc_rqst *rqstp, struct svc_fh *fhp, int type,
 	rdentry = lookup_one_len(fname, dentry, flen);
 	host_err = PTR_ERR(rdentry);
 	if (IS_ERR(rdentry))
-		goto out_drop_write;
+		goto out_unlock;
 
 	if (d_really_is_negative(rdentry)) {
 		dput(rdentry);
 		host_err = -ENOENT;
-		goto out_drop_write;
+		goto out_unlock;
 	}
 	rinode = d_inode(rdentry);
 	ihold(rinode);
@@ -1797,6 +1797,9 @@ nfsd_unlink(struct svc_rqst *rqstp, struct svc_fh *fhp, int type,
 	}
 out:
 	return err;
+out_unlock:
+	fh_unlock(fhp);
+	goto out_drop_write;
 }
 
 /*
-- 
2.43.0



