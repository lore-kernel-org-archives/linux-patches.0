Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89A922EEE68;
	Tue, 16 Jun 2026 15:29:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781623763; cv=none; b=lDioGMibSfox2YO9Mnvxl+VNk92xekVtgtRZkJVdNIUYW8i7o1G9/5uRLwocah78zpx95mbpoEPEm82d9MdD2YC5vf/PiHx3vuXs2pM8NbI2hFpieph7bMgWUWv7oaoy/gjkgwia/syOVc0S/wo3T7MOlUJOB2anZFomhntra/0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781623763; c=relaxed/simple;
	bh=ssMctC7F0gV4mtNyWfxfJfTHefAwz5eT9vdOA3d7uGQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Dg+vbNhKIelKvpXqHXwBmu6GkB7EZuLveSSl8b0egcXS/18+YWe9Q4HnCI7ynuwj+zNqrbGmZEAjoRGxYpYbr8T7bKRAbkwiPgjjPRocSzR1NkbVB/An2mj+9N0ZcF8Ss3KV32seNv5pgkBnAoQiOCdikOc6AXYHRPB2jc/kZd8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ipw908wI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ipw908wI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04F231F000E9;
	Tue, 16 Jun 2026 15:29:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781623759;
	bh=ZDNAxjpWKoHf5NYE1m6Bos0W++udqSrs6lnFLRverkM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ipw908wIZcxW1V2T+ZXvP0rzFfO1oMcOW4Okg4474BBNQx6fQRRKBgf3XwaAgfUrt
	 pjCnJGcEmpAXxR/ZWYOt6G1qQYfBbkKDwddfq7zuIm1eKUrL5IiR+VPtMcPuxOgzDX
	 wGU7YNppDeJV+BykiYxUfWKb+9MqjUjKYGea7nM8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gil Portnoy <dddhkts1@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 7.0 203/378] ksmbd: fix use-after-free of a deferred file_lock on double SMB2_CANCEL
Date: Tue, 16 Jun 2026 20:27:14 +0530
Message-ID: <20260616145121.071650921@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145109.744539446@linuxfoundation.org>
References: <20260616145109.744539446@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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
@@ -7327,6 +7327,17 @@ int smb2_cancel(struct ksmbd_work *work)
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


