Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E5B715A85F;
	Tue, 18 Jun 2024 13:19:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718716745; cv=none; b=E7C1WTAzUMXUubzdeXN7AqIhOP7Dygv+ivSNBPF0b4wU19vZBx/ixTeHGS3XQbZMmEAZNuwT205p4t4ozidyXTwQ3jZNxO2KGTEUt3fIh8Wd4l5ZyTZ4V/xWESJd6BPq4tMilBbZZSlbPywJc7x1W8In2lkRamCo/UdyDamud7w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718716745; c=relaxed/simple;
	bh=iBZP6hqjCSo/htFZUGeupgEtrnyrsRbfqr3i0n05TpM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j7zB9JMZ80U7aEVXKT56j2SEanAXJZxCsIioPC7m5XkAAtk0Qx1xec8gwBI7ppkhJJAPHkrzoYI5yfpg56vJ216RwaxBzErpe/dVxLxbPmycZ2M1lHxQ8rFSIj2YZoPeo9hNXFCRVHyqkwirMGHUHC9skhc9W0uWBrDMZHvYr0s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=incw9lc+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="incw9lc+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF9ADC3277B;
	Tue, 18 Jun 2024 13:19:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718716745;
	bh=iBZP6hqjCSo/htFZUGeupgEtrnyrsRbfqr3i0n05TpM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=incw9lc+cUfaE8q9XC9XfgWUofYYCC53qr8TZHjA7i6WXeGFY0cv7s6b48LiLqpoa
	 uyYxMpP1DVFrJsIGJ5X9e0GqDW0lXCT8v0grXCWVjBNdNQtOmoVNDq/AaMI2zX90sp
	 ZOKUDaQ4wBd2qjqkb6AAuVxueuzYx4wJr2XrnaUk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 747/770] nfsd: dont kill nfsd_files because of lease break error
Date: Tue, 18 Jun 2024 14:40:00 +0200
Message-ID: <20240618123436.103510205@linuxfoundation.org>
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

From: Jeff Layton <jlayton@kernel.org>

[ Upstream commit c6593366c0bf222be9c7561354dfb921c611745e ]

An error from break_lease is non-fatal, so we needn't destroy the
nfsd_file in that case. Just put the reference like we normally would
and return the error.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
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



