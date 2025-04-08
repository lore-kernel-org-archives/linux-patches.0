Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01E0B27CCD5;
	Tue,  8 Apr 2025 12:58:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744117134; cv=none; b=r1EmldDEYFCpiPSFKzJ1iaLsUtuEzZqx6P5hncl7H+FltcGpBXws9xMJ0W4c0jzthiJUqhc5PcDertDO0eusvZqlKvXLC4rnxgjvGwqJ+15eCfeGS2wjGUeaPA1x0HKiITZpzxPZA/kIqPUktAWgZRU6t96vBzvF8IvTCeQ/Eh8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744117134; c=relaxed/simple;
	bh=q3NJwsVLOVPUBEhAHmamTGdcz88iVBbzb7AwhSubUCo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k3jUiqvasGtcrzTztVwqnQVQLxmTJYkeqNuttmk0cxAifoZiptJvsCB5mAokGaK4o2WKhJhF+GUP8Bk+OGinawvUFyg2fhefw5HGzhqEoEBvgLlY3tLKAgKihWOBvKUBPkL2qXMQ9p8sKEdrzWd7/w+KlMmp82ERrPv3XKGcgF8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lOhhVR29; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lOhhVR29"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02020C4CEE5;
	Tue,  8 Apr 2025 12:58:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744117133;
	bh=q3NJwsVLOVPUBEhAHmamTGdcz88iVBbzb7AwhSubUCo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lOhhVR29h8wERkJiv+4TW8bnHte+He+3ICsQJTITGoJUdGI4HQY5VZYhEQLdjIZCT
	 jm+/8GVNYSeVI2iy4vnqipuWAb6SWHInAzIuGhZjF7Sn6Mnoy/y96jL/mkM9rRJlZh
	 5DvaQ4aBhfF6Ru4+j40JKBIb8U5qHBatwVoOpt18=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Heelan <seanheelan@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.12 397/423] ksmbd: fix session use-after-free in multichannel connection
Date: Tue,  8 Apr 2025 12:52:03 +0200
Message-ID: <20250408104855.147503743@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104845.675475678@linuxfoundation.org>
References: <20250408104845.675475678@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Namjae Jeon <linkinjeon@kernel.org>

commit fa4cdb8cbca7d6cb6aa13e4d8d83d1103f6345db upstream.

There is a race condition between session setup and
ksmbd_sessions_deregister. The session can be freed before the connection
is added to channel list of session.
This patch check reference count of session before freeing it.

Cc: stable@vger.kernel.org
Reported-by: Sean Heelan <seanheelan@gmail.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/server/auth.c              |    4 ++--
 fs/smb/server/mgmt/user_session.c |   14 ++++++++------
 fs/smb/server/smb2pdu.c           |    7 ++++---
 3 files changed, 14 insertions(+), 11 deletions(-)

--- a/fs/smb/server/auth.c
+++ b/fs/smb/server/auth.c
@@ -1016,9 +1016,9 @@ static int ksmbd_get_encryption_key(stru
 
 	ses_enc_key = enc ? sess->smb3encryptionkey :
 		sess->smb3decryptionkey;
-	if (enc)
-		ksmbd_user_session_get(sess);
 	memcpy(key, ses_enc_key, SMB3_ENC_DEC_KEY_SIZE);
+	if (!enc)
+		ksmbd_user_session_put(sess);
 
 	return 0;
 }
--- a/fs/smb/server/mgmt/user_session.c
+++ b/fs/smb/server/mgmt/user_session.c
@@ -181,7 +181,7 @@ static void ksmbd_expire_session(struct
 	down_write(&sessions_table_lock);
 	down_write(&conn->session_lock);
 	xa_for_each(&conn->sessions, id, sess) {
-		if (atomic_read(&sess->refcnt) == 0 &&
+		if (atomic_read(&sess->refcnt) <= 1 &&
 		    (sess->state != SMB2_SESSION_VALID ||
 		     time_after(jiffies,
 			       sess->last_active + SMB2_SESSION_TIMEOUT))) {
@@ -233,7 +233,8 @@ void ksmbd_sessions_deregister(struct ks
 				down_write(&conn->session_lock);
 				xa_erase(&conn->sessions, sess->id);
 				up_write(&conn->session_lock);
-				ksmbd_session_destroy(sess);
+				if (atomic_dec_and_test(&sess->refcnt))
+					ksmbd_session_destroy(sess);
 			}
 		}
 	}
@@ -252,7 +253,8 @@ void ksmbd_sessions_deregister(struct ks
 		if (xa_empty(&sess->ksmbd_chann_list)) {
 			xa_erase(&conn->sessions, sess->id);
 			hash_del(&sess->hlist);
-			ksmbd_session_destroy(sess);
+			if (atomic_dec_and_test(&sess->refcnt))
+				ksmbd_session_destroy(sess);
 		}
 	}
 	up_write(&conn->session_lock);
@@ -328,8 +330,8 @@ void ksmbd_user_session_put(struct ksmbd
 
 	if (atomic_read(&sess->refcnt) <= 0)
 		WARN_ON(1);
-	else
-		atomic_dec(&sess->refcnt);
+	else if (atomic_dec_and_test(&sess->refcnt))
+		ksmbd_session_destroy(sess);
 }
 
 struct preauth_session *ksmbd_preauth_session_alloc(struct ksmbd_conn *conn,
@@ -436,7 +438,7 @@ static struct ksmbd_session *__session_c
 	xa_init(&sess->rpc_handle_list);
 	sess->sequence_number = 1;
 	rwlock_init(&sess->tree_conns_lock);
-	atomic_set(&sess->refcnt, 1);
+	atomic_set(&sess->refcnt, 2);
 
 	ret = __init_smb2_session(sess);
 	if (ret)
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -2230,13 +2230,14 @@ int smb2_session_logoff(struct ksmbd_wor
 		return -ENOENT;
 	}
 
-	ksmbd_destroy_file_table(&sess->file_table);
 	down_write(&conn->session_lock);
 	sess->state = SMB2_SESSION_EXPIRED;
 	up_write(&conn->session_lock);
 
-	ksmbd_free_user(sess->user);
-	sess->user = NULL;
+	if (sess->user) {
+		ksmbd_free_user(sess->user);
+		sess->user = NULL;
+	}
 	ksmbd_all_conn_set_status(sess_id, KSMBD_SESS_NEED_NEGOTIATE);
 
 	rsp->StructureSize = cpu_to_le16(4);


