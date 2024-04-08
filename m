Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A83F7F476;
	Mon,  8 Apr 2024 13:58:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712584688; cv=none; b=AOa/9XFSEJAYJ71BGbdDCVsJaUsm4h3gbesmAqMp3VafgfwIxtg7W/k5NeomGfIcN4pXcMpya2paiv3DxJrhS5Dd5bLh6hUSRwagdn5KAFrin63W4VEz7S+3nGrOJr/V9f90V3FLfTr57unNrw+c8PaZah8EmvcBonyou1MKvSo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712584688; c=relaxed/simple;
	bh=M4p5WvXtI6HFqiPSjEtefB1E6xHoTdC7jXReqjklr84=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HiZO0H1cdA5J+R6UKfNWt9Co9psLGx1bdrxluidKp/CGStNXghsK1l1RQ0AvGdKSxR86wUuOjwe5rt5kx5hTCTd8AwlY0Ztl0KZm835Lc19foEu6N0VZIfaAqFQQ4pTfF+YOFaP9evsHr58zLsS07MhWc++hSZSlRLlXMcmosLI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ElHHpXXL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ElHHpXXL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02B73C433C7;
	Mon,  8 Apr 2024 13:58:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712584688;
	bh=M4p5WvXtI6HFqiPSjEtefB1E6xHoTdC7jXReqjklr84=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ElHHpXXLkJGpwbikbCJ+it054rls+4MSnP2wHbiV+WOAxnRshtaHKl+cIa0wNN71F
	 0L8wCwLYbKTBvWxNwhsYdfp4ipxsgejpcJNQ70T6JfpRLc1hWsc0Qp/aP+sEKPEFYJ
	 Fna2pGexYx3ftYJpvNqqTzUcHEme5ClgGHA7ah5Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	Pierguido Lambri <plambri@redhat.com>
Subject: [PATCH 5.15 524/690] nfsd: dont fsync nfsd_files on last close
Date: Mon,  8 Apr 2024 14:56:30 +0200
Message-ID: <20240408125418.623953902@linuxfoundation.org>
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

[ Upstream commit 4c475eee02375ade6e864f1db16976ba0d96a0a2 ]

Most of the time, NFSv4 clients issue a COMMIT before the final CLOSE of
an open stateid, so with NFSv4, the fsync in the nfsd_file_free path is
usually a no-op and doesn't block.

We have a customer running knfsd over very slow storage (XFS over Ceph
RBD). They were using the "async" export option because performance was
more important than data integrity for this application. That export
option turns NFSv4 COMMIT calls into no-ops. Due to the fsync in this
codepath however, their final CLOSE calls would still stall (since a
CLOSE effectively became a COMMIT).

I think this fsync is not strictly necessary. We only use that result to
reset the write verifier. Instead of fsync'ing all of the data when we
free an nfsd_file, we can just check for writeback errors when one is
acquired and when it is freed.

If the client never comes back, then it'll never see the error anyway
and there is no point in resetting it. If an error occurs after the
nfsd_file is removed from the cache but before the inode is evicted,
then it will reset the write verifier on the next nfsd_file_acquire,
(since there will be an unseen error).

The only exception here is if something else opens and fsyncs the file
during that window. Given that local applications work with this
limitation today, I don't see that as an issue.

Link: https://bugzilla.redhat.com/show_bug.cgi?id=2166658
Fixes: ac3a2585f018 ("nfsd: rework refcounting in filecache")
Reported-and-tested-by: Pierguido Lambri <plambri@redhat.com>
Signed-off-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 fs/nfsd/filecache.c | 44 ++++++++++++--------------------------------
 fs/nfsd/trace.h     | 31 -------------------------------
 2 files changed, 12 insertions(+), 63 deletions(-)

diff --git a/fs/nfsd/filecache.c b/fs/nfsd/filecache.c
index 206742bbbd682..4a3796c6bd957 100644
--- a/fs/nfsd/filecache.c
+++ b/fs/nfsd/filecache.c
@@ -330,37 +330,27 @@ nfsd_file_alloc(struct nfsd_file_lookup_key *key, unsigned int may)
 	return nf;
 }
 
+/**
+ * nfsd_file_check_write_error - check for writeback errors on a file
+ * @nf: nfsd_file to check for writeback errors
+ *
+ * Check whether a nfsd_file has an unseen error. Reset the write
+ * verifier if so.
+ */
 static void
