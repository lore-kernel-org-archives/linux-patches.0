Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F19031A38E4;
	Tue, 18 Jun 2024 13:13:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718716432; cv=none; b=PGdHFcsfgOFHP2fXQcmgA0mA1QyXBrKwYEsG50aakMr6IlNF2KBfXLkQt6s7W/mnRLOF8fA+h3fKgLvse3UD4HmTmnJd+lvm6aUF7OhbZPutmz0oPKDz9odLED9gCg5yPdL0XX6oepEXtWUrt9DnpQNxzHreUHkLtoLlnyjV0Y0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718716432; c=relaxed/simple;
	bh=YAeBrU5zwY4UcsT/dJKolZO0YG5Xim+q7ULOMhppO5I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BX1Y+SAKWzDAEcAL+Kv4ahrB9JGkSksReypa1f5IfRs7a6h27SiITP2WLuJ2c5brIgu1b2TppOSWIOKvk4SwDtnKy+JlpCasO7qX0gHUaP85zNRBaRYpBZuSqePzN9GtcgnyBF/jWUAvQHUWyjEA0LRszB3HmM7ELQKCBAlSEPY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gmpDBbA9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gmpDBbA9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 764F3C3277B;
	Tue, 18 Jun 2024 13:13:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718716431;
	bh=YAeBrU5zwY4UcsT/dJKolZO0YG5Xim+q7ULOMhppO5I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gmpDBbA9S0P8ai/i1MRR9WHVkUmmiSS9HqaN7WExQP/zMGTXXJsjmpRoh4vXjyhWN
	 rK1pN4F2B9qt4SpaaiT2QEvwu3NFU2c9wEgAW+9Ymb4rb2Hp5jeyqvUJA5g2Y0pP2Q
	 w23wTm+BFpbjHtPwEYMj35tpZDg4ciCgZi0ySe1M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	NeilBrown <neilb@suse.de>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 617/770] NFSD: always drop directory lock in nfsd_unlink()
Date: Tue, 18 Jun 2024 14:37:50 +0200
Message-ID: <20240618123431.104334137@linuxfoundation.org>
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

[ Upstream commit b677c0c63a135a916493c064906582e9f3ed4802 ]

Some error paths in nfsd_unlink() allow it to exit without unlocking the
directory.  This is not a problem in practice as the directory will be
locked with an fh_put(), but it is untidy and potentially confusing.

This allows us to remove all the fh_unlock() calls that are immediately
after nfsd_unlink() calls.

Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: NeilBrown <neilb@suse.de>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs3proc.c | 2 --
 fs/nfsd/nfs4proc.c | 4 +---
 fs/nfsd/vfs.c      | 7 +++++--
 3 files changed, 6 insertions(+), 7 deletions(-)

diff --git a/fs/nfsd/nfs3proc.c b/fs/nfsd/nfs3proc.c
index c71f0c359f7ae..d78dbb214c5c3 100644
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
index 0396fa2c1cfe7..f588e592a0703 100644
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
index 3d794533bbd4b..6b8e1826956bf 100644
--- a/fs/nfsd/vfs.c
+++ b/fs/nfsd/vfs.c
@@ -1767,12 +1767,12 @@ nfsd_unlink(struct svc_rqst *rqstp, struct svc_fh *fhp, int type,
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
@@ -1810,6 +1810,9 @@ nfsd_unlink(struct svc_rqst *rqstp, struct svc_fh *fhp, int type,
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



