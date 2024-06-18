Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DFC315B0F6;
	Tue, 18 Jun 2024 12:43:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718714622; cv=none; b=dBFMVboX0yT+oj8vVHFHWl+UC8PJ+u2eoxDLtoHSPT4HjVgiCal2j20197/8s7mMzWpnnwqWTJK6SMItcgULOxHNIl+tt9KHTVYy+b5mCa5O4Qd0Fh0B/d4PakRm3Qw56gzN/UT/8YCyUpWMJnsxM+FtLrYLFyRcAlIieX0zafs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718714622; c=relaxed/simple;
	bh=ZMNlEN5k+R3jJPtmeZI0xa6qIRmsNtLLdOn9vrTTiwA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fPDr/NcMRmeYUE5vsAG94RpIbM4bYEtldhzAMKipwA6iNLAmDpxWpm6ioWgaeY7XYX1CpvWkZyK2N2387jRO+WU5SWN8eXs+Lgsuv2/SRLKjJ4jm4BdvSrGN+jT6aSVc0v0zri6FO2EqNv9hF/nFkFvEdSXMTWTHxYHdn0LDBIM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kp5bYHk7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kp5bYHk7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 999C3C3277B;
	Tue, 18 Jun 2024 12:43:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718714622;
	bh=ZMNlEN5k+R3jJPtmeZI0xa6qIRmsNtLLdOn9vrTTiwA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kp5bYHk7Zbn48ccxt5Vdahuk4NlbmD/Iz3cE973wE8FogAdtzIytgJzHDEEIGMLOh
	 XsO5WjTJVQxHNpnr++5g3Vz/ifo8pjYQqNx8uROE77VBc/bV5gfCIOqOTT8TP+l5MM
	 cDQjFZE2XHWu0b/jOq4JtT0mIaIw416nPZKgxo5s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 005/770] NFSD: Clean up the show_nf_may macro
Date: Tue, 18 Jun 2024 14:27:38 +0200
Message-ID: <20240618123407.498269377@linuxfoundation.org>
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

[ Upstream commit b76278ae68848cea13b325d247aa5cf31c87edac ]

Display all currently possible NFSD_MAY permission flags.

Move and rename show_nf_may with a more generic name because the
NFSD_MAY permission flags are used in other places besides the file
cache.

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/trace.h | 40 ++++++++++++++++++++++++++--------------
 1 file changed, 26 insertions(+), 14 deletions(-)

diff --git a/fs/nfsd/trace.h b/fs/nfsd/trace.h
index a952f4a9b2a68..7bb1c398daa51 100644
--- a/fs/nfsd/trace.h
+++ b/fs/nfsd/trace.h
@@ -12,6 +12,22 @@
 #include "export.h"
 #include "nfsfh.h"
 
+#define show_nfsd_may_flags(x)						\
+	__print_flags(x, "|",						\
+		{ NFSD_MAY_EXEC,		"EXEC" },		\
+		{ NFSD_MAY_WRITE,		"WRITE" },		\
+		{ NFSD_MAY_READ,		"READ" },		\
+		{ NFSD_MAY_SATTR,		"SATTR" },		\
+		{ NFSD_MAY_TRUNC,		"TRUNC" },		\
+		{ NFSD_MAY_LOCK,		"LOCK" },		\
+		{ NFSD_MAY_OWNER_OVERRIDE,	"OWNER_OVERRIDE" },	\
+		{ NFSD_MAY_LOCAL_ACCESS,	"LOCAL_ACCESS" },	\
+		{ NFSD_MAY_BYPASS_GSS_ON_ROOT,	"BYPASS_GSS_ON_ROOT" },	\
+		{ NFSD_MAY_NOT_BREAK_LEASE,	"NOT_BREAK_LEASE" },	\
+		{ NFSD_MAY_BYPASS_GSS,		"BYPASS_GSS" },		\
+		{ NFSD_MAY_READ_IF_EXEC,	"READ_IF_EXEC" },	\
+		{ NFSD_MAY_64BIT_COOKIE,	"64BIT_COOKIE" })
+
 TRACE_EVENT(nfsd_compound,
 	TP_PROTO(const struct svc_rqst *rqst,
 		 u32 args_opcnt),
@@ -392,6 +408,9 @@ TRACE_EVENT(nfsd_clid_inuse_err,
 		__entry->cl_boot, __entry->cl_id)
 )
 
+/*
+ * from fs/nfsd/filecache.h
+ */
 TRACE_DEFINE_ENUM(NFSD_FILE_HASHED);
 TRACE_DEFINE_ENUM(NFSD_FILE_PENDING);
 TRACE_DEFINE_ENUM(NFSD_FILE_BREAK_READ);
@@ -406,13 +425,6 @@ TRACE_DEFINE_ENUM(NFSD_FILE_REFERENCED);
 		{ 1 << NFSD_FILE_BREAK_WRITE,	"BREAK_WRITE" },	\
 		{ 1 << NFSD_FILE_REFERENCED,	"REFERENCED"})
 
-/* FIXME: This should probably be fleshed out in the future. */
-#define show_nf_may(val)						\
-	__print_flags(val, "|",						\
-		{ NFSD_MAY_READ,		"READ" },		\
-		{ NFSD_MAY_WRITE,		"WRITE" },		\
-		{ NFSD_MAY_NOT_BREAK_LEASE,	"NOT_BREAK_LEASE" })
-
 DECLARE_EVENT_CLASS(nfsd_file_class,
 	TP_PROTO(struct nfsd_file *nf),
 	TP_ARGS(nf),
@@ -437,7 +449,7 @@ DECLARE_EVENT_CLASS(nfsd_file_class,
 		__entry->nf_inode,
 		__entry->nf_ref,
 		show_nf_flags(__entry->nf_flags),
-		show_nf_may(__entry->nf_may),
+		show_nfsd_may_flags(__entry->nf_may),
 		__entry->nf_file)
 )
 
@@ -463,10 +475,10 @@ TRACE_EVENT(nfsd_file_acquire,
 		__field(u32, xid)
 		__field(unsigned int, hash)
 		__field(void *, inode)
-		__field(unsigned int, may_flags)
+		__field(unsigned long, may_flags)
 		__field(int, nf_ref)
 		__field(unsigned long, nf_flags)
-		__field(unsigned char, nf_may)
+		__field(unsigned long, nf_may)
 		__field(struct file *, nf_file)
 		__field(u32, status)
 	),
@@ -485,10 +497,10 @@ TRACE_EVENT(nfsd_file_acquire,
 
 	TP_printk("xid=0x%x hash=0x%x inode=0x%p may_flags=%s ref=%d nf_flags=%s nf_may=%s nf_file=0x%p status=%u",
 			__entry->xid, __entry->hash, __entry->inode,
-			show_nf_may(__entry->may_flags), __entry->nf_ref,
-			show_nf_flags(__entry->nf_flags),
-			show_nf_may(__entry->nf_may), __entry->nf_file,
-			__entry->status)
+			show_nfsd_may_flags(__entry->may_flags),
+			__entry->nf_ref, show_nf_flags(__entry->nf_flags),
+			show_nfsd_may_flags(__entry->nf_may),
+			__entry->nf_file, __entry->status)
 );
 
 DECLARE_EVENT_CLASS(nfsd_file_search_class,
-- 
2.43.0



