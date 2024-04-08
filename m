Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D14262DF73;
	Mon,  8 Apr 2024 13:51:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712584282; cv=none; b=hMxYLbE9HxM7BYUzltSI/FZ5pMeiGJtRKqFdHnIs8hZvgR/IHDhbb5SW4k41cjilVUP2cDCITdfuN1fhxy4ib5rvadTbuuhBa/3P/LFtq9HofT9FoxspANMbs1cVLdZRQyHngvkssR2VIFVBT8S+RMlNmOhJf2X4Idn6wwzebnE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712584282; c=relaxed/simple;
	bh=HY3TxDWGjorzHFd2Ihewm6IWe/88kqodn8ThhGXRS2I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PjWcRxRXYMKEBhiAnqFou+8JgsDr8h0Yp6CtxzXrO5oGuawzMIO4k5k9necKvs91ncbe1Afh6+Or1xRliYiO5vSh0vvfdKKU1tZ/kULxXN70ItFGUAicoIngnw8vxiuHR6IGp3B2qZ3y4NteSWsx5VuVvB22EprvMaodYri9tVY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iq7TE/rK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iq7TE/rK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5857FC433C7;
	Mon,  8 Apr 2024 13:51:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712584282;
	bh=HY3TxDWGjorzHFd2Ihewm6IWe/88kqodn8ThhGXRS2I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iq7TE/rKKeDYiVBGta76nEFACR+Z0tjW1AB9oiaTFOtFTolESxWIOYDUqTgOp5WWK
	 lcIVNV8UwGZryuE/XPLWJWkjrMAIVztv2pYRiLubq1bhcEGIvtrBkX0ZsZ5hVV6mpG
	 wAXK5ig6qtO2rJosq58I7Rmr2c+83f7mq30zfNIY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.15 350/690] NFSD: Add nfsd_file_lru_dispose_list() helper
Date: Mon,  8 Apr 2024 14:53:36 +0200
Message-ID: <20240408125412.294124691@linuxfoundation.org>
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

[ Upstream commit 0bac5a264d9a923f5b01f3521e1519a8d0358342 ]

Refactor the invariant part of nfsd_file_lru_walk_list() into a
separate helper function.

Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 fs/nfsd/filecache.c | 29 ++++++++++++++++++++++-------
 1 file changed, 22 insertions(+), 7 deletions(-)

diff --git a/fs/nfsd/filecache.c b/fs/nfsd/filecache.c
index 0cd72c20fc12d..ffe46f3f33495 100644
--- a/fs/nfsd/filecache.c
+++ b/fs/nfsd/filecache.c
@@ -450,11 +450,31 @@ nfsd_file_lru_cb(struct list_head *item, struct list_lru_one *lru,
 	return LRU_SKIP;
 }
 
+/*
+ * Unhash items on @dispose immediately, then queue them on the
+ * disposal workqueue to finish releasing them in the background.
+ *
+ * cel: Note that between the time list_lru_shrink_walk runs and
+ * now, these items are in the hash table but marked unhashed.
+ * Why release these outside of lru_cb ? There's no lock ordering
+ * problem since lru_cb currently takes no lock.
+ */
+static void nfsd_file_gc_dispose_list(struct list_head *dispose)
+{
+	struct nfsd_file *nf;
+
+	list_for_each_entry(nf, dispose, nf_lru) {
+		spin_lock(&nfsd_file_hashtbl[nf->nf_hashval].nfb_lock);
+		nfsd_file_do_unhash(nf);
+		spin_unlock(&nfsd_file_hashtbl[nf->nf_hashval].nfb_lock);
+	}
+	nfsd_file_dispose_list_delayed(dispose);
+}
+
 static unsigned long
 nfsd_file_lru_walk_list(struct shrink_control *sc)
 {
 	LIST_HEAD(head);
-	struct nfsd_file *nf;
 	unsigned long ret;
 
 	if (sc)
@@ -464,12 +484,7 @@ nfsd_file_lru_walk_list(struct shrink_control *sc)
 		ret = list_lru_walk(&nfsd_file_lru,
 				nfsd_file_lru_cb,
 				&head, LONG_MAX);
-	list_for_each_entry(nf, &head, nf_lru) {
-		spin_lock(&nfsd_file_hashtbl[nf->nf_hashval].nfb_lock);
-		nfsd_file_do_unhash(nf);
-		spin_unlock(&nfsd_file_hashtbl[nf->nf_hashval].nfb_lock);
-	}
-	nfsd_file_dispose_list_delayed(&head);
+	nfsd_file_gc_dispose_list(&head);
 	return ret;
 }
 
-- 
2.43.0



