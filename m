Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5E8213C673;
	Tue, 18 Jun 2024 13:08:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718716085; cv=none; b=deQEiqYVa6TEb5MJJa2BBrg+bnpagKoavp/RSGA/7LxXW3CMKNjITK/q1r7arPypvFNL4VaVGsWOeWgLGg2hlEhJPJj8/pARawa2CH1lkLnWDfBUcDs6pXsev9FJEs2hOAji3mXp5EXRkkeGPfG5VhgeMO/FvpygE8w423Xc1Pw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718716085; c=relaxed/simple;
	bh=AdsyE3U0w2MyA5WwQ+gHcu4bDEIq5Pp4o2MfpWhPuuc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aRyCBQqLzAnuKyWi0hSrJNHT2vwPNd4L2u2ew313iK+BVWqO0pql5KYBKo/T5EWrmkUZo0uRXrB2o+K9P6vZdlQ/67nDO1Xu/Qbt45UjXU2EiBr1V76LIClyTmbakt1bDBfwu5Cb/EU63aJcR6Rrlqqx5vK+3MTDYTNz+42nQ4s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YY9pBDEN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YY9pBDEN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E61E3C3277B;
	Tue, 18 Jun 2024 13:08:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718716085;
	bh=AdsyE3U0w2MyA5WwQ+gHcu4bDEIq5Pp4o2MfpWhPuuc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YY9pBDENOwliFKZ7dqMHupHby3GjgcMhlg6HJBNTjzZPurYbXkLWuBnmFFvkCJ+gK
	 h74G85atE5wT5ztY9E0ESV6jFxh3wDSn8t+8Xkj6cgw0sDMU63hG7/a7pzlcz/H1wH
	 BKr/TO6MH3wO1Ogf9E6Vp2SwpToJNNnRcUzXbgBU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 528/770] NFSD: Trace filecache opens
Date: Tue, 18 Jun 2024 14:36:21 +0200
Message-ID: <20240618123427.695453023@linuxfoundation.org>
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

[ Upstream commit 0122e882119ddbd9efa6edfeeac3f5c704a7aeea ]

Instrument calls to nfsd_open_verified() to get a sense of the
filecache hit rate.

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/filecache.c |  5 +++--
 fs/nfsd/trace.h     | 28 ++++++++++++++++++++++++++++
 2 files changed, 31 insertions(+), 2 deletions(-)

diff --git a/fs/nfsd/filecache.c b/fs/nfsd/filecache.c
index db9c68a3c1f3b..bdb5de8c08036 100644
--- a/fs/nfsd/filecache.c
+++ b/fs/nfsd/filecache.c
@@ -996,10 +996,11 @@ nfsd_do_file_acquire(struct svc_rqst *rqstp, struct svc_fh *fhp,
 
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
index 8327d1601d710..c4c073e85fdd9 100644
--- a/fs/nfsd/trace.h
+++ b/fs/nfsd/trace.h
@@ -795,6 +795,34 @@ TRACE_EVENT(nfsd_file_acquire,
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



