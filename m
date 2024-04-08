Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B9D042046;
	Mon,  8 Apr 2024 13:51:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712584319; cv=none; b=Aicv3WQgiUfL8GI8ImlXyRePB+s+6Kp5dVBPdKj7kMi61zgFYqLXdjDHrNTpp/IYk34c1e8fw6g4F/7/mxhSHbadFom49bO30OQ6un7WknR8/sgoF+INRC9JoHsA4PobmqaVYsYGpFMfROtDSwYEW1d5dM2wwieI3iBqmYfpKjs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712584319; c=relaxed/simple;
	bh=Bvcc3GvQ+7+ris3eDdOAFcpwnTi7HjAQJRbf0V8Ym1k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Pdw7TMi4s980wGt7IJARPh8bMTHuwIQyOzzUBnVUtAgDDQnpaSggpS19l0s45hyaHFgWmbwp353LxuK+7GcjJ3dvTEhg7+K2/GYLIwgpCfOK4Bgy4uG0gkYC9dwlEvOHuttehgmQGBjsjqzSVArsCxycsN3qJjX7TZZCFxMfqCE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eIlkE+am; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eIlkE+am"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0373C433F1;
	Mon,  8 Apr 2024 13:51:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712584319;
	bh=Bvcc3GvQ+7+ris3eDdOAFcpwnTi7HjAQJRbf0V8Ym1k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eIlkE+amGRrnSPqeWFvKzSJ80aYScmRDdCk1DV9/Z4vOttsDutadEbSR/F/3f+v+s
	 wTrPLdK39/E9ZD263w4AvQAvskx76s/41q73KYS5JMle8NZWl84r8tx+YnpXsD7T9S
	 gwwZT8qX1IYIlGjZvt1vvYQ46wm6gD45FDKkoU8k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.15 398/690] NFSD: Remove kmalloc from nfsd4_do_async_copy()
Date: Mon,  8 Apr 2024 14:54:24 +0200
Message-ID: <20240408125413.964115093@linuxfoundation.org>
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

[ Upstream commit ad1e46c9b07b13659635ee5405f83ad0df143116 ]

Instead of manufacturing a phony struct nfsd_file, pass the
struct file returned by nfs42_ssc_open() directly to
nfsd4_do_copy().

[ cel: adjusted to apply to v5.15.y ]
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 fs/nfsd/nfs4proc.c | 28 ++++++++++++++--------------
 1 file changed, 14 insertions(+), 14 deletions(-)

diff --git a/fs/nfsd/nfs4proc.c b/fs/nfsd/nfs4proc.c
index 24c7d5e6c8c33..f63c3c4c10ca7 100644
--- a/fs/nfsd/nfs4proc.c
+++ b/fs/nfsd/nfs4proc.c
@@ -1755,29 +1755,31 @@ static void cleanup_async_copy(struct nfsd4_copy *copy)
 	nfs4_put_copy(copy);
 }
 
+/**
+ * nfsd4_do_async_copy - kthread function for background server-side COPY
+ * @data: arguments for COPY operation
+ *
+ * Return values:
+ *   %0: Copy operation is done.
+ */
 static int nfsd4_do_async_copy(void *data)
 {
 	struct nfsd4_copy *copy = (struct nfsd4_copy *)data;
 	struct nfsd4_copy *cb_copy;
 
 	if (nfsd4_ssc_is_inter(copy)) {
-		copy->nf_src = kzalloc(sizeof(struct nfsd_file), GFP_KERNEL);
-		if (!copy->nf_src) {
-			copy->nfserr = nfserr_serverfault;
-			/* ss_mnt will be unmounted by the laundromat */
-			goto do_callback;
-		}
-		copy->nf_src->nf_file = nfs42_ssc_open(copy->ss_mnt, &copy->c_fh,
-					      &copy->stateid);
-		if (IS_ERR(copy->nf_src->nf_file)) {
+		struct file *filp;
+
+		filp = nfs42_ssc_open(copy->ss_mnt, &copy->c_fh,
+				      &copy->stateid);
+		if (IS_ERR(filp)) {
 			copy->nfserr = nfserr_offload_denied;
 			/* ss_mnt will be unmounted by the laundromat */
 			goto do_callback;
 		}
-		copy->nfserr = nfsd4_do_copy(copy, copy->nf_src->nf_file,
+		copy->nfserr = nfsd4_do_copy(copy, filp,
 					     copy->nf_dst->nf_file, false);
-		nfsd4_cleanup_inter_ssc(copy->ss_mnt, copy->nf_src->nf_file,
-					copy->nf_dst);
+		nfsd4_cleanup_inter_ssc(copy->ss_mnt, filp, copy->nf_dst);
 	} else {
 		copy->nfserr = nfsd4_do_copy(copy, copy->nf_src->nf_file,
 					     copy->nf_dst->nf_file, false);
@@ -1799,8 +1801,6 @@ static int nfsd4_do_async_copy(void *data)
 			      &copy->fh, copy->cp_count, copy->nfserr);
 	nfsd4_run_cb(&cb_copy->cp_cb);
 out:
-	if (nfsd4_ssc_is_inter(copy))
-		kfree(copy->nf_src);
 	cleanup_async_copy(copy);
 	return 0;
 }
-- 
2.43.0



