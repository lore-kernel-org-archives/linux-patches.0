Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4E4622091;
	Mon, 18 Dec 2023 14:00:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rR5i4kY8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C356C433C7;
	Mon, 18 Dec 2023 14:00:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702908018;
	bh=sEqwoQnDIkzrrBBN4Y5nSimLokTi7CcbgHCZdAjQgKE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rR5i4kY8Zy0J7nzqsSJgSmvAwTOBYMlooEd3jAxAgvaQzcHIVUE9RfjcF6ii4WViI
	 Sxg715qkGAfwGtr7aKHcExb8g+t8SUfNlFa68BQWLckcKknFNgFJiDtx1fNeneYX84
	 vYv+f4GXeklslrkJc1tmhEnjqDTYkiuGuTRgg1yg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bill MacAllister <bill@ca-zephyr.org>,
	Jeffrey E Altman <jaltman@auristor.com>,
	David Howells <dhowells@redhat.com>,
	Marc Dionne <marc.dionne@auristor.com>,
	linux-afs@lists.infradead.org,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 005/166] afs: Fix refcount underflow from error handling race
Date: Mon, 18 Dec 2023 14:49:31 +0100
Message-ID: <20231218135105.180318713@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231218135104.927894164@linuxfoundation.org>
References: <20231218135104.927894164@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Howells <dhowells@redhat.com>

[ Upstream commit 52bf9f6c09fca8c74388cd41cc24e5d1bff812a9 ]

If an AFS cell that has an unreachable (eg. ENETUNREACH) server listed (VL
server or fileserver), an asynchronous probe to one of its addresses may
fail immediately because sendmsg() returns an error.  When this happens, a
refcount underflow can happen if certain events hit a very small window.

The way this occurs is:

 (1) There are two levels of "call" object, the afs_call and the
     rxrpc_call.  Each of them can be transitioned to a "completed" state
     in the event of success or failure.

 (2) Asynchronous afs_calls are self-referential whilst they are active to
     prevent them from evaporating when they're not being processed.  This
     reference is disposed of when the afs_call is completed.

     Note that an afs_call may only be completed once; once completed
     completing it again will do nothing.

 (3) When a call transmission is made, the app-side rxrpc code queues a Tx
     buffer for the rxrpc I/O thread to transmit.  The I/O thread invokes
     sendmsg() to transmit it - and in the case of failure, it transitions
     the rxrpc_call to the completed state.

 (4) When an rxrpc_call is completed, the app layer is notified.  In this
     case, the app is kafs and it schedules a work item to process events
     pertaining to an afs_call.

 (5) When the afs_call event processor is run, it goes down through the
     RPC-specific handler to afs_extract_data() to retrieve data from rxrpc
     - and, in this case, it picks up the error from the rxrpc_call and
     returns it.

     The error is then propagated to the afs_call and that is completed
     too.  At this point the self-reference is released.

 (6) If the rxrpc I/O thread manages to complete the rxrpc_call within the
     window between rxrpc_send_data() queuing the request packet and
     checking for call completion on the way out, then
     rxrpc_kernel_send_data() will return the error from sendmsg() to the
     app.

 (7) Then afs_make_call() will see an error and will jump to the error
     handling path which will attempt to clean up the afs_call.

 (8) The problem comes when the error handling path in afs_make_call()
     tries to unconditionally drop an async afs_call's self-reference.
     This self-reference, however, may already have been dropped by
     afs_extract_data() completing the afs_call

 (9) The refcount underflows when we return to afs_do_probe_vlserver() and
     that tries to drop its reference on the afs_call.

Fix this by making afs_make_call() attempt to complete the afs_call rather
than unconditionally putting it.  That way, if afs_extract_data() manages
to complete the call first, afs_make_call() won't do anything.

The bug can be forced by making do_udp_sendmsg() return -ENETUNREACH and
sticking an msleep() in rxrpc_send_data() after the 'success:' label to
widen the race window.

The error message looks something like:

    refcount_t: underflow; use-after-free.
    WARNING: CPU: 3 PID: 720 at lib/refcount.c:28 refcount_warn_saturate+0xba/0x110
    ...
    RIP: 0010:refcount_warn_saturate+0xba/0x110
    ...
    afs_put_call+0x1dc/0x1f0 [kafs]
    afs_fs_get_capabilities+0x8b/0xe0 [kafs]
    afs_fs_probe_fileserver+0x188/0x1e0 [kafs]
    afs_lookup_server+0x3bf/0x3f0 [kafs]
    afs_alloc_server_list+0x130/0x2e0 [kafs]
    afs_create_volume+0x162/0x400 [kafs]
    afs_get_tree+0x266/0x410 [kafs]
    vfs_get_tree+0x25/0xc0
    fc_mount+0xe/0x40
    afs_d_automount+0x1b3/0x390 [kafs]
    __traverse_mounts+0x8f/0x210
    step_into+0x340/0x760
    path_openat+0x13a/0x1260
    do_filp_open+0xaf/0x160
    do_sys_openat2+0xaf/0x170

or something like:

    refcount_t: underflow; use-after-free.
    ...
    RIP: 0010:refcount_warn_saturate+0x99/0xda
    ...
    afs_put_call+0x4a/0x175
    afs_send_vl_probes+0x108/0x172
    afs_select_vlserver+0xd6/0x311
    afs_do_cell_detect_alias+0x5e/0x1e9
    afs_cell_detect_alias+0x44/0x92
    afs_validate_fc+0x9d/0x134
    afs_get_tree+0x20/0x2e6
    vfs_get_tree+0x1d/0xc9
    fc_mount+0xe/0x33
    afs_d_automount+0x48/0x9d
    __traverse_mounts+0xe0/0x166
    step_into+0x140/0x274
    open_last_lookups+0x1c1/0x1df
    path_openat+0x138/0x1c3
    do_filp_open+0x55/0xb4
    do_sys_openat2+0x6c/0xb6

Fixes: 34fa47612bfe ("afs: Fix race in async call refcounting")
Reported-by: Bill MacAllister <bill@ca-zephyr.org>
Closes: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=1052304
Suggested-by: Jeffrey E Altman <jaltman@auristor.com>
Signed-off-by: David Howells <dhowells@redhat.com>
Reviewed-by: Jeffrey Altman <jaltman@auristor.com>
cc: Marc Dionne <marc.dionne@auristor.com>
cc: linux-afs@lists.infradead.org
Link: https://lore.kernel.org/r/2633992.1702073229@warthog.procyon.org.uk/ # v1
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/afs/rxrpc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/afs/rxrpc.c b/fs/afs/rxrpc.c
index ed1644e7683f4..d642d06a453be 100644
--- a/fs/afs/rxrpc.c
+++ b/fs/afs/rxrpc.c
@@ -424,7 +424,7 @@ void afs_make_call(struct afs_addr_cursor *ac, struct afs_call *call, gfp_t gfp)
 	if (call->async) {
 		if (cancel_work_sync(&call->async_work))
 			afs_put_call(call);
-		afs_put_call(call);
+		afs_set_call_complete(call, ret, 0);
 	}
 
 	ac->error = ret;
-- 
2.43.0



