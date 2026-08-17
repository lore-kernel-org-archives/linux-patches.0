Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1673540F8DF;
	Mon, 17 Aug 2026 14:11:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786975889; cv=none; b=B3sh+IxbeYwteV7rVvBSj6sKdyLZt0Zt3zfWGlP533pxl/hi65zjGw5de7r51ZVlgyMEKcblKMQQXsPXV1Lwkvro/sojiYye3iqWhRQfkYwGNW8RAuLaebk1+UYFiDtmMip9kabMS6dRbGfOh9v3GcNPAaoi8hZ8Z4YZVmk+1+Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786975889; c=relaxed/simple;
	bh=6Yb75j4qxwjuKOhN4aARQ1id+1Z+9lEIwaQlR/nGfos=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HXxa5YHYqR5D3aWiVkqBpcP0gZ6Y9VRPhqZUJyHCbmfgM6QaMwdURiwbpYK0Lrf8E6QTtl7+EU1pK3RBSXJatfsbRCH7wlbM5OhqLQCVGq+rqhycSVHfvOeXJ5JGKOigOVYCzk+kzqbgknMiwbSB1ZZ4psxC4Fjwesc5WhJdd6Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hBwRfyTn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hBwRfyTn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 301671F000E9;
	Mon, 17 Aug 2026 14:11:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786975887;
	bh=TgjyRIgD3N5pP8SG0D6Vo0HadboHrYptSGv3YfyXGYM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hBwRfyTnOcwdtzur3UWf3upEJd17tO/056BT3bfxeDw+HD9KXQR37lAsbrO7eMlOH
	 DfuhCoGmzfWyTiBXsA5CH16LoDsFmRCyE48Y1+pKW19mGzVlxO9fZ6xjv9x8g+ZGMd
	 WfRil6a1izYWjAan7ILOdzmVdSUPOngqrKnBC+qI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tung Nguyen <tung.quang.nguyen@est.tech>,
	Breno Leitao <leitao@debian.org>,
	Daehyeon Ko <4ncienth@gmail.com>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 5.10 182/389] tipc: clear sock->sk on the failed-insert path in tipc_sk_create()
Date: Mon, 17 Aug 2026 15:30:21 +0200
Message-ID: <20260817132546.284470423@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132538.796021292@linuxfoundation.org>
References: <20260817132538.796021292@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daehyeon Ko <4ncienth@gmail.com>

commit ba0533fc163f905fe817cfabdf8ed4058da44800 upstream.

When tipc_sk_create() fails to insert the new socket (tipc_sk_insert()
returns non-zero), its error path frees the sk with sk_free() but leaves
sock->sk pointing at the freed object:

	if (tipc_sk_insert(tsk)) {
		sk_free(sk);
		pr_warn("Socket create failed; port number exhausted\n");
		return -EINVAL;
	}

This is harmless for plain socket(): the syscall layer clears sock->ops
before releasing, so tipc_release() is never called. It is not harmless
on the accept() path. tipc_accept() creates the pre-allocated child
socket with tipc_sk_create(net, new_sock, 0, kern); on failure it leaves
new_sock->sk dangling and new_sock->ops non-NULL, and do_accept() then
fput()s the new file, so __sock_release() -> tipc_release() runs
lock_sock(new_sock->sk) on the freed sk -- a use-after-free write of the
sk_lock spinlock.

tipc_release() already guards this exact "failed accept() releases a
pre-allocated child" case with "if (sk == NULL) return 0;", but the
guard is bypassed because tipc_sk_create() left sock->sk non-NULL
(dangling) rather than NULL.

Clear sock->sk on the failed-insert path so the existing tipc_release()
NULL check fires and the use-after-free is avoided.

The tipc_sk_insert() failure is reached when the per-netns socket
rhashtable hits its max_size (tsk_rht_params.max_size = 1048576, ~2M
elements) -- i.e. once a netns holds ~2M TIPC sockets every insert
returns -E2BIG.

  BUG: KASAN: slab-use-after-free in lock_sock_nested (net/core/sock.c:3839)
  Write of size 8 at addr ffff8880047cdc38 by task init/1
   lock_sock_nested (net/core/sock.c:3839)
   tipc_release (net/tipc/socket.c:638)
   __sock_release (net/socket.c:710)
   sock_close (net/socket.c:1501)
   __fput (fs/file_table.c:512)
  Allocated by task 1:
   sk_alloc (net/core/sock.c:2308)
   tipc_sk_create (net/tipc/socket.c:487)
   tipc_accept (net/tipc/socket.c:2744)
   do_accept (net/socket.c:2034)
  Freed by task 1:
   __sk_destruct (net/core/sock.c:2391)
   tipc_sk_create (net/tipc/socket.c:504)
   tipc_accept (net/tipc/socket.c:2744)
   do_accept (net/socket.c:2034)

Fixes: 00aff3590fc0 ("net: tipc: fix possible refcount leak in tipc_sk_create()")
Cc: stable@vger.kernel.org
Reviewed-by: Tung Nguyen <tung.quang.nguyen@est.tech>
Reviewed-by: Breno Leitao <leitao@debian.org>
Signed-off-by: Daehyeon Ko <4ncienth@gmail.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20260714131939.1255974-1-4ncienth@gmail.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/tipc/socket.c |    1 +
 1 file changed, 1 insertion(+)

--- a/net/tipc/socket.c
+++ b/net/tipc/socket.c
@@ -490,6 +490,7 @@ static int tipc_sk_create(struct net *ne
 	tipc_set_sk_state(sk, TIPC_OPEN);
 	if (tipc_sk_insert(tsk)) {
 		sk_free(sk);
+		sock->sk = NULL;
 		pr_warn("Socket create failed; port number exhausted\n");
 		return -EINVAL;
 	}


