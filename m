Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5008B13C83B;
	Tue, 18 Jun 2024 13:12:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718716323; cv=none; b=l65p4RhtQtFDWlfnROL+bAF494E1y4OrkW8UIpJ4e0BVtc9IcUsP7hZTjduWt+BTmdL/4AR+FFGD8+tVvLAAJQOUbg/3PWGv5LOCHHvwPlMJZctLeVK/436UzsoP81CoWj1ayh5CRqlijNIHdCkhugEWdp92Emb6EnOIE6JjQaM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718716323; c=relaxed/simple;
	bh=P0AN3sI2EIFu4AJK570IPdmPpf1p/Pl9hxKiRp+6GiM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BR58vEpzcP+g1EXRlkWjg0eYwLClwOwPIbGojfJD1dmBBs5ERRS8d3WBVWvm9ww6vA4Rtbzwp3oZ1sVGbmzwywBoiA41lTr0PrGkwjcsElc50HkvV5UsCVPiBZ+6fb01SbFpHwYNJzUQD24/11gb9mvwdtsU51YDf5yof5JO4pI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cpMsCy/a; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cpMsCy/a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA6FCC3277B;
	Tue, 18 Jun 2024 13:12:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718716323;
	bh=P0AN3sI2EIFu4AJK570IPdmPpf1p/Pl9hxKiRp+6GiM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cpMsCy/a+0B7GCyKuHIQ4u8QBvN9OaN6pk1OWOwY2xYI4mRDDTo/Wc16+ZYzCqBUQ
	 /jrNPcfh1gTXO6KswgnQKuo3kfEjpXzK9lDbjUWXTX5lBTR6GGZs4SgZBAvZ6jNxXy
	 C+uW4W6vTDZLkWbrw9HqiTQZbvOux02OQ1ZwA/rs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 607/770] NFSD: Remove kmalloc from nfsd4_do_async_copy()
Date: Tue, 18 Jun 2024 14:37:40 +0200
Message-ID: <20240618123430.718474198@linuxfoundation.org>
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

[ Upstream commit ad1e46c9b07b13659635ee5405f83ad0df143116 ]

Instead of manufacturing a phony struct nfsd_file, pass the
struct file returned by nfs42_ssc_open() directly to
nfsd4_do_copy().

[ cel: adjusted to apply to v5.10.y ]
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4proc.c | 28 ++++++++++++++--------------
 1 file changed, 14 insertions(+), 14 deletions(-)

diff --git a/fs/nfsd/nfs4proc.c b/fs/nfsd/nfs4proc.c
index 16f968c165c98..dbc507c9aa11b 100644
--- a/fs/nfsd/nfs4proc.c
+++ b/fs/nfsd/nfs4proc.c
@@ -1753,29 +1753,31 @@ static void cleanup_async_copy(struct nfsd4_copy *copy)
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
@@ -1797,8 +1799,6 @@ static int nfsd4_do_async_copy(void *data)
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



