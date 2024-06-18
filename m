Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50999157E99;
	Tue, 18 Jun 2024 13:05:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718715956; cv=none; b=il8ElSNt4h/sB0msh0O7KxL9YgdzIZchgMikNRb5yp7vhkMgPHQLYeKg1iqGYVYPSNgEwOiC8QrqLK8rGPipB8640DVFYXQ+l3U77YYm4rlc7yj7TLU89nqJZktKeMPoQYelz/FAsGZc+YtSV+e6iKfnMHzQnMPFAejfmHlKkGM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718715956; c=relaxed/simple;
	bh=etKtWMN1zkzdLwE1OywHcCvnE7TUHl+YuLXg2mUwbYs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VB8cBErycQxcXY0Du2Zlf4/wsy0g1xObjWW5VcgtnALx9dZPGlRXyJ1a0bheHqnup/xtkofX6THyS0EHktLjtleYooz+58fYsL6ifcDGntbTLvXZ+3jkzQHBhNmq2Ci7wxF0igxYZ3gj8Ckxq9m5FBpXJiAVGm+QU8f2RwemE0g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gHOA0lYD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gHOA0lYD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2512C32786;
	Tue, 18 Jun 2024 13:05:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718715956;
	bh=etKtWMN1zkzdLwE1OywHcCvnE7TUHl+YuLXg2mUwbYs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gHOA0lYDozcq5nAOGZnpjfLopD9PYhVRaP0+wMkNh4pvceDuV41l0EYk8M9Gca9ch
	 WXML1UL7FzRfo+kOwXOyj/nTzX9Wom99YtGbfiMWZ+ObyAMCttz64EPGvPNgUZYXUd
	 pp7KQDMpCFbkbAwn31gV7LSM/5p5N+hHZQZDCwX0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 452/770] NFSD: De-duplicate net_generic(SVC_NET(rqstp), nfsd_net_id)
Date: Tue, 18 Jun 2024 14:35:05 +0200
Message-ID: <20240618123424.743675972@linuxfoundation.org>
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

[ Upstream commit fb7622c2dbd1aa41133a8c73e1137b833c074519 ]

Since this pointer is used repeatedly, move it to a stack variable.

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/vfs.c | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/fs/nfsd/vfs.c b/fs/nfsd/vfs.c
index cef8435d76a69..aba9d479d0840 100644
--- a/fs/nfsd/vfs.c
+++ b/fs/nfsd/vfs.c
@@ -980,6 +980,7 @@ nfsd_vfs_write(struct svc_rqst *rqstp, struct svc_fh *fhp, struct nfsd_file *nf,
 				unsigned long *cnt, int stable,
 				__be32 *verf)
 {
+	struct nfsd_net		*nn = net_generic(SVC_NET(rqstp), nfsd_net_id);
 	struct file		*file = nf->nf_file;
 	struct super_block	*sb = file_inode(file)->i_sb;
 	struct svc_export	*exp;
@@ -1024,13 +1025,10 @@ nfsd_vfs_write(struct svc_rqst *rqstp, struct svc_fh *fhp, struct nfsd_file *nf,
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
@@ -1043,8 +1041,7 @@ nfsd_vfs_write(struct svc_rqst *rqstp, struct svc_fh *fhp, struct nfsd_file *nf,
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



