Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E8F279F0;
	Mon,  8 Apr 2024 13:58:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712584712; cv=none; b=LrL5YmmJ+uYBVYoAdd+190I7ICq8rFMJ2mLSqcT5fOX9wfS4vebSIAdPNscEWTgd/v4/rxK+pgESyXh4zurPD9lmELNAWu4WXcRa6T5cq7xwylcNv3g9+MvbPPp58hh+hCXlld8EDyyW2hcf2YHfzq49Q3x3+++D32IWJRsPAD8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712584712; c=relaxed/simple;
	bh=EJKBdnmlUFF0i8weXBst+zhN7LXUMAybML/KHAVHTVc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tO3LFfnYn3NNDa4rBIhjKW9PPUWEq+ko9lEgSB+Y1yahktTfxFD2vNReTjPKNPawBACPPDdXnbwcgcSMEzED1psEQTl6zO4awKTE4OE0aVcUBJCbSEUQyYn52+du8QDO7re7bpkIrZ8NAqX2YLqEUx1FR8Rdt44oyANvezZmqfU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QIfmpsw4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QIfmpsw4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04A55C433F1;
	Mon,  8 Apr 2024 13:58:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712584712;
	bh=EJKBdnmlUFF0i8weXBst+zhN7LXUMAybML/KHAVHTVc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QIfmpsw4VajWx5EE0OcG8bIKdYJGOjqG8zPpTIdw4oJRT+vsNKCxst4+yesrUJJmK
	 tstp8PBSnGg3wCYLRXH6jq75wDtH8lpCV4dXzu5ZcraZKNR7SF715HGiSx5ylKJKOG
	 SqpFbWNbCZaaRU74rTYa09Z7T0N3R/tj6tqExzwU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.15 532/690] nfsd: dont kill nfsd_files because of lease break error
Date: Mon,  8 Apr 2024 14:56:38 +0200
Message-ID: <20240408125418.933509443@linuxfoundation.org>
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

From: Jeff Layton <jlayton@kernel.org>

[ Upstream commit c6593366c0bf222be9c7561354dfb921c611745e ]

An error from break_lease is non-fatal, so we needn't destroy the
nfsd_file in that case. Just put the reference like we normally would
and return the error.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 fs/nfsd/filecache.c | 29 +++++++++++++++--------------
 1 file changed, 15 insertions(+), 14 deletions(-)

diff --git a/fs/nfsd/filecache.c b/fs/nfsd/filecache.c
index d61c8223082a4..43bb2fd47cf58 100644
--- a/fs/nfsd/filecache.c
+++ b/fs/nfsd/filecache.c
@@ -1101,7 +1101,7 @@ nfsd_file_do_acquire(struct svc_rqst *rqstp, struct svc_fh *fhp,
 	nf = nfsd_file_alloc(&key, may_flags);
 	if (!nf) {
 		status = nfserr_jukebox;
-		goto out_status;
+		goto out;
 	}
 
 	ret = rhashtable_lookup_insert_key(&nfsd_file_rhash_tbl,
@@ -1110,13 +1110,11 @@ nfsd_file_do_acquire(struct svc_rqst *rqstp, struct svc_fh *fhp,
 	if (likely(ret == 0))
 		goto open_file;
 
-	nfsd_file_slab_free(&nf->nf_rcu);
-	nf = NULL;
 	if (ret == -EEXIST)
 		goto retry;
 	trace_nfsd_file_insert_err(rqstp, key.inode, may_flags, ret);
 	status = nfserr_jukebox;
-	goto out_status;
+	goto construction_err;
 
 wait_for_construction:
 	wait_on_bit(&nf->nf_flags, NFSD_FILE_PENDING, TASK_UNINTERRUPTIBLE);
@@ -1126,29 +1124,25 @@ nfsd_file_do_acquire(struct svc_rqst *rqstp, struct svc_fh *fhp,
 		trace_nfsd_file_cons_err(rqstp, key.inode, may_flags, nf);
 		if (!open_retry) {
 			status = nfserr_jukebox;
-			goto out;
+			goto construction_err;
 		}
 		open_retry = false;
-		if (refcount_dec_and_test(&nf->nf_ref))
-			nfsd_file_free(nf);
 		goto retry;
 	}
-
 	this_cpu_inc(nfsd_file_cache_hits);
 
 	status = nfserrno(nfsd_open_break_lease(file_inode(nf->nf_file), may_flags));
+	if (status != nfs_ok) {
+		nfsd_file_put(nf);
+		nf = NULL;
+	}
+
 out:
 	if (status == nfs_ok) {
 		this_cpu_inc(nfsd_file_acquisitions);
 		nfsd_file_check_write_error(nf);
 		*pnf = nf;
-	} else {
-		if (refcount_dec_and_test(&nf->nf_ref))
-			nfsd_file_free(nf);
-		nf = NULL;
 	}
-
-out_status:
 	put_cred(key.cred);
 	trace_nfsd_file_acquire(rqstp, key.inode, may_flags, nf, status);
 	return status;
@@ -1178,6 +1172,13 @@ nfsd_file_do_acquire(struct svc_rqst *rqstp, struct svc_fh *fhp,
 	if (status != nfs_ok)
 		nfsd_file_unhash(nf);
 	clear_and_wake_up_bit(NFSD_FILE_PENDING, &nf->nf_flags);
+	if (status == nfs_ok)
+		goto out;
+
+construction_err:
+	if (refcount_dec_and_test(&nf->nf_ref))
+		nfsd_file_free(nf);
+	nf = NULL;
 	goto out;
 }
 
-- 
2.43.0



