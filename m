Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B223515443A;
	Tue, 18 Jun 2024 12:55:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718715304; cv=none; b=jOS+Nn1gnZYx38ZFtzeliPC1L1ZotJvsfvELuP6cRwIl96V/pIf32B3vNbSGNdlLG60S6jI5Fs5SGnsCqGLRdfy3kpCmU/ScLDwpOAK2b7fFW32v7JzKVSv4UBs5wcza0WZJv88rOJC6vnEsJRvbsE+nZEbfesaoQ/nW0I8gkpg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718715304; c=relaxed/simple;
	bh=grn7qitW0pA56JtymqWsHOsVlgMS2Sh0fsh3PqXFJCM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T5VjfgOfzV7+GWWRQYSRpBNH7n2feySJUUFDF5P6qy5mUQD00+c1QgFnphMM4WZBFMZHphEffVlT5mfLVTf2u6aBAaBF9arEFhXQtETrcL9a6Qacj/+3Vfoo2JCbUWgyGGNAX0I4bxiu1zRhrbOy33JMFGNUxN2r5wq5Mvk55/M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vQQ1pxey; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vQQ1pxey"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3602EC3277B;
	Tue, 18 Jun 2024 12:55:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718715304;
	bh=grn7qitW0pA56JtymqWsHOsVlgMS2Sh0fsh3PqXFJCM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vQQ1pxeybgKs2el19Z94smCru4+9ag73Fb2Z1gg/7MiYhDlCA/olPeea11m6pYj+C
	 01f3bu/vHYnScNsP7Zjn7CSXh26jwFI03By53e2pO56GBDJkLItl2oPlPBeQhX4yUW
	 9hr5w314bITt8pr7+6jthEko7xCitH52O5sjEha8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"J. Bruce Fields" <bfields@redhat.com>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 263/770] nfsd: grant read delegations to clients holding writes
Date: Tue, 18 Jun 2024 14:31:56 +0200
Message-ID: <20240618123417.425140515@linuxfoundation.org>
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

[ Upstream commit aba2072f452346d56a462718bcde93d697383148 ]

It's OK to grant a read delegation to a client that holds a write,
as long as it's the only client holding the write.

