Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07D9E8061F;
	Mon,  8 Apr 2024 13:40:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712583617; cv=none; b=TAF5cQ1fBzILXXc9+N8FOw5hnQGfKcmgTNhKl2OVbpmNcxU1/LDI2yYklkRAbi2wHS3zcGr/8MvTaCeif4ygm66+wGIsdzBBCx9KfgL/eZnWgq2RawlsOD1tOhmoWryUpF8CerADoj8WVEEMzj9n/TK7TCx1pfOpvY39FXD/xRI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712583617; c=relaxed/simple;
	bh=oFepeX86pvylI+KE3BcPJcSTbAv5jTOEzJb8QX3rVzE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YST3Zns0xL7jbeyAuvVJJMw6h5+du2BPZ09SvfUKWyDjUHfGNT71BqFW+QlIZy+rrJztvSGfHdosAkdiMJYsGp7CFGijZUPN50IhdIQX3qBPexVYWQ/9SB7zPcqBDHDIw0D0ewBockLT1ckmh/ENFOUW1gGryC++duEPC+we2lE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HkyM1nI0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HkyM1nI0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84586C433F1;
	Mon,  8 Apr 2024 13:40:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712583616;
	bh=oFepeX86pvylI+KE3BcPJcSTbAv5jTOEzJb8QX3rVzE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HkyM1nI03fElwyTWXXsGUkzDstRDu5lk7Xi80lSMK8GQbZ1p4ivNmXEQk4u8kmz5p
	 uDFYijaNkEj67H67rbtM5gIpmyM8PlmOSSygelBqR/RdPfs6ChVjcwucIkUQ4uOuuU
	 p9005zF/o8QeHVPH1wkI4WfDxK52aY+dewATzpuM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bruce Fields <bfields@fieldses.org>,
	Ondrej Valousek <ondrej.valousek.xm@renesas.com>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.15 267/690] nfsd: Add support for the birth time attribute
Date: Mon,  8 Apr 2024 14:52:13 +0200
Message-ID: <20240408125409.291227022@linuxfoundation.org>
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

From: Ondrej Valousek <ondrej.valousek.xm@renesas.com>

[ Upstream commit e377a3e698fb56cb63f6bddbebe7da76dc37e316 ]

For filesystems that supports "btime" timestamp (i.e. most modern
filesystems do) we share it via kernel nfsd. Btime support for NFS
client has already been added by Trond recently.

Suggested-by: Bruce Fields <bfields@fieldses.org>
Signed-off-by: Ondrej Valousek <ondrej.valousek.xm@renesas.com>
[ cel: addressed some whitespace/checkpatch nits ]
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 fs/nfsd/nfs4xdr.c | 10 ++++++++++
 fs/nfsd/nfsd.h    |  2 +-
 2 files changed, 11 insertions(+), 1 deletion(-)

diff --git a/fs/nfsd/nfs4xdr.c b/fs/nfsd/nfs4xdr.c
index 19ddd80239944..771d3057577ef 100644
--- a/fs/nfsd/nfs4xdr.c
+++ b/fs/nfsd/nfs4xdr.c
@@ -2851,6 +2851,9 @@ nfsd4_encode_fattr(struct xdr_stream *xdr, struct svc_fh *fhp,
 	err = vfs_getattr(&path, &stat, STATX_BASIC_STATS, AT_STATX_SYNC_AS_STAT);
 	if (err)
 		goto out_nfserr;
+	if (!(stat.result_mask & STATX_BTIME))
+		/* underlying FS does not offer btime so we can't share it */
+		bmval1 &= ~FATTR4_WORD1_TIME_CREATE;
 	if ((bmval0 & (FATTR4_WORD0_FILES_AVAIL | FATTR4_WORD0_FILES_FREE |
 			FATTR4_WORD0_FILES_TOTAL | FATTR4_WORD0_MAXNAME)) ||
 	    (bmval1 & (FATTR4_WORD1_SPACE_AVAIL | FATTR4_WORD1_SPACE_FREE |
@@ -3251,6 +3254,13 @@ nfsd4_encode_fattr(struct xdr_stream *xdr, struct svc_fh *fhp,
 		p = xdr_encode_hyper(p, (s64)stat.mtime.tv_sec);
 		*p++ = cpu_to_be32(stat.mtime.tv_nsec);
 	}
+	if (bmval1 & FATTR4_WORD1_TIME_CREATE) {
+		p = xdr_reserve_space(xdr, 12);
+		if (!p)
+			goto out_resource;
+		p = xdr_encode_hyper(p, (s64)stat.btime.tv_sec);
+		*p++ = cpu_to_be32(stat.btime.tv_nsec);
+	}
 	if (bmval1 & FATTR4_WORD1_MOUNTED_ON_FILEID) {
 		struct kstat parent_stat;
 		u64 ino = stat.ino;
diff --git a/fs/nfsd/nfsd.h b/fs/nfsd/nfsd.h
index 3e5008b475ff0..4fc1fd639527a 100644
--- a/fs/nfsd/nfsd.h
+++ b/fs/nfsd/nfsd.h
@@ -364,7 +364,7 @@ void		nfsd_lockd_shutdown(void);
  | FATTR4_WORD1_OWNER	        | FATTR4_WORD1_OWNER_GROUP  | FATTR4_WORD1_RAWDEV           \
  | FATTR4_WORD1_SPACE_AVAIL     | FATTR4_WORD1_SPACE_FREE   | FATTR4_WORD1_SPACE_TOTAL      \
  | FATTR4_WORD1_SPACE_USED      | FATTR4_WORD1_TIME_ACCESS  | FATTR4_WORD1_TIME_ACCESS_SET  \
- | FATTR4_WORD1_TIME_DELTA   | FATTR4_WORD1_TIME_METADATA    \
+ | FATTR4_WORD1_TIME_DELTA      | FATTR4_WORD1_TIME_METADATA   | FATTR4_WORD1_TIME_CREATE      \
  | FATTR4_WORD1_TIME_MODIFY     | FATTR4_WORD1_TIME_MODIFY_SET | FATTR4_WORD1_MOUNTED_ON_FILEID)
 
 #define NFSD4_SUPPORTED_ATTRS_WORD2 0
-- 
2.43.0



