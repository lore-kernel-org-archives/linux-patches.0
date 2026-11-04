Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831524;
	b=5gpH/YXmKDSR4NSjk081oy3uZ6Zkh9URaI+CuQouSQaN4Yf/TXU/qEw1dlSC5WOQwgqC
	 Xw/fYKfLpQbcosbpay4gwf9qIrw9r4x7f7FiXW3HvUbT3lwAIpCDcziDmuuluBBAPyXUY
	 4ddii0rfydhYX8AovaHwPutcWbSOF6Es4MTcQA/666Uv46pILWN0NBUwNwyuT8yj3YzsL
	 hnq05sFmZhq/yXKzlTvmK5GjjvLQI6D6g/iZVLGAY0sqjJ/+oSspPDP7NYfS0gCBKFR2D
	 vALyF9v8naJJw31p/cjGGFz67JGq33oUn4AN38TAFbDNNG7Hub6WHtauPPJ+PlSyNVA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831524;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=5us5sz5ofU3wGXIGuBSwI71Kugr297Ky5GS1Uv/LYSs=;
	b=TRQ3JYmOKRpisWD7X+pC7UKAUnPd85w5QhJeBzxhP7EIOG9r1/h05MEPf5GpBsKBoLx5
	 DlXGPNCpOvifPpgQYA+aMNLMB6ECteT132VYWtDsNo34+BJPeOQrcUPQfOB7SGVxGMyqt
	 DYP5KXr5xwWuDFEM7nvVr/UlpUVQCPW1F2oHaplfEjZ3A+Qy45o6ArAK6XK8uSsVe6Zct
	 cTs4yH7HSoz8FytuKMejcZKfbkEhAsH52gShxMDX0Zt4cs7gXO723o71fyO20irh6aIMZ
	 uznVpkfDV/Ab0iYrkFqLYqyiFdXyb0AAz7Q7AfuQkZ2MOkD81eX1YUqq3fFHPNaAKBA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bI6C+MEW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC460606E806;
	Wed,  4 Nov 2026 22:32:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bI6C+MEW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DA431F00919;
	Wed,  4 Nov 2026 22:32:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831523;
	bh=5us5sz5ofU3wGXIGuBSwI71Kugr297Ky5GS1Uv/LYSs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bI6C+MEWug91td5RP6st71+oBhyZ4oElG8+hUMBRhg6U8EyrEHFJ9ej7AwUObKn/2
	 HkwypwOzfyGubT2wOz5NctQG4ibrNyLzNpbU6tt8yTWPBt8/Dfp5Qts13eJqrZlzyq
	 0/1mnjBiTss+tgPnt3WLyYfiaYP3WPe9Nogtgu60=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Heming Zhao <heming.zhao@suse.com>,
	Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>
Subject: [PATCH 6.18 0754/1005] ocfs2/dlm: hold the lookup reference across convert AST enqueue
Date: Wed,  4 Nov 2026 16:08:07 -0500
Message-ID: <20261104211104.565959140@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
 


