Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40D701A0B1A;
	Tue, 18 Jun 2024 13:11:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718716261; cv=none; b=Sdovy9nOBI7w4p+Ao3fab8d0U/wZ1y36HwS7kxBwA82em5DyXWHqEdHHh4/k5soW4P6uxFHiTpc/xwcAMveuctBg936jDJTqe5YpUFEiRYeW3DHhjGuHBufz+2tUGdUQ7dbsjsYzl8oj49LoDhDVZ5279zobWynEtqMzcb5Zkko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718716261; c=relaxed/simple;
	bh=1nErkLbeNLHWavVPS5mthYQUtJjICD9DDvfdrhKZQ24=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mDQiecM8TwfuMxWESJiDCVbillIDOPqbJkS+4qqYnD+Ii3d6n2EDV9y+n6teFyd+Uj/r6ibTnEDgNBCXcSh+4GpWynPAyNRzefcxeFOLIno6AwcjU5xpP79YXABYrgn0Dp3ynvZWQRglRh2kkvT21N+B+PbbreisMQDtaAmj/M0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lfS8r4e/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lfS8r4e/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9591C3277B;
	Tue, 18 Jun 2024 13:11:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718716261;
	bh=1nErkLbeNLHWavVPS5mthYQUtJjICD9DDvfdrhKZQ24=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lfS8r4e/fyYvRZ/ODojUF+bEK1W9ijHBcWYfztkRxGOkKJigJegZKxNSAH38xWKFr
	 d2Z9EatjHP0rrwetEMh0AqcF+xmMZr9/WF+JxxAYhJtu7vJM66zWuJh35GrOfxoUuR
	 3PsVUHcHue9QVPI040HNrankrfS57kGvtbEi/xQc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 555/770] NFSD: Report filecache LRU size
Date: Tue, 18 Jun 2024 14:36:48 +0200
Message-ID: <20240618123428.723820896@linuxfoundation.org>
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

[ Upstream commit 0fd244c115f0321fc5e34ad2291f2a572508e3f7 ]

Surface the NFSD filecache's LRU list length to help field
troubleshooters monitor filecache issues.

Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/filecache.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/nfsd/filecache.c b/fs/nfsd/filecache.c
index 1d3d13b78be0e..377d8211200ff 100644
--- a/fs/nfsd/filecache.c
+++ b/fs/nfsd/filecache.c
@@ -1047,7 +1047,7 @@ nfsd_file_create(struct svc_rqst *rqstp, struct svc_fh *fhp,
 static int nfsd_file_cache_stats_show(struct seq_file *m, void *v)
 {
 	unsigned int i, count = 0, longest = 0;
-	unsigned long hits = 0;
+	unsigned long lru = 0, hits = 0;
 
 	/*
 	 * No need for spinlocks here since we're not terribly interested in
@@ -1060,6 +1060,7 @@ static int nfsd_file_cache_stats_show(struct seq_file *m, void *v)
 			count += nfsd_file_hashtbl[i].nfb_count;
 			longest = max(longest, nfsd_file_hashtbl[i].nfb_count);
 		}
+		lru = list_lru_count(&nfsd_file_lru);
 	}
 	mutex_unlock(&nfsd_mutex);
 
@@ -1068,6 +1069,7 @@ static int nfsd_file_cache_stats_show(struct seq_file *m, void *v)
 
 	seq_printf(m, "total entries: %u\n", count);
 	seq_printf(m, "longest chain: %u\n", longest);
+	seq_printf(m, "lru entries:   %lu\n", lru);
 	seq_printf(m, "cache hits:    %lu\n", hits);
 	return 0;
 }
-- 
2.43.0



