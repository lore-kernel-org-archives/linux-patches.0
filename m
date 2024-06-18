Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5625713C821;
	Tue, 18 Jun 2024 13:11:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718716314; cv=none; b=LrUvEfdlxJLW+oE3L4xMo5puQfNKV0e5FXOCNnRdiToT3qTcNAOr7eJn2ctY5rBBwp7pbxrSjmAimUGwQcQbvnaMeKu+0tDYNCvZPBS16E314y2/tcjKdS+Lobx6Gk7+jIzzwzaxiUdwWI0tzKd1N1Km/GCCza3JuZqnVloIfmc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718716314; c=relaxed/simple;
	bh=Db4fPzYBkSKYPsaAVB6JwI8HBASVQ2xDx52bj3Y7Ngg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gxkzZplBM0EAxrWgj49mdsDoYUTRnG60kYLw418+USxHvqvju6bFQ7hy6fK1C/WABty1KPxOEhiLNtV3BYpVh7JdBxI9TYhnr0JDKVUw1xV8aABRTqpOF6zZ5PyM2G3Sz3GUohfL2MfqUOpOMpGDo5XyhwS1JPDmMpU/2/kFQaM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UoI2DhyY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UoI2DhyY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CED8AC3277B;
	Tue, 18 Jun 2024 13:11:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718716314;
	bh=Db4fPzYBkSKYPsaAVB6JwI8HBASVQ2xDx52bj3Y7Ngg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UoI2DhyYjV2Vf9km3M9/LN+FDSSBz/9KCkER8EeyefUEevemQujTUXPePJM4e32mu
	 RAh0xO26gNYzc8I/j3YLF2e0qj9Tz4+yRuzBWdDRm51HyuSy4ij8cQ3DJyXf3vnAVM
	 l9n09Pm5V+3J5vBBLw5cLjDD881OSha02C55z2So=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 604/770] NFSD: Refactor nfsd4_cleanup_inter_ssc() (1/2)
Date: Tue, 18 Jun 2024 14:37:37 +0200
Message-ID: <20240618123430.604366190@linuxfoundation.org>
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

[ Upstream commit 24d796ea383b8a4c8234e06d1b14bbcd371192ea ]

The @src parameter is sometimes a pointer to a struct nfsd_file and
sometimes a pointer to struct file hiding in a phony struct
nfsd_file. Refactor nfsd4_cleanup_inter_ssc() so the @src parameter
is always an explicit struct file.

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4proc.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/nfsd/nfs4proc.c b/fs/nfsd/nfs4proc.c
index a4bc096e509d4..d39150425da88 100644
--- a/fs/nfsd/nfs4proc.c
+++ b/fs/nfsd/nfs4proc.c
@@ -1549,7 +1549,7 @@ nfsd4_setup_inter_ssc(struct svc_rqst *rqstp,
 }
 
 static void
-nfsd4_cleanup_inter_ssc(struct vfsmount *ss_mnt, struct nfsd_file *src,
+nfsd4_cleanup_inter_ssc(struct vfsmount *ss_mnt, struct file *filp,
 			struct nfsd_file *dst)
 {
 	bool found = false;
@@ -1558,9 +1558,9 @@ nfsd4_cleanup_inter_ssc(struct vfsmount *ss_mnt, struct nfsd_file *src,
 	struct nfsd4_ssc_umount_item *ni = NULL;
 	struct nfsd_net *nn = net_generic(dst->nf_net, nfsd_net_id);
 
-	nfs42_ssc_close(src->nf_file);
+	nfs42_ssc_close(filp);
 	nfsd_file_put(dst);
-	fput(src->nf_file);
+	fput(filp);
 
 	if (!nn) {
 		mntput(ss_mnt);
@@ -1603,7 +1603,7 @@ nfsd4_setup_inter_ssc(struct svc_rqst *rqstp,
 }
 
 static void
-nfsd4_cleanup_inter_ssc(struct vfsmount *ss_mnt, struct nfsd_file *src,
+nfsd4_cleanup_inter_ssc(struct vfsmount *ss_mnt, struct file *filp,
 			struct nfsd_file *dst)
 {
 }
@@ -1716,7 +1716,7 @@ static __be32 nfsd4_do_copy(struct nfsd4_copy *copy, bool sync)
 	}
 
 	if (nfsd4_ssc_is_inter(copy))
-		nfsd4_cleanup_inter_ssc(copy->ss_mnt, copy->nf_src,
+		nfsd4_cleanup_inter_ssc(copy->ss_mnt, copy->nf_src->nf_file,
 					copy->nf_dst);
 	else
 		nfsd4_cleanup_intra_ssc(copy->nf_src, copy->nf_dst);
-- 
2.43.0



