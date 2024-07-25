Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 032A019B5BE;
	Thu, 25 Jul 2024 14:42:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721918521; cv=none; b=o0grE84RyVIOZH2eEdtpKZf1QidaOidHiCPfRHcj9M2B0bKyfkb8XQ+NtkZ85VTIIPoNSDBkmOnEFNXH8kHyqRV+G3MAcH3VvW7yPNXMOYHGiD0KfVZ888cpsi0nz7x0QN/R/uueyLq6fyhKRsz71PN1Cny3tbwKcQVs6Rv/UvM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721918521; c=relaxed/simple;
	bh=Rqf+OZLhFZtt0gdi3z8zasFui1OVL4/qExudBsZdddo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CMIot3GBRiCqmcziTGu6ZqTm1SC2qWXIXzacoOi8J4v0/WNomneoXp4/1MJhhCaPamWKOOxxGpUX81J19OySEw5COB8jZYqJ5hhKJTDe8acXgVEkXJYrIjq8OE3Z+/li6r0NiJcXWdZVkDTOS9Efc5bhygle2WPWEPktR6U8WWA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iSqtwki4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iSqtwki4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 658AAC116B1;
	Thu, 25 Jul 2024 14:42:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721918520;
	bh=Rqf+OZLhFZtt0gdi3z8zasFui1OVL4/qExudBsZdddo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iSqtwki4TcN+/z4kTOESC38rvvvMETkIvziewGVJX0IdKMAs7HJ7mk7CiVKdMaA3Y
	 30VhBE4VijNEjNW+8ZUTOjkljhzYZ04mM9d/1bT33c3bJwiPju6istjY21hPZRQXms
	 ddsz599a5ucgDOnH/LrkskZWD1IME4mfgBrnZwvE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Jann Horn <jannh@google.com>,
	Jeff Layton <jlayton@kernel.org>,
	Christian Brauner <brauner@kernel.org>
Subject: [PATCH 5.4 02/43] filelock: Remove locks reliably when fcntl/close race is detected
Date: Thu, 25 Jul 2024 16:36:25 +0200
Message-ID: <20240725142730.565093055@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240725142730.471190017@linuxfoundation.org>
References: <20240725142730.471190017@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2526,8 +2526,9 @@ int fcntl_setlk(unsigned int fd, struct
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
@@ -2541,9 +2542,7 @@ int fcntl_setlk(unsigned int fd, struct
 		f = fcheck(fd);
 		spin_unlock(&current->files->file_lock);
 		if (f != filp) {
-			file_lock->fl_type = F_UNLCK;
-			error = do_lock_file_wait(filp, cmd, file_lock);
-			WARN_ON_ONCE(error);
+			locks_remove_posix(filp, &current->files);
 			error = -EBADF;
 		}
 	}


