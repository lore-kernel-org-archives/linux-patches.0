Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13BB77E59F;
	Mon,  8 Apr 2024 13:39:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712583544; cv=none; b=aH7znnngliwQ+WUZPcGGOfUsJg5dlVTZXgllBaRQ+UDgn1m1PoDBhMv/WXwjleERdlQo5UPUi3hrLPuXNVwB0g+JbVYuR735bLxUmMXA4adErvZo2K+iGdiGWhU3/lnEvp/2hOzmvHRyNc0Z5anOj0YRr9Fe1lWd1jm9ggL9gtc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712583544; c=relaxed/simple;
	bh=kLkJgrBe/ICo8RPJrqT3bWK7Wh9BQgMvf4Gr+8iXnqE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iHwAd4Ewp54AeuS3sz8o1CmDHuFo0Vx/Zgczf9V/0qpNV0vUal+BIe0hqJGoxGw3zQmTrcgq12kCmBTxdsgVexMOtnv3AKTSWDvXj9xu8PTImj1c1frOzZqZB+aW0LqRuHSWSlmKKzUQn8ErkCJ/Ko/4qSjZNtpJ9etr1Of96RE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NeizBpRc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NeizBpRc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9024AC433C7;
	Mon,  8 Apr 2024 13:39:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712583544;
	bh=kLkJgrBe/ICo8RPJrqT3bWK7Wh9BQgMvf4Gr+8iXnqE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NeizBpRcsD8jrzJoRWMM8p4I1hns5pLW/br86E4ej3cPx43d/9Qwv+x+rxZsXEy1j
	 WJOW96Es08RMMcZHPH9jO1jLDI4eiHFZ5SJlz02H2Vwqrze/5SwbHT4/IorLnzgvO9
	 LmUN0o4Nnjavekq5D720FOCe6R8f4ayppqGbm8Hc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.15 258/690] NFSD: De-duplicate net_generic(SVC_NET(rqstp), nfsd_net_id)
Date: Mon,  8 Apr 2024 14:52:04 +0200
Message-ID: <20240408125408.961974590@linuxfoundation.org>
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

[ Upstream commit fb7622c2dbd1aa41133a8c73e1137b833c074519 ]

Since this pointer is used repeatedly, move it to a stack variable.

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 fs/nfsd/vfs.c | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/fs/nfsd/vfs.c b/fs/nfsd/vfs.c
index 98d370dcca867..17985d868887a 100644
--- a/fs/nfsd/vfs.c
+++ b/fs/nfsd/vfs.c
@@ -966,6 +966,7 @@ nfsd_vfs_write(struct svc_rqst *rqstp, struct svc_fh *fhp, struct nfsd_file *nf,
 				unsigned long *cnt, int stable,
 				__be32 *verf)
 {
+	struct nfsd_net		*nn = net_generic(SVC_NET(rqstp), nfsd_net_id);
 	struct file		*file = nf->nf_file;
 	struct super_block	*sb = file_inode(file)->i_sb;
 	struct svc_export	*exp;
@@ -1010,13 +1011,10 @@ nfsd_vfs_write(struct svc_rqst *rqstp, struct svc_fh *fhp, struct nfsd_file *nf,
 	iov_iter_kvec(&iter, WRITE, vec, vlen, *cnt);
 	since = READ_ONCE(file->f_wb_err);
 	if (verf)
-		nfsd_copy_boot_verifier(verf,
-				net_generic(SVC_NET(rqstp),
-				nfsd_net_id));
+		nfsd_copy_boot_verifier(verf, nn);
 	host_err = vfs_iter_write(file, &iter, &pos, flags);
 	if (host_err < 0) {
-		nfsd_reset_boot_verifier(net_generic(SVC_NET(rqstp),
-					 nfsd_net_id));
+		nfsd_reset_boot_verifier(nn);
 		goto out_nfserr;
 	}
 	*cnt = host_err;
@@ -1029,8 +1027,7 @@ nfsd_vfs_write(struct svc_rqst *rqstp, struct svc_fh *fhp, struct nfsd_file *nf,
 	if (stable && use_wgather) {
 		host_err = wait_for_concurrent_writes(file);
 		if (host_err < 0)
-			nfsd_reset_boot_verifier(net_generic(SVC_NET(rqstp),
-						 nfsd_net_id));
+			nfsd_reset_boot_verifier(nn);
 	}
 
 out_nfserr:
-- 
2.43.0



