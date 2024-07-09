Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEB601586C4;
	Tue,  9 Jul 2024 11:26:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720524374; cv=none; b=Pb2mxG4KYDfChjoZNcfGc9J3ZCtmgBYXxcuQKPspzQarrpHLGDt/o1pSM6JjWSRcusEBqs54qdPVKi51I49F7T7quLdYp/344xO8Ev56bjenVr9xC7V1sF0FKZixuLWzmI4fwWtOIRN70LBH9R/Hxz/2+Eh6ZQrIGDsZB3ocLIo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720524374; c=relaxed/simple;
	bh=BvFlT4HGthUvQS1D0OjTngLbJ87QmmGTS8zu/KbOhxs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YUJpYb0TahQunwowF+xigEdIZj0hZ9+CsnEwL8Fao8TsxikYUUh6HceXwgEsFsxio7Iu0ceU6FyjLUOlW8hfDawRGml8qa1gqoRyPih9o8FkzsB43N8Np0uROoe/hjvCcBw35ITI0slByuEQ73qwvlfcgU6v7A7+62uetTsEKe0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I28d3Cpn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I28d3Cpn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78338C3277B;
	Tue,  9 Jul 2024 11:26:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720524373;
	bh=BvFlT4HGthUvQS1D0OjTngLbJ87QmmGTS8zu/KbOhxs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=I28d3CpnFg9QRDmjxApMPXAM8JGO7E2i18J9Jp1WcylbJeoBWWLZJ9H1gH1r9PNKB
	 KNSe7UTGfIQOBGEjPJIyttRpjakfbO/qa26evYQJcrWIJseT4uhbpuOxgHCHuBX563
	 FWCTyIQ1BwU1cxIZcHPsBphu72tGvpwYVyrfPWwA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Jann Horn <jannh@google.com>,
	Jeff Layton <jlayton@kernel.org>,
	Christian Brauner <brauner@kernel.org>
Subject: [PATCH 6.9 159/197] filelock: Remove locks reliably when fcntl/close race is detected
Date: Tue,  9 Jul 2024 13:10:13 +0200
Message-ID: <20240709110715.108690884@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240709110708.903245467@linuxfoundation.org>
References: <20240709110708.903245467@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/locks.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

--- a/fs/locks.c
+++ b/fs/locks.c
@@ -2448,8 +2448,9 @@ int fcntl_setlk(unsigned int fd, struct
 	error = do_lock_file_wait(filp, cmd, file_lock);
 
 	/*
-	 * Attempt to detect a close/fcntl race and recover by releasing the
-	 * lock that was just acquired. There is no need to do that when we're
+	 * Detect close/fcntl races and recover by zapping all POSIX locks
+	 * associated with this file and our files_struct, just like on
+	 * filp_flush(). There is no need to do that when we're
 	 * unlocking though, or for OFD locks.
 	 */
 	if (!error && file_lock->c.flc_type != F_UNLCK &&
@@ -2464,9 +2465,7 @@ int fcntl_setlk(unsigned int fd, struct
 		f = files_lookup_fd_locked(files, fd);
 		spin_unlock(&files->file_lock);
 		if (f != filp) {
-			file_lock->c.flc_type = F_UNLCK;
-			error = do_lock_file_wait(filp, cmd, file_lock);
-			WARN_ON_ONCE(error);
+			locks_remove_posix(filp, files);
 			error = -EBADF;
 		}
 	}