We originally tried to do this in commit 94415b06eb8a ("nfsd4: a
client's own opens needn't prevent delegations"), which had to be
reverted in commit 6ee65a773096 ("Revert "nfsd4: a client's own
opens needn't prevent delegations"").

Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/locks.c          |  3 ++
 fs/nfsd/nfs4state.c | 82 +++++++++++++++++++++++++++++++++++++--------
 2 files changed, 71 insertions(+), 14 deletions(-)

diff --git a/fs/locks.c b/fs/locks.c
index 873f97504bddf..101867933e4d3 100644
--- a/fs/locks.c
+++ b/fs/locks.c
@@ -1808,6 +1808,9 @@ check_conflicting_open(struct file *filp, const long arg, int flags)
 
 	if (flags & FL_LAYOUT)
 		return 0;
+	if (flags & FL_DELEG)
+		/* We leave these checks to the caller */
+		return 0;
 
 	if (arg == F_RDLCK)
 		return inode_is_open_for_write(inode) ? -EAGAIN : 0;
diff --git a/fs/nfsd/nfs4state.c b/fs/nfsd/nfs4state.c
index 9c8dacf0f2b86..fd0d6e81a2272 100644
--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -5030,6 +5030,65 @@ static struct file_lock *nfs4_alloc_init_lease(struct nfs4_delegation *dp,
 	return fl;
 }
 
+static int nfsd4_check_conflicting_opens(struct nfs4_client *clp,
+					 struct nfs4_file *fp)
+{
+	struct nfs4_ol_stateid *st;
+	struct file *f = fp->fi_deleg_file->nf_file;
+	struct inode *ino = locks_inode(f);
+	int writes;
+
+	writes = atomic_read(&ino->i_writecount);
+	if (!writes)
+		return 0;
+	/*
+	 * There could be multiple filehandles (hence multiple
+	 * nfs4_files) referencing this file, but that's not too
+	 * common; let's just give up in that case rather than
+	 * trying to go look up all the clients using that other
+	 * nfs4_file as well:
+	 */
+	if (fp->fi_aliased)
+		return -EAGAIN;
+	/*
+	 * If there's a close in progress, make sure that we see it
+	 * clear any fi_fds[] entries before we see it decrement
+	 * i_writecount:
+	 */
+	smp_mb__after_atomic();
+
+	if (fp->fi_fds[O_WRONLY])
+		writes--;
+	if (fp->fi_fds[O_RDWR])
+		writes--;
+	if (writes > 0)
+		return -EAGAIN; /* There may be non-NFSv4 writers */
+	/*
+	 * It's possible there are non-NFSv4 write opens in progress,
+	 * but if they haven't incremented i_writecount yet then they
+	 * also haven't called break lease yet; so, they'll break this
+	 * lease soon enough.  So, all that's left to check for is NFSv4
+	 * opens:
+	 */
+	spin_lock(&fp->fi_lock);
+	list_for_each_entry(st, &fp->fi_stateids, st_perfile) {
+		if (st->st_openstp == NULL /* it's an open */ &&
+		    access_permit_write(st) &&
+		    st->st_stid.sc_client != clp) {
+			spin_unlock(&fp->fi_lock);
+			return -EAGAIN;
+		}
+	}
+	spin_unlock(&fp->fi_lock);
+	/*
+	 * There's a small chance that we could be racing with another
+	 * NFSv4 open.  However, any open that hasn't added itself to
+	 * the fi_stateids list also hasn't called break_lease yet; so,
+	 * they'll break this lease soon enough.
+	 */
+	return 0;
+}
+
 static struct nfs4_delegation *
 nfs4_set_delegation(struct nfs4_client *clp, struct svc_fh *fh,
 		    struct nfs4_file *fp, struct nfs4_clnt_odstate *odstate)
@@ -5049,9 +5108,12 @@ nfs4_set_delegation(struct nfs4_client *clp, struct svc_fh *fh,
 
 	nf = find_readable_file(fp);
 	if (!nf) {
-		/* We should always have a readable file here */
-		WARN_ON_ONCE(1);
-		return ERR_PTR(-EBADF);
+		/*
+		 * We probably could attempt another open and get a read
+		 * delegation, but for now, don't bother until the
+		 * client actually sends us one.
+		 */
+		return ERR_PTR(-EAGAIN);
 	}
 	spin_lock(&state_lock);
 	spin_lock(&fp->fi_lock);
@@ -5086,6 +5148,9 @@ nfs4_set_delegation(struct nfs4_client *clp, struct svc_fh *fh,
 		locks_free_lock(fl);
 	if (status)
 		goto out_clnt_odstate;
+	status = nfsd4_check_conflicting_opens(clp, fp);
+	if (status)
+		goto out_unlock;
 
 	spin_lock(&state_lock);
 	spin_lock(&fp->fi_lock);
@@ -5167,17 +5232,6 @@ nfs4_open_delegation(struct svc_fh *fh, struct nfsd4_open *open,
 				goto out_no_deleg;
 			if (!cb_up || !(oo->oo_flags & NFS4_OO_CONFIRMED))
 				goto out_no_deleg;
-			/*
-			 * Also, if the file was opened for write or
-			 * create, there's a good chance the client's
-			 * about to write to it, resulting in an
-			 * immediate recall (since we don't support
-			 * write delegations):
-			 */
-			if (open->op_share_access & NFS4_SHARE_ACCESS_WRITE)
-				goto out_no_deleg;
-			if (open->op_create == NFS4_OPEN_CREATE)
-				goto out_no_deleg;
 			break;
 		default:
 			goto out_no_deleg;
-- 
2.43.0



