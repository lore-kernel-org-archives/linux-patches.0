Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 155062D12ED;
	Fri,  7 Aug 2026 15:40:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786117252; cv=none; b=Lg46e+pvs4oC86Y97qVk5GqRWKNaL9FsugCjgZ8eNj4mdlEnfeGzzhnjgpACDcGue3YIByzgqTtdzVFqP04Vuw/6TdY0dckpO3+4XDb6n1Yw29yLUvGkK48oUZjLKGAHx/nQXmfuaNZhnyPM87Z60P/hGPT5oYpgQagOrdYvQmo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786117252; c=relaxed/simple;
	bh=s0+b6ku2fd+aNn3ELQ7RSgPB13lye14uHJ6DoH+Ev2Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ue2TSVaX5GXg10xqxBHAPZFRMCnA0WZBNZ6mPLh6ftoPJPGsS+oi6VUByVCZDmgcXxv/qH+huNPSlw10XLdUCPpplFOAyyn0zslz+InCwYyeL1Bc5N9l6nnqGvxShquwtkbLVqvq4rD8Vyjzk85wUqSDqhn4yosktRJ9i8TGkWw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mfqgRbws; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mfqgRbws"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6ED841F000E9;
	Fri,  7 Aug 2026 15:40:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786117250;
	bh=UCr1VTdV1D3BYUS6OyIg6yuSQb8AuzS3dLTZNO3T/JU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mfqgRbws0tcjO8NrrDzoQYRCtikCcbHsi+juBKgn+L+wtL2BDsBcWDCSw2S8lTp48
	 ZY9zgI1ZzINui9mBlYDCzqFTPXJq5yBrgH/eKN0osTw16zXgFyxvoAJ323WoEePbUS
	 p95bg9OR150bOjWmCC8IclQc7bYATp3oOGWn/elo=
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
Subject: [PATCH 7.1 251/438] afs: Fix UAF when sending a message
Date: Fri,  7 Aug 2026 16:37:27 +0200
Message-ID: <20260807143433.349605054@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143428.008222056@linuxfoundation.org>
References: <20260807143428.008222056@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1421,7 +1421,7 @@ static inline void afs_make_op_call(stru
 {
 	struct afs_addr_list *alist = op->estate->addresses;
 
-	op->call	= call;
+	op->call	= afs_get_call(call, afs_call_trace_get);
 	op->type	= call->type;
 	call->op	= op;
 	call->key	= op->key;
@@ -1429,6 +1429,7 @@ static inline void afs_make_op_call(stru
 	call->peer	= rxrpc_kernel_get_peer(alist->addrs[op->addr_index].peer);
 	call->service_id = op->server->service_id;
 	afs_make_call(call, gfp);
+	afs_put_call(call);
 }
 
 static inline void afs_extract_begin(struct afs_call *call, void *buf, size_t size)


