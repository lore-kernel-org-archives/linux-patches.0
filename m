Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E90582E3B19;
	Tue, 15 Jul 2025 13:27:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752586071; cv=none; b=Yzt7YoEvD7BHzo+X7YyXSvMrI8MSFnz0T0SLTIbtmULS4R/UyrEi3fNsdYnahNsBRhkTt/38/4j1JlkglLLlZtbnw+29FLrzYzi9tDWIHDY48iCtBYcuR7jZ9PticWkCilxGb+neFW5LqKiDGm5PGV7fkWaNzrrsXdQhXXZNNY4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752586071; c=relaxed/simple;
	bh=fJuZyCnHaBB5Qa9sP+27PPNuil/JeBR/KnCzI5vJ6GE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dsx0MXv22H+jrcYiOaTBb8Yuz/Z2p6lj8e0PNQxq+xdSu1OK8g5E1AJaEyZNmilw6LdoOb8BJ7mIJdiWt5xKi9MGT4w4+zXZryfa2RQPi+6Wz8PgjUv0jQWhXdszFbXpR6wHHzxQ6w8b3p749xxhPkyzNe4xY7WOOPzsCspc3bA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UoFX4Mss; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UoFX4Mss"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AE63C4CEF1;
	Tue, 15 Jul 2025 13:27:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752586070;
	bh=fJuZyCnHaBB5Qa9sP+27PPNuil/JeBR/KnCzI5vJ6GE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UoFX4Mss8Pcy/9c9bxnzjjadYN17f2QSoZbctNdDLdx1WVJtO563IHfOiVHJ483uB
	 u9FzIPzId05rMx6adunlG8SbtfdnMpve5Gg6sFa20Kqd6M1m0rwUN1lWjHUEXOTQxd
	 IKxOzQSrdtVxwI1zYtfeXzEF8wiLHseuY5UwaEfY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Paulo Alcantara (Red Hat)" <pc@manguebit.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.6 107/109] smb: client: fix potential race in cifs_put_tcon()
Date: Tue, 15 Jul 2025 15:14:03 +0200
Message-ID: <20250715130803.161180233@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130758.864940641@linuxfoundation.org>
References: <20250715130758.864940641@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paulo Alcantara <pc@manguebit.com>

commit c32b624fa4f7ca5a2ff217a0b1b2f1352bb4ec11 upstream.

dfs_cache_refresh() delayed worker could race with cifs_put_tcon(), so
make sure to call list_replace_init() on @tcon->dfs_ses_list after
kworker is cancelled or finished.

Fixes: 4f42a8b54b5c ("smb: client: fix DFS interlink failover")
Signed-off-by: Paulo Alcantara (Red Hat) <pc@manguebit.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/connect.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/fs/smb/client/connect.c
+++ b/fs/smb/client/connect.c
@@ -2557,9 +2557,6 @@ cifs_put_tcon(struct cifs_tcon *tcon, en
 
 	list_del_init(&tcon->tcon_list);
 	tcon->status = TID_EXITING;
-#ifdef CONFIG_CIFS_DFS_UPCALL
-	list_replace_init(&tcon->dfs_ses_list, &ses_list);
-#endif
 	spin_unlock(&tcon->tc_lock);
 	spin_unlock(&cifs_tcp_ses_lock);
 
@@ -2567,6 +2564,7 @@ cifs_put_tcon(struct cifs_tcon *tcon, en
 	cancel_delayed_work_sync(&tcon->query_interfaces);
 #ifdef CONFIG_CIFS_DFS_UPCALL
 	cancel_delayed_work_sync(&tcon->dfs_cache_work);
+	list_replace_init(&tcon->dfs_ses_list, &ses_list);
 #endif
 
 	if (tcon->use_witness) {