-nfsd_file_fsync(struct nfsd_file *nf)
-{
-	struct file *file = nf->nf_file;
-	int ret;
-
-	if (!file || !(file->f_mode & FMODE_WRITE))
-		return;
-	ret = vfs_fsync(file, 1);
-	trace_nfsd_file_fsync(nf, ret);
-	if (ret)
-		nfsd_reset_write_verifier(net_generic(nf->nf_net, nfsd_net_id));
-}
-
-static int
 nfsd_file_check_write_error(struct nfsd_file *nf)
 {
 	struct file *file = nf->nf_file;
 
-	if (!file || !(file->f_mode & FMODE_WRITE))
-		return 0;
-	return filemap_check_wb_err(file->f_mapping, READ_ONCE(file->f_wb_err));
+	if ((file->f_mode & FMODE_WRITE) &&
+	    filemap_check_wb_err(file->f_mapping, READ_ONCE(file->f_wb_err)))
+		nfsd_reset_write_verifier(net_generic(nf->nf_net, nfsd_net_id));
 }
 
 static void
 nfsd_file_hash_remove(struct nfsd_file *nf)
 {
 	trace_nfsd_file_unhash(nf);
-
-	if (nfsd_file_check_write_error(nf))
-		nfsd_reset_write_verifier(net_generic(nf->nf_net, nfsd_net_id));
 	rhashtable_remove_fast(&nfsd_file_rhash_tbl, &nf->nf_rhash,
 			       nfsd_file_rhash_params);
 }
@@ -386,23 +376,12 @@ nfsd_file_free(struct nfsd_file *nf)
 	this_cpu_add(nfsd_file_total_age, age);
 
 	nfsd_file_unhash(nf);
-
-	/*
-	 * We call fsync here in order to catch writeback errors. It's not
-	 * strictly required by the protocol, but an nfsd_file could get
-	 * evicted from the cache before a COMMIT comes in. If another
-	 * task were to open that file in the interim and scrape the error,
-	 * then the client may never see it. By calling fsync here, we ensure
-	 * that writeback happens before the entry is freed, and that any
-	 * errors reported result in the write verifier changing.
-	 */
-	nfsd_file_fsync(nf);
-
 	if (nf->nf_mark)
 		nfsd_file_mark_put(nf->nf_mark);
 	if (nf->nf_file) {
 		get_file(nf->nf_file);
 		filp_close(nf->nf_file, NULL);
+		nfsd_file_check_write_error(nf);
 		fput(nf->nf_file);
 	}
 
@@ -1157,6 +1136,7 @@ nfsd_file_do_acquire(struct svc_rqst *rqstp, struct svc_fh *fhp,
 out:
 	if (status == nfs_ok) {
 		this_cpu_inc(nfsd_file_acquisitions);
+		nfsd_file_check_write_error(nf);
 		*pnf = nf;
 	} else {
 		if (refcount_dec_and_test(&nf->nf_ref))
diff --git a/fs/nfsd/trace.h b/fs/nfsd/trace.h
index 5fb7e153ca865..276420ea3b8d9 100644
--- a/fs/nfsd/trace.h
+++ b/fs/nfsd/trace.h
@@ -1201,37 +1201,6 @@ TRACE_EVENT(nfsd_file_close,
 	)
 );
 
-TRACE_EVENT(nfsd_file_fsync,
-	TP_PROTO(
-		const struct nfsd_file *nf,
-		int ret
-	),
-	TP_ARGS(nf, ret),
-	TP_STRUCT__entry(
-		__field(void *, nf_inode)
-		__field(int, nf_ref)
-		__field(int, ret)
-		__field(unsigned long, nf_flags)
-		__field(unsigned char, nf_may)
-		__field(struct file *, nf_file)
-	),
-	TP_fast_assign(
-		__entry->nf_inode = nf->nf_inode;
-		__entry->nf_ref = refcount_read(&nf->nf_ref);
-		__entry->ret = ret;
-		__entry->nf_flags = nf->nf_flags;
-		__entry->nf_may = nf->nf_may;
-		__entry->nf_file = nf->nf_file;
-	),
-	TP_printk("inode=%p ref=%d flags=%s may=%s nf_file=%p ret=%d",
-		__entry->nf_inode,
-		__entry->nf_ref,
-		show_nf_flags(__entry->nf_flags),
-		show_nfsd_may_flags(__entry->nf_may),
-		__entry->nf_file, __entry->ret
-	)
-);
-
 #include "cache.h"
 
 TRACE_DEFINE_ENUM(RC_DROPIT);
-- 
2.43.0



