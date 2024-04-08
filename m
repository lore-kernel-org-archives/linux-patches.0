Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AD64524AF;
	Mon,  8 Apr 2024 13:51:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712584277; cv=none; b=r3uUgW3f9+epM7pEA8bJCiLnQBZtQGVvdeC1i1nSzYZB9a2U6w+hkGQ6FZv+6YBmRes62q0kMgDVuHjFU2HZQF2bPEbn0dWJpmw7n+mbHQRXkV0x8Q5S/KRr3vhPD6mLFJtpk1iv12WF0q+6IF6Dls6Sv4uCUj5/dCH7bHQga4s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712584277; c=relaxed/simple;
	bh=CIBIvxI08PPt2PLm6zejwgtQTBgE00ZYURr4BXRF2Io=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X1DaxKzHnLkhXeo3Ng948jRcWWSfKaCZROI1e38tgKbqtLNYYoYP1/Xp6QFdlv7+zMMgozWRPzHPqSBon5pC8gOBPiTId4KcbsNrWF8Sgj0DOtDPUX5yP7HtydjO1lciBovv/AcPJinQs6zsLGdxRbsZ9QpCWVfzgtFO+c2cFQM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pAG+g4Lk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pAG+g4Lk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 894EAC433C7;
	Mon,  8 Apr 2024 13:51:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712584276;
	bh=CIBIvxI08PPt2PLm6zejwgtQTBgE00ZYURr4BXRF2Io=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pAG+g4Lk3SBuqHtFxclPP/lWkweZfUiaQEm2WsW+41VJeNPYIynE9q0Qvkn2mcT51
	 A1Y8lXEQiAcGS2wmeDemfNrTTXvIi6jp53hYnvlpcRIL9Y2fc33WDDzzHQKfMOOgBl
	 oRCA5azjtPo2SbXT3lcIVHuRu0ah4xGmQbiyaDec=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.15 348/690] NFSD: Report count of freed filecache items
Date: Mon,  8 Apr 2024 14:53:34 +0200
Message-ID: <20240408125412.206534910@linuxfoundation.org>
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

[ Upstream commit d63293272abb51c02457f1017dfd61c3270d9ae3 ]

Surface the count of freed nfsd_file items.

Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 fs/nfsd/filecache.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/fs/nfsd/filecache.c b/fs/nfsd/filecache.c
index 5a09b76ae25a8..5d31622c23040 100644
--- a/fs/nfsd/filecache.c
+++ b/fs/nfsd/filecache.c
@@ -43,6 +43,7 @@ struct nfsd_fcache_bucket {
 
 static DEFINE_PER_CPU(unsigned long, nfsd_file_cache_hits);
 static DEFINE_PER_CPU(unsigned long, nfsd_file_acquisitions);
+static DEFINE_PER_CPU(unsigned long, nfsd_file_releases);
 
 struct nfsd_fcache_disposal {
 	struct work_struct work;
@@ -195,6 +196,8 @@ nfsd_file_free(struct nfsd_file *nf)
 {
 	bool flush = false;
 
+	this_cpu_inc(nfsd_file_releases);
+
 	trace_nfsd_file_put_final(nf);
 	if (nf->nf_mark)
 		nfsd_file_mark_put(nf->nf_mark);
@@ -1049,7 +1052,7 @@ nfsd_file_create(struct svc_rqst *rqstp, struct svc_fh *fhp,
  */
 static int nfsd_file_cache_stats_show(struct seq_file *m, void *v)
 {
-	unsigned long hits = 0, acquisitions = 0;
+	unsigned long hits = 0, acquisitions = 0, releases = 0;
 	unsigned int i, count = 0, longest = 0;
 	unsigned long lru = 0;
 
@@ -1071,6 +1074,7 @@ static int nfsd_file_cache_stats_show(struct seq_file *m, void *v)
 	for_each_possible_cpu(i) {
 		hits += per_cpu(nfsd_file_cache_hits, i);
 		acquisitions += per_cpu(nfsd_file_acquisitions, i);
+		releases += per_cpu(nfsd_file_releases, i);
 	}
 
 	seq_printf(m, "total entries: %u\n", count);
@@ -1078,6 +1082,7 @@ static int nfsd_file_cache_stats_show(struct seq_file *m, void *v)
 	seq_printf(m, "lru entries:   %lu\n", lru);
 	seq_printf(m, "cache hits:    %lu\n", hits);
 	seq_printf(m, "acquisitions:  %lu\n", acquisitions);
+	seq_printf(m, "releases:      %lu\n", releases);
 	return 0;
 }
 
-- 
2.43.0



