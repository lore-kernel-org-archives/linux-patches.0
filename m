Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793827230;
	b=AsA4R5L+2LMxgFce7RKpyyDga+S+SOE4JAaClJsf2+IJU+Sl6pogkP0PIPzhvYafA98n
	 guGz6txrofBEcgPeROap1OSzkVWI3nLeUu0JgXUysuRZYhR09vQe4v7jkjZGJIzEuGvdg
	 ZEoqdFZPML7NNhRthJ6I5SJtTaVZXUUsOqzIvHNrJPYfIBvibV18X9TvXJY4DdNz2h98v
	 U0XFKPhqstSUYlpfHnRlIawEuod0ESYCzHP8iDu2ZHhTafFGW/IDzp/AwP6RwpjvMOo7h
	 iK2cUhrJI3ILwzoFJEM0YEqlrHudWzbsv1Iys56h4+P9TrgotSgGfypRwBmOXE+rOHw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793827230;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=vmvxAUknSBSxCTxmOEWiAvm5vMAPUXDxUKGnYTghbkY=;
	b=hulqflbC2zoG2GGlTu00Ttm8mHFTnqFMPgY3uG13lgSx+GpB76wRh1ggeUD5QZBWf2uW
	 zFFbktDDKklmJBlRh0w3DuUImrXCJ0Vis6RghYdrJ6eZ6iIvbAYsaCNMNJJgbFwwaydvd
	 X/n+jSsi2bU8e6r4YTLtps1M77/a413LvU3hoTYo2zwbl+eBQvENRdH0NKMyTrkZ/J4T/
	 V8F0iGxXjIxxB7z7OTSLIkOzhYRKP/q/EyZC18hN6llJrAtHqFZuDt9K5kePIKvndj+DX
	 D5y/iAbH5O04SIiwViMgYUJvaLOWcIvowR/wD/SdOcL+vfb10euV//0sKiIU1b6FThQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=w8mZzqNH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C130606A864;
	Wed,  4 Nov 2026 21:20:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=w8mZzqNH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11DE61F00A16;
	Wed,  4 Nov 2026 21:20:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793827230;
	bh=vmvxAUknSBSxCTxmOEWiAvm5vMAPUXDxUKGnYTghbkY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=w8mZzqNHHQOHiaQgkjdJOKbvvFtUh3KtC2s/HOKM6mrVE1t5nrxQCfKGfo3RnzXgu
	 GPfFLLzh7FjdumwFZY+uDhxFFI/ljU8eApeKSw1SYHg9E1bbOj81ixs/B3VC7BLu5x
	 tNsro7TSlai3iTq7+ejsErttChDvFP1XHiguu0lc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Heming Zhao <heming.zhao@suse.com>,
	Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>
Subject: [PATCH 7.3 274/547] ocfs2/dlm: hold the lookup reference across convert AST enqueue
Date: Wed,  4 Nov 2026 16:07:38 -0500
Message-ID: <20261104211045.982682438@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211038.406938024@linuxfoundation.org>
References: <20261104211038.406938024@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joseph Qi <joseph.qi@linux.alibaba.com>

commit 125fe08ff6cfa064e1212f586f01993ee45c0330 upstream.

dlm_convert_lock_handler() drops the reference it took when it found the
lock on res->granted at its leave label, one statement before it calls
dlm_queue_ast().  dlm_free_dead_locks() takes res->spinlock and drops the
list and base references, so a peer death landing in that gap leaves the
handler's own put as the one that frees the lock, and __dlm_queue_ast()
then reads lock->lockres from freed memory.

The handler is registered next to dlm_create_lock_handler(), so a convert
message buffered on a dying peer's socket arrives on the same o2net
receive work that o2net_disconnect_node() does not wait for.  The two can
interleave as follows, with the reference counts as they are before this
fix:

  Socket data-ready       Node-down thread      Receive worker
  -----------------       ----------------      --------------
  o2net_data_ready()
    select sc under
    callback read lock
                          o2net_disconnect_node()
                            queue shutdown
                            begin flush; new color
    queue sc_rx_work
    in the new color
    release callback lock
                            shutdown socket
                            flush returns
                                                read buffered convert_lock
                                                dlm_convert_lock_handler()
                                                  find lock on res->granted
                                                  dlm_lock_get()  refs = 3
                                                  lock res->spinlock
                                                  __dlmconvert_master()
                                                    call_ast = 1
                                                  unlock res->spinlock
                          DLM node-down cleanup
                            lock res->spinlock
                            dlm_free_dead_locks()
                              unlink lock
                              put list ref  refs = 2
                              put base ref  refs = 1
                            unlock res->spinlock
                                                dlm_lock_put()  refs = 0
                                                  free lock
                                                dlm_queue_ast()
                                                  __dlm_queue_ast()
                                                  read lock->lockres
                                                  (use-after-free)

__dlmconvert_master() only moves the lock between lists, so the count
entering the gap is base, list and lookup.  Drop the lookup reference
after the AST is queued instead of before it and the race ends with the
one __dlm_queue_ast() took, which dlm_flush_asts() releases later with
ast_pending cleared and ast_list unlinked.  No extra get is needed, and
the normal case ends with the same count as before.

dlmconvert_master() has the same shape but is only reached from dlmlock()
for a lock this node owns, which dlm_free_dead_locks() never matches.

Link: https://lore.kernel.org/20261014112321.2955584-1-joseph.qi@linux.alibaba.com
Fixes: 2c5c54aca9d0 ("ocfs2/dlm: Add missing dlm_lock_put()s")
Signed-off-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Heming Zhao <heming.zhao@suse.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ocfs2/dlm/dlmconvert.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

--- a/fs/ocfs2/dlm/dlmconvert.c
+++ b/fs/ocfs2/dlm/dlmconvert.c
@@ -534,15 +534,19 @@ int dlm_convert_lock_handler(struct o2ne
 	}
 
 leave:
-	if (lock)
-		dlm_lock_put(lock);
-
 	/* either queue the ast or release it, if reserved */
 	if (call_ast)
 		dlm_queue_ast(dlm, lock);
 	else if (ast_reserved)
 		dlm_lockres_release_ast(dlm, res);
 
+	/*
+	 * Keep the lock alive through AST enqueue: a concurrent
+	 * dlm_free_dead_locks() drops the list and base references.
+	 */
+	if (lock)
+		dlm_lock_put(lock);
+
 	if (kick_thread)
 		dlm_kick_thread(dlm, res);
 


