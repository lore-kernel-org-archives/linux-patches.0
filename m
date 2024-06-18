Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECB4513C687;
	Tue, 18 Jun 2024 13:09:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718716169; cv=none; b=GWDKPq6/r2yewBCAbkQ1xX+3wWKU4qoB7IpizEDDLjGa0/aXGjrlpm1uk9Jz6das4hpxfWleVsa+OYR5y3r8w/XeQVko85YcNy1x8Mz4dkLvuIgQ40P+YZ7TcMLMyf+PFazwoAPpscQIEZc+NFm9Sr3PnftEUg/tto3J1l5gtaY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718716169; c=relaxed/simple;
	bh=0yCqfVH3lFY2kFxT4nEZifhyTOevPhvr4atyUSK2Uqo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iD7tU+qaa6uvYSnF94x1oyp38h8jmVtIQzaLtTUfIedKIsoIXO4vj15fxz3Cx5QhvuVDzECrwWx6MeJzWz93fcPiuRrxVkzMr7glKJpCtuGZZIK36eyQ+7tfDCYTvlYD87bWihytArvN4Kxq/8ZgXWr1ctwdHs/C7ceK5/esRBk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wagJQuP7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wagJQuP7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0836C3277B;
	Tue, 18 Jun 2024 13:09:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718716168;
	bh=0yCqfVH3lFY2kFxT4nEZifhyTOevPhvr4atyUSK2Uqo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wagJQuP7o4bvS1eA7Ab1tD81f8EfQDpmbLtkS3zDGHub1+1W0lsP6qxGav+JI09a+
	 gYswmJdGjPuW/KG+oGPCpQIyadet6mg6QjB2NRDXcfPNzqLbcT/UDyboUGCY1CqrMJ
	 8ttutB2tBn7yMjUXk/c2r2aXpOkB4KEtBxN0Vurk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 556/770] NFSD: Report count of calls to nfsd_file_acquire()
Date: Tue, 18 Jun 2024 14:36:49 +0200
Message-ID: <20240618123428.761610353@linuxfoundation.org>
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

[ Upstream commit 29d4bdbbb910f33d6058d2c51278f00f656df325 ]

Count the number of successful acquisitions that did not create a
file (ie, acquisitions that do not result in a compulsory cache
miss). This count can be compared directly with the reported hit
count to compute a hit ratio.

Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/filecache.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/fs/nfsd/filecache.c b/fs/nfsd/filecache.c
index 377d8211200ff..5a09b76ae25a8 100644
--- a/fs/nfsd/filecache.c
+++ b/fs/nfsd/filecache.c
@@ -42,6 +42,7 @@ struct nfsd_fcache_bucket {
 };
 
 static DEFINE_PER_CPU(unsigned long, nfsd_file_cache_hits);
+static DEFINE_PER_CPU(unsigned long, nfsd_file_acquisitions);
 
 struct nfsd_fcache_disposal {
 	struct work_struct work;
@@ -954,6 +955,8 @@ nfsd_do_file_acquire(struct svc_rqst *rqstp, struct svc_fh *fhp,
 	status = nfserrno(nfsd_open_break_lease(file_inode(nf->nf_file), may_flags));
 out:
 	if (status == nfs_ok) {
+		if (open)
+			this_cpu_inc(nfsd_file_acquisitions);
 		*pnf = nf;
 	} else {
 		nfsd_file_put(nf);
@@ -1046,8 +1049,9 @@ nfsd_file_create(struct svc_rqst *rqstp, struct svc_fh *fhp,
  */
 static int nfsd_file_cache_stats_show(struct seq_file *m, void *v)
 {
+	unsigned long hits = 0, acquisitions = 0;
 	unsigned int i, count = 0, longest = 0;
-	unsigned long lru = 0, hits = 0;
+	unsigned long lru = 0;
 
 	/*
 	 * No need for spinlocks here since we're not terribly interested in
@@ -1064,13 +1068,16 @@ static int nfsd_file_cache_stats_show(struct seq_file *m, void *v)
 	}
 	mutex_unlock(&nfsd_mutex);
 
-	for_each_possible_cpu(i)
+	for_each_possible_cpu(i) {
 		hits += per_cpu(nfsd_file_cache_hits, i);
+		acquisitions += per_cpu(nfsd_file_acquisitions, i);
+	}
 
 	seq_printf(m, "total entries: %u\n", count);
 	seq_printf(m, "longest chain: %u\n", longest);
 	seq_printf(m, "lru entries:   %lu\n", lru);
 	seq_printf(m, "cache hits:    %lu\n", hits);
+	seq_printf(m, "acquisitions:  %lu\n", acquisitions);
 	return 0;
 }
 
-- 
2.43.0



