Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A80093D3CE5;
	Wed, 30 Sep 2026 19:17:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790795871; cv=none; b=pd1MeBwd2pQ8I7S/ulm5/hxAYuQcftAdgUlqogCHElrIe1oE9oF7q2WAna502vadIqk4su4tROM7t3BcZlEL7UJIRLUwK+nHA96bw1SRZ/eUzlXKgZPnrrpAzESfvyNj7K3pP0LmC3JMve066heXvtLmOY0dqET5qG64z9Xcve4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790795871; c=relaxed/simple;
	bh=KC5eKxRGJMWZ+r/re3eKc5/4R2MKtANKMcelaq0i8aE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M8tAIgaFlMJ2ixwYNprHH6VIbbOk9Uc8kx2EP4huV/nAocrqJgaURFOoqJxSC3952XT71aavfiwKv+LjZOYpXWg7MXlD/C2gKHD8C8DXIQuG0CeQaS4rz92AVV5mLxbNIFie7V4+5spNMeXrF0R/MASxNY4uQ/586UPWmqc4thc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=y4w4sP4w; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="y4w4sP4w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD06B1F000FF;
	Wed, 30 Sep 2026 19:17:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790795870;
	bh=8KhH6uEMECvWbaXRD0EmBoHfEoGTtP3bkwU3iKDH9Zo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=y4w4sP4wnkHRQVVm0LscmGOt++2o0FD7OmHUty6w4CWjBdliNoyof0lC1t+3adrRx
	 N1AEUQkYllz+DAF/YHikeSO0alLthxDgMFIuT+mNvsVe0vU1YbiSh43DWIfbEGEX8B
	 xXuMZcTeDnGbELCbD7otB3zdQkP8M2wQP3K8sBPo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bjoern Doebel <doebel@amazon.de>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Paulo Alcantara <pc@manguebit.org>
Subject: [PATCH 6.6 0668/1193] smb: client: avoid leaking refcount in cifs_queue_oplock_break()
Date: Wed, 30 Sep 2026 17:22:32 +0200
Message-ID: <20260930152449.084249323@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bjoern Doebel <doebel@amazon.de>

commit 9f2e63f1b2d5fc5b5423424902c091123e220e7e upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/misc.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/fs/smb/client/misc.c
+++ b/fs/smb/client/misc.c
@@ -654,10 +654,11 @@ void cifs_queue_oplock_break(struct cifs
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


