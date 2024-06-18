Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 052A41A08AA;
	Tue, 18 Jun 2024 13:10:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718716210; cv=none; b=tpn8CoudPMReEp4bU4RGUxKPfnF17L1kqIRjaLt1TjBhi5VZl1gbVtyy6QvMJbDvh50z9EtK8o0puRtJstINUuYnUKt7ImFbOlw9iZodzojq+YOgIh3HTLGb7wMPi44MomxWNpqvcKAC54LMKYJ+p9WhntTuuHv9UspIFKwtadI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718716210; c=relaxed/simple;
	bh=IFS/KHkGXyQRtATwEHDvpvR4nr55iF+zTqCtvxcWEM8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aVjlmbri+QoyoBbwsHxKAYdFZtW5oX7s450oqha9lEAXxJZpm6iYHB2LRnSghLq+Lq9v88Kq64R9G6g5lSOpVGN7OQ51uUZy6D9LgZFKjhCsh7WOaoxDaESZWGYjOLf+G+h4WCjlPB8awbhfJoK2dGqY7aIViRg+tFtc1xTdoHs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=B7pf6e7t; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="B7pf6e7t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F93FC32786;
	Tue, 18 Jun 2024 13:10:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718716209;
	bh=IFS/KHkGXyQRtATwEHDvpvR4nr55iF+zTqCtvxcWEM8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=B7pf6e7teBJs8Kp6CKu/x8zXbS7U4+CjD9bHRUUPdpqrfEKTXThEWVE6EMLDrl+jJ
	 cCz7YMqL/Lt1v+vxt7lMNyhwud0wwoIHCj3p9YUqrc8q/KH3qi9bN3tToulNcsIi3k
	 ifnpa4pgeVYu8K534vASfsTPQqY7WHwDJeugp5fg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dave Chinner <david@fromorbit.com>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 569/770] NFSD: Fix the filecache LRU shrinker
Date: Tue, 18 Jun 2024 14:37:02 +0200
Message-ID: <20240618123429.261318361@linuxfoundation.org>
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

[ Upstream commit edead3a55804739b2e4af0f35e9c7326264e7b22 ]

Without LRU item rotation, the shrinker visits only a few items on
the end of the LRU list, and those would always be long-term OPEN
files for NFSv4 workloads. That makes the filecache shrinker
completely ineffective.

Adopt the same strategy as the inode LRU by using LRU_ROTATE.

Suggested-by: Dave Chinner <david@fromorbit.com>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/filecache.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/nfsd/filecache.c b/fs/nfsd/filecache.c
index 5c9e3ff6397b0..849c010c6ef61 100644
--- a/fs/nfsd/filecache.c
+++ b/fs/nfsd/filecache.c
@@ -445,6 +445,7 @@ nfsd_file_dispose_list_delayed(struct list_head *dispose)
  *
  * Return values:
  *   %LRU_REMOVED: @item was removed from the LRU
+ *   %LRU_ROTATE: @item is to be moved to the LRU tail
  *   %LRU_SKIP: @item cannot be evicted
  */
 static enum lru_status
@@ -483,7 +484,7 @@ nfsd_file_lru_cb(struct list_head *item, struct list_lru_one *lru,
 
 	if (test_and_clear_bit(NFSD_FILE_REFERENCED, &nf->nf_flags)) {
 		trace_nfsd_file_gc_referenced(nf);
-		return LRU_SKIP;
+		return LRU_ROTATE;
 	}
 
 	if (!test_and_clear_bit(NFSD_FILE_HASHED, &nf->nf_flags)) {
@@ -525,7 +526,7 @@ nfsd_file_gc(void)
 	unsigned long ret;
 
 	ret = list_lru_walk(&nfsd_file_lru, nfsd_file_lru_cb,
-			    &dispose, LONG_MAX);
+			    &dispose, list_lru_count(&nfsd_file_lru));
 	trace_nfsd_file_gc_removed(ret, list_lru_count(&nfsd_file_lru));
 	nfsd_file_gc_dispose_list(&dispose);
 }
-- 
2.43.0



