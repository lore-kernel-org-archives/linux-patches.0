Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F109573461;
	Tue, 18 Jun 2024 13:11:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718716300; cv=none; b=cOPFnG2qaRun/BN/R6mLpF0Jf4ijGMQN27XjYibID9IZBqjJfuDzBWXWBxnO43bMDLzt3s6LDuHvJDnfznBNfdzKjWPClcB34Nc8Tdvp2fTAlFmnjzWb9dRZJY6B23nnFCFTeACBKv3cVD3DIAH5v5y+Yx+YLzV+t2iBvDLcLAI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718716300; c=relaxed/simple;
	bh=zDK4hU7uVFO0IWu6qFwYoKREuPe/oZOHhSfbcu9cIe8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T5WWLesqFYRAEu7ifLYZWnCxQL8a/cQ9wCyJ2yWFGB+0R1pvWXuFvo2qPJC1Dn+BVFEGbuxSk/6XLPvAs95g3taebwHFCXgL1GvKg5KHmOHBlkAY53hlVjXjw/tdOr9Sy4pLlZ2cCWr4sSuCG0a53E/yXPBQgBD1GhlSi1RT5ec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=m9oPLurO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m9oPLurO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 211E7C3277B;
	Tue, 18 Jun 2024 13:11:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718716299;
	bh=zDK4hU7uVFO0IWu6qFwYoKREuPe/oZOHhSfbcu9cIe8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m9oPLurOlIRpwWPWRNhVpKx1Vif4aXmemGn3mspoarHRzoH2N0M1/Uv+OR8vSuSCx
	 6Y2fpPhumKe/AcPKavPXrMpq0AkSKg1Omy9rCEldDtx+w933at7JJupDHzgEeDZxAt
	 v+6DRI2fpXUE4zT2jhjF8Ck5EyDeX159jXnXVW/k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 582/770] NFSD: Move nfsd_file_trace_alloc() tracepoint
Date: Tue, 18 Jun 2024 14:37:15 +0200
Message-ID: <20240618123429.758813015@linuxfoundation.org>
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

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit b40a2839470cd62ed68c4a32d72a18ee8975b1ac ]

Avoid recording the allocation of an nfsd_file item that is
immediately released because a matching item was already
inserted in the hash.

Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/filecache.c |  2 +-
 fs/nfsd/trace.h     | 25 ++++++++++++++++++++++++-
 2 files changed, 25 insertions(+), 2 deletions(-)

diff --git a/fs/nfsd/filecache.c b/fs/nfsd/filecache.c
index 85813affb8abf..26cfae138b906 100644
--- a/fs/nfsd/filecache.c
+++ b/fs/nfsd/filecache.c
@@ -302,7 +302,6 @@ nfsd_file_alloc(struct nfsd_file_lookup_key *key, unsigned int may)
 		refcount_set(&nf->nf_ref, 2);
 		nf->nf_may = key->need;
 		nf->nf_mark = NULL;
-		trace_nfsd_file_alloc(nf);
 	}
 	return nf;
 }
@@ -1125,6 +1124,7 @@ nfsd_file_do_acquire(struct svc_rqst *rqstp, struct svc_fh *fhp,
 	return status;
 
 open_file:
+	trace_nfsd_file_alloc(nf);
 	nf->nf_mark = nfsd_file_mark_find_or_create(nf);
 	if (nf->nf_mark) {
 		if (open) {
diff --git a/fs/nfsd/trace.h b/fs/nfsd/trace.h
index ce391ba2f1ca5..22c1fb735f1a7 100644
--- a/fs/nfsd/trace.h
+++ b/fs/nfsd/trace.h
@@ -739,12 +739,35 @@ DEFINE_EVENT(nfsd_file_class, name, \
 	TP_PROTO(struct nfsd_file *nf), \
 	TP_ARGS(nf))
 
-DEFINE_NFSD_FILE_EVENT(nfsd_file_alloc);
 DEFINE_NFSD_FILE_EVENT(nfsd_file_put_final);
 DEFINE_NFSD_FILE_EVENT(nfsd_file_unhash);
 DEFINE_NFSD_FILE_EVENT(nfsd_file_put);
 DEFINE_NFSD_FILE_EVENT(nfsd_file_unhash_and_dispose);
 
+TRACE_EVENT(nfsd_file_alloc,
+	TP_PROTO(
+		const struct nfsd_file *nf
+	),
+	TP_ARGS(nf),
+	TP_STRUCT__entry(
+		__field(const void *, nf_inode)
+		__field(unsigned long, nf_flags)
+		__field(unsigned long, nf_may)
+		__field(unsigned int, nf_ref)
+	),
+	TP_fast_assign(
+		__entry->nf_inode = nf->nf_inode;
+		__entry->nf_flags = nf->nf_flags;
+		__entry->nf_ref = refcount_read(&nf->nf_ref);
+		__entry->nf_may = nf->nf_may;
+	),
+	TP_printk("inode=%p ref=%u flags=%s may=%s",
+		__entry->nf_inode, __entry->nf_ref,
+		show_nf_flags(__entry->nf_flags),
+		show_nfsd_may_flags(__entry->nf_may)
+	)
+);
+
 TRACE_EVENT(nfsd_file_acquire,
 	TP_PROTO(
 		const struct svc_rqst *rqstp,
-- 
2.43.0



