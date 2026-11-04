Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829245;
	b=NokjciLBvHGNX70Psx6TOhvg1m+30CPE4XH/pW7Wd+7jlh3qqVTHm/CBbbpX7zsbY/yZ
	 UwWiGeMPREUpOPlZcoEu3UU9jJy9/E0te2Bwxe8D8F6AD8kRMRA6XpNVhGwq3yOwG90Nk
	 AS1Zd+3JTgGbp+kBSJ/RaMnq/vN+Ub6vNMIvxOIYOp44ZuGSXYyOXroGRz93CrNYIH+Sk
	 EdsjcePP+vUw11q47H3ax61JHjPUi6FHnQ/pihi8/quZr6QtseuydqV6Mq0xs5GI6m/b+
	 CMIDa2R5axD2JeRWR7LLTiUC5NZMDzsTonTGgl2Apc/pcxglt34sIsegvb3I9kCM8Yw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829245;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=i0LogzbTvkcOZJcR0Zram0G8xZgBm2rrZrLiPGhVgBQ=;
	b=adOBlOzaYRdas09lBapQog9Eu4nR6qy1ba3t+Hy3K2PioTXRAETHVKLQWQ6EF49UZ1MN
	 k8HiDm3tqdFTJ+RQ6lrNYSdAF69Xp2r4t4mB0u+UK6zpp4Ekt7xehKVdYVfs1w/FXX2L+
	 uM/a5mcjdMxnd+jY93WLCdsOj9IVC9FY/FiKd7Sh70+t8PqQjEg6VpPnS1Z7wnHutSAXW
	 5aynM98+jE/pJkgdLKtRMfCUzG4V1D5j13l2m6N05g1JQ4iXXtWqwaAgNg2CUOH1+6/y9
	 bD9wtuGK12VEnhErcR3xbnVHpzoPFUty0+ysDO5kXVYlVG+TRv6IbyjRzYWlsUgmPKg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wpGQChcG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A12D36072F83;
	Wed,  4 Nov 2026 21:54:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wpGQChcG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E5851F0093A;
	Wed,  4 Nov 2026 21:54:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829244;
	bh=i0LogzbTvkcOZJcR0Zram0G8xZgBm2rrZrLiPGhVgBQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wpGQChcGqsXJh1H8NZhsngWxuZlIY+vEmUfO8yyWdj11YlA/5Kn9Qkn3hvapwQ6rw
	 I+vM8cJSPoSbea1MTOlZ56YaFuAZ6nnMYRRghqFztLWveo5Hc4gkfxC5/9GXlkx0F5
	 Dow22AKDnQlCX1xtZj80rdxrVOdRtm67NgYE9zFU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Bridges <icb@fastmail.org>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 539/547] ksmbd: fix app-instance non-durable supersede session UAF
Date: Wed,  4 Nov 2026 16:12:03 -0500
Message-ID: <20261104211053.719906681@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211038.406938024@linuxfoundation.org>
References: <20261104211038.406938024@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ian Bridges <icb@fastmail.org>

[ Upstream commit f728cfee6929057087c303d07d7a6a7c61196b48 ]

ksmbd_close_fd_app_instance_id() supersedes a prior open that has the
same AppInstanceId. It reaches that open's session through opinfo->sess.
This pointer is not refcounted.

Session teardown detaches durable handles before it frees the session.
It does not detach a non-durable open. That open still points at the
session through opinfo->sess after the session is freed. Another session
can supersede the open at the same time. The supersede then takes a
write lock through the stale pointer, in the freed session's file table.

  BUG: KASAN: slab-use-after-free in _raw_write_lock+0x71/0xd0
  Call Trace:
   _raw_write_lock+0x71/0xd0
   ksmbd_close_fd_app_instance_id+0xd9/0x670 [ksmbd]
   smb2_open+0x3e10/0xd910 [ksmbd]
  Freed by task 212:
   ksmbd_session_destroy+0x38d/0x480 [ksmbd]

Fix this by looking the session up by opinfo->session_id. The lookup
returns a reference, as smb2_break_collect_channels() does. Recheck that
opinfo->sess still points at it before using it.

Do the lookup without m_lock held. destroy_previous_session() takes
m_lock under the session table lock, and taking them in the other order
here would deadlock.

Fixes: 16c30649709d ("ksmbd: handle durable v2 app instance id")
Cc: stable@vger.kernel.org # e0386cd6498b: ksmbd: validate AppInstanceId takeover target
Signed-off-by: Ian Bridges <icb@fastmail.org>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/server/vfs_cache.c |   32 ++++++++++++++++++++++++++++++--
 1 file changed, 30 insertions(+), 2 deletions(-)

--- a/fs/smb/server/vfs_cache.c
+++ b/fs/smb/server/vfs_cache.c
@@ -1054,7 +1054,9 @@ int ksmbd_close_fd_app_instance_id(struc
 				 struct ksmbd_file *fp, bool *closed)
 {
 	struct ksmbd_file_table *ft;
+	struct ksmbd_session *sess;
 	struct oplock_info *opinfo;
+	u64 session_id;
 	int n_to_drop = 0;
 
 	*closed = false;
@@ -1067,10 +1069,35 @@ int ksmbd_close_fd_app_instance_id(struc
 		up_read(&fp->f_ci->m_lock);
 		goto out;
 	}
+	/*
+	 * opinfo->sess is not refcounted, and m_lock does not keep it alive.
+	 * The owner can be torn down while we hold only a reference to fp.
+	 * Look the owner up by id to take a real reference instead.
+	 */
+	session_id = opinfo->session_id;
+	up_read(&fp->f_ci->m_lock);
+
+	/* destroy_previous_session() takes m_lock under sessions_table_lock. */
+	sess = ksmbd_session_lookup_slowpath(session_id);
+	if (!sess)
+		goto out;
 
-	ft = &opinfo->sess->file_table;
+	down_read(&fp->f_ci->m_lock);
+	if (opinfo->sess != sess) {
+		up_read(&fp->f_ci->m_lock);
+		ksmbd_user_session_put(sess);
+		goto out;
+	}
+	ft = &sess->file_table;
 	write_lock(&ft->lock);
-	if (fp->f_state == FP_INITED && has_file_id(fp->volatile_id) &&
+	/*
+	 * The table may already be detached by destroy_previous_session().
+	 * A new session could also reuse the old id and address and pass the
+	 * check above. Only remove fp if this table still publishes it.
+	 */
+	if (ft->idr && fp->f_state == FP_INITED &&
+	    has_file_id(fp->volatile_id) &&
+	    idr_find(ft->idr, fp->volatile_id) == fp &&
 	    ksmbd_app_instance_id_matches(work, fp)) {
 		idr_remove(ft->idr, fp->volatile_id);
 		fp->volatile_id = KSMBD_NO_FID;
@@ -1078,6 +1105,7 @@ int ksmbd_close_fd_app_instance_id(struc
 	}
 	write_unlock(&ft->lock);
 	up_read(&fp->f_ci->m_lock);
+	ksmbd_user_session_put(sess);
 	opinfo_put(opinfo);
 	opinfo = NULL;
 


