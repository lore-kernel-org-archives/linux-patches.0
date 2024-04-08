Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A701745D6;
	Mon,  8 Apr 2024 13:59:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712584765; cv=none; b=QhEfyss0+jn4U9ZsKxoaBmK+zY3w8s5ul1o72D6XOWjULdkVDlm1bJlZ0PwrAtzDCzpuwjygJWj7fRPPCfT1nT+c0XeitcCB5r74IfNTXu0Fx0HVWWeZoO3V6UH/0Q7wWB3eLYglg/O19Jpt2Jha14OsuHuDRw29dF3IzXG183I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712584765; c=relaxed/simple;
	bh=smZHEJGXHvkM4vwb7+OscsGpR13JU2foSqgLxyI21+c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sU3NUsSNzJ3WYV/Ij1bEQ2iA9hLj/X5zYhMdXrnT55yUurF6pffHLmln806xRq5NiSzjJlm5ivcdMiYqvMt/hWA5Z6K3pVgIpSZpzs3jg4S69HTsvS76cXiQPlsL9fUtxnD9g1r4ZxbTVkFDnKcuaVKk4ZAMFtlWuOKGTanhc3c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L70kaUd4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L70kaUd4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 967DBC433C7;
	Mon,  8 Apr 2024 13:59:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712584765;
	bh=smZHEJGXHvkM4vwb7+OscsGpR13JU2foSqgLxyI21+c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L70kaUd4JNHQeYqtCulEU5+vSTjJxCNfxNmvr+KghlXcVQlSGcbdwXFqFU74sxyeS
	 yTmFDUGOXSGMu5+4JR97e5pmVUtd23nMlio62xSojOecLkFLoNhcUtO/deYAhV1cnM
	 VrSS1nLNQwN/6OkKUIofIEAT5BF8uXhkuKU8wecM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.15 519/690] nfsd: clean up potential nfsd_file refcount leaks in COPY codepath
Date: Mon,  8 Apr 2024 14:56:25 +0200
Message-ID: <20240408125418.447235042@linuxfoundation.org>
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
---
 fs/nfsd/nfs4proc.c | 23 ++++++++++-------------
 1 file changed, 10 insertions(+), 13 deletions(-)

diff --git a/fs/nfsd/nfs4proc.c b/fs/nfsd/nfs4proc.c
index 6fb5f10602233..ada46ef5a093d 100644
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



