Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 793BF1A072E;
	Tue, 18 Jun 2024 13:10:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718716201; cv=none; b=qFZAaSs36G9WmLuVr4+c1dnQpciOdHLPqaQVZYeddCud7bITbBaoA1JbQZ/l2c0o6F7dgMsGSGfRhm7kxiZAoVUQpPDsM86xBKP2HZUUiSANVOZtsUTRwVGEoMtPEmClOhTPivOlm5QSWrKhnG8GO5c2UxltRPu3JD4RCmAlqps=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718716201; c=relaxed/simple;
	bh=hoLv7yJHtZeMDqy3BCknNAp1AOJ1LBvr0flwyVnt7pA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UDxXhF205ex5o3wXLG6Pj64pUIpUJ1rVU4W2m/G8gAtGodwrbxT+47BwFHIFkNbjIsC/j5ZB/Wkr8EMwkCfKFw+KFLnRHl6KShZD5Mtwhrce/UJQIeKxavxwyslMWj+I7mSbfPxUC0ee9jGiX5f/SitvJUpDAltBQRePUkkFzbU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ExEb42mx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ExEb42mx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B08FCC3277B;
	Tue, 18 Jun 2024 13:10:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718716201;
	bh=hoLv7yJHtZeMDqy3BCknNAp1AOJ1LBvr0flwyVnt7pA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ExEb42mx/j2eA/f7FktkrgHCT8hP9PacJ8tVuBe3SjiIjELZizDiHp80I2Pd1uMF7
	 spSU0lcutUQHZLT5bsF1mj9lBDd5Ij+33w3dlxwufAqRF2wdR4jcQqdhgNJ9KX9vvK
	 Gy2/v5vgJc1HKkgy9rzj6xqZhUoAaMN7nsNd73KI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 566/770] NFSD: WARN when freeing an item still linked via nf_lru
Date: Tue, 18 Jun 2024 14:36:59 +0200
Message-ID: <20240618123429.147787311@linuxfoundation.org>
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

[ Upstream commit 668ed92e651d3c25f9b6e8cb7ceca54d00daa96d ]

Add a guardrail to prevent freeing memory that is still on a list.
This includes either a dispose list or the LRU list.

This is the sign of a bug, but this class of bugs can be detected
so that they don't endanger system stability, especially while
debugging.

Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
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



