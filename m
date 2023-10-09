Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB6B21946D
	for <patches@lists.linux.dev>; Mon,  9 Oct 2023 13:14:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="brcLlctQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36E4AC433C7;
	Mon,  9 Oct 2023 13:14:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696857287;
	bh=O2p7EoJh3RHgelDbB6eO4GV6jFkOeQQK1vLjezNtaLA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=brcLlctQXHSbkquwVT84IqtjzhM9rWckFYBkA39t8qgOVePFtHo3EYE5QaIAMilKv
	 LLgTgrysQM8R08759wbtLDxXTUXbwVqVFNyleNEyDjIpy7pFif3Njap0T78iXLXkTa
	 NbUdrqRbJpIcvXFu2dXXEPO7/xt3X0YctCZDIKP0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	luosili <rootlab@huawei.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.5 160/163] ksmbd: fix race condition between session lookup and expire
Date: Mon,  9 Oct 2023 15:02:04 +0200
Message-ID: <20231009130128.423921294@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231009130124.021290599@linuxfoundation.org>
References: <20231009130124.021290599@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Namjae Jeon <linkinjeon@kernel.org>

commit 53ff5cf89142b978b1a5ca8dc4d4425e6a09745f upstream.

 Thread A                        +  Thread B
 ksmbd_session_lookup            |  smb2_sess_setup
   sess = xa_load                |
                                 |
                                 |    xa_erase(&conn->sessions, sess->id);
                                 |
                                 |    ksmbd_session_destroy(sess) --> kfree(sess)
                                 |
   // UAF!                       |
   sess->last_active = jiffies   |
                                 +

This patch add rwsem to fix race condition between ksmbd_session_lookup
and ksmbd_expire_session.

Reported-by: luosili <rootlab@huawei.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/server/connection.c        |    2 ++
 fs/smb/server/connection.h        |    1 +
 fs/smb/server/mgmt/user_session.c |   10 +++++++---
 3 files changed, 10 insertions(+), 3 deletions(-)

--- a/fs/smb/server/connection.c
+++ b/fs/smb/server/connection.c
@@ -84,6 +84,8 @@ struct ksmbd_conn *ksmbd_conn_alloc(void
 	spin_lock_init(&conn->llist_lock);
 	INIT_LIST_HEAD(&conn->lock_list);
 
+	init_rwsem(&conn->session_lock);
+
 	down_write(&conn_list_lock);
 	list_add(&conn->conns_list, &conn_list);
 	up_write(&conn_list_lock);
--- a/fs/smb/server/connection.h
+++ b/fs/smb/server/connection.h
@@ -50,6 +50,7 @@ struct ksmbd_conn {
 	struct nls_table		*local_nls;
 	struct unicode_map		*um;
 	struct list_head		conns_list;
+	struct rw_semaphore		session_lock;
 	/* smb session 1 per user */
 	struct xarray			sessions;
 	unsigned long			last_active;
--- a/fs/smb/server/mgmt/user_session.c
+++ b/fs/smb/server/mgmt/user_session.c
@@ -174,7 +174,7 @@ static void ksmbd_expire_session(struct
 	unsigned long id;
 	struct ksmbd_session *sess;
 
-	down_write(&sessions_table_lock);
+	down_write(&conn->session_lock);
 	xa_for_each(&conn->sessions, id, sess) {
 		if (sess->state != SMB2_SESSION_VALID ||
 		    time_after(jiffies,
@@ -185,7 +185,7 @@ static void ksmbd_expire_session(struct
 			continue;
 		}
 	}
-	up_write(&sessions_table_lock);
+	up_write(&conn->session_lock);
 }
 
 int ksmbd_session_register(struct ksmbd_conn *conn,
@@ -227,7 +227,9 @@ void ksmbd_sessions_deregister(struct ks
 			}
 		}
 	}
+	up_write(&sessions_table_lock);
 
+	down_write(&conn->session_lock);
 	xa_for_each(&conn->sessions, id, sess) {
 		unsigned long chann_id;
 		struct channel *chann;
@@ -244,7 +246,7 @@ void ksmbd_sessions_deregister(struct ks
 			ksmbd_session_destroy(sess);
 		}
 	}
-	up_write(&sessions_table_lock);
+	up_write(&conn->session_lock);
 }
 
 struct ksmbd_session *ksmbd_session_lookup(struct ksmbd_conn *conn,
@@ -252,9 +254,11 @@ struct ksmbd_session *ksmbd_session_look
 {
 	struct ksmbd_session *sess;
 
+	down_read(&conn->session_lock);
 	sess = xa_load(&conn->sessions, id);
 	if (sess)
 		sess->last_active = jiffies;
+	up_read(&conn->session_lock);
 	return sess;
 }
 


