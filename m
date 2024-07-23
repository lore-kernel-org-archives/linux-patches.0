Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EE4A157A4F;
	Tue, 23 Jul 2024 18:26:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721759187; cv=none; b=mEnyGNnv1EQK4wbNxmgNzvxojQ6JoLkfe0mhUP3fML+4OxyMlXm5D68ISW+FxGWELOBwNuzSfLwlrR9ME0y2y50apalEGTdGikJ4nT5PQ2FdD4h5FBULXtPp5uAO1GfvraQUhsqJCPVNK+VrVNgiHGp6AQj7GuxNG9WbvVGqLII=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721759187; c=relaxed/simple;
	bh=XoxLOClTQ+dgc3yZLAvWJ9d+71pOnVt8mqD9ep6YE58=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KDFy7Sn6T+aeshLQrpd5XVzGXHY664KWofO5D+PHHCLMUAzzwP8myxAjFl1lSHysYnJca4Dy9sI1p99bDyOc+1NnizYgTwTdczawdYt3Exyh3s+bQIwiIRdEsZjbMj0Udd79ztN8zOMtAMJMMoKAfv2/r1KM2p/rcF0LDKZqhD4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nZ1+UaBY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nZ1+UaBY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7F99C4AF09;
	Tue, 23 Jul 2024 18:26:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721759187;
	bh=XoxLOClTQ+dgc3yZLAvWJ9d+71pOnVt8mqD9ep6YE58=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nZ1+UaBYMZnsgmvxUpOWfUQuyVvXFRHxAZQLCBkgqF3WUObQAj9zKUDXTj9Rc3mk2
	 vndLeTvUsSA6aEJOiCNrXDiypuVV9PVFlRxZA7b+VNJ26I9PxgYdiBey/AAxLTDX5z
	 skrnpBuD+jsuR6BlnD12oCoczN9oozus0mrAXeYg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Jann Horn <jannh@google.com>,
	Jeff Layton <jlayton@kernel.org>,
	Christian Brauner <brauner@kernel.org>
Subject: [PATCH 6.1 009/105] filelock: Remove locks reliably when fcntl/close race is detected
Date: Tue, 23 Jul 2024 20:22:46 +0200
Message-ID: <20240723180403.059233132@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240723180402.490567226@linuxfoundation.org>
References: <20240723180402.490567226@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jann Horn <jannh@google.com>

commit 3cad1bc010416c6dd780643476bc59ed742436b9 upstream.

When fcntl_setlk() races with close(), it removes the created lock with
do_lock_file_wait().
However, LSMs can allow the first do_lock_file_wait() that created the lock
while denying the second do_lock_file_wait() that tries to remove the lock.
In theory (but AFAIK not in practice), posix_lock_file() could also fail to
remove a lock due to GFP_KERNEL allocation failure (when splitting a range
in the middle).

After the bug has been triggered, use-after-free reads will occur in
lock_get_status() when userspace reads /proc/locks. This can likely be used
to read arbitrary kernel memory, but can't corrupt kernel memory.
This only affects systems with SELinux / Smack / AppArmor / BPF-LSM in
enforcing mode and only works from some security contexts.

Fix it by calling locks_remove_posix() instead, which is designed to
reliably get rid of POSIX locks associated with the given file and
files_struct and is also used by filp_flush().

Fixes: c293621bbf67 ("[PATCH] stale POSIX lock handling")
Cc: stable@kernel.org
Link: https://bugs.chromium.org/p/project-zero/issues/detail?id=2563
Signed-off-by: Jann Horn <jannh@google.com>
Link: https://lore.kernel.org/r/20240702-fs-lock-recover-2-v1-1-edd456f63789@google.com
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Christian Brauner <brauner@kernel.org>
[stable fixup: ->c.flc_type was ->fl_type in older kernels]
Signed-off-by: Jann Horn <jannh@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/locks.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

--- a/fs/locks.c
+++ b/fs/locks.c
@@ -2394,8 +2394,9 @@ int fcntl_setlk(unsigned int fd, struct
 	error = do_lock_file_wait(filp, cmd, file_lock);
 
 	/*
-	 * Attempt to detect a close/fcntl race and recover by releasing the
-	 * lock that was just acquired. There is no need to do that when we're
+	 * Detect close/fcntl races and recover by zapping all POSIX locks
+	 * associated with this file and our files_struct, just like on
+	 * filp_flush(). There is no need to do that when we're
 	 * unlocking though, or for OFD locks.
 	 */
 	if (!error && file_lock->fl_type != F_UNLCK &&
@@ -2410,9 +2411,7 @@ int fcntl_setlk(unsigned int fd, struct
 		f = files_lookup_fd_locked(files, fd);
 		spin_unlock(&files->file_lock);
 		if (f != filp) {
-			file_lock->fl_type = F_UNLCK;
-			error = do_lock_file_wait(filp, cmd, file_lock);
-			WARN_ON_ONCE(error);
+			locks_remove_posix(filp, files);
 			error = -EBADF;
 		}
 	}


