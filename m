Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8D1130EF9A;
	Tue, 21 Jul 2026 22:27:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784672861; cv=none; b=AIv2EPoQLSEh/Om2oEpbKJd3GPDsReqWLKm3dvDh2RLaAK7lIIo8GG/Jbd8PoUGKEpvSZnflqZwVF/dlzbbyuGVnLYXRMnEZBcDoP0rxSuJWH2Eo2gsDr/XlGSqFCDI30CTrZIywO3O1wCMWsRo9KGbj7SzoSfOaB6NS8APkBuE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784672861; c=relaxed/simple;
	bh=I8OlI5FyyvoNXT8ncOSbBsVisKjB8r4aIbtTPe4coSU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HKqInL1d/ryHrjTofz3t6QipBNQXMwzWdNrcpCfMXFonx+BhbWjSY529jStKublOW/YK8lK7FTIWSaxlQ+QY9JhIk+kC2JLSoCbGa0EHvah99Q0FYzhVPuDVGAK/EkfcknalwPIvxJJsgmfPF+Vp43ZUsPQO7EiN9hsT9eUGD8g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kvk1H9Vj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kvk1H9Vj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 222021F000E9;
	Tue, 21 Jul 2026 22:27:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784672859;
	bh=Q9XuaFndJPH+Qo0zwxolU9QVhx9Vt/JxYUFF9KEcFz8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kvk1H9Vj+DVmKpfS2Jrxx5sS/f+RUpyui252g8m9IpiG2LosRgxZHeoIowwLuj+D5
	 5z2N/SVQzC/IrbQPRD3R5xf9pT9V/uq3HhH07oCjv6H32LEO0KQGkMLl4d3MlJvg0r
	 HbALyfjHnEmojkT6sx4wLM3LWNzV9j5VQBRhVgyU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	munan Huang <munanevil@gmail.com>,
	ChenXiaoSong <chenxiaosong@kylinos.cn>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 785/843] ksmbd: fix use-after-free in __ksmbd_close_fd() via durable scavenger
Date: Tue, 21 Jul 2026 17:27:00 +0200
Message-ID: <20260721152423.721419064@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Namjae Jeon <linkinjeon@kernel.org>

[ Upstream commit 235e32320a470fcd3998fb3774f2290a0eb302a1 ]

When a durable file handle survives session disconnect (TCP close without
SMB2_LOGOFF), session_fd_check() sets fp->conn = NULL to preserve the
handle for later reconnection. However, it did not clean up the byte-range
locks on fp->lock_list.

Later, when the durable scavenger thread times out and calls
__ksmbd_close_fd(NULL, fp), the lock cleanup loop did:

    spin_lock(&fp->conn->llist_lock);

This caused a slab use-after-free because fp->conn was NULL and the
original connection object had already been freed by
ksmbd_tcp_disconnect().

The root cause is asymmetric cleanup: lock entries (smb_lock->clist) were
left dangling on the freed conn->lock_list while fp->conn was nulled out.

To fix this issue properly, we need to handle the lifetime of
smb_lock->clist across three paths:
 - Safely skip clist deletion when list is empty and fp->conn is NULL.
 - Remove the lock from the old connection's lock_list in
   session_fd_check()
 - Re-add the lock to the new connection's lock_list in
   ksmbd_reopen_durable_fd().

Fixes: c8efcc786146 ("ksmbd: add support for durable handles v1/v2")
Co-developed-by: munan Huang <munanevil@gmail.com>
Signed-off-by: munan Huang <munanevil@gmail.com>
Reviewed-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Stable-dep-of: c1016dd1d8b2 ("ksmbd: track the connection owning a byte-range lock")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ksmbd/vfs_cache.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/fs/ksmbd/vfs_cache.c
+++ b/fs/ksmbd/vfs_cache.c
@@ -317,9 +317,11 @@ static void __ksmbd_close_fd(struct ksmb
 	 * there are not accesses to fp->lock_list.
 	 */
 	list_for_each_entry_safe(smb_lock, tmp_lock, &fp->lock_list, flist) {
-		spin_lock(&fp->conn->llist_lock);
-		list_del(&smb_lock->clist);
-		spin_unlock(&fp->conn->llist_lock);
+		if (!list_empty(&smb_lock->clist) && fp->conn) {
+			spin_lock(&fp->conn->llist_lock);
+			list_del(&smb_lock->clist);
+			spin_unlock(&fp->conn->llist_lock);
+		}
 
 		list_del(&smb_lock->flist);
 		locks_free_lock(smb_lock->fl);


