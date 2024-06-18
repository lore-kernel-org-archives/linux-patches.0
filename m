Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B5E21586D5;
	Tue, 18 Jun 2024 13:09:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718716189; cv=none; b=Cr7neH9I/LPLae7mc4Q8ifsZDQPETQN3QEwdFhzugccrUPuL2bATuM+KfFNMBk4rGtWJPCRPIj/c6ofJM9rs/ea4npWbIZHqOvyX+xfITvqj48BbpRL1xqQLQAXryXeSk9YrNOS0FI+rU3v0Yrclhz0lFGVZSgIM3f9TcH1F9OI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718716189; c=relaxed/simple;
	bh=zhvat2V2jzxbsvI29uTaYCRrQg5xWhCihQXjzghrKEU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mrDB5yAiduj48OrJ2RhdoNXlRFPAF1213dngPtXttNvkA0K6KijGcGV1LTjdmDsBdL7R543CnZg9aNj86Lug/tAxVR48UDhR23m3K25ey7wCtb1XbyekSeNisAY0IPM664PoNujKwGLyo6WzQOC0G5ugXNkN8O9OPsumCiohXZQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v7P9ZQu2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v7P9ZQu2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3120C3277B;
	Tue, 18 Jun 2024 13:09:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718716189;
	bh=zhvat2V2jzxbsvI29uTaYCRrQg5xWhCihQXjzghrKEU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=v7P9ZQu2y4WibxJSwM1V2vSTh/Sll6WfpoqsAHQ4YrxKoAfJh9Y2ovmvynfZOcg8O
	 FOJ7QgR93axa9VZXEks2cNrAwSXMuRJCFPIM4Oeld3qGVsd1ILgeI1ltOSAhAxm4qc
	 GrrCWwNdTlYUqOGSwVQcfz8AuVe7ACyvQWtOxhH4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 563/770] NFSD: Record number of flush calls
Date: Tue, 18 Jun 2024 14:36:56 +0200
Message-ID: <20240618123429.031975175@linuxfoundation.org>
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

[ Upstream commit df2aff524faceaf743b7c5ab0f4fb86cb511f782 ]

Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/filecache.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/fs/nfsd/filecache.c b/fs/nfsd/filecache.c
index e5bd9f06492c8..b9941d4ef20d6 100644
--- a/fs/nfsd/filecache.c
+++ b/fs/nfsd/filecache.c
@@ -45,6 +45,7 @@ static DEFINE_PER_CPU(unsigned long, nfsd_file_cache_hits);
 static DEFINE_PER_CPU(unsigned long, nfsd_file_acquisitions);
 static DEFINE_PER_CPU(unsigned long, nfsd_file_releases);
 static DEFINE_PER_CPU(unsigned long, nfsd_file_total_age);
+static DEFINE_PER_CPU(unsigned long, nfsd_file_pages_flushed);
 static DEFINE_PER_CPU(unsigned long, nfsd_file_evictions);
 
 struct nfsd_fcache_disposal {
@@ -242,7 +243,12 @@ nfsd_file_check_write_error(struct nfsd_file *nf)
 static void
 nfsd_file_flush(struct nfsd_file *nf)
 {
-	if (nf->nf_file && vfs_fsync(nf->nf_file, 1) != 0)
+	struct file *file = nf->nf_file;
+
+	if (!file || !(file->f_mode & FMODE_WRITE))
+		return;
+	this_cpu_add(nfsd_file_pages_flushed, file->f_mapping->nrpages);
+	if (vfs_fsync(file, 1) != 0)
 		nfsd_reset_write_verifier(net_generic(nf->nf_net, nfsd_net_id));
 }
 
@@ -1069,7 +1075,8 @@ nfsd_file_create(struct svc_rqst *rqstp, struct svc_fh *fhp,
  */
 static int nfsd_file_cache_stats_show(struct seq_file *m, void *v)
 {
-	unsigned long hits = 0, acquisitions = 0, releases = 0, evictions = 0;
+	unsigned long releases = 0, pages_flushed = 0, evictions = 0;
+	unsigned long hits = 0, acquisitions = 0;
 	unsigned int i, count = 0, longest = 0;
 	unsigned long lru = 0, total_age = 0;
 
@@ -1094,6 +1101,7 @@ static int nfsd_file_cache_stats_show(struct seq_file *m, void *v)
 		releases += per_cpu(nfsd_file_releases, i);
 		total_age += per_cpu(nfsd_file_total_age, i);
 		evictions += per_cpu(nfsd_file_evictions, i);
+		pages_flushed += per_cpu(nfsd_file_pages_flushed, i);
 	}
 
 	seq_printf(m, "total entries: %u\n", count);
@@ -1107,6 +1115,7 @@ static int nfsd_file_cache_stats_show(struct seq_file *m, void *v)
 		seq_printf(m, "mean age (ms): %ld\n", total_age / releases);
 	else
 		seq_printf(m, "mean age (ms): -\n");
+	seq_printf(m, "pages flushed: %lu\n", pages_flushed);
 	return 0;
 }
 
-- 
2.43.0



