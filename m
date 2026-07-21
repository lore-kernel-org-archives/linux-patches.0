Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DC54472530;
	Tue, 21 Jul 2026 20:12:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784664739; cv=none; b=uGRJW3EuStluwv4bnOseCi4RRRvuReazzrx8qAe80muag1/PKdmc4mMTdx0bkb5tl8SG6xfeOEeMNSagE+Z8P7xTs8HD99QpR3jOAtcBLgJk+UtGlY3SMwWRy1kwGpFwOegNspVeZVjBgnfxboByhQqzC9alHSGwCg1/bsw78zA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784664739; c=relaxed/simple;
	bh=mrcAEO/hShm56BOiq0EFfQvY9n44EJ+TWt+LoJe1gqA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ibp4hLkWVx+zXLCNIw/IFDB4g3EMKPorp+rThfYOR11mh513r4HRJNNDAaF/KWhsUnBw18sZZaqwShACeBv59d3ZKAVvIvnl6FjrrVaAuhD6RgRrD5JxUMuofJKXeWtN4YBTdABb+wFLDpqkehv8NojhVf94y5aoDD0CQcq4GC8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rBTA3uSZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rBTA3uSZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BF081F00A3F;
	Tue, 21 Jul 2026 20:12:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784664738;
	bh=2+Srcn+YQqYH9+Y7azSs6Ch9a0ixe/qqm0T+60Is+0I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rBTA3uSZzLwyNU3efhZGOzd0NP0Ja91k129wb/eQtXHfYomsElnNHIknAhYWEK5H5
	 GAc4jQFh37iUVV5DZ+qW4ij15sIt21PnujgeAt+hiAsHufG2v8BaaK0Kf0KhhEUhJ6
	 VCkBZREaAMoFiVTZSOCkdWdGuXJBEVyMBtTSWkn4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0039/1266] nfsd: Dont reset the write verifier on a commit EAGAIN
Date: Tue, 21 Jul 2026 17:07:56 +0200
Message-ID: <20260721152442.677294113@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

From: Trond Myklebust <trond.myklebust@hammerspace.com>

[ Upstream commit 1b2021bdeeca12364ad0fa7aac9ddba5cae964f3 ]

If fsync() is returning EAGAIN, then we can assume that the filesystem
being exported is something like NFS with the 'softerr' mount option
enabled, and that it is just asking us to replay the fsync() operation
at a later date.

If we see an ESTALE, then ditto: the file is gone, so there is no danger
of losing the error.

For those cases, do not reset the write verifier. A write verifier
change has a global effect, causing retransmission by all clients of
all uncommitted unstable writes for all files, so it is worth
mitigating where possible.

Link: https://lore.kernel.org/linux-nfs/20230911184357.11739-1-trond.myklebust@hammerspace.com/
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Stable-dep-of: 2090b05803fa ("nfsd: reset write verifier on deferred writeback errors")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/vfs.c |   33 +++++++++++++++++++++++----------
 1 file changed, 23 insertions(+), 10 deletions(-)

--- a/fs/nfsd/vfs.c
+++ b/fs/nfsd/vfs.c
@@ -338,6 +338,24 @@ out:
 	return err;
 }
 
+static void
+commit_reset_write_verifier(struct nfsd_net *nn, struct svc_rqst *rqstp,
+			    int err)
+{
+	switch (err) {
+	case -EAGAIN:
+	case -ESTALE:
+		/*
+		 * Neither of these are the result of a problem with
+		 * durable storage, so avoid a write verifier reset.
+		 */
+		break;
+	default:
+		nfsd_reset_write_verifier(nn);
+		trace_nfsd_writeverf_reset(nn, rqstp, err);
+	}
+}
+
 /*
  * Commit metadata changes to stable storage.
  */
@@ -659,8 +677,7 @@ __be32 nfsd4_clone_file_range(struct svc
 					&nfsd4_get_cstate(rqstp)->current_fh,
 					dst_pos,
 					count, status);
-			nfsd_reset_write_verifier(nn);
-			trace_nfsd_writeverf_reset(nn, rqstp, status);
+			commit_reset_write_verifier(nn, rqstp, status);
 			ret = nfserrno(status);
 		}
 	}
@@ -1177,8 +1194,7 @@ nfsd_vfs_write(struct svc_rqst *rqstp, s
 	host_err = vfs_iter_write(file, &iter, &pos, flags);
 	file_end_write(file);
 	if (host_err < 0) {
-		nfsd_reset_write_verifier(nn);
-		trace_nfsd_writeverf_reset(nn, rqstp, host_err);
+		commit_reset_write_verifier(nn, rqstp, host_err);
 		goto out_nfserr;
 	}
 	*cnt = host_err;
@@ -1193,10 +1209,8 @@ nfsd_vfs_write(struct svc_rqst *rqstp, s
 
 	if (stable && use_wgather) {
 		host_err = wait_for_concurrent_writes(file);
-		if (host_err < 0) {
-			nfsd_reset_write_verifier(nn);
-			trace_nfsd_writeverf_reset(nn, rqstp, host_err);
-		}
+		if (host_err < 0)
+			commit_reset_write_verifier(nn, rqstp, host_err);
 	}
 
 out_nfserr:
@@ -1343,8 +1357,7 @@ nfsd_commit(struct svc_rqst *rqstp, stru
 			err = nfserr_notsupp;
 			break;
 		default:
-			nfsd_reset_write_verifier(nn);
-			trace_nfsd_writeverf_reset(nn, rqstp, err2);
+			commit_reset_write_verifier(nn, rqstp, err2);
 			err = nfserrno(err2);
 		}
 	} else


