Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A8313876BA;
	Sat, 17 Oct 2026 16:29:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792254566; cv=none; b=szuVL8uQ09q5XN/1wuI0SQA8O2sbdaOczgp3k72GMvk59tastXMhiVXm4IcvtI3JULnNE+sIpzHw42MhNBMrvU+dLG63z5zWVWvF6V4a2PpCGEgDZZCY5sp70T5ReUWg1A5sxFdhCRdFBdYqbiTna6l49gPzy5wtprC0oQg9UHs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792254566; c=relaxed/simple;
	bh=BacTj4VXZmriXWhpj9HcgiYZQqnkzg2SORHnecNSJA8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ndD3HPeip9lTKFTtdJH2fOFYUx/Gx74JIMGY91yeay/dn9s4sZLvaPUK9J1qUZTW3RJwuxYZoGy7HTDo+yCWD2wLJeqkHfEbh42B12+Kd0/+YxYaPYcqezzjDhsxwzgZdZFodWvWnPi90zd3yh3iCLhfKwpk1C7xbWClaumuL30=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wBWmoDJj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wBWmoDJj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A40C1F000C4;
	Sat, 17 Oct 2026 16:29:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792254564;
	bh=j3jDOBdtDkmtAtuayvTOgOwD4PRii8bf+X2EnvZb248=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wBWmoDJjfB0D0AOKh3jZi6kkB4rzUD38Le9dAITbeSN3mF1f3+zG/3nWVI/2Dw09h
	 3pm+/Y+quEMtjiR7n+YNp06NwbFZRLgQFP+59YMEGp8Xr/N/wQStsQbIO2FlmJTOQp
	 iKIwEERao0MY/ScRpSl8AlBll4kwQkrvsUlmWczQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marc Dionne <marc.dionne@auristor.com>,
	David Howells <dhowells@redhat.com>,
	Jeffrey Altman <jaltman@auristor.com>,
	linux-afs@lists.infradead.org,
	stable@kernel.org,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 489/869] afs: Fix UAF when sending a message
Date: Sat, 17 Oct 2026 17:55:30 +0200
Message-ID: <20261017160049.650478861@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

[ Upstream commit 4af1ec68d54b3871155914d584fb10669c41a861 ]

In afs_make_call(), there's a race with async call reception and
destruction.  If a call is dispatched that doesn't have call->write_iter
set (used to specify the data content for FS.StoreData), then the first
rxrpc_kernel_send_data() will not set MSG_MORE in the msghdr.

Once rxrpc_send_data() queues the last request packet, the response could
come in at any time and cause the call to be completed and put.  However,
afs_make_call() will look at the call again to see it ->write_iter should
be handled - something it's only allowed to do if it has its own ref on the
call.  Whilst this is the case for synchronous calls, it isn't true for
async calls such as FS.FetchData.

There's also a potential UAF in afs_make_call() in the event that an
asynchronous call is being sent, but the call fails in some way (e.g. it
gets aborted from the server).  The problem there is that afs_make_call()
tries to abort a call if the rxrpc send fails, but the asynchronous
notification from rxrpc may have caused the afs_call to be torn down.

generic/650 plays games with randomly taking CPUs offline, and can
interject a significant delay such that the call is deallocated before
afs_make_call() gets to check call->write_iter - and a UAF ensues (caught
by KASAN).

   BUG: KASAN: slab-use-after-free in afs_make_call+0x1c90/0x2210 [kafs]
   Read of size 8 at addr ffff888035e050e8 by task fsstress/1409

Fix this by making afs_make_op_call() give the op->call its own ref rather
than transferring the caller's ref to it and then dropping the ref when
afs_make_call() returns.

This also means that the afs_make_call() func never loses its ref on the
call now.

Fixes: eddf51f2bb2c ("afs: Make {Y,}FS.FetchData an asynchronous operation")
Fixes: e49c7b2f6de7 ("afs: Build an abstraction around an "operation" concept")
Link: https://sashiko.dev/#/patchset/20260702144919.172295-1-dhowells%40redhat.com
Reported-by: Marc Dionne <marc.dionne@auristor.com>
Signed-off-by: David Howells <dhowells@redhat.com>
Link: https://patch.msgid.link/20260723113452.566619-4-dhowells@redhat.com
cc: Jeffrey Altman <jaltman@auristor.com>
cc: linux-afs@lists.infradead.org
cc: stable@kernel.org
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/afs/internal.h | 4 +++-
 fs/afs/rxrpc.c    | 4 ++--
 2 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/fs/afs/internal.h b/fs/afs/internal.h
index beaedbb3a01ce..a1090863ea465 100644
--- a/fs/afs/internal.h
+++ b/fs/afs/internal.h
@@ -1336,6 +1336,7 @@ extern int __net_init afs_open_socket(struct afs_net *);
 extern void __net_exit afs_close_socket(struct afs_net *);
 extern void afs_charge_preallocation(struct work_struct *);
 extern void afs_put_call(struct afs_call *);
+extern struct afs_call *afs_get_call(struct afs_call *call, enum afs_call_trace why);
 void afs_deferred_put_call(struct afs_call *call);
 void afs_make_call(struct afs_call *call, gfp_t gfp);
 void afs_wait_for_call_to_complete(struct afs_call *call);
@@ -1362,7 +1363,7 @@ static inline void afs_make_op_call(struct afs_operation *op, struct afs_call *c
 {
 	struct afs_addr_list *alist = op->estate->addresses;
 
-	op->call	= call;
+	op->call	= afs_get_call(call, afs_call_trace_get);
 	op->type	= call->type;
 	call->op	= op;
 	call->key	= op->key;
@@ -1370,6 +1371,7 @@ static inline void afs_make_op_call(struct afs_operation *op, struct afs_call *c
 	call->peer	= rxrpc_kernel_get_peer(alist->addrs[op->addr_index].peer);
 	call->service_id = op->server->service_id;
 	afs_make_call(call, gfp);
+	afs_put_call(call);
 }
 
 static inline void afs_extract_begin(struct afs_call *call, void *buf, size_t size)
diff --git a/fs/afs/rxrpc.c b/fs/afs/rxrpc.c
index c35c2332c5b72..12bafd03fd59a 100644
--- a/fs/afs/rxrpc.c
+++ b/fs/afs/rxrpc.c
@@ -247,8 +247,8 @@ void afs_deferred_put_call(struct afs_call *call)
 		schedule_work(&call->free_work);
 }
 
-static struct afs_call *afs_get_call(struct afs_call *call,
-				     enum afs_call_trace why)
+struct afs_call *afs_get_call(struct afs_call *call,
+			      enum afs_call_trace why)
 {
 	int r;
 
-- 
2.53.0



