Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18D2A43C7C5;
	Tue, 21 Jul 2026 21:11:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784668278; cv=none; b=j1dTUT5k39RtCx9sY1G9s5f7ZrF6M0QLl1QWgUCcFviNL1VPoDXpiUWw26VbPluu7wS3gel7BjiC2uO36qCu64r1+5X8ZSBKo3QwJP+uaaJk+t06NzPqidZpYDnSJ56fWzzvljrIL0bo5dpLFc5nXpQBeJ4O84TEEgIHhVQhinA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784668278; c=relaxed/simple;
	bh=1uBYIS2J/ltckugyt+AJF0gUWRSWqkBZyd94cr0pLTY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OQIK+MoHE2GzRcjgZZUffKmgWYjRV0U1drFOb9FFNYT1i00WXvxqkmjB56L95LPfISaONQyhDTvd+08749StRfXosVZ6AqyA6JEkTTW2FU5X0Mla+Uz73hoO68Ktns5y7s9Xe9We/ypsftUslFO3foGSDczIhI7YR0rug5SJv8c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OiFJ6ANw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OiFJ6ANw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D49D1F000E9;
	Tue, 21 Jul 2026 21:11:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784668277;
	bh=96aCNj3aGNt4gZXjU09X8c7thzGo91GtJVvmhMegsfk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OiFJ6ANwFE4YjhuXgZYqJra38Q7z0GPU9TWeT63ntEX1LddQASbyno9zHtqWc4jk/
	 xLU9QjKemIuPDS6TUpMODSalrRKahrKDXuyZOioqOR/uuTlpUEwSir9qEXnwVQZp/S
	 tO3c8ypBZmL35GhEpMDqW1Os6g0jrVy+xaJvSU1A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gil Portnoy <dddhkts1@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.1 0116/1067] ksmbd: fix use-after-free of a deferred file_lock on SMB2_CLOSE then SMB2_CANCEL
Date: Tue, 21 Jul 2026 17:11:57 +0200
Message-ID: <20260721152427.183368590@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -6816,14 +6816,14 @@ int smb2_cancel(struct ksmbd_work *work)
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


