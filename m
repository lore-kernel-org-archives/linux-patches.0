Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DB08330B21;
	Fri, 17 Oct 2025 15:44:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760715872; cv=none; b=PgMwoAk2JQP9fil7FBtW8NhKpmIWivUhKTZ+SK6Jl1YwA5NvNkLg4azyNVirD20QwxoOIkoTGHrQekofDgiIAdR52ciECBy/RTVWdrYFN8qMVEFnzow/YVGl1Zz7h1meMb0db1g4dWmH+7E2VtK1lwWbHyjAFkPcNmaJ2/JyXCk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760715872; c=relaxed/simple;
	bh=nClh2577163dlybQhCh9aInIp3JpLYOhJAxjoR9WOVk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G68WOG9o8AqdccpMN3NK1SbJDS81Loo5VKfNKnQqFs6rUzmgm944aM3Qnf6DE10bXp/LSQaRY3ysYIVQnjNGxoE29HvGFKwSqIn/1vKeJFCqA4rWPcivsagxKcOKUJZiOFDiOpiMhZJaddW+4q3DLQULVWRNF6yaHwgZcVXk9Rc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e5uRUkiE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e5uRUkiE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAD1BC4CEFE;
	Fri, 17 Oct 2025 15:44:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760715872;
	bh=nClh2577163dlybQhCh9aInIp3JpLYOhJAxjoR9WOVk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e5uRUkiErPhmUdjzUNkxvH8N0dw4feiinMYuKpyj0R/j+SMTePxSFnLuG3PxGT14e
	 uRw7BsovC9BUEGMa2ujU53q+xzc91tYOQsF+oraK0FBEA03oPdr8cdvw+GSeHK1giq
	 ZOsgYwvLDMTbt5EIUJIGrgVvgYptmCLiRRUdBKFI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Brauner <brauner@kernel.org>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 366/371] mnt_ns_tree_remove(): DTRT if mnt_ns had never been added to mnt_ns_list
Date: Fri, 17 Oct 2025 16:55:41 +0200
Message-ID: <20251017145215.327630736@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145201.780251198@linuxfoundation.org>
References: <20251017145201.780251198@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Al Viro <viro@zeniv.linux.org.uk>

[ Upstream commit 38f4885088fc5ad41b8b0a2a2cfc73d01e709e5c ]

Actual removal is done under the lock, but for checking if need to bother
the lockless RB_EMPTY_NODE() is safe - either that namespace had never
been added to mnt_ns_tree, in which case the the node will stay empty, or
whoever had allocated it has called mnt_ns_tree_add() and it has already
run to completion.  After that point RB_EMPTY_NODE() will become false and
will remain false, no matter what we do with other nodes in the tree.

Reviewed-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/namespace.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/namespace.c b/fs/namespace.c
index 38609066cf330..fc4cbbefa70e2 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -196,7 +196,7 @@ static void mnt_ns_release_rcu(struct rcu_head *rcu)
 static void mnt_ns_tree_remove(struct mnt_namespace *ns)
 {
 	/* remove from global mount namespace list */
-	if (!is_anon_ns(ns)) {
+	if (!RB_EMPTY_NODE(&ns->mnt_ns_tree_node)) {
 		mnt_ns_tree_write_lock();
 		rb_erase(&ns->mnt_ns_tree_node, &mnt_ns_tree);
 		list_bidir_del_rcu(&ns->mnt_ns_list);
-- 
2.51.0



