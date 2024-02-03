Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA0C8FBFC;
	Sat,  3 Feb 2024 04:08:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933335; cv=none; b=HaRYuvmOLYXJ3qC/+/YNIjkJasNeMw70XLwtoSzgWoTVZarPo7coZdD5hUXgsxI6y8SaovgRIn2e1/MbTi3u8V50n4Rcp4C8P9GMXZNUFUuXd6BxbpVfcGVtQW2gjWbwdE9glIgg64HXoLr7vW515onB1mToymJMgoPW5oCPBgQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933335; c=relaxed/simple;
	bh=l3BJInT7ksOulVLCvJEcItl80X5f9vkWCgTTOkHKqOw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pKYlAAEMU5A0qm+UVsvsWaY7WmFavkGy5JXoAAxpsqIxijOxVZWdywZh/IAsCOqK+MdrhQn9WLhfB5NAx8OW/QPPJUMr6wrI0Gk8jT47EJfNjBUJmNeE6m7rb7CFQhHIOlBnmwvwnHFaPDy6ldZjX/pU0HlJ7tMCQP0spa910x4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CU/xC96s; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CU/xC96s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B06FCC433C7;
	Sat,  3 Feb 2024 04:08:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933334;
	bh=l3BJInT7ksOulVLCvJEcItl80X5f9vkWCgTTOkHKqOw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CU/xC96snGW3r47v7j16/rJN5WNwfF+XkQnd2huEVLWobNNLMaAyTCoHKREonZe0W
	 iGy3cCWtJo1MzIThiIi38xifxK7fcpxwrQ/zXIQ1aDWPiO6/p6thAe8TAI/eD5kTMs
	 cIVwJX66NqkYFR6YEDOAYDD5Mm/ByPkLJ6yH6Ke8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oleg Nesterov <oleg@redhat.com>,
	David Howells <dhowells@redhat.com>,
	Marc Dionne <marc.dionne@auristor.com>,
	linux-afs@lists.infradead.org,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 032/219] afs: fix the usage of read_seqbegin_or_lock() in afs_find_server*()
Date: Fri,  2 Feb 2024 20:03:25 -0800
Message-ID: <20240203035320.826619686@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035317.354186483@linuxfoundation.org>
References: <20240203035317.354186483@linuxfoundation.org>
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

From: Oleg Nesterov <oleg@redhat.com>

[ Upstream commit 1702e0654ca9a7bcd7c7619c8a5004db58945b71 ]

David Howells says:

 (5) afs_find_server().

     There could be a lot of servers in the list and each server can have
     multiple addresses, so I think this would be better with an exclusive
     second pass.

     The server list isn't likely to change all that often, but when it does
     change, there's a good chance several servers are going to be
     added/removed one after the other.  Further, this is only going to be
     used for incoming cache management/callback requests from the server,
     which hopefully aren't going to happen too often - but it is remotely
     drivable.

 (6) afs_find_server_by_uuid().

     Similarly to (5), there could be a lot of servers to search through, but
     they are in a tree not a flat list, so it should be faster to process.
     Again, it's not likely to change that often and, again, when it does
     change it's likely to involve multiple changes.  This can be driven
     remotely by an incoming cache management request but is mostly going to
     be driven by setting up or reconfiguring a volume's server list -
     something that also isn't likely to happen often.

Make the "seq" counter odd on the 2nd pass, otherwise read_seqbegin_or_lock()
never takes the lock.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: David Howells <dhowells@redhat.com>
cc: Marc Dionne <marc.dionne@auristor.com>
cc: linux-afs@lists.infradead.org
Link: https://lore.kernel.org/r/20231130115614.GA21581@redhat.com/
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/afs/server.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/fs/afs/server.c b/fs/afs/server.c
index b5237206eac3..0bd2f5ba6900 100644
--- a/fs/afs/server.c
+++ b/fs/afs/server.c
@@ -27,7 +27,7 @@ struct afs_server *afs_find_server(struct afs_net *net,
 	const struct afs_addr_list *alist;
 	struct afs_server *server = NULL;
 	unsigned int i;
-	int seq = 0, diff;
+	int seq = 1, diff;
 
 	rcu_read_lock();
 
@@ -35,6 +35,7 @@ struct afs_server *afs_find_server(struct afs_net *net,
 		if (server)
 			afs_unuse_server_notime(net, server, afs_server_trace_put_find_rsq);
 		server = NULL;
+		seq++; /* 2 on the 1st/lockless path, otherwise odd */
 		read_seqbegin_or_lock(&net->fs_addr_lock, &seq);
 
 		if (srx->transport.family == AF_INET6) {
@@ -90,7 +91,7 @@ struct afs_server *afs_find_server_by_uuid(struct afs_net *net, const uuid_t *uu
 {
 	struct afs_server *server = NULL;
 	struct rb_node *p;
-	int diff, seq = 0;
+	int diff, seq = 1;
 
 	_enter("%pU", uuid);
 
@@ -102,7 +103,7 @@ struct afs_server *afs_find_server_by_uuid(struct afs_net *net, const uuid_t *uu
 		if (server)
 			afs_unuse_server(net, server, afs_server_trace_put_uuid_rsq);
 		server = NULL;
-
+		seq++; /* 2 on the 1st/lockless path, otherwise odd */
 		read_seqbegin_or_lock(&net->fs_lock, &seq);
 
 		p = net->fs_servers.rb_node;
-- 
2.43.0



