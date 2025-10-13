Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0975E3093D3;
	Mon, 13 Oct 2025 15:43:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760370234; cv=none; b=JL3EF/r3iXHJbjs33L5GqQofAhXuJX3sPQAlPON3L03LGhqLzqYsiln5DyBd9lsXN//MMGn8M1nA7sVGN2rUeRsxsYijFl9A1nbTDQoc4JcRcXoRIvebOOGuRngeJqHHxh6LjEwJFkXHOkrhZkUpzx6Aco+0wpDCQ2D7LSixoAU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760370234; c=relaxed/simple;
	bh=CIjVEFpzfLa5TECtBq1d4ZitCExNuos+rOOXM2553Wg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A1sHDRMQYQqqb5sANdIVpiYW9uPnpaYFPTrp6/56q6GWbd87OhB9KRgDnQN+IOqQANSvR0wc2npEJOUatI/OsD+B4AM9Mk1RLSsfiYrFkQvYxfods/6i/S0MRXdFL7ZqunI8u3D+mcDDxDMc7mVhZrfloflzOPmWIhkpGyJt1IU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OUeZP8E7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OUeZP8E7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87B6CC116C6;
	Mon, 13 Oct 2025 15:43:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760370233;
	bh=CIjVEFpzfLa5TECtBq1d4ZitCExNuos+rOOXM2553Wg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OUeZP8E7Y0bvhYShseNRuV88gQN9+n1wpDWfy95/Dkl0i5E0KWlM79kU4J2ZvaVbE
	 1w0MGD0+uBPGat/uFbzkImD52USdUEna2iwTwCWOV+lIVTyxUqeLPYwHC0SL+dMvbr
	 G41FZllyR+ioi/qKXQ7QSc0SngPYuhbrgyFddESA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mike Snitzer <snitzer@kernel.org>,
	Jeff Layton <jlayton@kernel.org>,
	NeilBrown <neil@brown.name>,
	Chuck Lever <chuck.lever@oracle.com>,
	Anna Schumaker <anna.schumaker@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 483/563] NFSD: filecache: add STATX_DIOALIGN and STATX_DIO_READ_ALIGN support
Date: Mon, 13 Oct 2025 16:45:44 +0200
Message-ID: <20251013144428.789490550@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mike Snitzer <snitzer@kernel.org>

[ Upstream commit d11f6cd1bb4a416b4515702d020a7480ac667f0f ]

Use STATX_DIOALIGN and STATX_DIO_READ_ALIGN to get DIO alignment
attributes from the underlying filesystem and store them in the
associated nfsd_file. This is done when the nfsd_file is first
opened for each regular file.

Signed-off-by: Mike Snitzer <snitzer@kernel.org>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Reviewed-by: NeilBrown <neil@brown.name>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Acked-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Anna Schumaker <anna.schumaker@oracle.com>
Stable-dep-of: 25ba2b84c38f ("nfs/localio: avoid issuing misaligned IO using O_DIRECT")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/filecache.c     | 34 ++++++++++++++++++++++++++++++++++
 fs/nfsd/filecache.h     |  4 ++++
 fs/nfsd/trace.h         | 27 +++++++++++++++++++++++++++
 fs/nfsd/vfs.h           |  4 ++++
 include/trace/misc/fs.h | 22 ++++++++++++++++++++++
 5 files changed, 91 insertions(+)

diff --git a/fs/nfsd/filecache.c b/fs/nfsd/filecache.c
index 732abf6b92a56..7ca1dedf4e04a 100644
--- a/fs/nfsd/filecache.c
+++ b/fs/nfsd/filecache.c
@@ -231,6 +231,9 @@ nfsd_file_alloc(struct net *net, struct inode *inode, unsigned char need,
 	refcount_set(&nf->nf_ref, 1);
 	nf->nf_may = need;
 	nf->nf_mark = NULL;
+	nf->nf_dio_mem_align = 0;
+	nf->nf_dio_offset_align = 0;
+	nf->nf_dio_read_offset_align = 0;
 	return nf;
 }
 
@@ -1069,6 +1072,35 @@ nfsd_file_is_cached(struct inode *inode)
 	return ret;
 }
 
+static __be32
+nfsd_file_get_dio_attrs(const struct svc_fh *fhp, struct nfsd_file *nf)
+{
+	struct inode *inode = file_inode(nf->nf_file);
+	struct kstat stat;
+	__be32 status;
+
+	/* Currently only need to get DIO alignment info for regular files */
+	if (!S_ISREG(inode->i_mode))
+		return nfs_ok;
+
+	status = fh_getattr(fhp, &stat);
+	if (status != nfs_ok)
+		return status;
+
+	trace_nfsd_file_get_dio_attrs(inode, &stat);
+
+	if (stat.result_mask & STATX_DIOALIGN) {
+		nf->nf_dio_mem_align = stat.dio_mem_align;
+		nf->nf_dio_offset_align = stat.dio_offset_align;
+	}
+	if (stat.result_mask & STATX_DIO_READ_ALIGN)
+		nf->nf_dio_read_offset_align = stat.dio_read_offset_align;
+	else
+		nf->nf_dio_read_offset_align = nf->nf_dio_offset_align;
+
+	return nfs_ok;
+}
+
 static __be32
 nfsd_file_do_acquire(struct svc_rqst *rqstp, struct net *net,
 		     struct svc_cred *cred,
@@ -1187,6 +1219,8 @@ nfsd_file_do_acquire(struct svc_rqst *rqstp, struct net *net,
 			}
 			status = nfserrno(ret);
 			trace_nfsd_file_open(nf, status);
+			if (status == nfs_ok)
+				status = nfsd_file_get_dio_attrs(fhp, nf);
 		}
 	} else
 		status = nfserr_jukebox;
