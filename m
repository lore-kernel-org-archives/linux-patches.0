Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC54B2E405;
	Mon,  8 Apr 2024 13:51:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712584316; cv=none; b=Q44R3ZQE0QRnVjXxzpw4fnBhVwZP2N43P2Mm87QZgAyzdZ/t6Aw5+hX5U7hyhGrX6bEqabLa4442INWY1OTjRMGlnt9L6xFb/L/VFcBQi13C2vERtBAARBlJSlI6OgFNPbc/ymJ8jW4Mk0LX7oh7HpXjDUZ7H1TjqfeUxN7Gbio=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712584316; c=relaxed/simple;
	bh=6tpRQFAdMUu0xFYAnXcGljIXpuSPsMmUTZhn3aDd5fM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JGrkUWS3WpzGFFyNqGGoC9H2o6LPk6YdCfPl/fcvFfMdkFUgvMhxEWqWJZT2LMxzDTfZTEcx0dJk+EWlzO1s4hKjf0eJo3zgQ75hSZa1dBkBywViQpQFyhwoVGlftspyAno+YUzH6eb5aiyAyeyM0naN4BDiqE/kayIiaQmOTx8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lysKZOYD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lysKZOYD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70B91C433C7;
	Mon,  8 Apr 2024 13:51:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712584315;
	bh=6tpRQFAdMUu0xFYAnXcGljIXpuSPsMmUTZhn3aDd5fM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lysKZOYD4wzXqszqnjwVAExeqTSdvUEXmB9dGBfa9HhZJC3zLbqLMBj9Rn47arU8+
	 mBArxbz4RlU9VvJIdvoekdrfk1zanxgomyKWZWUPDFxdsaBgkUhCJhNQ7L/tdQYZf4
	 Q2Ugqreyw93G8ifhEqWC1YQlZsbumU3OIz5SLosc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.15 397/690] NFSD: Refactor nfsd4_do_copy()
Date: Mon,  8 Apr 2024 14:54:23 +0200
Message-ID: <20240408125413.932681150@linuxfoundation.org>
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

[ Upstream commit 3b7bf5933cada732783554edf0dc61283551c6cf ]

Refactor: Now that nfsd4_do_copy() no longer calls the cleanup
helpers, plumb the use of struct file pointers all the way down to
_nfsd_copy_file_range().

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 fs/nfsd/nfs4proc.c | 22 ++++++++++++++--------
 1 file changed, 14 insertions(+), 8 deletions(-)

diff --git a/fs/nfsd/nfs4proc.c b/fs/nfsd/nfs4proc.c
index 10130f0b088ef..24c7d5e6c8c33 100644
--- a/fs/nfsd/nfs4proc.c
+++ b/fs/nfsd/nfs4proc.c
@@ -1661,10 +1661,10 @@ static void nfsd4_init_copy_res(struct nfsd4_copy *copy, bool sync)
 	gen_boot_verifier(&copy->cp_res.wr_verifier, copy->cp_clp->net);
 }
 
-static ssize_t _nfsd_copy_file_range(struct nfsd4_copy *copy)
+static ssize_t _nfsd_copy_file_range(struct nfsd4_copy *copy,
+				     struct file *dst,
+				     struct file *src)
 {
-	struct file *dst = copy->nf_dst->nf_file;
-	struct file *src = copy->nf_src->nf_file;
 	errseq_t since;
 	ssize_t bytes_copied = 0;
 	u64 bytes_total = copy->cp_count;
@@ -1701,12 +1701,15 @@ static ssize_t _nfsd_copy_file_range(struct nfsd4_copy *copy)
 	return bytes_copied;
 }
 
-static __be32 nfsd4_do_copy(struct nfsd4_copy *copy, bool sync)
+static __be32 nfsd4_do_copy(struct nfsd4_copy *copy,
+			    struct file *src, struct file *dst,
+			    bool sync)
 {
 	__be32 status;
 	ssize_t bytes;
 
-	bytes = _nfsd_copy_file_range(copy);
+	bytes = _nfsd_copy_file_range(copy, dst, src);
+
 	/* for async copy, we ignore the error, client can always retry
 	 * to get the error
 	 */
@@ -1771,11 +1774,13 @@ static int nfsd4_do_async_copy(void *data)
 			/* ss_mnt will be unmounted by the laundromat */
 			goto do_callback;
 		}
-		copy->nfserr = nfsd4_do_copy(copy, 0);
+		copy->nfserr = nfsd4_do_copy(copy, copy->nf_src->nf_file,
+					     copy->nf_dst->nf_file, false);
 		nfsd4_cleanup_inter_ssc(copy->ss_mnt, copy->nf_src->nf_file,
 					copy->nf_dst);
 	} else {
-		copy->nfserr = nfsd4_do_copy(copy, 0);
+		copy->nfserr = nfsd4_do_copy(copy, copy->nf_src->nf_file,
+					     copy->nf_dst->nf_file, false);
 		nfsd4_cleanup_intra_ssc(copy->nf_src, copy->nf_dst);
 	}
 
@@ -1853,7 +1858,8 @@ nfsd4_copy(struct svc_rqst *rqstp, struct nfsd4_compound_state *cstate,
 		wake_up_process(async_copy->copy_task);
 		status = nfs_ok;
 	} else {
-		status = nfsd4_do_copy(copy, 1);
+		status = nfsd4_do_copy(copy, copy->nf_src->nf_file,
+				       copy->nf_dst->nf_file, true);
 		nfsd4_cleanup_intra_ssc(copy->nf_src, copy->nf_dst);
 	}
 out:
-- 
2.43.0



