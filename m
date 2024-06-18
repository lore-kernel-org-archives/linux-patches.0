Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39A201A01C4;
	Tue, 18 Jun 2024 13:09:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718716174; cv=none; b=KbcOax2Sj/EjGZeLrP1+IP/kbOK5QgsdeO1B14+AbgkkDaO2FkjxkAHOqBLf9xvfMPflK4VJMiIIAfqGxz8b1igCweH7bPO/3whHF3lZg1aLRKcs0M81ow6lL6HIrcxAGUqARKbIlxTj5RbgmXtgfYFT/9E9Ru0PNliGXDkyzzo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718716174; c=relaxed/simple;
	bh=NimuYT60MpLGhd7BqXHCv581JT6lqugKLMrKDBWuLMo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k7KxrTFkYheH6Z7EL6FIH5v0tcHqktmZgsWISOK330m8ePi8yUoZ8o+CYb3e/5Hk1/1/zx0M559e8k0lBlR+MZjvNT75uJOZRggvq9ftQdREmcJcKpIcPo1xDmN2J7pPvDxcEGkc5XYG4bfbrI1a0/MBevBu/2LblJh6THY9cdw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wdI3OvHr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wdI3OvHr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B189AC3277B;
	Tue, 18 Jun 2024 13:09:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718716174;
	bh=NimuYT60MpLGhd7BqXHCv581JT6lqugKLMrKDBWuLMo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wdI3OvHrv7WAa8lYMfNUD4XG6Soe+lzRQmf0t9Ns2LhokdZ6me8oAtlxS1XGXb+3x
	 CVh6bOm35Mke1MPtbpcl0BpaCKQwOMEFF40U06R0Ja83Vjo7C+BDXYkzFDGdw18llD
	 bNbXoF720Xa3oj5rhSmlnvXiJMBqri5OZjQnQoIA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 558/770] NFSD: Report average age of filecache items
Date: Tue, 18 Jun 2024 14:36:51 +0200
Message-ID: <20240618123428.840381226@linuxfoundation.org>
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

[ Upstream commit 904940e94a887701db24401e3ed6928a1d4e329f ]

This is a measure of how long items stay in the filecache, to help
assess how efficient the cache is.

Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/filecache.c | 11 ++++++++++-
 fs/nfsd/filecache.h |  1 +
 2 files changed, 11 insertions(+), 1 deletion(-)

diff --git a/fs/nfsd/filecache.c b/fs/nfsd/filecache.c
index 5d31622c23040..0cd72c20fc12d 100644
--- a/fs/nfsd/filecache.c
+++ b/fs/nfsd/filecache.c
@@ -44,6 +44,7 @@ struct nfsd_fcache_bucket {
 static DEFINE_PER_CPU(unsigned long, nfsd_file_cache_hits);
 static DEFINE_PER_CPU(unsigned long, nfsd_file_acquisitions);
 static DEFINE_PER_CPU(unsigned long, nfsd_file_releases);
+static DEFINE_PER_CPU(unsigned long, nfsd_file_total_age);
 
 struct nfsd_fcache_disposal {
 	struct work_struct work;
@@ -177,6 +178,7 @@ nfsd_file_alloc(struct inode *inode, unsigned int may, unsigned int hashval,
 	if (nf) {
 		INIT_HLIST_NODE(&nf->nf_node);
 		INIT_LIST_HEAD(&nf->nf_lru);
+		nf->nf_birthtime = ktime_get();
 		nf->nf_file = NULL;
 		nf->nf_cred = get_current_cred();
 		nf->nf_net = net;
@@ -194,9 +196,11 @@ nfsd_file_alloc(struct inode *inode, unsigned int may, unsigned int hashval,
 static bool
 nfsd_file_free(struct nfsd_file *nf)
 {
+	s64 age = ktime_to_ms(ktime_sub(ktime_get(), nf->nf_birthtime));
 	bool flush = false;
 
 	this_cpu_inc(nfsd_file_releases);
+	this_cpu_add(nfsd_file_total_age, age);
 
 	trace_nfsd_file_put_final(nf);
 	if (nf->nf_mark)
@@ -1054,7 +1058,7 @@ static int nfsd_file_cache_stats_show(struct seq_file *m, void *v)
 {
 	unsigned long hits = 0, acquisitions = 0, releases = 0;
 	unsigned int i, count = 0, longest = 0;
-	unsigned long lru = 0;
+	unsigned long lru = 0, total_age = 0;
 
 	/*
 	 * No need for spinlocks here since we're not terribly interested in
@@ -1075,6 +1079,7 @@ static int nfsd_file_cache_stats_show(struct seq_file *m, void *v)
 		hits += per_cpu(nfsd_file_cache_hits, i);
 		acquisitions += per_cpu(nfsd_file_acquisitions, i);
 		releases += per_cpu(nfsd_file_releases, i);
+		total_age += per_cpu(nfsd_file_total_age, i);
 	}
 
 	seq_printf(m, "total entries: %u\n", count);
@@ -1083,6 +1088,10 @@ static int nfsd_file_cache_stats_show(struct seq_file *m, void *v)
 	seq_printf(m, "cache hits:    %lu\n", hits);
 	seq_printf(m, "acquisitions:  %lu\n", acquisitions);
 	seq_printf(m, "releases:      %lu\n", releases);
+	if (releases)
+		seq_printf(m, "mean age (ms): %ld\n", total_age / releases);
+	else
+		seq_printf(m, "mean age (ms): -\n");
 	return 0;
 }
 
diff --git a/fs/nfsd/filecache.h b/fs/nfsd/filecache.h
index c9e3c6eb4776e..c6ad5fe47f12f 100644
--- a/fs/nfsd/filecache.h
+++ b/fs/nfsd/filecache.h
@@ -44,6 +44,7 @@ struct nfsd_file {
 	refcount_t		nf_ref;
 	unsigned char		nf_may;
 	struct nfsd_file_mark	*nf_mark;
+	ktime_t			nf_birthtime;
 };
 
 int nfsd_file_cache_init(void);
-- 
2.43.0



