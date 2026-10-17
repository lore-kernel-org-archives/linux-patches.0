Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DCA02E266C;
	Sat, 17 Oct 2026 17:32:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792258357; cv=none; b=CFjl4iJpSmDCCM7t6YAttMsHq+qyHp3b7Ua+dvzcpbSR9CdoAka3AwQf7nHJXPz1XM3Bxp1GVNEEFycMlw/FIYjLTMCpY+GhRxO8HtUocqp7JK4rXhFsID9WH5fCunP0WVLpDpV5L2j9xC9i22/grQY5B2VLc2iIoIBdLUbQxYo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792258357; c=relaxed/simple;
	bh=df6iYoYlkR+stXWvpkEI0MnJWz7MUBkcM3ZrOhNaHF0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d69zWYk163i+GAzs+UCjGibY1zUPxugkEgUeuUCbbHl2X0yeaba6huxl4bykXQL3An/OoIzVIhtXeCwRc3O8tc8aEKYMZYRVptLT5tVA3DPdbF5/UTcOdj/oVf9BMZROFIUilKDxt1AzSV20HcXjJN/MltLd6UG+KkpaMyWx8LQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bEgU93fR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bEgU93fR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A70E61F000C4;
	Sat, 17 Oct 2026 17:32:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792258356;
	bh=aYZa8v3SQg0XN63lvE4hXtpQaIxD1BU7GFbuVCvXf2s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bEgU93fRV3I4HyjoyYD0Vv1IHPZfrvLNNjsaK96xOw6U1NS/vrTViUDnt29sDEWww
	 ZiTgOnXA0qgccu0BA84oy/enxlX3N6EB38lbKPLUrp1QSU6YT2bZZhJRCvHegUtHt9
	 t/1WACHG0YVVUo2KpVGKu73D1fG1P5tRaEpR9VsU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Igor Stepansky <igor.stepansky@orca.security>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0858/1674] ksmbd: add chann_lock to protect ksmbd_chann_list xarray
Date: Sat, 17 Oct 2026 17:52:10 +0200
Message-ID: <20261017160453.144038625@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

From: Namjae Jeon <linkinjeon@kernel.org>

[ Upstream commit 4f3a06cc57976cafa8c6f716646be6c79a99e485 ]

ksmbd_chann_list xarray lacks synchronization, allowing use-after-free in
multi-channel sessions (between lookup_chann_list() and ksmbd_chann_del).

Adds rw_semaphore chann_lock to struct ksmbd_session and protects
all xa_load/xa_store/xa_erase accesses.

Cc: stable@vger.kernel.org
Reported-by: Igor Stepansky <igor.stepansky@orca.security>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/mgmt/user_session.c |  5 +++++
 fs/smb/server/mgmt/user_session.h |  1 +
 fs/smb/server/smb2pdu.c           | 12 +++++++++++-
 3 files changed, 17 insertions(+), 1 deletion(-)

diff --git a/fs/smb/server/mgmt/user_session.c b/fs/smb/server/mgmt/user_session.c
index 64f6ff2a7a8b3..26c1bfff242a5 100644
--- a/fs/smb/server/mgmt/user_session.c
+++ b/fs/smb/server/mgmt/user_session.c
@@ -32,12 +32,14 @@ static void free_channel_list(struct ksmbd_session *sess)
 	struct channel *chann;
 	unsigned long index;
 
+	down_write(&sess->chann_lock);
 	xa_for_each(&sess->ksmbd_chann_list, index, chann) {
 		xa_erase(&sess->ksmbd_chann_list, index);
 		kfree(chann);
 	}
 
 	xa_destroy(&sess->ksmbd_chann_list);
+	up_write(&sess->chann_lock);
 }
 
 static void __session_rpc_close(struct ksmbd_session *sess,
@@ -220,7 +222,9 @@ static int ksmbd_chann_del(struct ksmbd_conn *conn, struct ksmbd_session *sess)
 {
 	struct channel *chann;
 
+	down_write(&sess->chann_lock);
 	chann = xa_erase(&sess->ksmbd_chann_list, (long)conn);
+	up_write(&sess->chann_lock);
 	if (!chann)
 		return -ENOENT;
 
@@ -469,6 +473,7 @@ static struct ksmbd_session *__session_create(int protocol)
 	rwlock_init(&sess->tree_conns_lock);
 	atomic_set(&sess->refcnt, 2);
 	init_rwsem(&sess->rpc_lock);
+	init_rwsem(&sess->chann_lock);
 
 	ret = __init_smb2_session(sess);
 	if (ret)
diff --git a/fs/smb/server/mgmt/user_session.h b/fs/smb/server/mgmt/user_session.h
index 523b68c4ca40e..525650d6876c3 100644
--- a/fs/smb/server/mgmt/user_session.h
+++ b/fs/smb/server/mgmt/user_session.h
@@ -49,6 +49,7 @@ struct ksmbd_session {
 	char				sess_key[CIFS_KEY_SIZE];
 
 	struct hlist_node		hlist;
+	struct rw_semaphore		chann_lock;
 	struct xarray			ksmbd_chann_list;
 	struct xarray			tree_conns;
 	struct ida			tree_conn_ida;
diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index b9b0ea3701c27..b6b67a9e09a98 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -79,7 +79,13 @@ static inline bool check_session_id(struct ksmbd_conn *conn, u64 id)
 
 struct channel *lookup_chann_list(struct ksmbd_session *sess, struct ksmbd_conn *conn)
 {
-	return xa_load(&sess->ksmbd_chann_list, (long)conn);
+	struct channel *chann;
+
+	down_read(&sess->chann_lock);
+	chann = xa_load(&sess->ksmbd_chann_list, (long)conn);
+	up_read(&sess->chann_lock);
+
+	return chann;
 }
 
 /**
@@ -1563,7 +1569,9 @@ static int ntlm_authenticate(struct ksmbd_work *work,
 				return -ENOMEM;
 
 			chann->conn = conn;
+			down_write(&sess->chann_lock);
 			xa_store(&sess->ksmbd_chann_list, (long)conn, chann, GFP_KERNEL);
+			up_write(&sess->chann_lock);
 		}
 	}
 
@@ -1656,7 +1664,9 @@ static int krb5_authenticate(struct ksmbd_work *work,
 				return -ENOMEM;
 
 			chann->conn = conn;
+			down_write(&sess->chann_lock);
 			xa_store(&sess->ksmbd_chann_list, (long)conn, chann, GFP_KERNEL);
+			up_write(&sess->chann_lock);
 		}
 	}
 
-- 
2.53.0



