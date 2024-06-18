Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 939E21BBBEF;
	Tue, 18 Jun 2024 12:43:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718714598; cv=none; b=F4PCx1L/pAd57dazVvCZgzu5WdZTo2LtlvaMg8PktnQ0rJInq4B9/4o4kvBxPh9eN3UBV/gepivAwbn1J69Fpz1TBdAPHYtYk4ELimZHCOF8R5FAf8DpICPrWIvbYsPIPt7bXL+od05KgcMbOS9ywj11+q8u1YDqHzuBg2Eehqs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718714598; c=relaxed/simple;
	bh=jYTnuBq+Mrp9YFdbWDOluePZqUAq8cvyDXf/wqzUBl0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e7SX2PrioACUIzgfbZm0hFMnikc5qXV+lr9jmn4TCT4rewaS4VGUgyYqsd5nFacnkOYNZlenN3kdkgsFrbnm3A6URAkwgnncgpsWsS9WltQdtovdyyYhgWx89XX3ztYKnpCBUGq0wexcYVlAyeeTQKuYfbj7YAHl27vdw6m15p0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=leQ7/E0S; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="leQ7/E0S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 197E5C4AF1D;
	Tue, 18 Jun 2024 12:43:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718714598;
	bh=jYTnuBq+Mrp9YFdbWDOluePZqUAq8cvyDXf/wqzUBl0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=leQ7/E0SFzABjM6PMIYzC6x/6yIe50hMNR/6vbWxxt0i67ecJYczG1VNfelo5Q2pi
	 4mUK6G1TAEWFmYCG7AYkA2xvGCgCJTq5QOmGlwTh5zJgtrjzEbuA3GUQQ1zfsafwbY
	 7C7ULRMErYz4ZVQ7MYF/pjhBnFpPFHS8jjQbXMzw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 024/770] NFSD: Replace READ* macros that decode the fattr4 time_set attributes
Date: Tue, 18 Jun 2024 14:27:57 +0200
Message-ID: <20240618123408.228931127@linuxfoundation.org>
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

[ Upstream commit 1c3eff7ea4a98c642134ee493001ae13b79ff38c ]

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4xdr.c | 39 +++++++++++++++++++++++++++++----------
 1 file changed, 29 insertions(+), 10 deletions(-)

diff --git a/fs/nfsd/nfs4xdr.c b/fs/nfsd/nfs4xdr.c
index 979f1d384cd0f..09975786e71b2 100644
--- a/fs/nfsd/nfs4xdr.c
+++ b/fs/nfsd/nfs4xdr.c
@@ -219,6 +219,21 @@ nfsd4_decode_time(struct nfsd4_compoundargs *argp, struct timespec64 *tv)
 	DECODE_TAIL;
 }
 
+static __be32
+nfsd4_decode_nfstime4(struct nfsd4_compoundargs *argp, struct timespec64 *tv)
+{
+	__be32 *p;
+
+	p = xdr_inline_decode(argp->xdr, XDR_UNIT * 3);
+	if (!p)
+		return nfserr_bad_xdr;
+	p = xdr_decode_hyper(p, &tv->tv_sec);
+	tv->tv_nsec = be32_to_cpup(p++);
+	if (tv->tv_nsec >= (u32)1000000000)
+		return nfserr_inval;
+	return nfs_ok;
+}
+
 static __be32
 nfsd4_decode_bitmap(struct nfsd4_compoundargs *argp, u32 *bmval)
 {
@@ -388,11 +403,13 @@ nfsd4_decode_fattr(struct nfsd4_compoundargs *argp, u32 *bmval,
 		iattr->ia_valid |= ATTR_GID;
 	}
 	if (bmval[1] & FATTR4_WORD1_TIME_ACCESS_SET) {
-		READ_BUF(4);
-		dummy32 = be32_to_cpup(p++);
-		switch (dummy32) {
+		u32 set_it;
+
+		if (xdr_stream_decode_u32(argp->xdr, &set_it) < 0)
+			return nfserr_bad_xdr;
+		switch (set_it) {
 		case NFS4_SET_TO_CLIENT_TIME:
-			status = nfsd4_decode_time(argp, &iattr->ia_atime);
+			status = nfsd4_decode_nfstime4(argp, &iattr->ia_atime);
 			if (status)
 				return status;
 			iattr->ia_valid |= (ATTR_ATIME | ATTR_ATIME_SET);
@@ -401,15 +418,17 @@ nfsd4_decode_fattr(struct nfsd4_compoundargs *argp, u32 *bmval,
 			iattr->ia_valid |= ATTR_ATIME;
 			break;
 		default:
-			goto xdr_error;
+			return nfserr_bad_xdr;
 		}
 	}
 	if (bmval[1] & FATTR4_WORD1_TIME_MODIFY_SET) {
-		READ_BUF(4);
-		dummy32 = be32_to_cpup(p++);
-		switch (dummy32) {
+		u32 set_it;
+
+		if (xdr_stream_decode_u32(argp->xdr, &set_it) < 0)
+			return nfserr_bad_xdr;
+		switch (set_it) {
 		case NFS4_SET_TO_CLIENT_TIME:
-			status = nfsd4_decode_time(argp, &iattr->ia_mtime);
+			status = nfsd4_decode_nfstime4(argp, &iattr->ia_mtime);
 			if (status)
 				return status;
 			iattr->ia_valid |= (ATTR_MTIME | ATTR_MTIME_SET);
@@ -418,7 +437,7 @@ nfsd4_decode_fattr(struct nfsd4_compoundargs *argp, u32 *bmval,
 			iattr->ia_valid |= ATTR_MTIME;
 			break;
 		default:
-			goto xdr_error;
+			return nfserr_bad_xdr;
 		}
 	}
 
-- 
2.43.0



