Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C17D78612E;
	Mon,  8 Apr 2024 13:30:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712583020; cv=none; b=uED1X6SuyauMWpODWSCI6lg8Jwp+kCW9WaGeq3YdqIU4odzTwYf3x3sTjic1nDplRQQ6E7tuCIGCA/8fIfiiyWS7eyO0kvZ3caZoRBks8fCXigM2zgMP1Ml6EHZcVrUZIg93pv4RMsvFRntFfODkITatDeji7tAt00F/jdK6mfc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712583020; c=relaxed/simple;
	bh=IgXTZSnquIkKQ/Awx/32T4T5HiWQkzt2Xoezqy2KUQg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EJ9YGhojQt2bBGIL9yGt3gWCycUwiXeH4DS1i4pgASSI8nc76upKZkYNCQc28dlElmSSA/pdhyUMiPXe3o4PT7Y/0kTsU3xlSKcF0XljNWkIgEjug8VdVbqJGHDlidpAh30u1/cBpqiniYq9s4OJdVGWAaAhmVR63w1RrfCnJNI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rJytboS+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rJytboS+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CE47C43390;
	Mon,  8 Apr 2024 13:30:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712583020;
	bh=IgXTZSnquIkKQ/Awx/32T4T5HiWQkzt2Xoezqy2KUQg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rJytboS+C8HQPfG8zG7LxnIsoVzsMbCTnIpQUkT/+SUyBo0tKgdvg+E/V4x2xtp7A
	 fr6mHq1XEZ7ZuUgoKbLYKaY/SsA+fEpkdZOZbc2iJ6+C0rWyM8pA6r/7BYEFDelA/u
	 px2dUNIsUP1Y0jBl0b77ereb80NXTxyn3hAzpAc0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	"J. Bruce Fields" <bfields@redhat.com>
Subject: [PATCH 5.15 199/690] NFSD: Optimize DRC bucket pruning
Date: Mon,  8 Apr 2024 14:51:05 +0200
Message-ID: <20240408125406.753691834@linuxfoundation.org>
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

[ Upstream commit 8847ecc9274a14114385d1cb4030326baa0766eb ]

DRC bucket pruning is done by nfsd_cache_lookup(), which is part of
every NFSv2 and NFSv3 dispatch (ie, it's done while the client is
waiting).

I added a trace_printk() in prune_bucket() to see just how long
it takes to prune. Here are two ends of the spectrum:

 prune_bucket: Scanned 1 and freed 0 in 90 ns, 62 entries remaining
 prune_bucket: Scanned 2 and freed 1 in 716 ns, 63 entries remaining
...
 prune_bucket: Scanned 75 and freed 74 in 34149 ns, 1 entries remaining

Pruning latency is noticeable on fast transports with fast storage.
By noticeable, I mean that the latency measured here in the worst
case is the same order of magnitude as the round trip time for
cached server operations.

We could do something like moving expired entries to an expired list
and then free them later instead of freeing them right in
prune_bucket(). But simply limiting the number of entries that can
be pruned by a lookup is simple and retains more entries in the
cache, making the DRC somewhat more effective.

Comparison with a 70/30 fio 8KB 12 thread direct I/O test:

Before:

  write: IOPS=61.6k, BW=481MiB/s (505MB/s)(14.1GiB/30001msec); 0 zone resets

WRITE:
        1848726 ops (30%)
        avg bytes sent per op: 8340 avg bytes received per op: 136
        backlog wait: 0.635158  RTT: 0.128525   total execute time: 0.827242 (milliseconds)

After:

  write: IOPS=63.0k, BW=492MiB/s (516MB/s)(14.4GiB/30001msec); 0 zone resets

WRITE:
        1891144 ops (30%)
        avg bytes sent per op: 8340 avg bytes received per op: 136
        backlog wait: 0.616114  RTT: 0.126842   total execute time: 0.805348 (milliseconds)

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 fs/nfsd/nfscache.c | 17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff --git a/fs/nfsd/nfscache.c b/fs/nfsd/nfscache.c
index 830bb8493c7fd..6b9ef15c9c03b 100644
--- a/fs/nfsd/nfscache.c
+++ b/fs/nfsd/nfscache.c
@@ -241,8 +241,8 @@ lru_put_end(struct nfsd_drc_bucket *b, struct svc_cacherep *rp)
 	list_move_tail(&rp->c_lru, &b->lru_head);
 }
 
-static long
-prune_bucket(struct nfsd_drc_bucket *b, struct nfsd_net *nn)
+static long prune_bucket(struct nfsd_drc_bucket *b, struct nfsd_net *nn,
+			 unsigned int max)
 {
 	struct svc_cacherep *rp, *tmp;
 	long freed = 0;
@@ -258,11 +258,17 @@ prune_bucket(struct nfsd_drc_bucket *b, struct nfsd_net *nn)
 		    time_before(jiffies, rp->c_timestamp + RC_EXPIRE))
 			break;
 		nfsd_reply_cache_free_locked(b, rp, nn);
-		freed++;
+		if (max && freed++ > max)
+			break;
 	}
 	return freed;
 }
 
+static long nfsd_prune_bucket(struct nfsd_drc_bucket *b, struct nfsd_net *nn)
+{
+	return prune_bucket(b, nn, 3);
+}
+
 /*
  * Walk the LRU list and prune off entries that are older than RC_EXPIRE.
  * Also prune the oldest ones when the total exceeds the max number of entries.
@@ -279,7 +285,7 @@ prune_cache_entries(struct nfsd_net *nn)
 		if (list_empty(&b->lru_head))
 			continue;
 		spin_lock(&b->cache_lock);
-		freed += prune_bucket(b, nn);
+		freed += prune_bucket(b, nn, 0);
 		spin_unlock(&b->cache_lock);
 	}
 	return freed;
@@ -453,8 +459,7 @@ int nfsd_cache_lookup(struct svc_rqst *rqstp)
 	atomic_inc(&nn->num_drc_entries);
 	nfsd_stats_drc_mem_usage_add(nn, sizeof(*rp));
 
-	/* go ahead and prune the cache */
-	prune_bucket(b, nn);
+	nfsd_prune_bucket(b, nn);
 
 out_unlock:
 	spin_unlock(&b->cache_lock);
-- 
2.43.0



