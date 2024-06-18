Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2542C153819;
	Tue, 18 Jun 2024 12:53:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718715233; cv=none; b=dhE/1VYJJwRCFJNnbDfm0F3iwXvxDqehIWdi+5ctUId+9Tn1IxJfN1wW9rfRMHggaIFpAssSbY7zCveRiUu6r/quOlU2Ba43BgJQJnc0wAY2+EEDOON2oJJsrOCoKDHM615ili/FC3UlOtqns10B/+Jn6fVracMhZ6DrbU+OnPs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718715233; c=relaxed/simple;
	bh=t1rhr8kLdid6/MlhssdX6V/omfXOFCCoh4GnDNDlvTw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EWbmon+g5zUH4p+gDff/djnernSiqhpcDRpyB866NDtMtjlt9bs7ssqQbIJI83cvQJ+XZgCr6WCDIiA964Ln1tKzCrz73mVkyGSp+Squi9JniQdnKwy9AZHQlxpwnWsucKnMDwnyRpN/psQPTcX7j054r9ObdV/6bv40feasgCw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mMtyrhSJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mMtyrhSJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E106C3277B;
	Tue, 18 Jun 2024 12:53:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718715233;
	bh=t1rhr8kLdid6/MlhssdX6V/omfXOFCCoh4GnDNDlvTw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mMtyrhSJFo6cdeHYWK/Yz4WPWwR/ob+JMAeW4fyoJB0ctYT53IeogvZDNFhEewWfe
	 pl7d3axWKcXOKDJTrr89xREf9EEaaCNNFCiUOhU7KPAf0jwDZsFDIIH58OK8EXPGh+
	 rN5KB4InfE0x1qDql/xluyumQowAsuPR0Q4zxeug=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 238/770] NFSD: Add a tracepoint to record directory entry encoding
Date: Tue, 18 Jun 2024 14:31:31 +0200
Message-ID: <20240618123416.465795563@linuxfoundation.org>
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

[ Upstream commit 6019ce0742ca55d3e45279a19b07d1542747a098 ]

Enable watching the progress of directory encoding to capture the
timing of any issues with reading or encoding a directory. The
new tracepoint captures dirent encoding for all NFS versions.

For example, here's what a few NFSv4 directory entries might look
like:

nfsd-989   [002]   468.596265: nfsd_dirent:          fh_hash=0x5d162594 ino=2 name=.
nfsd-989   [002]   468.596267: nfsd_dirent:          fh_hash=0x5d162594 ino=1 name=..
nfsd-989   [002]   468.596299: nfsd_dirent:          fh_hash=0x5d162594 ino=3827 name=zlib.c
nfsd-989   [002]   468.596325: nfsd_dirent:          fh_hash=0x5d162594 ino=3811 name=xdiff
nfsd-989   [002]   468.596351: nfsd_dirent:          fh_hash=0x5d162594 ino=3810 name=xdiff-interface.h
nfsd-989   [002]   468.596377: nfsd_dirent:          fh_hash=0x5d162594 ino=3809 name=xdiff-interface.c

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/trace.h | 24 ++++++++++++++++++++++++
 fs/nfsd/vfs.c   |  9 ++++++---
 2 files changed, 30 insertions(+), 3 deletions(-)

diff --git a/fs/nfsd/trace.h b/fs/nfsd/trace.h
index 2bc2a888f7fa8..d20ab767ba26a 100644
--- a/fs/nfsd/trace.h
+++ b/fs/nfsd/trace.h
@@ -391,6 +391,30 @@ DEFINE_EVENT(nfsd_err_class, nfsd_##name,	\
 DEFINE_NFSD_ERR_EVENT(read_err);
 DEFINE_NFSD_ERR_EVENT(write_err);
 
+TRACE_EVENT(nfsd_dirent,
+	TP_PROTO(struct svc_fh *fhp,
+		 u64 ino,
+		 const char *name,
+		 int namlen),
+	TP_ARGS(fhp, ino, name, namlen),
+	TP_STRUCT__entry(
+		__field(u32, fh_hash)
+		__field(u64, ino)
+		__field(int, len)
+		__dynamic_array(unsigned char, name, namlen)
+	),
+	TP_fast_assign(
+		__entry->fh_hash = fhp ? knfsd_fh_hash(&fhp->fh_handle) : 0;
+		__entry->ino = ino;
+		__entry->len = namlen;
+		memcpy(__get_str(name), name, namlen);
+		__assign_str(name, name);
+	),
+	TP_printk("fh_hash=0x%08x ino=%llu name=%.*s",
+		__entry->fh_hash, __entry->ino,
+		__entry->len, __get_str(name))
+)
+
 #include "state.h"
 #include "filecache.h"
 #include "vfs.h"
diff --git a/fs/nfsd/vfs.c b/fs/nfsd/vfs.c
index d12c3e71ca10e..520e55c35e742 100644
--- a/fs/nfsd/vfs.c
+++ b/fs/nfsd/vfs.c
@@ -1979,8 +1979,9 @@ static int nfsd_buffered_filldir(struct dir_context *ctx, const char *name,
 	return 0;
 }
 
-static __be32 nfsd_buffered_readdir(struct file *file, nfsd_filldir_t func,
-				    struct readdir_cd *cdp, loff_t *offsetp)
+static __be32 nfsd_buffered_readdir(struct file *file, struct svc_fh *fhp,
+				    nfsd_filldir_t func, struct readdir_cd *cdp,
+				    loff_t *offsetp)
 {
 	struct buffered_dirent *de;
 	int host_err;
@@ -2026,6 +2027,8 @@ static __be32 nfsd_buffered_readdir(struct file *file, nfsd_filldir_t func,
 			if (cdp->err != nfs_ok)
 				break;
 
+			trace_nfsd_dirent(fhp, de->ino, de->name, de->namlen);
+
 			reclen = ALIGN(sizeof(*de) + de->namlen,
 				       sizeof(u64));
 			size -= reclen;
@@ -2073,7 +2076,7 @@ nfsd_readdir(struct svc_rqst *rqstp, struct svc_fh *fhp, loff_t *offsetp,
 		goto out_close;
 	}
 
-	err = nfsd_buffered_readdir(file, func, cdp, offsetp);
+	err = nfsd_buffered_readdir(file, fhp, func, cdp, offsetp);
 
 	if (err == nfserr_eof || err == nfserr_toosmall)
 		err = nfs_ok; /* can still be found in ->err */
-- 
2.43.0



