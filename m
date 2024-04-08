Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A3147CF27;
	Mon,  8 Apr 2024 13:56:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712584606; cv=none; b=RDHamIEnmz9rrJJUDCPbq6RDWyiJ6n9FAsHUYclb66fe4PCNGSwDnPuQrrqRhT3STu9ThayCJNy94R8V4CkKnRaFLAQKGS4UzIm6UHdKjCNqF6HfmZqc90RbRKy3Cbk6jMY4+1+Z/NBKpyzNZ3EfNPoifz4CHE37Rub21NjhmDg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712584606; c=relaxed/simple;
	bh=9hWH7HE+nYKqKG3yzYwRn+nMVOHj+KmZRyC+5J0aldw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jIfjwBl30maOHbnMJ2+20QA40JLVhWsRQaB1g1sm6Q5QjgOxenarHNRoQHq59DMy4vNdy9EHlRE9unJMmml2S3baD8L5rQQPraHV5HAWPhxQ+H4vfZXMzNUL9keFp92eWTt/zUUvESVscpUdDeHcoVdI1W0XjXck1v0uLjWeXwc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DVkQEVXW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DVkQEVXW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A39D0C433F1;
	Mon,  8 Apr 2024 13:56:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712584606;
	bh=9hWH7HE+nYKqKG3yzYwRn+nMVOHj+KmZRyC+5J0aldw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DVkQEVXWv0/gvGB8kAQSqGE8G9aczGoADAxlLbF7W1yty7gWhA9HEoexPM5XMIeX9
	 WEHomqsOCSPe0mTGnGgVHr83lB4zDdvSTeHVhpOb4/xVP/uw7Tuuct2Ne7MS6sqW6a
	 +LoA2lb5e/riIsZ6t14QxaTmLXJxHq2DVXZuYO/k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Jeff Layton <jlayton@kernel.org>
Subject: [PATCH 5.15 496/690] NFSD: Add an nfsd_file_fsync tracepoint
Date: Mon,  8 Apr 2024 14:56:02 +0200
Message-ID: <20240408125417.613437655@linuxfoundation.org>
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

[ Upstream commit d7064eaf688cfe454c50db9f59298463d80d403c ]

Add a tracepoint to capture the number of filecache-triggered fsync
calls and which files needed it. Also, record when an fsync triggers
a write verifier reset.

Examples:

<...>-97    [007]   262.505611: nfsd_file_free:       inode=0xffff888171e08140 ref=0 flags=GC may=WRITE nf_file=0xffff8881373d2400
<...>-97    [007]   262.505612: nfsd_file_fsync:      inode=0xffff888171e08140 ref=0 flags=GC may=WRITE nf_file=0xffff8881373d2400 ret=0
<...>-97    [007]   262.505623: nfsd_file_free:       inode=0xffff888171e08dc0 ref=0 flags=GC may=WRITE nf_file=0xffff8881373d1e00
<...>-97    [007]   262.505624: nfsd_file_fsync:      inode=0xffff888171e08dc0 ref=0 flags=GC may=WRITE nf_file=0xffff8881373d1e00 ret=0

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 fs/nfsd/filecache.c |  5 ++++-
 fs/nfsd/trace.h     | 31 +++++++++++++++++++++++++++++++
 2 files changed, 35 insertions(+), 1 deletion(-)

diff --git a/fs/nfsd/filecache.c b/fs/nfsd/filecache.c
index 522e900a88605..6b8873b0c2c38 100644
--- a/fs/nfsd/filecache.c
+++ b/fs/nfsd/filecache.c
@@ -335,10 +335,13 @@ static void
 nfsd_file_fsync(struct nfsd_file *nf)
 {
 	struct file *file = nf->nf_file;
+	int ret;
 
 	if (!file || !(file->f_mode & FMODE_WRITE))
 		return;
-	if (vfs_fsync(file, 1) != 0)
+	ret = vfs_fsync(file, 1);
+	trace_nfsd_file_fsync(nf, ret);
+	if (ret)
 		nfsd_reset_write_verifier(net_generic(nf->nf_net, nfsd_net_id));
 }
 
diff --git a/fs/nfsd/trace.h b/fs/nfsd/trace.h
index 2c72a666aa9c2..eb155e98a9dc2 100644
--- a/fs/nfsd/trace.h
+++ b/fs/nfsd/trace.h
@@ -1237,6 +1237,37 @@ DEFINE_EVENT(nfsd_file_lruwalk_class, name,				\
 DEFINE_NFSD_FILE_LRUWALK_EVENT(nfsd_file_gc_removed);
 DEFINE_NFSD_FILE_LRUWALK_EVENT(nfsd_file_shrinker_removed);
 
+TRACE_EVENT(nfsd_file_fsync,
+	TP_PROTO(
+		const struct nfsd_file *nf,
+		int ret
+	),
+	TP_ARGS(nf, ret),
+	TP_STRUCT__entry(
+		__field(void *, nf_inode)
+		__field(int, nf_ref)
+		__field(int, ret)
+		__field(unsigned long, nf_flags)
+		__field(unsigned char, nf_may)
+		__field(struct file *, nf_file)
+	),
+	TP_fast_assign(
+		__entry->nf_inode = nf->nf_inode;
+		__entry->nf_ref = refcount_read(&nf->nf_ref);
+		__entry->ret = ret;
+		__entry->nf_flags = nf->nf_flags;
+		__entry->nf_may = nf->nf_may;
+		__entry->nf_file = nf->nf_file;
+	),
+	TP_printk("inode=%p ref=%d flags=%s may=%s nf_file=%p ret=%d",
+		__entry->nf_inode,
+		__entry->nf_ref,
+		show_nf_flags(__entry->nf_flags),
+		show_nfsd_may_flags(__entry->nf_may),
+		__entry->nf_file, __entry->ret
+	)
+);
+
 #include "cache.h"
 
 TRACE_DEFINE_ENUM(RC_DROPIT);
-- 
2.43.0



