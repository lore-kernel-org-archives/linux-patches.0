Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 713A91A01D8;
	Tue, 18 Jun 2024 13:09:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718716177; cv=none; b=QY8d6EkaXNFMllH7bbUPFNEUerDEjl4wrEOpC9DOqTMtw/2Yn84T+UrUeb2QJ5PgBmHv3Xss3WLApuzs6sRUjMwb4YioXG9Sk6cgp9CoT6Kchr9pPbf1ajRzy6SpAj9KqvAHSPM0usyXGjNrYuNPNowXxQxt6wH7n0ScZMNAVDQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718716177; c=relaxed/simple;
	bh=nKKAUFEEVAOv/Bvon40WDDUEzf4qXg8YF5KI5SZRnOg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kKxbGGceTXLZ8zKRCrNs7hDSncAkza4BRTJYpy9d9zEx+iLtSMAWZ41tz5eTt3DoQWmlXRcx9TG2iOZGPkdcTG+QliWCME3Hr5xR0ucSrjBc06qK7pnPsIutfUpfXD2aVnWml8T3ZKreKX6sAWQ7wOrWYVEDb0BxL9yEubUbKac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QoWziMOw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QoWziMOw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9A97C3277B;
	Tue, 18 Jun 2024 13:09:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718716177;
	bh=nKKAUFEEVAOv/Bvon40WDDUEzf4qXg8YF5KI5SZRnOg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QoWziMOwOwbTqVbYYPw8N4568CjAWfJoxoEq3fY77V9YMxetAO8hSvU4s8QFswxuE
	 rs3gYa9SmSVmecygWAp5igvB/UM2MV4BdEkz1l9WhW9nv/EwRWEJuzIpkX9LRoTeQ7
	 4iEleMa4VXH+t6QeHHtjENN1nZYi8Rgnav4/t0eU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 559/770] NFSD: Add nfsd_file_lru_dispose_list() helper
Date: Tue, 18 Jun 2024 14:36:52 +0200
Message-ID: <20240618123428.877837655@linuxfoundation.org>
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

[ Upstream commit 0bac5a264d9a923f5b01f3521e1519a8d0358342 ]

Refactor the invariant part of nfsd_file_lru_walk_list() into a
separate helper function.

Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
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