diff --git a/fs/nfsd/filecache.h b/fs/nfsd/filecache.h
index 722b26c71e454..237a05c74211b 100644
--- a/fs/nfsd/filecache.h
+++ b/fs/nfsd/filecache.h
@@ -54,6 +54,10 @@ struct nfsd_file {
 	struct list_head	nf_gc;
 	struct rcu_head		nf_rcu;
 	ktime_t			nf_birthtime;
+
+	u32			nf_dio_mem_align;
+	u32			nf_dio_offset_align;
+	u32			nf_dio_read_offset_align;
 };
 
 int nfsd_file_cache_init(void);
diff --git a/fs/nfsd/trace.h b/fs/nfsd/trace.h
index a664fdf1161e9..6e2c8e2aab10a 100644
--- a/fs/nfsd/trace.h
+++ b/fs/nfsd/trace.h
@@ -1133,6 +1133,33 @@ TRACE_EVENT(nfsd_file_alloc,
 	)
 );
 
+TRACE_EVENT(nfsd_file_get_dio_attrs,
+	TP_PROTO(
+		const struct inode *inode,
+		const struct kstat *stat
+	),
+	TP_ARGS(inode, stat),
+	TP_STRUCT__entry(
+		__field(const void *, inode)
+		__field(unsigned long, mask)
+		__field(u32, mem_align)
+		__field(u32, offset_align)
+		__field(u32, read_offset_align)
+	),
+	TP_fast_assign(
+		__entry->inode = inode;
+		__entry->mask = stat->result_mask;
+		__entry->mem_align = stat->dio_mem_align;
+		__entry->offset_align = stat->dio_offset_align;
+		__entry->read_offset_align = stat->dio_read_offset_align;
+	),
+	TP_printk("inode=%p flags=%s mem_align=%u offset_align=%u read_offset_align=%u",
+		__entry->inode, show_statx_mask(__entry->mask),
+		__entry->mem_align, __entry->offset_align,
+		__entry->read_offset_align
+	)
+);
+
 TRACE_EVENT(nfsd_file_acquire,
 	TP_PROTO(
 		const struct svc_rqst *rqstp,
diff --git a/fs/nfsd/vfs.h b/fs/nfsd/vfs.h
index eff04959606fe..fde3e0c11dbaf 100644
--- a/fs/nfsd/vfs.h
+++ b/fs/nfsd/vfs.h
@@ -185,6 +185,10 @@ static inline __be32 fh_getattr(const struct svc_fh *fh, struct kstat *stat)
 	u32 request_mask = STATX_BASIC_STATS;
 	struct path p = {.mnt = fh->fh_export->ex_path.mnt,
 			 .dentry = fh->fh_dentry};
+	struct inode *inode = d_inode(p.dentry);
+
+	if (S_ISREG(inode->i_mode))
+		request_mask |= (STATX_DIOALIGN | STATX_DIO_READ_ALIGN);
 
 	if (fh->fh_maxsize == NFS4_FHSIZE)
 		request_mask |= (STATX_BTIME | STATX_CHANGE_COOKIE);
diff --git a/include/trace/misc/fs.h b/include/trace/misc/fs.h
index 0406ebe2a80a4..7ead1c61f0cb1 100644
--- a/include/trace/misc/fs.h
+++ b/include/trace/misc/fs.h
@@ -141,3 +141,25 @@
 		{ ATTR_TIMES_SET,	"TIMES_SET" },	\
 		{ ATTR_TOUCH,		"TOUCH"},	\
 		{ ATTR_DELEG,		"DELEG"})
+
+#define show_statx_mask(flags)					\
+	__print_flags(flags, "|",				\
+		{ STATX_TYPE,		"TYPE" },		\
+		{ STATX_MODE,		"MODE" },		\
+		{ STATX_NLINK,		"NLINK" },		\
+		{ STATX_UID,		"UID" },		\
+		{ STATX_GID,		"GID" },		\
+		{ STATX_ATIME,		"ATIME" },		\
+		{ STATX_MTIME,		"MTIME" },		\
+		{ STATX_CTIME,		"CTIME" },		\
+		{ STATX_INO,		"INO" },		\
+		{ STATX_SIZE,		"SIZE" },		\
+		{ STATX_BLOCKS,		"BLOCKS" },		\
+		{ STATX_BASIC_STATS,	"BASIC_STATS" },	\
+		{ STATX_BTIME,		"BTIME" },		\
+		{ STATX_MNT_ID,		"MNT_ID" },		\
+		{ STATX_DIOALIGN,	"DIOALIGN" },		\
+		{ STATX_MNT_ID_UNIQUE,	"MNT_ID_UNIQUE" },	\
+		{ STATX_SUBVOL,		"SUBVOL" },		\
+		{ STATX_WRITE_ATOMIC,	"WRITE_ATOMIC" },	\
+		{ STATX_DIO_READ_ALIGN,	"DIO_READ_ALIGN" })
-- 
2.51.0



