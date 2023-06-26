Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3793C8E5
	for <patches@lists.linux.dev>; Mon, 26 Jun 2023 18:35:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AC11C433C8;
	Mon, 26 Jun 2023 18:35:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1687804546;
	bh=pbElzT0knfLf0iH3ecE7byXZZCrei3QmW3UVR7vHEDM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1xPbR9en5btY7YHmHK90CY6eAbOAe0foqSWwPDnn3Of/qngiSo1SCkbihFHOwJzB0
	 LBdfkazyc/DM6/bWZuGFWUFH5LgMC+cUlJOrdF4O6Y8CxkWrf74ScOSArtCqqDdk7E
	 nBYUmenlz4iZ2YIJZqaP00auvY2qAN1QNCKhefBc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Paulo Alcantara (SUSE)" <pc@cjr.nz>,
	Aurelien Aptel <aaptel@suse.com>,
	Steve French <stfrench@microsoft.com>,
	Rishabh Bhatnagar <risbhat@amazon.com>
Subject: [PATCH 5.4 20/60] cifs: Get rid of kstrdup_const()d paths
Date: Mon, 26 Jun 2023 20:11:59 +0200
Message-ID: <20230626180740.387801285@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230626180739.558575012@linuxfoundation.org>
References: <20230626180739.558575012@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: "Paulo Alcantara (SUSE)" <pc@cjr.nz>

commit 199c6bdfb04b71d88a7765e08285885fbca60df4 upstream.

The DFS cache API is mostly used with heap allocated strings.

Signed-off-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
Reviewed-by: Aurelien Aptel <aaptel@suse.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Rishabh Bhatnagar <risbhat@amazon.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/cifs/dfs_cache.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/fs/cifs/dfs_cache.c
+++ b/fs/cifs/dfs_cache.c
@@ -131,7 +131,7 @@ static inline void flush_cache_ent(struc
 		return;
 
 	hlist_del_init_rcu(&ce->hlist);
-	kfree_const(ce->path);
+	kfree(ce->path);
 	free_tgts(ce);
 	cache_count--;
 	call_rcu(&ce->rcu, free_cache_entry);
@@ -420,7 +420,7 @@ static struct cache_entry *alloc_cache_e
 	if (!ce)
 		return ERR_PTR(-ENOMEM);
 
-	ce->path = kstrdup_const(path, GFP_KERNEL);
+	ce->path = kstrndup(path, strlen(path), GFP_KERNEL);
 	if (!ce->path) {
 		kmem_cache_free(cache_slab, ce);
 		return ERR_PTR(-ENOMEM);
@@ -430,7 +430,7 @@ static struct cache_entry *alloc_cache_e
 
 	rc = copy_ref_data(refs, numrefs, ce, NULL);
 	if (rc) {
-		kfree_const(ce->path);
+		kfree(ce->path);
 		kmem_cache_free(cache_slab, ce);
 		ce = ERR_PTR(rc);
 	}


