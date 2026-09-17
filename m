Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F01084DEC09;
	Thu, 17 Sep 2026 18:53:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789671185; cv=none; b=YERUSNtp6zTvLC4rDQzIHuGARoGqKmzU/+s33t0W6k39xKqtCYkUIuVCOlhL8itmS6Pk+Nn3QISKrhwFxoGHArx9dKksZw0081Ncdv93InRXpk1qtSufFfV/XSnxjNKyKQRATdbIEIATHRmSenyuF4ii/k0LVER+uOgge/ff2D0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789671185; c=relaxed/simple;
	bh=MUfNv6P3B8f6YwY9xI9u1/66GgtkNEgjJPGeUcGNft4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t64ClNbks7LQVAuElUk6xRD0aaHrbz5Ui21kmWwYWK/K3TbvzJ0L7c6bGTHX+3cZRw3Iu3aS1I41u21Uv4w4MwSFDpRXgEB0Jl3lymc96Jbl5y9EpAZKjkRLfXzaTa7tQgbONJNTLVDifITA9LPpBTnqth34Op2bZUgGRWLs+04=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k/0wlkyF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k/0wlkyF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 359821F00893;
	Thu, 17 Sep 2026 18:53:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789671183;
	bh=pCrBdbf78zMxsqOuW3V6Be2/s4SMoZQlBjsSN0tNLi4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=k/0wlkyFF1mTRQkX/sBpx6WkAgx5jhkaSVY8X9G3zC93HJCxuf67l9q710iBHSEPC
	 c3daJ3UCOokfQy+6i377l7HudoqtypswDZpbbCgGAf2dX9o6ewY0hAPuIJsIoYMN+t
	 MNmhe3+iibNcdnGI1Yp77d/hmUU/qRXefIrxVZoQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bjoern Doebel <doebel@amazon.de>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Paulo Alcantara <pc@manguebit.org>
Subject: [PATCH 6.12 0894/1102] smb: client: avoid leaking refcount in cifs_queue_oplock_break()
Date: Thu, 17 Sep 2026 16:13:57 +0100
Message-ID: <20260917151603.032401409@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


