Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3CFB8005E;
	Mon,  8 Apr 2024 13:47:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712584046; cv=none; b=dFVWLnlMkRyQI4zLb6MUfWoqM/VhxwSHRTWG02uA8rEISsgAMZKmu6mh6gspjinx+r2tPa/X5+C3Kpmhm+yhzAscNhUXonr/Fzmo0ThLV9sZWHQMG8lBOOsuaGVHSjYx9kvN0pD8Gl6TPyxWm4gedEC6ELQEeoc8mwfGIvkJ03I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712584046; c=relaxed/simple;
	bh=iyp3iTt+I6Fj8jsaygGKcPb9yWy1TN2YNRG5vTqTfsk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rfupoxqNxT8j3TZLSqioyaEUV34NmSANsTdnL5FEwo1P3n0JM6Tz4g/cKpZJqDYTuLspoiUM13KOf0y0zQraOf6FvS+3dcjWQAsexFzMLpsi8RrTUVGGRQ7B8d299gWGF3+Puew65is7Is23QwR6p59deMS7Ch68upFT4PovQK8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1LvR5B0Q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1LvR5B0Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35BE5C433C7;
	Mon,  8 Apr 2024 13:47:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712584045;
	bh=iyp3iTt+I6Fj8jsaygGKcPb9yWy1TN2YNRG5vTqTfsk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1LvR5B0QDyY/w0K4oR+cATacrlt8Ymiy+Pl4g3YAGtsRkgGXsp/SfyNJiTpZ1ZiUn
	 Vj1zBj9dfVJXyGE/tSa0e1asjAoDrSfXTrh4QLljyF2P2+R2/56M2VYYW5N9SmAZ/H
	 JtYd/oYuX8IiIghsymLjY0T9AyED/RS+R2vzeZC4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.15 325/690] NFSD: Trace filecache opens
Date: Mon,  8 Apr 2024 14:53:11 +0200
Message-ID: <20240408125411.385301641@linuxfoundation.org>
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

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit 0122e882119ddbd9efa6edfeeac3f5c704a7aeea ]

Instrument calls to nfsd_open_verified() to get a sense of the
filecache hit rate.

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 fs/nfsd/filecache.c |  5 +++--
 fs/nfsd/trace.h     | 28 ++++++++++++++++++++++++++++
 2 files changed, 31 insertions(+), 2 deletions(-)

diff --git a/fs/nfsd/filecache.c b/fs/nfsd/filecache.c
index 045f5a869ddc7..0863bf5050935 100644
--- a/fs/nfsd/filecache.c
+++ b/fs/nfsd/filecache.c
@@ -976,10 +976,11 @@ nfsd_do_file_acquire(struct svc_rqst *rqstp, struct svc_fh *fhp,
 
 	nf->nf_mark = nfsd_file_mark_find_or_create(nf);
 	if (nf->nf_mark) {
-		if (open)
+		if (open) {
 			status = nfsd_open_verified(rqstp, fhp, may_flags,
 						    &nf->nf_file);
-		else
+			trace_nfsd_file_open(nf, status);
+		} else
 			status = nfs_ok;
 	} else
 		status = nfserr_jukebox;
diff --git a/fs/nfsd/trace.h b/fs/nfsd/trace.h
index 7f3f40f6c0ff3..3cff3ada00a85 100644
--- a/fs/nfsd/trace.h
+++ b/fs/nfsd/trace.h
@@ -775,6 +775,34 @@ TRACE_EVENT(nfsd_file_acquire,
 			__entry->nf_file, __entry->status)
 );
 
+TRACE_EVENT(nfsd_file_open,
+	TP_PROTO(struct nfsd_file *nf, __be32 status),
+	TP_ARGS(nf, status),
+	TP_STRUCT__entry(
+		__field(unsigned int, nf_hashval)
+		__field(void *, nf_inode)	/* cannot be dereferenced */
+		__field(int, nf_ref)
+		__field(unsigned long, nf_flags)
+		__field(unsigned long, nf_may)
+		__field(void *, nf_file)	/* cannot be dereferenced */
+	),
+	TP_fast_assign(
+		__entry->nf_hashval = nf->nf_hashval;
+		__entry->nf_inode = nf->nf_inode;
+		__entry->nf_ref = refcount_read(&nf->nf_ref);
+		__entry->nf_flags = nf->nf_flags;
+		__entry->nf_may = nf->nf_may;
+		__entry->nf_file = nf->nf_file;
+	),
+	TP_printk("hash=0x%x inode=%p ref=%d flags=%s may=%s file=%p",
+		__entry->nf_hashval,
+		__entry->nf_inode,
+		__entry->nf_ref,
+		show_nf_flags(__entry->nf_flags),
+		show_nfsd_may_flags(__entry->nf_may),
+		__entry->nf_file)
+)
+
 DECLARE_EVENT_CLASS(nfsd_file_search_class,
 	TP_PROTO(struct inode *inode, unsigned int hash, int found),
 	TP_ARGS(inode, hash, found),
-- 
2.43.0



