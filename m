Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C90A158A27;
	Tue, 18 Jun 2024 13:09:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718716171; cv=none; b=jmBrGT8BceyHkExjLTlGkTFUNibrX/6dACark/IL//l92FuY9gABosarBHoL2ZmPKr2nD85dzdFcfFTad7rRGUvuogH8p94fsA723q6aDWKqZ7xIGln4eWyfuGZJwk9u6Cik05DAgpQSh/oRZDAFwIPEatADio/gjpi9HMsuvYM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718716171; c=relaxed/simple;
	bh=BSJW3soWbOrOvd4yDfRG43Kcr97J4xQqwFsi+r6O+Ag=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Hho/UpMzc7zBjMr8bVK/kp/Q50U8W5I1WQvLlqa3RRn8mPzGIZfiidOnSOD/AAf4A/MWxpvUnxWq+JyIePMUPyZgKMeXSEbzDW66hMQt5A9kiq31EIFeKb8m6VxE51NpwGL/XSUMs7ql0Dfedc3eZGqfzoYkfK/qKHn/C6vHHXo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nwB0dMxm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nwB0dMxm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1FC8C3277B;
	Tue, 18 Jun 2024 13:09:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718716171;
	bh=BSJW3soWbOrOvd4yDfRG43Kcr97J4xQqwFsi+r6O+Ag=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nwB0dMxmkTNTWgjPAN2wAQA5l3w3A/nfbUIUewVnW7pZfM2MaKKFRDY7DzRMK9uO9
	 w2mPf8HzpuYFBZSDQq0vU+veKZSz6iCyqu62bWCE1rCe2lnQL3OwUw4R2zNPKFG07F
	 VUlvuoB9IiTPZqYAk6XEEF2Q7TNqHtiy1OMZx2x8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 557/770] NFSD: Report count of freed filecache items
Date: Tue, 18 Jun 2024 14:36:50 +0200
Message-ID: <20240618123428.800772391@linuxfoundation.org>
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

[ Upstream commit d63293272abb51c02457f1017dfd61c3270d9ae3 ]

Surface the count of freed nfsd_file items.

Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
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



