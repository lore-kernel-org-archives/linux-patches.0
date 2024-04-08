Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04C3F7E0FF;
	Mon,  8 Apr 2024 13:49:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712584189; cv=none; b=jWpnDbqgZLwhrpicEU6gQ0XFR7xE3Y8heHIs0VYdsQIZXSiufGpn25zb/gpTHXcrNZ60FXX6QK0TTRoRXI3SGymtmnyt2XA41eJ7CAHSHvjY8t41G4DdM1Rh8tUZM8kOmHRLNQIZ9NPG8Sbv9nzzykie+z03zfxYDkAiQBNJIVw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712584189; c=relaxed/simple;
	bh=PTiQizZ0fl0LwQX1waSo7p0sT89PFNhbEVuc6UnZC4I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lcR8/zDDSsFJO0VvlPtsh6+rxQgOXgjMADuMWTgP2YjHAYRE3wrRz9xvUiAyyMBRcG9bfX4H5ZhinVAl+GV5bAWfy7UynDhuuLhHBuWQyqyBR38O++7IO25s4Pv8WvksreEVQuJFphWylisMWfd7BsOQxZDa/AjrJS6Oj4FP+EI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F1WnyzXP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F1WnyzXP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83327C433F1;
	Mon,  8 Apr 2024 13:49:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712584188;
	bh=PTiQizZ0fl0LwQX1waSo7p0sT89PFNhbEVuc6UnZC4I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F1WnyzXPY+rD49FvnimJtaQ86fo62COzXg2GUiOktGziS+ZXprHls480me1+4VAFQ
	 ZhqWHVqY3qMlmrZWiHWmhUmJ0/zqD1aA4DDB5aaY+IFgPpX7VHMjbmBr7kudf60smJ
	 C2Skavn32ktsoC7V6i7T25uUTnFc5+HHDOKCMNHI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.15 354/690] NFSD: Record number of flush calls
Date: Mon,  8 Apr 2024 14:53:40 +0200
Message-ID: <20240408125412.424212462@linuxfoundation.org>
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

[ Upstream commit df2aff524faceaf743b7c5ab0f4fb86cb511f782 ]

Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
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



