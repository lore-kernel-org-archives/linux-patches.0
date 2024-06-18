Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5ED5C13C83B;
	Tue, 18 Jun 2024 13:12:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718716320; cv=none; b=UAonrGppCU+LgyrWs6A8vzntZnk9qrGGIkxxazOncKoVHDd+jd2GIX39Vqej5DRm2FQsdNw3HDijUWcTKEQ0HPPnZnEGIVX0JG3n0aY5sXdVlbR7h0UjBOA7s2fa+NMP+I60rtzaUZZHAh9+kEAIuJ5UeSJlYhKCgVzpjv0v4tE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718716320; c=relaxed/simple;
	bh=zYkuJiPV+Ae/1autVp1Gohg80/KNpSOoMqWA+WBFtLE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pyG4hVTXDK3vYyqasYXgT+HGtx/WCqUTrOpClj0618kiCRG+JZV+baKrKD95tlNdm5vxPt+afPDtakmMfAvrWG6H4j9d89eLJ1Nc1gLRLBdS8rcXGZBRckSNLtdmHM60wOIhPCWfljGOpjzJNx1zNRCL7ABb9sDZ78ZqZanKHMg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bMlxfdca; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bMlxfdca"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0913C3277B;
	Tue, 18 Jun 2024 13:11:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718716320;
	bh=zYkuJiPV+Ae/1autVp1Gohg80/KNpSOoMqWA+WBFtLE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bMlxfdcapMwBRr8c6poaomLyeBm3q5mgTCqnhhozrfPv1+KMvGNY44cJ72mZca65/
	 XmB4S6jgwFzsT6kzjzXMAamkPIzlS7rXYXJqeKro7/Nk5m83oR/dZl0/vEXZ0qafny
	 fEBGF526uVbUMQoowH8S54oCu9naMRbYiiceAVHU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 606/770] NFSD: Refactor nfsd4_do_copy()
Date: Tue, 18 Jun 2024 14:37:39 +0200
Message-ID: <20240618123430.679839316@linuxfoundation.org>
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

[ Upstream commit 3b7bf5933cada732783554edf0dc61283551c6cf ]

Refactor: Now that nfsd4_do_copy() no longer calls the cleanup
helpers, plumb the use of struct file pointers all the way down to
_nfsd_copy_file_range().

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4proc.c | 22 ++++++++++++++--------
 1 file changed, 14 insertions(+), 8 deletions(-)

diff --git a/fs/nfsd/nfs4proc.c b/fs/nfsd/nfs4proc.c
index 5d05bb7a0c0f6..16f968c165c98 100644
--- a/fs/nfsd/nfs4proc.c
+++ b/fs/nfsd/nfs4proc.c
@@ -1660,10 +1660,10 @@ static void nfsd4_init_copy_res(struct nfsd4_copy *copy, bool sync)
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
@@ -1699,12 +1699,15 @@ static ssize_t _nfsd_copy_file_range(struct nfsd4_copy *copy)
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
@@ -1769,11 +1772,13 @@ static int nfsd4_do_async_copy(void *data)
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
 
@@ -1851,7 +1856,8 @@ nfsd4_copy(struct svc_rqst *rqstp, struct nfsd4_compound_state *cstate,
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



