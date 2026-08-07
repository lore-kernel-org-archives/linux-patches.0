Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81E6A2DC765;
	Fri,  7 Aug 2026 15:06:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786115219; cv=none; b=fr1VXBr9AAIxKeIcLtqDxQuXJRpR9GQKiGRI1m7616ow/6vXiGaFBlCANox9cTKlngN9bTuS9HoL7jaI2jOtkhpEjgexblO5oW8YOnfu+wrBzM44mTDkn72glL+XeWFEufv0woSSFKAlbfHUMvD9FMoMVyMcCHsX3kpTLvH5H7o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786115219; c=relaxed/simple;
	bh=dV91f4cw+kv/1nEkXP6RfKFlOoAb3T9vuCJpP9c8p4I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HYnRrGVraSCt+YJm0Z5yoiSeGkuxJmWF1Lb2m7QOZs7zVs6KYtPNFDjRT0BzQg4WYM6hd+iiE/+86/DMxdOuXz/rJHUxkW0xWpu7cJ945+4nrDiyD0sP6ylg0DlWGTc9WZKiOjVb6LnC7EBxBY3+BzeaPscqPk612o3RyQK80M4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=q0wJin7a; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q0wJin7a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCEEF1F000E9;
	Fri,  7 Aug 2026 15:06:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786115217;
	bh=qUcf4JvdYDFZIP7iZxa/VoxCiB+lgT/s5y522l3J4mk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=q0wJin7ahDwlGzLFxrcMJ1bbWPjptstnovHDEfdtpDqDipAHEYFJUOKey9W2hxgK+
	 +BhCVILlFSr7qMu5mz6VZhXGH2wsGUnZdOjloDBYs/3x51P14xbHCMeVSLfkgEXrLL
	 rJfhWuY/9g0dRDs3dmChjuPMy2yhVgBYmC7gutzM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marc Dionne <marc.dionne@auristor.com>,
	David Howells <dhowells@redhat.com>,
	Jeffrey Altman <jaltman@auristor.com>,
	linux-afs@lists.infradead.org,
	stable@kernel.org,
	"Christian Brauner (Amutable)" <brauner@kernel.org>
Subject: [PATCH 6.18 200/396] afs: Fix UAF when sending a message
Date: Fri,  7 Aug 2026 16:36:00 +0200
Message-ID: <20260807143428.596343543@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143424.272339768@linuxfoundation.org>
References: <20260807143424.272339768@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Howells <dhowells@redhat.com>

commit 4af1ec68d54b3871155914d584fb10669c41a861 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/afs/internal.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/afs/internal.h
+++ b/fs/afs/internal.h
@@ -1420,7 +1420,7 @@ static inline void afs_make_op_call(stru
 {
 	struct afs_addr_list *alist = op->estate->addresses;
 
-	op->call	= call;
+	op->call	= afs_get_call(call, afs_call_trace_get);
 	op->type	= call->type;
 	call->op	= op;
 	call->key	= op->key;
@@ -1428,6 +1428,7 @@ static inline void afs_make_op_call(stru
 	call->peer	= rxrpc_kernel_get_peer(alist->addrs[op->addr_index].peer);
 	call->service_id = op->server->service_id;
 	afs_make_call(call, gfp);
+	afs_put_call(call);
 }
 
 static inline void afs_extract_begin(struct afs_call *call, void *buf, size_t size)


