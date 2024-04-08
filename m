Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B58D86A342;
	Mon,  8 Apr 2024 13:50:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712584209; cv=none; b=BSJCUly1MRoi/EvO9XtgjgKUTd/WdnIx/gfqs/gay5xjwau2tM5traaDF+GWckprMuUiEi2eUNqtOxe8jLzcY6kt84g9h0MLXAMpw8yIyz4Qa9ASoEiOyfxIWlWggOw2VyfkdkGW3yTHU+sWsz6pLoirvV5UqfKJ6yWYgLwLkTI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712584209; c=relaxed/simple;
	bh=EuU/gQM8JEgaY2YlESz3ouch6ZhGX2sa/sm8cjLAwQQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nNC5x/+7MBm5/JFboTr93jyL+J0hlWEn8K70One4KmGpzsI2+TKCd0OH5FIwv1v3YKbeiRt50sDDz1EHzF1h8UJQouKXwlUrFOer8upWB/hJaOXUEMVBLomwZ2Ooz7pQb5Sp9KX38wruxO/DJ/Lz5ytOePsXKURmyMa2tzOEuBc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YhlkehhB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YhlkehhB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 414FCC433F1;
	Mon,  8 Apr 2024 13:50:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712584209;
	bh=EuU/gQM8JEgaY2YlESz3ouch6ZhGX2sa/sm8cjLAwQQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YhlkehhBAdGPVRSae21SqJxDcSXgWiazk4f15bbdubzu/pGALcC6ZTjLTJFTt1Uvt
	 +7BXK1tWL6amya3edEMfUFFn5MfvU+2/siCsklyUhezexVHtWNdUKUIMLj545uPLCf
	 PMSpR9afTVoAIPPMa9UaqlJejDxt/0YqvW2UarB8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wang Yugui <wangyugui@e16-tech.com>,
	Dave Chinner <david@fromorbit.com>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.15 361/690] NFSD: Never call nfsd_file_gc() in foreground paths
Date: Mon,  8 Apr 2024 14:53:47 +0200
Message-ID: <20240408125412.664560963@linuxfoundation.org>
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

[ Upstream commit 6df19411367a5fb4ef61854cbd1af269c077f917 ]

The checks in nfsd_file_acquire() and nfsd_file_put() that directly
invoke filecache garbage collection are intended to keep cache
occupancy between a low- and high-watermark. The reason to limit the
capacity of the filecache is to keep filecache lookups reasonably
fast.

However, invoking garbage collection at those points has some
undesirable negative impacts. Files that are held open by NFSv4
clients often push the occupancy of the filecache over these
watermarks. At that point:

- Every call to nfsd_file_acquire() and nfsd_file_put() results in
  an LRU walk. This has the same effect on lookup latency as long
  chains in the hash table.
- Garbage collection will then run on every nfsd thread, causing a
  lot of unnecessary lock contention.
- Limiting cache capacity pushes out files used only by NFSv3
  clients, which are the type of files the filecache is supposed to
  help.

To address those negative impacts, remove the direct calls to the
garbage collector. Subsequent patches will address maintaining
lookup efficiency as cache capacity increases.

Suggested-by: Wang Yugui <wangyugui@e16-tech.com>
Suggested-by: Dave Chinner <david@fromorbit.com>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 fs/nfsd/filecache.c | 10 +---------
 1 file changed, 1 insertion(+), 9 deletions(-)

diff --git a/fs/nfsd/filecache.c b/fs/nfsd/filecache.c
index 849c010c6ef61..7a02ff11b9ec1 100644
--- a/fs/nfsd/filecache.c
+++ b/fs/nfsd/filecache.c
@@ -28,8 +28,6 @@
 #define NFSD_LAUNDRETTE_DELAY		     (2 * HZ)
 
 #define NFSD_FILE_SHUTDOWN		     (1)
-#define NFSD_FILE_LRU_THRESHOLD		     (4096UL)
-#define NFSD_FILE_LRU_LIMIT		     (NFSD_FILE_LRU_THRESHOLD << 2)
 
 /* We only care about NFSD_MAY_READ/WRITE for this cache */
 #define NFSD_FILE_MAY_MASK	(NFSD_MAY_READ|NFSD_MAY_WRITE)
@@ -65,8 +63,6 @@ static struct fsnotify_group		*nfsd_file_fsnotify_group;
 static atomic_long_t			nfsd_filecache_count;
 static struct delayed_work		nfsd_filecache_laundrette;
 
-static void nfsd_file_gc(void);
-
 static void
 nfsd_file_schedule_laundrette(void)
 {
@@ -343,9 +339,6 @@ nfsd_file_put(struct nfsd_file *nf)
 		nfsd_file_schedule_laundrette();
 	} else
 		nfsd_file_put_noref(nf);
-
-	if (atomic_long_read(&nfsd_filecache_count) >= NFSD_FILE_LRU_LIMIT)
-		nfsd_file_gc();
 }
 
 struct nfsd_file *
@@ -1054,8 +1047,7 @@ nfsd_do_file_acquire(struct svc_rqst *rqstp, struct svc_fh *fhp,
 	nfsd_file_hashtbl[hashval].nfb_maxcount = max(nfsd_file_hashtbl[hashval].nfb_maxcount,
 			nfsd_file_hashtbl[hashval].nfb_count);
 	spin_unlock(&nfsd_file_hashtbl[hashval].nfb_lock);
-	if (atomic_long_inc_return(&nfsd_filecache_count) >= NFSD_FILE_LRU_THRESHOLD)
-		nfsd_file_gc();
+	atomic_long_inc(&nfsd_filecache_count);
 
 	nf->nf_mark = nfsd_file_mark_find_or_create(nf);
 	if (nf->nf_mark) {
-- 
2.43.0



