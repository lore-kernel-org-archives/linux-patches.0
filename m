Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 863ED1BDEC;
	Wed,  3 Jan 2024 16:56:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xmSPd4sN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CBBEC433C7;
	Wed,  3 Jan 2024 16:56:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1704301006;
	bh=HzG6baD/76GH1tGpsDTKS/p9syEg8OkRPiPCsZKql4M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xmSPd4sNGH359SanBGma6qiICcpPwhfHaVyl+rl2IyUSv25rnZla0PUJd9Sbmeody
	 9m7ShZButSLgh6Ukggt5y3oaziYf9SV7tTNWbC2hD503NFLQByIgn+ZrKS/oPIeRrj
	 eXyStk08L28dXh/cg4y5LH5mG9PEnqxgZbNXvUe0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dawei Li <set_pte_at@outlook.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 006/100] ksmbd: Implements sess->rpc_handle_list as xarray
Date: Wed,  3 Jan 2024 17:53:55 +0100
Message-ID: <20240103164857.149805827@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240103164856.169912722@linuxfoundation.org>
References: <20240103164856.169912722@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dawei Li <set_pte_at@outlook.com>

[ Upstream commit b685757c7b08d5073046fb379be965fd6c06aafc ]

For some ops on rpc handle:
1. ksmbd_session_rpc_method(), possibly on high frequency.
2. ksmbd_session_rpc_close().

id is used as indexing key to lookup channel, in that case,
linear search based on list may suffer a bit for performance.

Implements sess->rpc_handle_list as xarray.

Signed-off-by: Dawei Li <set_pte_at@outlook.com>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/mgmt/user_session.c | 37 ++++++++++++-------------------
 fs/smb/server/mgmt/user_session.h |  2 +-
 2 files changed, 15 insertions(+), 24 deletions(-)

diff --git a/fs/smb/server/mgmt/user_session.c b/fs/smb/server/mgmt/user_session.c
index cf6621e21ba36..b8be14a96cf66 100644
--- a/fs/smb/server/mgmt/user_session.c
+++ b/fs/smb/server/mgmt/user_session.c
@@ -25,7 +25,6 @@ static DECLARE_RWSEM(sessions_table_lock);
 struct ksmbd_session_rpc {
 	int			id;
 	unsigned int		method;
-	struct list_head	list;
 };
 
 static void free_channel_list(struct ksmbd_session *sess)
@@ -58,15 +57,14 @@ static void __session_rpc_close(struct ksmbd_session *sess,
 static void ksmbd_session_rpc_clear_list(struct ksmbd_session *sess)
 {
 	struct ksmbd_session_rpc *entry;
+	long index;
 
-	while (!list_empty(&sess->rpc_handle_list)) {
-		entry = list_entry(sess->rpc_handle_list.next,
-				   struct ksmbd_session_rpc,
-				   list);
-
-		list_del(&entry->list);
+	xa_for_each(&sess->rpc_handle_list, index, entry) {
+		xa_erase(&sess->rpc_handle_list, index);
 		__session_rpc_close(sess, entry);
 	}
+
+	xa_destroy(&sess->rpc_handle_list);
 }
 
 static int __rpc_method(char *rpc_name)
@@ -102,13 +100,13 @@ int ksmbd_session_rpc_open(struct ksmbd_session *sess, char *rpc_name)
 
 	entry = kzalloc(sizeof(struct ksmbd_session_rpc), GFP_KERNEL);
 	if (!entry)
-		return -EINVAL;
+		return -ENOMEM;
 
-	list_add(&entry->list, &sess->rpc_handle_list);
 	entry->method = method;
 	entry->id = ksmbd_ipc_id_alloc();
 	if (entry->id < 0)
 		goto free_entry;
+	xa_store(&sess->rpc_handle_list, entry->id, entry, GFP_KERNEL);
 
 	resp = ksmbd_rpc_open(sess, entry->id);
 	if (!resp)
@@ -117,9 +115,9 @@ int ksmbd_session_rpc_open(struct ksmbd_session *sess, char *rpc_name)
 	kvfree(resp);
 	return entry->id;
 free_id:
+	xa_erase(&sess->rpc_handle_list, entry->id);
 	ksmbd_rpc_id_free(entry->id);
 free_entry:
-	list_del(&entry->list);
 	kfree(entry);
 	return -EINVAL;
 }
@@ -128,24 +126,17 @@ void ksmbd_session_rpc_close(struct ksmbd_session *sess, int id)
 {
 	struct ksmbd_session_rpc *entry;
 
-	list_for_each_entry(entry, &sess->rpc_handle_list, list) {
-		if (entry->id == id) {
-			list_del(&entry->list);
-			__session_rpc_close(sess, entry);
-			break;
-		}
-	}
+	entry = xa_erase(&sess->rpc_handle_list, id);
+	if (entry)
+		__session_rpc_close(sess, entry);
 }
 
 int ksmbd_session_rpc_method(struct ksmbd_session *sess, int id)
 {
 	struct ksmbd_session_rpc *entry;
 
-	list_for_each_entry(entry, &sess->rpc_handle_list, list) {
-		if (entry->id == id)
-			return entry->method;
-	}
-	return 0;
+	entry = xa_load(&sess->rpc_handle_list, id);
+	return entry ? entry->method : 0;
 }
 
 void ksmbd_session_destroy(struct ksmbd_session *sess)
@@ -362,7 +353,7 @@ static struct ksmbd_session *__session_create(int protocol)
 	set_session_flag(sess, protocol);
 	xa_init(&sess->tree_conns);
 	xa_init(&sess->ksmbd_chann_list);
-	INIT_LIST_HEAD(&sess->rpc_handle_list);
+	xa_init(&sess->rpc_handle_list);
 	sess->sequence_number = 1;
 
 	ret = __init_smb2_session(sess);
diff --git a/fs/smb/server/mgmt/user_session.h b/fs/smb/server/mgmt/user_session.h
index 51f38e5b61abb..f99d475b28db4 100644
--- a/fs/smb/server/mgmt/user_session.h
+++ b/fs/smb/server/mgmt/user_session.h
@@ -52,7 +52,7 @@ struct ksmbd_session {
 	struct xarray			ksmbd_chann_list;
 	struct xarray			tree_conns;
 	struct ida			tree_conn_ida;
-	struct list_head		rpc_handle_list;
+	struct xarray			rpc_handle_list;
 
 	__u8				smb3encryptionkey[SMB3_ENC_DEC_KEY_SIZE];
 	__u8				smb3decryptionkey[SMB3_ENC_DEC_KEY_SIZE];
-- 
2.43.0



