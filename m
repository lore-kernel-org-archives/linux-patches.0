Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CABA5185E77;
	Tue, 18 Jun 2024 13:00:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718715641; cv=none; b=LqgSbi83VVIPvttSphjiVX+5qjt26ije/Wiblm0sTf3lXNA4wPdS9DC0eErecfQxojWzFzwcJqr+YUXOfHW0nMnvuidk0kCjSTJZexTjH8K/JHIiUQQ9SRab0ZDC0rHvaq8eVBr/5iCr8y67272YTBSnX/yYwCdxAzy0kLNFiHA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718715641; c=relaxed/simple;
	bh=SEtoKu2je/UEc9ZdqojzwQySMZ24g7ezlM7nMDBc4UM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n7RtBw3r0daYLwN2x0Ba270pD2C0XL/pqVyPsy7ijQc95gVqxpyG8TumuWJqQPDxPcUSiMm8aApYI3V6nzaFSJcOvtfLMChizL0e/HQLcek+fRjJTzN2W6yvRMDfyrIYW9bYRC3QVq/5Ryo7GFIECe6ir5uAhTOnHaqhpH9NGj4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0agrwFDb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0agrwFDb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18E79C3277B;
	Tue, 18 Jun 2024 13:00:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718715641;
	bh=SEtoKu2je/UEc9ZdqojzwQySMZ24g7ezlM7nMDBc4UM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0agrwFDbGXD+gv/Itu/mlb8JDb7UgC7RCMuSF6WdeKGSGBcma9x3jbwdiwI4U3SOh
	 96t54bmtRwfFMvKaJqfHsgSiLRuqzMZhI/p/B1h8YAHmi4YG5zDEVVt4HWVQ95GxG9
	 kiKTjUogB87OA0Okb5LmSmF5z0nLkx6iBkkFUsok=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"J. Bruce Fields" <bfields@redhat.com>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 346/770] nlm: minor nlm_lookup_file argument change
Date: Tue, 18 Jun 2024 14:33:19 +0200
Message-ID: <20240618123420.619434297@linuxfoundation.org>
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

From: J. Bruce Fields <bfields@redhat.com>

[ Upstream commit 2dc6f19e4f438d4c14987cb17aee38aaf7304e7f ]

It'll come in handy to get the whole nlm_lock.

Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/lockd/svc4proc.c         |  3 ++-
 fs/lockd/svcproc.c          |  2 +-
 fs/lockd/svcsubs.c          | 15 ++++++++-------
 include/linux/lockd/lockd.h |  2 +-
 4 files changed, 12 insertions(+), 10 deletions(-)

diff --git a/fs/lockd/svc4proc.c b/fs/lockd/svc4proc.c
index 4c10fb5138f10..bc496bbd696b8 100644
--- a/fs/lockd/svc4proc.c
+++ b/fs/lockd/svc4proc.c
@@ -40,7 +40,8 @@ nlm4svc_retrieve_args(struct svc_rqst *rqstp, struct nlm_args *argp,
 
 	/* Obtain file pointer. Not used by FREE_ALL call. */
 	if (filp != NULL) {
-		if ((error = nlm_lookup_file(rqstp, &file, &lock->fh)) != 0)
+		error = nlm_lookup_file(rqstp, &file, lock);
+		if (error)
 			goto no_locks;
 		*filp = file;
 
diff --git a/fs/lockd/svcproc.c b/fs/lockd/svcproc.c
index 4ae4b63b53925..f4e5e0eb30fd1 100644
--- a/fs/lockd/svcproc.c
+++ b/fs/lockd/svcproc.c
@@ -69,7 +69,7 @@ nlmsvc_retrieve_args(struct svc_rqst *rqstp, struct nlm_args *argp,
 
 	/* Obtain file pointer. Not used by FREE_ALL call. */
 	if (filp != NULL) {
-		error = cast_status(nlm_lookup_file(rqstp, &file, &lock->fh));
+		error = cast_status(nlm_lookup_file(rqstp, &file, lock));
 		if (error != 0)
 			goto no_locks;
 		*filp = file;
diff --git a/fs/lockd/svcsubs.c b/fs/lockd/svcsubs.c
index 028fc152da22f..2d62633b39e51 100644
--- a/fs/lockd/svcsubs.c
+++ b/fs/lockd/svcsubs.c
@@ -82,31 +82,31 @@ static inline unsigned int file_hash(struct nfs_fh *f)
  */
 __be32
 nlm_lookup_file(struct svc_rqst *rqstp, struct nlm_file **result,
-					struct nfs_fh *f)
+					struct nlm_lock *lock)
 {
 	struct nlm_file	*file;
 	unsigned int	hash;
 	__be32		nfserr;
 
-	nlm_debug_print_fh("nlm_lookup_file", f);
+	nlm_debug_print_fh("nlm_lookup_file", &lock->fh);
 
-	hash = file_hash(f);
+	hash = file_hash(&lock->fh);
 
 	/* Lock file table */
 	mutex_lock(&nlm_file_mutex);
 
 	hlist_for_each_entry(file, &nlm_files[hash], f_list)
-		if (!nfs_compare_fh(&file->f_handle, f))
+		if (!nfs_compare_fh(&file->f_handle, &lock->fh))
 			goto found;
 
-	nlm_debug_print_fh("creating file for", f);
+	nlm_debug_print_fh("creating file for", &lock->fh);
 
 	nfserr = nlm_lck_denied_nolocks;
 	file = kzalloc(sizeof(*file), GFP_KERNEL);
 	if (!file)
 		goto out_unlock;
 
-	memcpy(&file->f_handle, f, sizeof(struct nfs_fh));
+	memcpy(&file->f_handle, &lock->fh, sizeof(struct nfs_fh));
 	mutex_init(&file->f_mutex);
 	INIT_HLIST_NODE(&file->f_list);
 	INIT_LIST_HEAD(&file->f_blocks);
@@ -117,7 +117,8 @@ nlm_lookup_file(struct svc_rqst *rqstp, struct nlm_file **result,
 	 * We have to make sure we have the right credential to open
 	 * the file.
 	 */
-	if ((nfserr = nlmsvc_ops->fopen(rqstp, f, &file->f_file)) != 0) {
+	nfserr = nlmsvc_ops->fopen(rqstp, &lock->fh, &file->f_file);
+	if (nfserr) {
 		dprintk("lockd: open failed (error %d)\n", nfserr);
 		goto out_free;
 	}
diff --git a/include/linux/lockd/lockd.h b/include/linux/lockd/lockd.h
index 666f5f310a041..81b71ad2040ac 100644
--- a/include/linux/lockd/lockd.h
+++ b/include/linux/lockd/lockd.h
@@ -286,7 +286,7 @@ void		  nlmsvc_locks_init_private(struct file_lock *, struct nlm_host *, pid_t);
  * File handling for the server personality
  */
 __be32		  nlm_lookup_file(struct svc_rqst *, struct nlm_file **,
-					struct nfs_fh *);
+					struct nlm_lock *);
 void		  nlm_release_file(struct nlm_file *);
 void		  nlmsvc_release_lockowner(struct nlm_lock *);
 void		  nlmsvc_mark_resources(struct net *);
-- 
2.43.0



