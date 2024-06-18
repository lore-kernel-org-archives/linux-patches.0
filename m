Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 616F213A877;
	Tue, 18 Jun 2024 13:18:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718716697; cv=none; b=tn3AwO44GX5kBwlCzw3USJV3dWr3bTJL4VoFpwzU0x0hj+CZSGPxOw87WMsr+4J6Hw0bt7iUroam5l2psE/jP+oNLYFwPhPEMvyQr12V3RP8K2biqiKupYjjobuDTN/GCjuzkq8X5/ZPMfVHqxQeIQ5pD/wq1L7YZWJEVfxMqZE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718716697; c=relaxed/simple;
	bh=LpWkNNwuHyObzKI+Ta3UxrQlNwro8QJuvuBnsvYuw6I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=btxgTe0D+eoOzvS3Srn663LK9TzbSEsDOrPG7SWgmw5gte2SYBVVc5Pynb9t7BVKnJ2vH8XfjrQIG+3PZd0nIPbc+xvh8yyQJK4fd2NNLPE/fYEhBCLj+2asGKHe83aAWR5YldFSRaYVc5ETC+r8TSgBKnpYiO3u75jnmxruqjA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fVO6DcWR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fVO6DcWR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0E9BC3277B;
	Tue, 18 Jun 2024 13:18:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718716697;
	bh=LpWkNNwuHyObzKI+Ta3UxrQlNwro8QJuvuBnsvYuw6I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fVO6DcWRlUs5J4JjNT0n0ZeciE2XHlRhFeqD++wbTk/ovlp0cGc2mnW//htO3SKE9
	 n8NzR1AEqBF6CEM2A41GjmirYHl7+Owmrtgav+5BbgPb2Xoywg4X035QeSA4WpWxYr
	 thXyC6oOZWE0gO0J5EfM7QsIxLHdf8vk9cujYxeY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dai Ngo <dai.ngo@oracle.com>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 733/770] NFSD: fix leaked reference count of nfsd4_ssc_umount_item
Date: Tue, 18 Jun 2024 14:39:46 +0200
Message-ID: <20240618123435.559824809@linuxfoundation.org>
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

From: Dai Ngo <dai.ngo@oracle.com>

[ Upstream commit 34e8f9ec4c9ac235f917747b23a200a5e0ec857b ]

The reference count of nfsd4_ssc_umount_item is not decremented
on error conditions. This prevents the laundromat from unmounting
the vfsmount of the source file.

This patch decrements the reference count of nfsd4_ssc_umount_item
on error.

Fixes: f4e44b393389 ("NFSD: delay unmount source's export after inter-server copy completed.")
Signed-off-by: Dai Ngo <dai.ngo@oracle.com>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4proc.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/fs/nfsd/nfs4proc.c b/fs/nfsd/nfs4proc.c
index 0fe00d6d385a1..fe20fd0933355 100644
--- a/fs/nfsd/nfs4proc.c
+++ b/fs/nfsd/nfs4proc.c
@@ -1813,13 +1813,17 @@ nfsd4_copy(struct svc_rqst *rqstp, struct nfsd4_compound_state *cstate,
 	release_copy_files(copy);
 	return status;
 out_err:
+	if (nfsd4_ssc_is_inter(copy)) {
+		/*
+		 * Source's vfsmount of inter-copy will be unmounted
+		 * by the laundromat. Use copy instead of async_copy
+		 * since async_copy->ss_nsui might not be set yet.
+		 */
+		refcount_dec(&copy->ss_nsui->nsui_refcnt);
+	}
 	if (async_copy)
 		cleanup_async_copy(async_copy);
 	status = nfserrno(-ENOMEM);
-	/*
-	 * source's vfsmount of inter-copy will be unmounted
-	 * by the laundromat
-	 */
 	goto out;
 }
 
-- 
2.43.0



