Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C84BA524AF;
	Mon,  8 Apr 2024 13:50:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712584250; cv=none; b=GtopJlnP3tovRBts26f1btq3tmHoO5je4Z4y/28TE0DXRcermqYX8ONmSzKXV9AcxFyyI9UMNk7ULGRaml+G10n935FKKzFhvmPouX7v8hm1+3ifos+tNT3IQqv+BSyEJ24Lvf5tRaF2yEEdZ0A7OpuRAGZtkgLynqXKEeuZ/Hc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712584250; c=relaxed/simple;
	bh=F/S134mlTelEij5hVokpgZboRHG7RHqNpI1kvcDA9uo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mQoAp98SILx56UXcFZWZqKtkfVwM7ARZsLIE5X1fkTudVRd+vzq6Q/WPz5yzlKVG+0Ca3L972gr3tP/vxEIcN87gy2dPqx3Zn0Ubd2JK7FDMCIxJ6MuZhE6EARFKivvNfnQy/unJbjVwtd9WEOVbhyP8l/ogJfe5bUnixjM4y3k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hmScQRwM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hmScQRwM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51CD2C433F1;
	Mon,  8 Apr 2024 13:50:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712584250;
	bh=F/S134mlTelEij5hVokpgZboRHG7RHqNpI1kvcDA9uo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hmScQRwMrlPpzRUYST0lPmk1W+ZDXtJyCumvICkXBtk6B3KJJUgLrwVyVWVtqs+oq
	 3XsC/lu4Z8Ii9RKfVuBzWZHMqqESafstxPU+lmGHWYTPFHkISDzcUPWzG0DAa6iZNU
	 s8A7NQzmWuc0pJ5hnylAD4CEvx/8YMUUTziD86gw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.15 373/690] NFSD: Move nfsd_file_trace_alloc() tracepoint
Date: Mon,  8 Apr 2024 14:53:59 +0200
Message-ID: <20240408125413.071953467@linuxfoundation.org>
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

[ Upstream commit b40a2839470cd62ed68c4a32d72a18ee8975b1ac ]

Avoid recording the allocation of an nfsd_file item that is
immediately released because a matching item was already
inserted in the hash.

Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
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
index 12dbc190e6595..c824ab30a758e 100644
--- a/fs/nfsd/trace.h
+++ b/fs/nfsd/trace.h
@@ -773,12 +773,35 @@ DEFINE_EVENT(nfsd_file_class, name, \
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



