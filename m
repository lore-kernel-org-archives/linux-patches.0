Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECABD524AF;
	Mon,  8 Apr 2024 13:51:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712584280; cv=none; b=teXNQsQ02dAWzXTnpQYrOlUN6/VhLHVW9Z3gxhh0VnFe2sCBgv+YRrMSozqpFWwKfy30llVLXzcuXnmFVegGEJbCSl7IkzLr9DXbKN3xD4MnMzblf5r1oblU6vtKpANibSRg4lgRZTdR8bcWEsuy0SaHTn2nMZzIIA3sYkfD9FA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712584280; c=relaxed/simple;
	bh=zdeaHe2zfdtkhK1rUWndapqQU6w8wAkDa3gjwme50yc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uKcmncgtF1N6axew4Pq7HS1W7J7dV3rorXHPjQHMo6MCxu1IdIJSG7FA1yT1UrOCACWbbPUyv+n1D4lcauh2XuhBXaN0Ltx1ThM8hNsgfpYjwKewTYW93TzDx24vBFHD9P1gm7WDrUsEwwBdXIzboikU0nzJrsGCL6vXk/eT5Fw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qJUmOloe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qJUmOloe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 720C2C433C7;
	Mon,  8 Apr 2024 13:51:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712584279;
	bh=zdeaHe2zfdtkhK1rUWndapqQU6w8wAkDa3gjwme50yc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qJUmOloeY/cKO94M3tGstNnpmoOewZ7PJfwjQx3NBFpMdrG4vyPSWsmYC0sWM8LRb
	 HumwMUQ3ihc7D3fpc1zj9qc5lAE2ZKgKb91VDK6ckvwB4iFI81HuJY2wlxu4PaqTPO
	 1nlO8bTPiBhjsEqi34QmT/1NuqVs+8C9pKJ6ickk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.15 349/690] NFSD: Report average age of filecache items
Date: Mon,  8 Apr 2024 14:53:35 +0200
Message-ID: <20240408125412.246520759@linuxfoundation.org>
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

[ Upstream commit 904940e94a887701db24401e3ed6928a1d4e329f ]

This is a measure of how long items stay in the filecache, to help
assess how efficient the cache is.

Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
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



