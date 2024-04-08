Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0D7A7E0FF;
	Mon,  8 Apr 2024 13:49:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712584198; cv=none; b=V25ZI+0DDP3LBXE5SU6sFeTRIqmFsT3X6xGuIrx4T8GACoP9sarLdTYIhBLI1yy5uevidXBJ1WSLXGqTIV0F259oxPB3I8/HS9yWE9gfbWrrxZ43/p+VErMRHPGRRtapNwq65XufkA03Olc5Ra/jSLA4UCC3b6U00nrntI8KNIs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712584198; c=relaxed/simple;
	bh=nk8YAMcfGirl2HdAe8xElCwH+oPHsGSCsWemDYNrZhs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MYwi6ErCGocmxRhhcmVsBEdlDfCNLujNTHp0K22YsnNc8+DSVirW72Y39KmWKVSryPvvmmASGHKDQ3IELz+uJytNpMXF4n+zwqxkkyLZDhEfgax1CH6jp0MMyhz5oCHuyEqg7/TDIUEb5efiAtK79xopA4++bCeJM1iEL3U0uOI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tgtGEWsr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tgtGEWsr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66F90C433C7;
	Mon,  8 Apr 2024 13:49:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712584197;
	bh=nk8YAMcfGirl2HdAe8xElCwH+oPHsGSCsWemDYNrZhs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tgtGEWsrECYEqQ2M1LBntiVUb0/uxRguEro8sTWJoLyy4xiryAemosZ2A+kAzj5A4
	 9JW3LL3yAh2xtUOPRM0Na+1aZpG0lfvDtoBlVnF9MhF5AG3cMAZuZYn6c+GwJQ7aVy
	 hlvwnH1o5QTShLS+iDnmGGznnq7INoqr2wFBd7iQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.15 357/690] NFSD: WARN when freeing an item still linked via nf_lru
Date: Mon,  8 Apr 2024 14:53:43 +0200
Message-ID: <20240408125412.537519619@linuxfoundation.org>
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

[ Upstream commit 668ed92e651d3c25f9b6e8cb7ceca54d00daa96d ]

Add a guardrail to prevent freeing memory that is still on a list.
This includes either a dispose list or the LRU list.

This is the sign of a bug, but this class of bugs can be detected
so that they don't endanger system stability, especially while
debugging.

Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 fs/nfsd/filecache.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/fs/nfsd/filecache.c b/fs/nfsd/filecache.c
index 60c51a4d8e0d7..d9b5f1e183976 100644
--- a/fs/nfsd/filecache.c
+++ b/fs/nfsd/filecache.c
@@ -213,6 +213,14 @@ nfsd_file_free(struct nfsd_file *nf)
 		fput(nf->nf_file);
 		flush = true;
 	}
+
+	/*
+	 * If this item is still linked via nf_lru, that's a bug.
+	 * WARN and leak it to preserve system stability.
+	 */
+	if (WARN_ON_ONCE(!list_empty(&nf->nf_lru)))
+		return flush;
+
 	call_rcu(&nf->nf_rcu, nfsd_file_slab_free);
 	return flush;
 }
@@ -342,7 +350,7 @@ nfsd_file_dispose_list(struct list_head *dispose)
 
 	while(!list_empty(dispose)) {
 		nf = list_first_entry(dispose, struct nfsd_file, nf_lru);
-		list_del(&nf->nf_lru);
+		list_del_init(&nf->nf_lru);
 		nfsd_file_flush(nf);
 		nfsd_file_put_noref(nf);
 	}
@@ -356,7 +364,7 @@ nfsd_file_dispose_list_sync(struct list_head *dispose)
 
 	while(!list_empty(dispose)) {
 		nf = list_first_entry(dispose, struct nfsd_file, nf_lru);
-		list_del(&nf->nf_lru);
+		list_del_init(&nf->nf_lru);
 		nfsd_file_flush(nf);
 		if (!refcount_dec_and_test(&nf->nf_ref))
 			continue;
-- 
2.43.0



