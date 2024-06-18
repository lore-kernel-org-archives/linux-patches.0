Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 648B0155301;
	Tue, 18 Jun 2024 12:56:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718715387; cv=none; b=OUM45UYnmcaqRUxgp7l7EMDCmD+xy6mAVKKLAwmOC+hnaixcN6wh0IZgsitfbOW+JPpeZ5P3lywDlYVrCn9Jl3P7IJt6yj4esDoxzjIPgTFlFzrSAzevh+hu5aw3Nqyp8CDUta0Bv2YPIRa1/qLrVi2gL2ijsHbktKeSf4cke9U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718715387; c=relaxed/simple;
	bh=mym73zDveV49m06hhnlha7T3Y76OP7xxB/VXsdcrsBw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Dtm4ap1ieg4F8RtJW+bvxSSdGv/3bWd3G9mnJPinKFLfIYa2Tgveq8wIyBi2HX9sne6cvR5aq7NraOXcPhBbP784f/fNzgUZ5uBoOLYTEOpTx9yHy2/TscN81s6fUo6OALaj4NwWKy+/7bxfZzY0+oZqDEwLIV42ODV3gUFyDW8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OZXgXepx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OZXgXepx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2E73C3277B;
	Tue, 18 Jun 2024 12:56:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718715387;
	bh=mym73zDveV49m06hhnlha7T3Y76OP7xxB/VXsdcrsBw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OZXgXepxo0tHStPYgJxivE7nE/HknlNhuX+Y/9I8prPJVDB7W1X2OcQKlwXS4zd/5
	 3WfoIuajTMGcY2RN1Xv+qTALgRyclvU1d8PPE26ZQoeFluyUaJqnMiq+WGhBHCIXGa
	 uPUKnfXHQI1TP1KXZjNUt1v4gkIed7mv8/23tukY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Olga Kornievskaia <kolga@netapp.com>,
	"J. Bruce Fields" <bfields@redhat.com>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 292/770] NFSD add vfs_fsync after async copy is done
Date: Tue, 18 Jun 2024 14:32:25 +0200
Message-ID: <20240618123418.532349879@linuxfoundation.org>
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

From: Olga Kornievskaia <kolga@netapp.com>

[ Upstream commit eac0b17a77fbd763d305a5eaa4fd1119e5a0fe0d ]

Currently, the server does all copies as NFS_UNSTABLE. For synchronous
copies linux client will append a COMMIT to the COPY compound but for
async copies it does not (because COMMIT needs to be done after all
bytes are copied and not as a reply to the COPY operation).

However, in order to save the client doing a COMMIT as a separate
rpc, the server can reply back with NFS_FILE_SYNC copy. This patch
proposed to add vfs_fsync() call at the end of the async copy.

Signed-off-by: Olga Kornievskaia <kolga@netapp.com>
Signed-off-by: J. Bruce Fields <bfields@redhat.com>
[ cel: adjusted to apply to v5.10.y ]
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4proc.c | 15 ++++++++++++++-
 fs/nfsd/xdr4.h     |  1 +
 2 files changed, 15 insertions(+), 1 deletion(-)

diff --git a/fs/nfsd/nfs4proc.c b/fs/nfsd/nfs4proc.c
index dfce9c432a5ee..aa0da0737a3ff 100644
--- a/fs/nfsd/nfs4proc.c
+++ b/fs/nfsd/nfs4proc.c
@@ -1366,7 +1366,8 @@ static const struct nfsd4_callback_ops nfsd4_cb_offload_ops = {
 
 static void nfsd4_init_copy_res(struct nfsd4_copy *copy, bool sync)
 {
-	copy->cp_res.wr_stable_how = NFS_UNSTABLE;
+	copy->cp_res.wr_stable_how =
+		copy->committed ? NFS_FILE_SYNC : NFS_UNSTABLE;
 	copy->cp_synchronous = sync;
 	gen_boot_verifier(&copy->cp_res.wr_verifier, copy->cp_clp->net);
 }
@@ -1375,10 +1376,12 @@ static ssize_t _nfsd_copy_file_range(struct nfsd4_copy *copy)
 {
 	struct file *dst = copy->nf_dst->nf_file;
 	struct file *src = copy->nf_src->nf_file;
+	errseq_t since;
 	ssize_t bytes_copied = 0;
 	u64 bytes_total = copy->cp_count;
 	u64 src_pos = copy->cp_src_pos;
 	u64 dst_pos = copy->cp_dst_pos;
+	__be32 status;
 
 	/* See RFC 7862 p.67: */
 	if (bytes_total == 0)
@@ -1395,6 +1398,16 @@ static ssize_t _nfsd_copy_file_range(struct nfsd4_copy *copy)
 		src_pos += bytes_copied;
 		dst_pos += bytes_copied;
 	} while (bytes_total > 0 && !copy->cp_synchronous);
+	/* for a non-zero asynchronous copy do a commit of data */
+	if (!copy->cp_synchronous && copy->cp_res.wr_bytes_written > 0) {
+		since = READ_ONCE(dst->f_wb_err);
+		status = vfs_fsync_range(dst, copy->cp_dst_pos,
+					 copy->cp_res.wr_bytes_written, 0);
+		if (!status)
+			status = filemap_check_wb_err(dst->f_mapping, since);
+		if (!status)
+			copy->committed = true;
+	}
 	return bytes_copied;
 }
 
diff --git a/fs/nfsd/xdr4.h b/fs/nfsd/xdr4.h
index fe540a3415c6a..37af86e370cb3 100644
--- a/fs/nfsd/xdr4.h
+++ b/fs/nfsd/xdr4.h
@@ -567,6 +567,7 @@ struct nfsd4_copy {
 	struct vfsmount		*ss_mnt;
 	struct nfs_fh		c_fh;
 	nfs4_stateid		stateid;
+	bool			committed;
 };
 
 struct nfsd4_seek {
-- 
2.43.0



