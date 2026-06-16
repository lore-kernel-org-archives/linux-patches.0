Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74ED847CC7F;
	Tue, 16 Jun 2026 17:41:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781631720; cv=none; b=Oji5tFlgPykVEKjSGwyaUzr87m64DH4O1x60mgFcLwtpjUX5s1S0ePlSfEk5Gn3wnSpg5hjqYksDbx9uwYt3e3BqKw2befsQs96mVL1o4r6VdQk132CtiTEnSxf6CKc9BlV8I9rjKY7odLAz4yNU57peZG8xnRk3D06VqcdwbKo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781631720; c=relaxed/simple;
	bh=tgTf8fUh5aRArfwmxehXKtxUnNkkNjAKGOnYZGwOcKU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YjSJRy8u0oNT1LCbZ66VdTDFSKtbLT106x/168AD+XRA6QgqI4roVBjS8e9PWONMRnYtwkjiyXgbNrUVBOGw+JXET0ZTx47PC4gJMeurYkqxMdi4yP+scymhxuMOYnv3A199VVcxRHmdKzeD+dGA6yKfZlaMX31afxfJzMcvNoQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d19U7Y5s; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d19U7Y5s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50D801F00A3A;
	Tue, 16 Jun 2026 17:41:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781631715;
	bh=o2cKLRB2fd361Cd+oOJaWsqIKkNIx1yhKvbow5zIG7Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=d19U7Y5suSc6rYAmJcBCvYSbVYraGEEQwmF4mRrS+/VpQpUqjbiMqm4Qwr3eIZ7LY
	 GJm3UOZeaKuN6PdD/WiDeQVgWr0re7sIgDrNLrORAqpL1VMbsV0fSFllO6zWKb0cJj
	 FHswoWCbBcELCiRU2owU279VSA4h9SLIs1Iy1iI8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gil Portnoy <dddhkts1@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.1 272/522] ksmbd: fix use-after-free of a deferred file_lock on double SMB2_CANCEL
Date: Tue, 16 Jun 2026 20:26:59 +0530
Message-ID: <20260616145138.690642369@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145125.307082728@linuxfoundation.org>
References: <20260616145125.307082728@linuxfoundation.org>
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
@@ -6810,6 +6810,17 @@ int smb2_cancel(struct ksmbd_work *work)
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


