Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56CDD4534B4;
	Tue, 16 Jun 2026 16:00:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781625630; cv=none; b=lYU36sxd+QPqRCASPIPg24IZUj729LBq5Iu7TY3szWNApTHv88SKaBRc6OqXx46APPHDvzAucb7aye3m6XPzdogX2saOHCipZNBn0ZOUZ+i8WnbJPySL5dqEeqGs/t/PkuvyGmxzXjcUMAtePywI/+slvQE1Mq6GjgQPbh/gv/I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781625630; c=relaxed/simple;
	bh=AbfSACgVlAvItdRWyYhPlnkcqGelrFOBd6vRC0jVDT0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cQZbE/nUQ5ueRsJeTJQAEMmc+MkIvbvid56ZupcLxvh1FXcfr5OP4pdomFIUamK58L9Eb7nJP1SqJ1+pRt0lCZaOBRBrsES5dutk4X8JCbThW6KI5n18u4xWjVNYQ/uUzyM9UayIT/gRXR2cc3WRm/U0yPa+XElKkbEtRwCrJ0E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qi5pAC44; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qi5pAC44"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 633371F000E9;
	Tue, 16 Jun 2026 16:00:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781625629;
	bh=OPas+cDFqBZR6D037aHvtGc/dkJeM3Ji4B18mqWxYwI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qi5pAC44jWasGLfqzz5T2uIOCxPSjrup26lkpPbvTe9Ls+N/MeabxkwnYhjWk86i9
	 QsPFh/Qs1T0uhDLWjRy9ouBCFreN3FN6KRQQC1LcIiZ9Y/xprQ3M2r9Ino1XtH0YKO
	 +ub5vfFTmYiL6ZqVjQKKop7SqH22vgxw8caw6Va8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gil Portnoy <dddhkts1@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.18 170/325] ksmbd: fix use-after-free of a deferred file_lock on double SMB2_CANCEL
Date: Tue, 16 Jun 2026 20:29:26 +0530
Message-ID: <20260616145106.300754133@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145057.827196531@linuxfoundation.org>
References: <20260616145057.827196531@linuxfoundation.org>
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

commit f580d27e8928828693df44ba2db0fffdbe11dfea upstream.

A deferred byte-range lock (an SMB2_LOCK that blocks) registers an async work on
conn->async_requests via setup_async_work(), with cancel_fn =
smb2_remove_blocked_lock and cancel_argv[0] pointing at the struct file_lock.

When the request is cancelled, the worker frees the file_lock with
locks_free_lock() and takes the cancelled early-exit, which "goto out"s and never
reaches release_async_work() -- the only site that unlinks the work from
conn->async_requests and clears cancel_fn/cancel_argv. The work therefore stays
matchable on async_requests with a live cancel_fn pointing at the freed file_lock,
until connection teardown finally runs release_async_work().

smb2_cancel() fires cancel_fn unconditionally with no state guard, so a second
SMB2_CANCEL for the same AsyncId, arriving in that window, re-runs
smb2_remove_blocked_lock() on the freed file_lock -- a slab use-after-free:

  BUG: KASAN: slab-use-after-free in __locks_delete_block
    __locks_delete_block
    locks_delete_block
    ksmbd_vfs_posix_lock_unblock
    smb2_remove_blocked_lock
    smb2_cancel                 <- 2nd SMB2_CANCEL fires cancel_fn
    handle_ksmbd_work
  Allocated by ...: locks_alloc_lock <- smb2_lock
  Freed by ...:     locks_free_lock  <- smb2_lock (cancelled branch)
  ... cache file_lock_cache of size 192

Reproduced on mainline with KASAN by an authenticated SMB client.

Skip a work whose state is already KSMBD_WORK_CANCELLED so its cancel callback
cannot be fired a second time.

Cc: stable@vger.kernel.org
Signed-off-by: Gil Portnoy <dddhkts1@gmail.com>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/server/smb2pdu.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -7328,6 +7328,17 @@ int smb2_cancel(struct ksmbd_work *work)
 			    le64_to_cpu(hdr->Id.AsyncId))
 				continue;
 
+			/*
+			 * A cancelled deferred byte-range lock frees its
+			 * file_lock and takes the smb2_lock() early-exit that
+			 * skips release_async_work(), so the work stays on
+			 * conn->async_requests with a live cancel_fn pointing
+			 * at the freed file_lock.  Re-firing it on a second
+			 * SMB2_CANCEL is a use-after-free.
+			 */
+			if (iter->state == KSMBD_WORK_CANCELLED)
+				break;
+
 			ksmbd_debug(SMB,
 				    "smb2 with AsyncId %llu cancelled command = 0x%x\n",
 				    le64_to_cpu(hdr->Id.AsyncId),


