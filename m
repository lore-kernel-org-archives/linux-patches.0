Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A53915A848;
	Tue, 18 Jun 2024 13:18:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718716712; cv=none; b=OF7l8PcIzpINZJfI9vcz18OfGBSD50tESC3jEfPx0XVLPKJ3TfsD9GgQTLmOYY2mmIUsj2O0E8MFI08xMXt0TLmwQxRiUXF5rMTAXZdriYEiWcHm3K/DM0HSVs8Tw5z5KkCF5Vwwezx3TovGUIGGMqN3aexXDX8n95pg2BXyiN4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718716712; c=relaxed/simple;
	bh=Oh5Vc0B6Sw+VkZQiZtBBYWEh+MLchgzObp8X/jIo7j4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XXv290CifVCO5yCwa2ehGLUstu1HI+DAbwA9bLcLzB7fduRygl/Q0bLbIGZFdWyPC0KQL0/2uPzgqQ1vKHW7SL8+geg7F75RjbghWohNZ5qR/qWRpBrKZ6pBK0ladjB7ZwoBfpJcuZCVMuXpkH56oBbt+iNDYcxG8+O1oy9e2h0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZQmRuPPZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZQmRuPPZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98558C3277B;
	Tue, 18 Jun 2024 13:18:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718716712;
	bh=Oh5Vc0B6Sw+VkZQiZtBBYWEh+MLchgzObp8X/jIo7j4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZQmRuPPZ4Z9Yfb09WoeF60iKN38E5S48U2mXDqLLQ7zOf25uEmzDb+PshAzJienXl
	 x0wZzWqIJ9R3W6rHta9BLthPmVBEZgF7P8NbefZm30ICGfP41M7Ii/Khnbpdvvlz0L
	 F8IEICB3ie/ZwpXoPl7uZM9z43N5/V2fumPxio5c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>,
	Pierguido Lambri <plambri@redhat.com>
Subject: [PATCH 5.10 737/770] nfsd: dont fsync nfsd_files on last close
Date: Tue, 18 Jun 2024 14:39:50 +0200
Message-ID: <20240618123435.715093261@linuxfoundation.org>
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
Signed-off-by: Sasha Levin <sashal@kernel.org>
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
index 0f674982785ce..445d00f00eab7 100644
--- a/fs/nfsd/trace.h
+++ b/fs/nfsd/trace.h
@@ -1112,37 +1112,6 @@ TRACE_EVENT(nfsd_file_close,
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



