Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FF1753816;
	Wed, 21 Feb 2024 13:14:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708521264; cv=none; b=lZ6JHyxwrkOECgEmKeTbTMok0JirU9QxNKfvHoCKDqSeUNy0MEr9bUli0dCLxacGblO8iAxgpCCh+IOxhjfCJKcv2ErIgsBkf+OcMBccnyPd+Z5gyfe+EEeepcFXkNCJ/yex+HIpqGqqT5fMa3MTE/Mf1TIn9qQM5KBUw431FAE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708521264; c=relaxed/simple;
	bh=PJ3ek/z8/tUsgq/ztmKutoaSTzbvGUq50aOEGlPsZns=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=APmGNxNVSME995OmI7X5XOEEmlKZvQyNcz80sOKM4VlPszinzzQPjNrt8xDzckYwWYSra9rgbvc0neCQRS+lufpa+lKPUotOybMgokOL5jrAkYTT+sGEWZg751nrXVTcF9kzKluA4yE0S34fAWBmKOqHUD7ltRgj/rjRkXR2SXU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0Oc86tRF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0Oc86tRF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB174C433F1;
	Wed, 21 Feb 2024 13:14:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708521264;
	bh=PJ3ek/z8/tUsgq/ztmKutoaSTzbvGUq50aOEGlPsZns=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0Oc86tRFifdYIz6VLIbI+iUbiCYu/ma1Sxfrtax1TO1KJ7QHo3EJfkdxlqjlktbu6
	 YKFpOI5UZ6GpfUub+WayU32UCVmbNvrqoAqmUBi093R+UOSmWGe4Ld/j8JAdUisYDz
	 s9lb6i/IQEg+Lq/RWyuqXWkdDPv3BjiYRdavMLDo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oleg Nesterov <oleg@redhat.com>,
	David Howells <dhowells@redhat.com>,
	Marc Dionne <marc.dionne@auristor.com>,
	linux-afs@lists.infradead.org,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 065/202] afs: fix the usage of read_seqbegin_or_lock() in afs_find_server*()
Date: Wed, 21 Feb 2024 14:06:06 +0100
Message-ID: <20240221125933.935584883@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125931.742034354@linuxfoundation.org>
References: <20240221125931.742034354@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
index 2c7f6211c360..b12caa1acf53 100644
--- a/fs/afs/server.c
+++ b/fs/afs/server.c
@@ -37,7 +37,7 @@ struct afs_server *afs_find_server(struct afs_net *net,
 	const struct afs_addr_list *alist;
 	struct afs_server *server = NULL;
 	unsigned int i;
-	int seq = 0, diff;
+	int seq = 1, diff;
 
 	rcu_read_lock();
 
@@ -45,6 +45,7 @@ struct afs_server *afs_find_server(struct afs_net *net,
 		if (server)
 			afs_put_server(net, server);
 		server = NULL;
+		seq++; /* 2 on the 1st/lockless path, otherwise odd */
 		read_seqbegin_or_lock(&net->fs_addr_lock, &seq);
 
 		if (srx->transport.family == AF_INET6) {
@@ -100,7 +101,7 @@ struct afs_server *afs_find_server_by_uuid(struct afs_net *net, const uuid_t *uu
 {
 	struct afs_server *server = NULL;
 	struct rb_node *p;
-	int diff, seq = 0;
+	int diff, seq = 1;
 
 	_enter("%pU", uuid);
 
@@ -112,7 +113,7 @@ struct afs_server *afs_find_server_by_uuid(struct afs_net *net, const uuid_t *uu
 		if (server)
 			afs_put_server(net, server);
 		server = NULL;
-
+		seq++; /* 2 on the 1st/lockless path, otherwise odd */
 		read_seqbegin_or_lock(&net->fs_lock, &seq);
 
 		p = net->fs_servers.rb_node;
-- 
2.43.0



