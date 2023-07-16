Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB0918F57
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:54:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40AB6C433C8;
	Sun, 16 Jul 2023 20:54:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689540857;
	bh=dQJNXT7z4f+Rc/2+nxexWGiBHtZg0gmSSzhOCGso6Ks=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m+j4jUT1KOs1iEc6lZKkRq9q0Wsa3q+rG3RH5Tj/+CeNOWRGquiCaeM8Jf0o2/76F
	 wIsbVBztJL/5lnrBFnECAwIHCnnmxhyhwbPlxToio9MV49TKtLRFwAJbk49VHDdENG
	 F0sMoAQoTIsgzn+l0vg4ICDLQnnNEYducfkFR79A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marc Dionne <marc.dionne@auristor.com>,
	David Howells <dhowells@redhat.com>,
	Jeffrey Altman <jaltman@auristor.com>,
	linux-afs@lists.infradead.org,
	linux-fsdevel@vger.kernel.org,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 512/591] afs: Fix accidental truncation when storing data
Date: Sun, 16 Jul 2023 21:50:51 +0200
Message-ID: <20230716194937.129813314@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194923.861634455@linuxfoundation.org>
References: <20230716194923.861634455@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: David Howells <dhowells@redhat.com>

[ Upstream commit 03275585cabd0240944f19f33d7584a1b099a3a8 ]

When an AFS FS.StoreData RPC call is made, amongst other things it is
given the resultant file size to be.  On the server, this is processed
by truncating the file to new size and then writing the data.

Now, kafs has a lock (vnode->io_lock) that serves to serialise
operations against a specific vnode (ie.  inode), but the parameters for
the op are set before the lock is taken.  This allows two writebacks
(say sync and kswapd) to race - and if writes are ongoing the writeback
for a later write could occur before the writeback for an earlier one if
the latter gets interrupted.

Note that afs_writepages() cannot take i_mutex and only takes a shared
lock on vnode->validate_lock.

Also note that the server does the truncation and the write inside a
lock, so there's no problem at that end.

Fix this by moving the calculation for the proposed new i_size inside
the vnode->io_lock.  Also reset the iterator (which we might have read
from) and update the mtime setting there.

Fixes: bd80d8a80e12 ("afs: Use ITER_XARRAY for writing")
Reported-by: Marc Dionne <marc.dionne@auristor.com>
Signed-off-by: David Howells <dhowells@redhat.com>
Reviewed-by: Jeffrey Altman <jaltman@auristor.com>
Reviewed-by: Marc Dionne <marc.dionne@auristor.com>
cc: linux-afs@lists.infradead.org
cc: linux-fsdevel@vger.kernel.org
Link: https://lore.kernel.org/r/3526895.1687960024@warthog.procyon.org.uk/
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/afs/write.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/fs/afs/write.c b/fs/afs/write.c
index 08fd456dde67c..3ecc212b62099 100644
--- a/fs/afs/write.c
+++ b/fs/afs/write.c
@@ -381,17 +381,19 @@ static int afs_store_data(struct afs_vnode *vnode, struct iov_iter *iter, loff_t
 	afs_op_set_vnode(op, 0, vnode);
 	op->file[0].dv_delta = 1;
 	op->file[0].modification = true;
-	op->store.write_iter = iter;
 	op->store.pos = pos;
 	op->store.size = size;
-	op->store.i_size = max(pos + size, vnode->netfs.remote_i_size);
 	op->store.laundering = laundering;
-	op->mtime = vnode->netfs.inode.i_mtime;
 	op->flags |= AFS_OPERATION_UNINTR;
 	op->ops = &afs_store_data_operation;
 
 try_next_key:
 	afs_begin_vnode_operation(op);
+
+	op->store.write_iter = iter;
+	op->store.i_size = max(pos + size, vnode->netfs.remote_i_size);
+	op->mtime = vnode->netfs.inode.i_mtime;
+
 	afs_wait_for_operation(op);
 
 	switch (op->error) {
-- 
2.39.2



