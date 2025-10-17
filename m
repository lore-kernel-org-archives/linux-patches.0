Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5532C337110;
	Fri, 17 Oct 2025 15:31:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760715087; cv=none; b=iFemKBEnyAa5OLc401diPhDhUgouLRUKs9h9HDXv2tYtVsviGo1aZ3C+XmfeMVi7zvfix/So40Cu3OHDI4MpNRsgXnJGXaJ/lJnbfjHnKCPM21OjIq5vxDUj6+6Km5Q0T6wxjIeD12eBusOC96xU1jB+2oC3qiX4mo82cZ9a0YY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760715087; c=relaxed/simple;
	bh=/Kl12LFaVYTekF0XGPW2RV3ezwq+AuHoXuWYKZkqaqo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VIxtml7gPsFFcjUZZESED4yIiuMRyiWI4574x/F8dPvA67r6n4nEJYCQ8XYybBnsURmPYmVDgmimgBG7r6p/rGpSyJiZk7mOwWbpb30SFQ0QcAioDhGX9Aa5gvQNyePFQD2C9beq/wyTZl5hpIQ5Gp0PE/VSl1dCNYLoEdG7Hv4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2qS/LjPr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2qS/LjPr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4F81C4CEFE;
	Fri, 17 Oct 2025 15:31:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760715087;
	bh=/Kl12LFaVYTekF0XGPW2RV3ezwq+AuHoXuWYKZkqaqo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2qS/LjPrdCAWn0CCoHVeC25wgQyVPufaN2suTRiNx48G8Nf4NcySWRD0m9FSqxnep
	 pIS4HxgX51GtBVsMSw8MsaK+nEQ1wesZ2wqMi2xiMfxIHz6A/KoUrYLWGc4Zpe0hP2
	 dxFQa0bPItTmkX2qIRs1PkAL/La7BD308BWcOMwE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 060/371] nfsd: track original timestamps in nfs4_delegation
Date: Fri, 17 Oct 2025 16:50:35 +0200
Message-ID: <20251017145203.971106193@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145201.780251198@linuxfoundation.org>
References: <20251017145201.780251198@linuxfoundation.org>
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

From: Jeff Layton <jlayton@kernel.org>

[ Upstream commit 7663e963a51122792811811c8119fd55c9ab254a ]

As Trond points out [1], the "original time" mentioned in RFC 9754
refers to the timestamps on the files at the time that the delegation
was granted, and not the current timestamp of the file on the server.

Store the current timestamps for the file in the nfs4_delegation when
granting one. Add STATX_ATIME and STATX_MTIME to the request mask in
nfs4_delegation_stat(). When granting OPEN_DELEGATE_READ_ATTRS_DELEG, do
a nfs4_delegation_stat() and save the correct atime. If the stat() fails
for any reason, fall back to granting a normal read deleg.

[1]: https://lore.kernel.org/linux-nfs/47a4e40310e797f21b5137e847b06bb203d99e66.camel@kernel.org/

Fixes: 7e13f4f8d27d ("nfsd: handle delegated timestamps in SETATTR")
Signed-off-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4state.c | 11 ++++++++---
 fs/nfsd/state.h     |  5 +++++
 2 files changed, 13 insertions(+), 3 deletions(-)

diff --git a/fs/nfsd/nfs4state.c b/fs/nfsd/nfs4state.c
index 77eea2ad93cc0..8737b721daf34 100644
--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -6157,7 +6157,8 @@ nfs4_delegation_stat(struct nfs4_delegation *dp, struct svc_fh *currentfh,
 	path.dentry = file_dentry(nf->nf_file);
 
 	rc = vfs_getattr(&path, stat,
-			 (STATX_MODE | STATX_SIZE | STATX_CTIME | STATX_CHANGE_COOKIE),
+			 STATX_MODE | STATX_SIZE | STATX_ATIME |
+			 STATX_MTIME | STATX_CTIME | STATX_CHANGE_COOKIE,
 			 AT_STATX_SYNC_AS_STAT);
 
 	nfsd_file_put(nf);
@@ -6274,10 +6275,14 @@ nfs4_open_delegation(struct svc_rqst *rqstp, struct nfsd4_open *open,
 						    OPEN_DELEGATE_WRITE;
 		dp->dl_cb_fattr.ncf_cur_fsize = stat.size;
 		dp->dl_cb_fattr.ncf_initial_cinfo = nfsd4_change_attribute(&stat);
+		dp->dl_atime = stat.atime;
+		dp->dl_ctime = stat.ctime;
+		dp->dl_mtime = stat.mtime;
 		trace_nfsd_deleg_write(&dp->dl_stid.sc_stateid);
 	} else {
-		open->op_delegate_type = deleg_ts ? OPEN_DELEGATE_READ_ATTRS_DELEG :
-						    OPEN_DELEGATE_READ;
+		open->op_delegate_type = deleg_ts && nfs4_delegation_stat(dp, currentfh, &stat) ?
+					 OPEN_DELEGATE_READ_ATTRS_DELEG : OPEN_DELEGATE_READ;
+		dp->dl_atime = stat.atime;
 		trace_nfsd_deleg_read(&dp->dl_stid.sc_stateid);
 	}
 	nfs4_put_stid(&dp->dl_stid);
diff --git a/fs/nfsd/state.h b/fs/nfsd/state.h
index 8adc2550129e6..ce7c0d129ba33 100644
--- a/fs/nfsd/state.h
+++ b/fs/nfsd/state.h
@@ -224,6 +224,11 @@ struct nfs4_delegation {
 
 	/* for CB_GETATTR */
 	struct nfs4_cb_fattr    dl_cb_fattr;
+
+	/* For delegated timestamps */
+	struct timespec64	dl_atime;
+	struct timespec64	dl_mtime;
+	struct timespec64	dl_ctime;
 };
 
 static inline bool deleg_is_read(u32 dl_type)
-- 
2.51.0



