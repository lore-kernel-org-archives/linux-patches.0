Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCF141AB910;
	Tue, 18 Jun 2024 13:16:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718716616; cv=none; b=CZ19v7fFKBlQg+OpwhiBAUoH71Tkgb5BMWM/5gtQfJ6yxZb+oMZGAx0xQmDdSY7kh0bpJl5H0BAlZP7l9SmjCPQeR65PGxFbOOmkDXbnGQUYQ4pewLdmDGeK37Sg80KRE9+ikkDofGoheeet3SWbA7YyTdTl1PPJZzqgwVDJL9U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718716616; c=relaxed/simple;
	bh=8Xv+PHKsGhYsKvJeuKKPa06mQckg4IyorfSguU0lCQc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g14m7hYAQyrMQAnFobojhFT2I9R9jBxHcVqSFK+FVnHWG08mN2kyf7+c5FeOWvMyyMUHDuqF1JpmLWK4X/dwJHAeuoZg/X8UNuJQvQVtFFVELBTfyAQUbBeOHHg8EtAO/LhvYh/EoAmmW65l8iRT8uqxQSjGeVHqWsNIzu3R/74=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oome0LgT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oome0LgT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53DE9C4AF49;
	Tue, 18 Jun 2024 13:16:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718716616;
	bh=8Xv+PHKsGhYsKvJeuKKPa06mQckg4IyorfSguU0lCQc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oome0LgTkHqs0+7Rn+0JzlAN5nH1jjANGEgeEztgEabcL4nSvpp50rTJ1xfERLrB2
	 uWEMjkpHyLGjbraS1uhRsGN/Dh4/GJlo1Axv4v0KECRsuh6D3cBZsIBJw+2HAj99le
	 74qif9iYrq4OWxazDC6st08pRxpbHd2mTQ2Azkqo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 705/770] nfsd: remove the pages_flushed statistic from filecache
Date: Tue, 18 Jun 2024 14:39:18 +0200
Message-ID: <20240618123434.485666600@linuxfoundation.org>
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

[ Upstream commit 1f696e230ea5198e393368b319eb55651828d687 ]

We're counting mapping->nrpages, but not all of those are necessarily
dirty. We don't really have a simple way to count just the dirty pages,
so just remove this stat since it's not accurate.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/filecache.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/fs/nfsd/filecache.c b/fs/nfsd/filecache.c
index b43d2d7ac5957..b95b1be5b2e43 100644
--- a/fs/nfsd/filecache.c
+++ b/fs/nfsd/filecache.c
@@ -57,7 +57,6 @@ static DEFINE_PER_CPU(unsigned long, nfsd_file_cache_hits);
 static DEFINE_PER_CPU(unsigned long, nfsd_file_acquisitions);
 static DEFINE_PER_CPU(unsigned long, nfsd_file_releases);
 static DEFINE_PER_CPU(unsigned long, nfsd_file_total_age);
-static DEFINE_PER_CPU(unsigned long, nfsd_file_pages_flushed);
 static DEFINE_PER_CPU(unsigned long, nfsd_file_evictions);
 
 struct nfsd_fcache_disposal {
@@ -395,7 +394,6 @@ nfsd_file_flush(struct nfsd_file *nf)
 
 	if (!file || !(file->f_mode & FMODE_WRITE))
 		return;
-	this_cpu_add(nfsd_file_pages_flushed, file->f_mapping->nrpages);
 	if (vfs_fsync(file, 1) != 0)
 		nfsd_reset_write_verifier(net_generic(nf->nf_net, nfsd_net_id));
 }
@@ -1022,7 +1020,6 @@ nfsd_file_cache_shutdown(void)
 		per_cpu(nfsd_file_acquisitions, i) = 0;
 		per_cpu(nfsd_file_releases, i) = 0;
 		per_cpu(nfsd_file_total_age, i) = 0;
-		per_cpu(nfsd_file_pages_flushed, i) = 0;
 		per_cpu(nfsd_file_evictions, i) = 0;
 	}
 }
@@ -1237,7 +1234,7 @@ nfsd_file_create(struct svc_rqst *rqstp, struct svc_fh *fhp,
  */
 int nfsd_file_cache_stats_show(struct seq_file *m, void *v)
 {
-	unsigned long releases = 0, pages_flushed = 0, evictions = 0;
+	unsigned long releases = 0, evictions = 0;
 	unsigned long hits = 0, acquisitions = 0;
 	unsigned int i, count = 0, buckets = 0;
 	unsigned long lru = 0, total_age = 0;
@@ -1265,7 +1262,6 @@ int nfsd_file_cache_stats_show(struct seq_file *m, void *v)
 		releases += per_cpu(nfsd_file_releases, i);
 		total_age += per_cpu(nfsd_file_total_age, i);
 		evictions += per_cpu(nfsd_file_evictions, i);
-		pages_flushed += per_cpu(nfsd_file_pages_flushed, i);
 	}
 
 	seq_printf(m, "total entries: %u\n", count);
@@ -1279,6 +1275,5 @@ int nfsd_file_cache_stats_show(struct seq_file *m, void *v)
 		seq_printf(m, "mean age (ms): %ld\n", total_age / releases);
 	else
 		seq_printf(m, "mean age (ms): -\n");
-	seq_printf(m, "pages flushed: %lu\n", pages_flushed);
 	return 0;
 }
-- 
2.43.0



