Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 263596A352;
	Mon,  8 Apr 2024 13:51:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712584274; cv=none; b=rPyhJmJB9vFNJdyDuKopSe0WeehU+QRSjJxzfmdZmRodlnk844OlaEK49RE7ecnnjbBvt/ZRYWnGaj/Fq8GdAt7i4buYEoH2AzCo6yEZGAc1FI4ZnKk9wbQeNcwlWivwFjlX6OM364LKxHGqJOr6mSrxmdp2wn8CpXI4538LCWU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712584274; c=relaxed/simple;
	bh=atHFKKnQZbeJzJtHdKYEYlRt3PurPUys0b37p/TbpFk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XbqvZS0Sda61OGNBeRNqZRTxFMCPZusE77usNXfm0VSQ1UZAROgQJACkn2nO7o5O9S6lenLhqSsp/GbD4rYpJXm1rgvuQApK2JVeJ8f/FDbRvatcOtPxCxwQ782vgQm+5/KhDXH2gL9zci9qSQW5ZW7Hm+51J+f/dwf/nnstJpw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=isd2qGlj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="isd2qGlj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A251BC433C7;
	Mon,  8 Apr 2024 13:51:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712584274;
	bh=atHFKKnQZbeJzJtHdKYEYlRt3PurPUys0b37p/TbpFk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=isd2qGljJTvp5Png6XZaMJM817kdFVObuE2FiKD3MX8W7CMiOPh/gKFT6fazwgZ0c
	 V5wItPYaHeJRLOs1kvyoQ15HYNIxG/CHIlW5yOS3naaMFv1erQMGHSVz8pE3pxaRP2
	 hxXrXFZdy1XMXU4R6L6dxXeaOfU9gfMtukA1irJ4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.15 347/690] NFSD: Report count of calls to nfsd_file_acquire()
Date: Mon,  8 Apr 2024 14:53:33 +0200
Message-ID: <20240408125412.172866983@linuxfoundation.org>
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

[ Upstream commit 29d4bdbbb910f33d6058d2c51278f00f656df325 ]

Count the number of successful acquisitions that did not create a
file (ie, acquisitions that do not result in a compulsory cache
miss). This count can be compared directly with the reported hit
count to compute a hit ratio.

Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
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



