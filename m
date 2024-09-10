Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 324791922F6;
	Tue, 10 Sep 2024 10:24:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725963881; cv=none; b=aKywUxrvn9DlywFOWIuYmgM7AYUcw6s9W65aBPsAC2lPg9PFEqtey1bmg1x83dVeDvyNg5KTO2Ka+ybo+9wxd/UMD9v7yd/3GzuTjS38S+M2ZPhgfRF7xN0yEJyuTWoauXLk98XILoS5DyTmIctlWp5sye7XHUnScGbAfpyfku0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725963881; c=relaxed/simple;
	bh=Aa6VdyvlzcSUkI/8rXvOK9k8pNJU3kldM5zwOFZvytY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HXymOWEgr0H5FO0/HxYrcQjYGccM3ZfXs6SWWrZ4lbD9A38zb3nGYwOaVXHNsOFSvPgr7QNBZzjtIXeVzeOYSU108XibLWVBlXMmpkUnS0sab5qgzDpTZLS7IX2/XvhK9+IqGeLbDzDkK1jDwazS2uZ7h7NlQOgm5NLYq0fdvx4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vvqT3RID; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vvqT3RID"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD984C4CEC3;
	Tue, 10 Sep 2024 10:24:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725963881;
	bh=Aa6VdyvlzcSUkI/8rXvOK9k8pNJU3kldM5zwOFZvytY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vvqT3RIDHLt8MNry4a+pBiwJPUIblPwCtidcbxq+gGoZmyc8Ohhaf51P+vLJ5LSLA
	 wo9imHkeVLLRPzU2TXxy44Wb/1exZxLiXoiV6zPQ4BL18z6T7ZRrZpEMi9+d0eBU4Z
	 04mQOLbQsVqBca281zzeBh9JzjNNLbyeXHnWmMsQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Jeff Layton <jlayton@kernel.org>,
	Anna Schumaker <Anna.Schumaker@Netapp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 172/214] NFSv4: Add missing rescheduling points in nfs_client_return_marked_delegations
Date: Tue, 10 Sep 2024 11:33:14 +0200
Message-ID: <20240910092605.706772156@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092558.714365667@linuxfoundation.org>
References: <20240910092558.714365667@linuxfoundation.org>
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

From: Trond Myklebust <trond.myklebust@hammerspace.com>

[ Upstream commit a017ad1313fc91bdf235097fd0a02f673fc7bb11 ]

We're seeing reports of soft lockups when iterating through the loops,
so let's add rescheduling points.

Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Anna Schumaker <Anna.Schumaker@Netapp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/super.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/nfs/super.c b/fs/nfs/super.c
index a847011f36c9..9e672aed3590 100644
--- a/fs/nfs/super.c
+++ b/fs/nfs/super.c
@@ -47,6 +47,7 @@
 #include <linux/vfs.h>
 #include <linux/inet.h>
 #include <linux/in6.h>
+#include <linux/sched.h>
 #include <linux/slab.h>
 #include <net/ipv6.h>
 #include <linux/netdevice.h>
@@ -219,6 +220,7 @@ static int __nfs_list_for_each_server(struct list_head *head,
 		ret = fn(server, data);
 		if (ret)
 			goto out;
+		cond_resched();
 		rcu_read_lock();
 	}
 	rcu_read_unlock();
-- 
2.43.0



