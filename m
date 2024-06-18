Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 378371AC767;
	Tue, 18 Jun 2024 13:18:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718716694; cv=none; b=VZ0Hf6i5c0osrg5X06qd29fkoDd8PCJC+v8MUfRSEbFqvAWmcGKviyXHBWacrbIfbxpMtEqisjYy4LtY2e8r1xYrUe8WPMXlF6Y8gE9rECVqzc8wzORUppVRoEqdoJWhHIlyS8fyK8ZsD+NhIEQFpkRYr3wz0wL7qRa67QYgbS0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718716694; c=relaxed/simple;
	bh=JnGKMC0GDofVjl0hUPTUfp9etn54DBHvy6hN/CXfX+U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ghfm4zpJ1yfGeVgU6xcyES+rkO7w9uStmaBNHce/VlD7SRk1rtTC9Ec8swEq44OTFiNeR1ewj3h00uy8rP5H9UjRJEIont8/jmgGWE1RHPzEc2XS94WLHHi/7DhSIakDL/19xh52sjEaw155GlVTbzuVI0nx8m3yz/RdAfxChas=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dQ40eA96; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dQ40eA96"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B382FC3277B;
	Tue, 18 Jun 2024 13:18:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718716694;
	bh=JnGKMC0GDofVjl0hUPTUfp9etn54DBHvy6hN/CXfX+U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dQ40eA96iuKW9OZWXl/DbGjnCI3OqDZ/fP1SVJ07JuKnIMCpj9t6tftx2mRr8tz+4
	 7cLd8k9Z1XaHUyLA3Mnl9wqnWT0CgmNSxjsDFAMQFF6+PEnMjnb+IW/xnft0S/Yc9o
	 /+ITgGIqcsDYZbtpn86IYB/f+7h1UIHYIlRi/5uw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 732/770] nfsd: clean up potential nfsd_file refcount leaks in COPY codepath
Date: Tue, 18 Jun 2024 14:39:45 +0200
Message-ID: <20240618123435.521891003@linuxfoundation.org>
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

From: Jeff Layton <jlayton@kernel.org>

[ Upstream commit 6ba434cb1a8d403ea9aad1b667c3ea3ad8b3191f ]

There are two different flavors of the nfsd4_copy struct. One is
embedded in the compound and is used directly in synchronous copies. The
other is dynamically allocated, refcounted and tracked in the client
struture. For the embedded one, the cleanup just involves releasing any
nfsd_files held on its behalf. For the async one, the cleanup is a bit
more involved, and we need to dequeue it from lists, unhash it, etc.

There is at least one potential refcount leak in this code now. If the
kthread_create call fails, then both the src and dst nfsd_files in the
original nfsd4_copy object are leaked.

The cleanup in this codepath is also sort of weird. In the async copy
case, we'll have up to four nfsd_file references (src and dst for both
flavors of copy structure). They are both put at the end of
nfsd4_do_async_copy, even though the ones held on behalf of the embedded
one outlive that structure.

Change it so that we always clean up the nfsd_file refs held by the
embedded copy structure before nfsd4_copy returns. Rework
cleanup_async_copy to handle both inter and intra copies. Eliminate
nfsd4_cleanup_intra_ssc since it now becomes a no-op.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4proc.c | 23 ++++++++++-------------
 1 file changed, 10 insertions(+), 13 deletions(-)

diff --git a/fs/nfsd/nfs4proc.c b/fs/nfsd/nfs4proc.c
index 5e175133b7bc7..0fe00d6d385a1 100644
--- a/fs/nfsd/nfs4proc.c
+++ b/fs/nfsd/nfs4proc.c
@@ -1512,7 +1512,6 @@ nfsd4_cleanup_inter_ssc(struct nfsd4_ssc_umount_item *nsui, struct file *filp,
 	long timeout = msecs_to_jiffies(nfsd4_ssc_umount_timeout);
 
 	nfs42_ssc_close(filp);
-	nfsd_file_put(dst);
 	fput(filp);
 
 	spin_lock(&nn->nfsd_ssc_lock);
@@ -1562,13 +1561,6 @@ nfsd4_setup_intra_ssc(struct svc_rqst *rqstp,
 				 &copy->nf_dst);
 }
 
-static void
-nfsd4_cleanup_intra_ssc(struct nfsd_file *src, struct nfsd_file *dst)
-{
-	nfsd_file_put(src);
-	nfsd_file_put(dst);
-}
-
 static void nfsd4_cb_offload_release(struct nfsd4_callback *cb)
 {
 	struct nfsd4_cb_offload *cbo =
@@ -1683,12 +1675,18 @@ static void dup_copy_fields(struct nfsd4_copy *src, struct nfsd4_copy *dst)
 	dst->ss_nsui = src->ss_nsui;
 }
 
+static void release_copy_files(struct nfsd4_copy *copy)
+{
+	if (copy->nf_src)
+		nfsd_file_put(copy->nf_src);
+	if (copy->nf_dst)
+		nfsd_file_put(copy->nf_dst);
+}
+
 static void cleanup_async_copy(struct nfsd4_copy *copy)
 {
 	nfs4_free_copy_state(copy);
-	nfsd_file_put(copy->nf_dst);
-	if (!nfsd4_ssc_is_inter(copy))
-		nfsd_file_put(copy->nf_src);
+	release_copy_files(copy);
 	spin_lock(&copy->cp_clp->async_lock);
 	list_del(&copy->copies);
 	spin_unlock(&copy->cp_clp->async_lock);
@@ -1748,7 +1746,6 @@ static int nfsd4_do_async_copy(void *data)
 	} else {
 		nfserr = nfsd4_do_copy(copy, copy->nf_src->nf_file,
 				       copy->nf_dst->nf_file, false);
-		nfsd4_cleanup_intra_ssc(copy->nf_src, copy->nf_dst);
 	}
 
 do_callback:
@@ -1811,9 +1808,9 @@ nfsd4_copy(struct svc_rqst *rqstp, struct nfsd4_compound_state *cstate,
 	} else {
 		status = nfsd4_do_copy(copy, copy->nf_src->nf_file,
 				       copy->nf_dst->nf_file, true);
-		nfsd4_cleanup_intra_ssc(copy->nf_src, copy->nf_dst);
 	}
 out:
+	release_copy_files(copy);
 	return status;
 out_err:
 	if (async_copy)
-- 
2.43.0



