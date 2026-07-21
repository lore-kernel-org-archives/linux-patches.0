Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 631D1471268;
	Tue, 21 Jul 2026 20:09:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784664589; cv=none; b=qeTX1H7fEizFqq29pkdlG5IhKd7OFWppvzo6qyy0tOoAeMclGOZ5sHRMRWFZEfPnKMC3FwpJir4k0i7SqMjSs71N9ZIfeu1Q18bnRVM4eO/1TiUteRutnmBMiCaBrnCZlXwM7QNRtCbMIKz0m+MyLA9jmiT/Z1LNtnfYPhAKRPQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784664589; c=relaxed/simple;
	bh=zgr59FFQMDmGcrCfJPRq+wGhPrS9X89gaFpxzwUEYWc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RTXak1qV5gtGqcZRK0DueSJqfTcyYagHQsTxw0Q79eninm+yvNIO769dCgqaNoT59CZt7shn0DT1vLyIwXiTrJCfhrwn9qMmrAyRR0c46Fk5cjjaK/Y4LUhXcXrWNR8LaQ42qofR07WHJpBi0UiZmk0tL0/8Ldv8wk61i7G4WBA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=w4YZ8GTj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="w4YZ8GTj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA6861F000E9;
	Tue, 21 Jul 2026 20:09:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784664588;
	bh=ImFaZoXZzqM7Vyq8kkBVbsKKDjEAZkSdhXdeznFJVO0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=w4YZ8GTjtyuILw+pYF4dc3B2zW5K6UIGPVb6mIydnIjVL8QmvnuzOVUu5fz4GEPmk
	 5UsJ81q2FKAxDWYsmcPMf3uWYzxtFxgQqOvhxsQcr4zoT+3FLOQtDklMgViHRboIsS
	 5y+C3cVI7K4bUPmGIgEgtYZgYs7ggucByEVhNyVM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+3b6c5c6a1d0119b687a1@syzkaller.appspotmail.com,
	syzbot+8245611446194a52150d@syzkaller.appspotmail.com,
	syzbot+1aa62e6852a6ad1c7944@syzkaller.appspotmail.com,
	syzbot+54e6c2176ba76c56217e@syzkaller.appspotmail.com,
	David Howells <dhowells@redhat.com>,
	Marc Dionne <marc.dionne@auristor.com>,
	linux-afs@lists.infradead.org,
	linux-fsdevel@vger.kernel.org,
	Christian Brauner <brauner@kernel.org>
Subject: [PATCH 6.12 1258/1276] afs: Fix afs_dynroot_readdir() to not use the RCU read lock
Date: Tue, 21 Jul 2026 17:28:21 +0200
Message-ID: <20260721152514.244847397@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Howells <dhowells@redhat.com>

commit a64e4d48a0b77e4ada19ac26ca3a08cd492f6362 upstream.

afs_dynroot_readdir() uses the RCU read lock to walk the cell list whilst
emitting cell automount entries - but dir_emit() may write to a userspace
buffer, thereby causing a fault to occur and waits to happen.

Fix afs_dynroot_readdir() to get a shared lock on net->cells_lock instead.

This can be triggered by enabling lockdep, preconfiguring a number of
cells, doing "mount -t afs none /afs -o dyn" (or using the kafs-client
package with afs.mount systemd unit enabled) and then doing "ls /afs".

Fixes: 1d0b929fc070 ("afs: Change dynroot to create contents on demand")
Reported-by: syzbot+3b6c5c6a1d0119b687a1@syzkaller.appspotmail.com
Reported-by: syzbot+8245611446194a52150d@syzkaller.appspotmail.com
Reported-by: syzbot+1aa62e6852a6ad1c7944@syzkaller.appspotmail.com
Reported-by: syzbot+54e6c2176ba76c56217e@syzkaller.appspotmail.com
Signed-off-by: David Howells <dhowells@redhat.com>
Link: https://lore.kernel.org/1638014.1744145189@warthog.procyon.org.uk
cc: Marc Dionne <marc.dionne@auristor.com>
cc: linux-afs@lists.infradead.org
cc: linux-fsdevel@vger.kernel.org
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/afs/dynroot.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/afs/dynroot.c
+++ b/fs/afs/dynroot.c
@@ -347,9 +347,9 @@ static int afs_dynroot_readdir(struct fi
 	}
 
 	if ((unsigned long long)ctx->pos <= AFS_MAX_DYNROOT_CELL_INO) {
-		rcu_read_lock();
+		down_read(&net->cells_lock);
 		ret = afs_dynroot_readdir_cells(net, ctx);
-		rcu_read_unlock();
+		up_read(&net->cells_lock);
 	}
 	return ret;
 }


