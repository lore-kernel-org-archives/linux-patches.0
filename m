Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80E5823EA9E;
	Fri, 17 Oct 2025 15:31:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760715084; cv=none; b=EcyV9Ixvi8YAOqhf7nVs9+fQ62Dt9sntQieq4Sebx1NYUpDUm+eSX7BJuO3LUbEnr16LDTSdrbw3i0KsnN8kHvq6fN9t0ZgNPo0hGc9OmXdlDjiJfoJkk762JbsSLpNTdgtUIiaFcN+tMZfdHngB0vdk/fvEj62VYtWcgRRsUB0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760715084; c=relaxed/simple;
	bh=ji15KFgmDWWuWQBg0iKIiRTF8KHkIwx7Oj9k6reYUNU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Nq2Gv6TkbNOxRpuYBY8nlf5kbduyjjg0l2cVSivZvl1K/mWxrFmECp91cAC4zgSnTKH9fV+vp0hSiAbmrpHbUkRbDz9/CfWPDmD+/A3W2C8I6WZMVJgcu6M2ay7yDgIKPyyLErgiTUgeCAxry0OHfLhk3ygZxDsPynS85G426/Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oV0lMyzc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oV0lMyzc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BDB6C4CEFE;
	Fri, 17 Oct 2025 15:31:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760715084;
	bh=ji15KFgmDWWuWQBg0iKIiRTF8KHkIwx7Oj9k6reYUNU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oV0lMyzcQPhxadO8zKyhcdB4LUPa3Go5CtnB9qgTyScoeJ7Y732vdqeZQYgQccXlB
	 kRVxSNy0Q/OKS+WcLY6UOD9/S6M8/h+olH9Ank2yeqnkZJdxAfu/1Z3Wtz7LLJ3C3w
	 p3aqW5wqqpz667LkLpitpFajoVzRLUkUs5jwnRCw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 059/371] nfsd: use ATTR_CTIME_SET for delegated ctime updates
Date: Fri, 17 Oct 2025 16:50:34 +0200
Message-ID: <20251017145203.934163488@linuxfoundation.org>
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

[ Upstream commit c066ff58e5d6e5d7400e5fda0c33f95b8c37dd02 ]

Ensure that notify_change() doesn't clobber a delegated ctime update
with current_time() by setting ATTR_CTIME_SET for those updates.

Don't bother setting the timestamps in cb_getattr_update_times() in the
non-delegated case. notify_change() will do that itself.

Fixes: 7e13f4f8d27d ("nfsd: handle delegated timestamps in SETATTR")
Signed-off-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4state.c | 6 +++---
 fs/nfsd/nfs4xdr.c   | 3 ++-
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/fs/nfsd/nfs4state.c b/fs/nfsd/nfs4state.c
index 88c347957da5b..77eea2ad93cc0 100644
--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -9167,7 +9167,6 @@ static bool set_cb_time(struct timespec64 *cb, const struct timespec64 *orig,
 static int cb_getattr_update_times(struct dentry *dentry, struct nfs4_delegation *dp)
 {
 	struct inode *inode = d_inode(dentry);
-	struct timespec64 now = current_time(inode);
 	struct nfs4_cb_fattr *ncf = &dp->dl_cb_fattr;
 	struct iattr attrs = { };
 	int ret;
@@ -9175,6 +9174,7 @@ static int cb_getattr_update_times(struct dentry *dentry, struct nfs4_delegation
 	if (deleg_attrs_deleg(dp->dl_type)) {
 		struct timespec64 atime = inode_get_atime(inode);
 		struct timespec64 mtime = inode_get_mtime(inode);
+		struct timespec64 now = current_time(inode);
 
 		attrs.ia_atime = ncf->ncf_cb_atime;
 		attrs.ia_mtime = ncf->ncf_cb_mtime;
@@ -9183,12 +9183,12 @@ static int cb_getattr_update_times(struct dentry *dentry, struct nfs4_delegation
 			attrs.ia_valid |= ATTR_ATIME | ATTR_ATIME_SET;
 
 		if (set_cb_time(&attrs.ia_mtime, &mtime, &now)) {
-			attrs.ia_valid |= ATTR_CTIME | ATTR_MTIME | ATTR_MTIME_SET;
+			attrs.ia_valid |= ATTR_CTIME | ATTR_CTIME_SET |
+					  ATTR_MTIME | ATTR_MTIME_SET;
 			attrs.ia_ctime = attrs.ia_mtime;
 		}
 	} else {
 		attrs.ia_valid |= ATTR_MTIME | ATTR_CTIME;
-		attrs.ia_mtime = attrs.ia_ctime = now;
 	}
 
 	if (!attrs.ia_valid)
diff --git a/fs/nfsd/nfs4xdr.c b/fs/nfsd/nfs4xdr.c
index 1f3a20360d0c2..a00300b287754 100644
--- a/fs/nfsd/nfs4xdr.c
+++ b/fs/nfsd/nfs4xdr.c
@@ -539,7 +539,8 @@ nfsd4_decode_fattr4(struct nfsd4_compoundargs *argp, u32 *bmval, u32 bmlen,
 		iattr->ia_mtime.tv_nsec = modify.nseconds;
 		iattr->ia_ctime.tv_sec = modify.seconds;
 		iattr->ia_ctime.tv_nsec = modify.nseconds;
-		iattr->ia_valid |= ATTR_CTIME | ATTR_MTIME | ATTR_MTIME_SET | ATTR_DELEG;
+		iattr->ia_valid |= ATTR_CTIME | ATTR_CTIME_SET |
+				   ATTR_MTIME | ATTR_MTIME_SET | ATTR_DELEG;
 	}
 
 	/* request sanity: did attrlist4 contain the expected number of words? */
-- 
2.51.0



