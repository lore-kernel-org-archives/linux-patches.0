Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793826972;
	b=PfKjIAUUeCFs54UzoXvBUaDBR7RoOEhIXn9mini7+w0+E+8QCJTFfS/Cp8HXH2enVUbd
	 gBb1Zvejj8d+6ggJav/dAwEd+PE2B1GX+5bv44C39b8xpC+wzbaCLB8DCxTEQd8TAIEIb
	 l/9hQgIg9tnF771GrOcKwkwcZnMhedDjhxfwAcUQYLMELCavV9rOXMy36en8VHtma0cSW
	 u5vgobVryHdkwf9bc1LJkx7oL5aAdaHHUUMFPuaJeTHYkLMW3kp1OAjSbAB7mLTLyvBtD
	 Lm4OdZN5dHovHBdyGDWRi4EDAWz5+Us/AnLpsNnpElrgvk5IbmYvApu0AToesOZcINw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793826972;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=MsefyVBaKb4i4u2BgQim8Ee3NMFW7Ux3RP3IMCl2hYA=;
	b=CITktavDn54lxY+YTCbpZ9k0FhCiUEsfWTKKgu3wVjR9hWcYpzHbztwh/7gKcbqlQHff
	 jCTaE4zfDmxYCovabSnVDCugkogsoT0z2X+C2nvk+3NkhdETQ2KxzR4xdv5CLd/5DOvjI
	 gIJomCD/gQIsyyrRcIJpw2ujoZHAb1zabfvt/S5eMU2r68Z4A7zEN6hVBs4y46dQympov
	 wcv8zuKxojC5LzCv1kyRSMPcoV8VxcJ7I2j3k/Sp609wJdewWLPfMy0ymI475AkIQn9uy
	 TCMcj3fNvVbjfkZ4hMh0h5dI6tUJ3kxSe/WWaqsIJqduIei/qaRgAxeCMHbyZpzh8wQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Fv45iS9G;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53E276070A96;
	Wed,  4 Nov 2026 21:16:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Fv45iS9G
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F5881F00A02;
	Wed,  4 Nov 2026 21:16:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793826971;
	bh=MsefyVBaKb4i4u2BgQim8Ee3NMFW7Ux3RP3IMCl2hYA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Fv45iS9G68nNlauGRszGmOUOL1CwmW9adg/rYsHuTL1lVlsMgvryAWzBJdq2rYg18
	 JnEu24mdB//zC6zN8tdBq6WNRIRPse1fXhebREBeYaT+wEGEUoa10r59Xk01KcgXpF
	 9VyDEzDRapFx1e2q35F0LBPpjbn6I7+9Ec9n7uwI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdifatah Suruur <suruurism@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 7.3 117/547] ksmbd: drain session procfs readers before dropping table references
Date: Wed,  4 Nov 2026 16:05:01 -0500
Message-ID: <20261104211041.524903172@linuxfoundation.org>
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

From: Namjae Jeon <linkinjeon@kernel.org>

commit 1c087cf7d5386c708d8984b263280b42b3daada0 upstream.

Session registration failure and connection cleanup can drop the table
reference while the per-session procfs entry is still accessible. If a
reader holds the last remaining reference, its final put calls
proc_remove() from its own callback and waits for that callback to
finish.

Remove the procfs entry before dropping the table reference in the
registration failure path. Queue sessions removed during connection
cleanup and drain their procfs readers after releasing both session
locks, then return their table references. Keep the global hash node
unhashed while a session is queued so a concurrent unregister cannot
drop the reference again.

Previous-session replacement also destroys the file table before the
session is finally freed. Detach the idr under the lock used by procfs
file counters, and report zero files after it has been detached. This
prevents a reader from accessing the idr during or after its
destruction.

Fixes: d7fd1f98607f ("ksmbd: follow SMB2 session expiration semantics")
Cc: stable@vger.kernel.org
Reported-by: Abdifatah Suruur <suruurism@gmail.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/server/mgmt/user_session.c |   15 +++++++++------
 fs/smb/server/vfs_cache.c         |    9 +++++++--
 2 files changed, 16 insertions(+), 8 deletions(-)

--- a/fs/smb/server/mgmt/user_session.c
+++ b/fs/smb/server/mgmt/user_session.c
@@ -95,8 +95,10 @@ static unsigned int session_open_file_co
 	unsigned int id;
 
 	read_lock(&session->file_table.lock);
-	idr_for_each_entry(session->file_table.idr, fp, id)
-		count++;
+	if (session->file_table.idr) {
+		idr_for_each_entry(session->file_table.idr, fp, id)
+			count++;
+	}
 	read_unlock(&session->file_table.lock);
 	return count;
 }
@@ -477,6 +479,7 @@ int ksmbd_session_register(struct ksmbd_
 		down_write(&sessions_table_lock);
 		ksmbd_session_remove_from_table(sess);
 		up_write(&sessions_table_lock);
+		delete_proc_session(sess);
 		ksmbd_user_session_put(sess);
 	}
 
@@ -604,6 +607,7 @@ static int ksmbd_chann_del(struct ksmbd_
 
 void ksmbd_conn_sessions_cleanup(struct ksmbd_conn *conn)
 {
+	LIST_HEAD(dispose);
 	struct ksmbd_session *sess;
 	unsigned long id;
 	struct hlist_node *tmp;
@@ -617,8 +621,7 @@ void ksmbd_conn_sessions_cleanup(struct
 			down_write(&conn->session_lock);
 			xa_erase(&conn->sessions, sess->id);
 			up_write(&conn->session_lock);
-			if (atomic_dec_and_test(&sess->refcnt))
-				ksmbd_session_destroy(sess);
+			list_add_tail(&sess->dispose_entry, &dispose);
 		}
 	}
 
@@ -628,12 +631,12 @@ void ksmbd_conn_sessions_cleanup(struct
 		if (xa_empty(&sess->ksmbd_chann_list)) {
 			xa_erase(&conn->sessions, sess->id);
 			ksmbd_session_remove_from_table(sess);
-			if (atomic_dec_and_test(&sess->refcnt))
-				ksmbd_session_destroy(sess);
+			list_add_tail(&sess->dispose_entry, &dispose);
 		}
 	}
 	up_write(&conn->session_lock);
 	up_write(&sessions_table_lock);
+	ksmbd_dispose_sessions(&dispose);
 }
 
 bool is_ksmbd_session_in_connection(struct ksmbd_conn *conn,
--- a/fs/smb/server/vfs_cache.c
+++ b/fs/smb/server/vfs_cache.c
@@ -1975,14 +1975,19 @@ int ksmbd_init_file_table(struct ksmbd_f
 void ksmbd_destroy_file_table(struct ksmbd_session *sess)
 {
 	struct ksmbd_file_table *ft = &sess->file_table;
+	struct idr *idr;
 
 	if (!ft->idr)
 		return;
 
 	__close_file_table_ids(sess, NULL, session_fd_check, true);
-	idr_destroy(ft->idr);
-	kfree(ft->idr);
+	/* Stop procfs readers before freeing the detached file table. */
+	write_lock(&ft->lock);
+	idr = ft->idr;
 	ft->idr = NULL;
+	write_unlock(&ft->lock);
+	idr_destroy(idr);
+	kfree(idr);
 }
 
 int ksmbd_init_file_cache(void)


