Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 207144307AD;
	Tue, 21 Jul 2026 20:10:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784664655; cv=none; b=IBTGsrQGhN1f/Mj5ApdAldIt4SUoy7nmLHQo8CYuOki8a3jtpIWVx6gI2LdEhH2YIuEWWaE08FeQW7QkXWyc+IE/Kcnl2JxrqULtJImaoFN+WrdjuHALr7T+TB26NyMlh6GrYjzlfy3CCaSD06sA4/KE1A2R5fuDf5RqGTW1FbI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784664655; c=relaxed/simple;
	bh=tG7fLh8FlJ1zwr5GgiUFHfvxPQbSpixDwEbmO3CfNVE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R3CHIuyx13YcIA9TDbvxrD2aPpW/3Z4flWZ8tteOwLO1252q3pT3m0VwGrMKgs/jY8znyxMzZG0GkprcZ0J3be+YgASK3n45cmiVmD50Cvw8FNMhvTtN1iR+yqM182gPAQG2pbp7wBBIEocNRu8La1ydp6RW7ROFPSaCxVysMSo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yx5XbdBJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yx5XbdBJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84A931F000E9;
	Tue, 21 Jul 2026 20:10:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784664654;
	bh=mMSeybww4KYW+tzjRhy0kNQMG5IlHBATDXCFPbf2N4I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yx5XbdBJTXtu3V4DNL7xM00vIMyFjday+nz8LcnEp941Huyz/DY+kGt2FRLas5F4R
	 Sxen9pCm15LlDNdnKMSuhqyFT1D0tP8zmwqwCakIjXzIYwcUCeBiAa6dII2r25RUWy
	 vbXQDGq2uFZ0L3JXEcZn98ZcE0r0wM/fqeidK1nw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gil Portnoy <dddhkts1@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.12 1252/1276] ksmbd: fix durable reconnect double-bind race in ksmbd_reopen_durable_fd
Date: Tue, 21 Jul 2026 17:28:15 +0200
Message-ID: <20260721152514.111239409@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

From: Gil Portnoy <dddhkts1@gmail.com>

commit 7ce4fc40018de07f05f3035241122d992610dbfb upstream.

Two concurrent same-user DHnC reconnects can both observe fp->conn == NULL
before either sets it. ksmbd_reopen_durable_fd() checks fp->conn to guard
against a handle already being reconnected, but the check and the binding
assignment are not atomic: both threads pass the guard, both call
ksmbd_conn_get() on the same fp, and both eventually reach
kfree(fp->owner.name) -- a double-free of the owner.name slab object.
The double-bound ksmbd_file also causes a write-UAF on the 344-byte
ksmbd_file_cache object when a concurrent smb2_close() spins on fp->f_lock
after the object has been freed by the losing reconnect path.

KASAN on 7.1-rc5 (48-thread concurrent reconnect, 3000 cycles):
  BUG: KASAN: double-free in ksmbd_reopen_durable_fd+0x268/0x308
  BUG: KASAN: slab-use-after-free in _raw_spin_lock+0xac/0x150
    Write of size 4 at offset 24 into freed ksmbd_file_cache object
Five double-bind windows observed; 63 total KASAN reports triggered.

Fix: validate and claim fp->conn under write_lock(&global_ft.lock) so the
check-and-claim is atomic. ksmbd_lookup_durable_fd() already treats
fp->conn != NULL as "in use" and skips such an fp; setting fp->conn before
dropping the lock closes the race. ksmbd_conn_get() is a non-sleeping
refcount increment, safe under the rwlock. The rollback path on __open_id()
failure also clears fp->conn/tcon under the lock so concurrent readers see
a consistent state.

Fixes: b1f1e80620de ("ksmbd: centralize ksmbd_conn final release to plug transport leak")
Assisted-by: Henry (Claude):claude-opus-4
Signed-off-by: Gil Portnoy <dddhkts1@gmail.com>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/server/vfs_cache.c |   12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

--- a/fs/smb/server/vfs_cache.c
+++ b/fs/smb/server/vfs_cache.c
@@ -1185,19 +1185,19 @@ int ksmbd_reopen_durable_fd(struct ksmbd
 	struct ksmbd_lock *smb_lock;
 	unsigned int old_f_state;
 
+	write_lock(&global_ft.lock);
 	if (!fp->is_durable || fp->conn || fp->tcon) {
+		write_unlock(&global_ft.lock);
 		pr_err("Invalid durable fd [%p:%p]\n", fp->conn, fp->tcon);
 		return -EBADF;
 	}
 
 	if (has_file_id(fp->volatile_id)) {
+		write_unlock(&global_ft.lock);
 		pr_err("Still in use durable fd: %llu\n", fp->volatile_id);
 		return -EBADF;
 	}
 
-	old_f_state = fp->f_state;
-	fp->f_state = FP_NEW;
-
 	/*
 	 * Initialize fp's connection binding before publishing fp into the
 	 * session's file table.  If __open_id() is ordered first, a
@@ -1208,11 +1208,17 @@ int ksmbd_reopen_durable_fd(struct ksmbd
 	 */
 	fp->conn = ksmbd_conn_get(conn);
 	fp->tcon = work->tcon;
+	write_unlock(&global_ft.lock);
+
+	old_f_state = fp->f_state;
+	fp->f_state = FP_NEW;
 
 	__open_id(&work->sess->file_table, fp, OPEN_ID_TYPE_VOLATILE_ID);
 	if (!has_file_id(fp->volatile_id)) {
+		write_lock(&global_ft.lock);
 		fp->conn = NULL;
 		fp->tcon = NULL;
+		write_unlock(&global_ft.lock);
 		ksmbd_conn_put(conn);
 		fp->f_state = old_f_state;
 		return -EBADF;


