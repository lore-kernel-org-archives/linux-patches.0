Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFD7F3F822B;
	Thu, 16 Jul 2026 14:06:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784210766; cv=none; b=UjJn+PNtzSgd+KjsXn4FCHwdZeQ95FOJlOhq9YmbhOHZlkwXrh9G3Cgnh2qCjXM+y3bt4zv+C6OWAk17v7JjJWVS9StlMRw6mMPyIztXMoipYYGbNz3gBRVKG1RdjJxri2mUUsJolOGwQN3HDJkVNawLsdAT+Jo1OREKYrQbLwM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784210766; c=relaxed/simple;
	bh=neGrDEl2twTZJ0PGZxzvIRZbUtPuX/xcAoxdj0rVB2U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p5WXbrT4GJhJ08eKJpozVGX3zulVXDt1szABuf4YrqlrhOPFGToBFmQQ/IA1xEZT5tz84XyF75KrYgZBKFEw0XP9xBLh6U3gmhC9iKH1fSBA37hiFaGtSO97AN8qGfK4slBlLMZEcs4D0tmQzb0HaFs+9VTtJqefhenkEOJjv4E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cKp6Qcc8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cKp6Qcc8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40D021F00A3A;
	Thu, 16 Jul 2026 14:06:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784210765;
	bh=oWa6G/LnmWlmk8TIVt/nxBtoOaOv0Uz9JgCoLkXBeHw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cKp6Qcc8zVdFrBk9UmTUtVyrGt30aQ7WytBJYbPcF1jO6R1AroI0YXvQXFGNBu3Kg
	 MkptDD5Dv08Ek9ONXCY77FDl4LVpGmaWDjla/7ao3anFclSn153SsiCaVkO0wKAZiX
	 vv22blQoZtXznB+FcaW6++2cKUAok9wx2tW6I/Ck=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gil Portnoy <dddhkts1@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.18 171/480] ksmbd: fix use-after-free of a deferred file_lock on SMB2_CLOSE then SMB2_CANCEL
Date: Thu, 16 Jul 2026 15:28:38 +0200
Message-ID: <20260716133048.408330267@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133044.672218725@linuxfoundation.org>
References: <20260716133044.672218725@linuxfoundation.org>
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

From: Gil Portnoy <dddhkts1@gmail.com>

commit 10f293a07f9e10e988b0ae44e2e99c631f5a68e0 upstream.

Commit f580d27e8928 ("ksmbd: fix use-after-free of a deferred file_lock on
double SMB2_CANCEL") made smb2_cancel() skip a work whose state is
KSMBD_WORK_CANCELLED, so its cancel_fn cannot be fired a second time. But
KSMBD_WORK has three states (ACTIVE, CANCELLED, CLOSED), and the same
freeing producer path is reached for CLOSED too:

  SMB2_CLOSE on the locking handle -> set_close_state_blocked_works() sets
  the deferred work's state to KSMBD_WORK_CLOSED and wakes the smb2_lock()
  worker. The worker takes the non-ACTIVE early-exit, locks_free_lock()s
  the file_lock and, because the state is not KSMBD_WORK_CANCELLED, takes
  the STATUS_RANGE_NOT_LOCKED branch with "goto out2" -- which, like the
  cancelled branch, skips release_async_work(). The work stays on
  conn->async_requests with a live cancel_fn = smb2_remove_blocked_lock
  pointing at the freed file_lock.

A subsequent SMB2_CANCEL for the same AsyncId then passes the
KSMBD_WORK_CANCELLED-only guard (its state is KSMBD_WORK_CLOSED), so
smb2_cancel() fires cancel_fn again over the freed file_lock -- the same
use-after-free fixed, via SMB2_CLOSE instead of a first SMB2_CANCEL:

  BUG: KASAN: slab-use-after-free in __locks_delete_block
    __locks_delete_block
    locks_delete_block
    ksmbd_vfs_posix_lock_unblock
    smb2_remove_blocked_lock
    smb2_cancel                 <- 2nd SMB2_CANCEL fires cancel_fn
    handle_ksmbd_work
  Allocated by ...: locks_alloc_lock <- smb2_lock
  Freed by ...:     locks_free_lock  <- smb2_lock (non-ACTIVE early-exit)
  ... cache file_lock_cache of size 192

Reproduced on mainline 7.1-rc7 (which already contains f580d27e8928) with
KASAN by an authenticated SMB client; the double-SMB2_CANCEL control is
silent on that kernel, so the splat is attributable to the CLOSE trigger.

Only an ACTIVE deferred work may have its cancel_fn fired: both terminal
states (CANCELLED and CLOSED) reach the smb2_lock() early-exit that frees
the file_lock and skips release_async_work(). Guard on KSMBD_WORK_ACTIVE
so any non-active work is skipped.

Fixes: f580d27e8928 ("ksmbd: fix use-after-free of a deferred file_lock on double SMB2_CANCEL")
Cc: stable@vger.kernel.org
Signed-off-by: Gil Portnoy <dddhkts1@gmail.com>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/server/smb2pdu.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -7334,14 +7334,14 @@ int smb2_cancel(struct ksmbd_work *work)
 				continue;
 
 			/*
-			 * A cancelled deferred byte-range lock frees its
-			 * file_lock and takes the smb2_lock() early-exit that
-			 * skips release_async_work(), so the work stays on
-			 * conn->async_requests with a live cancel_fn pointing
-			 * at the freed file_lock.  Re-firing it on a second
-			 * SMB2_CANCEL is a use-after-free.
+			 * Only an ACTIVE deferred work may have its cancel_fn
+			 * fired.  A CANCELLED or CLOSED work already took the
+			 * smb2_lock() non-ACTIVE early-exit that frees the
+			 * file_lock and skips release_async_work(), so it is
+			 * still on conn->async_requests with a live cancel_fn
+			 * pointing at the freed file_lock.
 			 */
-			if (iter->state == KSMBD_WORK_CANCELLED)
+			if (iter->state != KSMBD_WORK_ACTIVE)
 				break;
 
 			ksmbd_debug(SMB,


