Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793208198;
	b=kYHXj5gCPt5oxqIfdsFYBwsErYNXEC2KvIP5b3apiK6lch1ARy4uyAv1ICK/5MZ1zjJc
	 1DpkaQw1CIuHJ+2Te8a/P/3qVPJ8SfI8xbeUlzdr/PHAWcfa4Ep1y5IYncjpo1uMML7ME
	 Wpy9w8gTrayZNjpo3AzcFiVhRN234QY+gtd4Z6MBDKQkMnhFx+5xhwZjaimqi/UceLGuF
	 FZDAWGt7hJQ2fD/++ulMRY9kP/Oo5l776gx1aTyyVnYWUGIJhfQ7sdPSx9M/bgpQB7+d/
	 7YaanLA1UJ/rUKNHeDzUyUWsIqv2FLwW2Dw1jyLgeKOKlIjbbz7YfxCrYBewwX9P/pQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793208198;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=dUuLYM9R77P2i0oSTZgxIKqK22AyLNxLKyFb3PxfXDQ=;
	b=dRzEBN/FCF2etviTz76gSXtdwR8Z6AXfEJg4yOZH+kIqZVIeKvyeDMYb8/DGDF1qdwel
	 pIxR0l8AcQ0uf01AnZIbwMBXAryhl6ERgL0kLuOtHtrJfyELc9bQlOu3ZrAHqpXv4+z4v
	 jWoiiG4niJbD7x1ZVsk9DbaEasrgWh6t5Pf+wqTaha7N/K1AFf9YGXHXM92AppBWl6FJ5
	 SulLP4uJKXszbRPgknDR6dreHJpVXK7MhWevgXVGQDX1tKoc0G2ZDpgq8UvUotiQzdPYy
	 kLsCxcXUPYghWLoDPWsQuDC9h6K9Bi1owMNt0XodGGkMmfrYJzxfwAkuzX5GuZxGJeQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xoM8QhE+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB265606A32E;
	Wed, 28 Oct 2026 17:23:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xoM8QhE+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37A191F01825;
	Wed, 28 Oct 2026 17:23:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793208197;
	bh=dUuLYM9R77P2i0oSTZgxIKqK22AyLNxLKyFb3PxfXDQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xoM8QhE+EuBl4wauJk4TnvCSFSFg9+ZW/Y9MWeuj2uw57/jxioMs48dfH7Jmj/qu9
	 Ng6oorzVTn99Z2nmEv1jD2lGshzug68kqMIH77gdmNie0+JKc6/j0ZlJUQb8H4olH9
	 aDVzaBNVrw4arbofVTRHMMV5rmL3NKOiEb+t8urg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bjoern Doebel <doebel@amazon.de>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Paulo Alcantara <pc@manguebit.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 034/516] smb: client: avoid leaking refcount in cifs_queue_oplock_break()
Date: Wed, 28 Oct 2026 17:53:06 +0100
Message-ID: <20261028170004.337356832@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bjoern Doebel <doebel@amazon.de>

[ Upstream commit 9f2e63f1b2d5fc5b5423424902c091123e220e7e ]

cifs_queue_oplock_break() unconditionally takes a reference on the
target file before queueing cifs_oplock_break(). Only that work item
decreases the reference counter again.

If another oplock break arrives while that work is still queued,
queue_work() will return false and not queue this second work item. As a
result, we will never reach the point to drop the file reference again
and are leaking this reference. This can be triggered when interacting
with a slow-responding server.

As a result, later unmount operations for this file system will fail with

  BUG: Dentry ... still in use (1) [unmount of cifs cifs]
  VFS: Busy inodes after unmount of cifs (cifs)
  kernel BUG at fs/super.c:777!

Fix this by only incrementing the reference count if the work has been
queued successfully. Taking it after queue_work() is safe because all
three callers hold tcon->open_file_lock across the call and
_cifsFileInfo_put() decrements under that same lock, so a worker that
starts the handler in the window cannot drop the reference before it has
been taken.

Fixes: b98749cac4a69 ("CIFS: keep FileInfo handle live during oplock break")
Cc: stable@vger.kernel.org
Assisted-by: Kiro:claude-opus-5
Signed-off-by: Bjoern Doebel <doebel@amazon.de>
Reviewed-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Paulo Alcantara <pc@manguebit.org>
[ Adjusted the patch path from fs/smb/client/misc.c to fs/cifs/misc.c. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/cifs/misc.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/fs/cifs/misc.c b/fs/cifs/misc.c
index b4199b4085db3..e9be60ca34454 100644
--- a/fs/cifs/misc.c
+++ b/fs/cifs/misc.c
@@ -628,10 +628,11 @@ void cifs_queue_oplock_break(struct cifsFileInfo *cfile)
 	 * open_file_lock to enforce the validity of it for the oplock
 	 * break handler. The matching put is done at the end of the
 	 * handler.
+	 *
+	 * Only take a reference if the work is actually queued.
 	 */
-	cifsFileInfo_get(cfile);
-
-	queue_work(cifsoplockd_wq, &cfile->oplock_break);
+	if (queue_work(cifsoplockd_wq, &cfile->oplock_break))
+		cifsFileInfo_get(cfile);
 }
 
 void cifs_done_oplock_break(struct cifsInodeInfo *cinode)
-- 
2.53.0



