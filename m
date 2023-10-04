Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 529B418E2A
	for <patches@lists.linux.dev>; Wed,  4 Oct 2023 18:12:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C773AC433C7;
	Wed,  4 Oct 2023 18:12:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696443138;
	bh=+LMlbiPIT/Y1JBLR6yfXbbW0oIx78S6kIIzrK27IqXo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IMEpY6Xd68PJiCkK1oYaZ8bUMLQebF9kGHESlrVThZy+UOY+j2d+ied26X1GAMDQb
	 cmGgMXzO7FkmnOPGfJGLjEyzWKhnFLftYX+qhLQh2ZUG+kB2igr6lDFUEDgIZABKCD
	 /06mvp7pjVdmjXK8tIDYVDFxs9Zg2IJCvrHhq6HM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 032/259] netfilter: nft_set_rbtree: use read spinlock to avoid datapath contention
Date: Wed,  4 Oct 2023 19:53:25 +0200
Message-ID: <20231004175218.908102117@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231004175217.404851126@linuxfoundation.org>
References: <20231004175217.404851126@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pablo Neira Ayuso <pablo@netfilter.org>

commit 96b33300fba880ec0eafcf3d82486f3463b4b6da upstream.

rbtree GC does not modify the datastructure, instead it collects expired
elements and it enqueues a GC transaction. Use a read spinlock instead
to avoid data contention while GC worker is running.

Fixes: f6c383b8c31a ("netfilter: nf_tables: adapt set backend to use GC transaction API")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nft_set_rbtree.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/nft_set_rbtree.c b/net/netfilter/nft_set_rbtree.c
index f250b5399344a..70491ba98decb 100644
--- a/net/netfilter/nft_set_rbtree.c
+++ b/net/netfilter/nft_set_rbtree.c
@@ -622,8 +622,7 @@ static void nft_rbtree_gc(struct work_struct *work)
 	if (!gc)
 		goto done;
 
-	write_lock_bh(&priv->lock);
-	write_seqcount_begin(&priv->count);
+	read_lock_bh(&priv->lock);
 	for (node = rb_first(&priv->root); node != NULL; node = rb_next(node)) {
 
 		/* Ruleset has been updated, try later. */
@@ -673,8 +672,7 @@ static void nft_rbtree_gc(struct work_struct *work)
 	gc = nft_trans_gc_catchall(gc, gc_seq);
 
 try_later:
-	write_seqcount_end(&priv->count);
-	write_unlock_bh(&priv->lock);
+	read_unlock_bh(&priv->lock);
 
 	if (gc)
 		nft_trans_gc_queue_async_done(gc);
-- 
2.40.1



