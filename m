Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 401C94C602;
	Wed, 20 Dec 2023 16:12:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GqccRH6C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5B14C433C9;
	Wed, 20 Dec 2023 16:12:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1703088752;
	bh=P87KTTJUG/gs/Cpiq+7eDA9ODLm35EIW9JJelnpcTFU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GqccRH6CDBItp2TdOCuy3iA4XkS35uLhBKFMSDyWVjSabuJEHehTxsukk/5kxZ0DK
	 NAf/qoFhslWeH4SIrf9/LkEfyD5Cd1KJPuewcuPDFj7ro0x/aoGQFY50PyTh5j7gp0
	 vrjFTYNlipl0Mb6gF7L1BGyAp4pjPl/OP8+UFEjg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Atte=20Heikkil=C3=A4?= <atteh.mailbox@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 5.15 046/159] ksmbd: request update to stale share config
Date: Wed, 20 Dec 2023 17:08:31 +0100
Message-ID: <20231220160933.466114661@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231220160931.251686445@linuxfoundation.org>
References: <20231220160931.251686445@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Atte Heikkilä <atteh.mailbox@gmail.com>

[ Upstream commit 4963d74f8a6cc0eafd71d9ffc13e3a11ff1dd160 ]

ksmbd_share_config_get() retrieves the cached share config as long
as there is at least one connection to the share. This is an issue when
the user space utilities are used to update share configs. In that case
there is a need to inform ksmbd that it should not use the cached share
config for a new connection to the share. With these changes the tree
connection flag KSMBD_TREE_CONN_FLAG_UPDATE indicates this. When this
flag is set, ksmbd removes the share config from the shares hash table
meaning that ksmbd_share_config_get() ends up requesting a share config
from user space.

Signed-off-by: Atte Heikkilä <atteh.mailbox@gmail.com>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ksmbd/ksmbd_netlink.h     |    2 ++
 fs/ksmbd/mgmt/share_config.c |    6 +++++-
 fs/ksmbd/mgmt/share_config.h |    1 +
 fs/ksmbd/mgmt/tree_connect.c |   14 ++++++++++++++
 fs/ksmbd/smb2pdu.c           |    1 +
 5 files changed, 23 insertions(+), 1 deletion(-)

--- a/fs/ksmbd/ksmbd_netlink.h
+++ b/fs/ksmbd/ksmbd_netlink.h
@@ -350,6 +350,7 @@ enum KSMBD_TREE_CONN_STATUS {
 #define KSMBD_SHARE_FLAG_STREAMS		BIT(11)
 #define KSMBD_SHARE_FLAG_FOLLOW_SYMLINKS	BIT(12)
 #define KSMBD_SHARE_FLAG_ACL_XATTR		BIT(13)
+#define KSMBD_SHARE_FLAG_UPDATE		BIT(14)
 
 /*
  * Tree connect request flags.
@@ -365,6 +366,7 @@ enum KSMBD_TREE_CONN_STATUS {
 #define KSMBD_TREE_CONN_FLAG_READ_ONLY		BIT(1)
 #define KSMBD_TREE_CONN_FLAG_WRITABLE		BIT(2)
 #define KSMBD_TREE_CONN_FLAG_ADMIN_ACCOUNT	BIT(3)
+#define KSMBD_TREE_CONN_FLAG_UPDATE		BIT(4)
 
 /*
  * RPC over IPC.
--- a/fs/ksmbd/mgmt/share_config.c
+++ b/fs/ksmbd/mgmt/share_config.c
@@ -51,12 +51,16 @@ static void kill_share(struct ksmbd_shar
 	kfree(share);
 }
 
-void __ksmbd_share_config_put(struct ksmbd_share_config *share)
+void ksmbd_share_config_del(struct ksmbd_share_config *share)
 {
 	down_write(&shares_table_lock);
 	hash_del(&share->hlist);
 	up_write(&shares_table_lock);
+}
 
+void __ksmbd_share_config_put(struct ksmbd_share_config *share)
+{
+	ksmbd_share_config_del(share);
 	kill_share(share);
 }
 
--- a/fs/ksmbd/mgmt/share_config.h
+++ b/fs/ksmbd/mgmt/share_config.h
@@ -64,6 +64,7 @@ static inline int test_share_config_flag
 	return share->flags & flag;
 }
 
+void ksmbd_share_config_del(struct ksmbd_share_config *share);
 void __ksmbd_share_config_put(struct ksmbd_share_config *share);
 
 static inline void ksmbd_share_config_put(struct ksmbd_share_config *share)
--- a/fs/ksmbd/mgmt/tree_connect.c
+++ b/fs/ksmbd/mgmt/tree_connect.c
@@ -57,6 +57,20 @@ ksmbd_tree_conn_connect(struct ksmbd_con
 		goto out_error;
 
 	tree_conn->flags = resp->connection_flags;
+	if (test_tree_conn_flag(tree_conn, KSMBD_TREE_CONN_FLAG_UPDATE)) {
+		struct ksmbd_share_config *new_sc;
+
+		ksmbd_share_config_del(sc);
+		new_sc = ksmbd_share_config_get(share_name);
+		if (!new_sc) {
+			pr_err("Failed to update stale share config\n");
+			status.ret = -ESTALE;
+			goto out_error;
+		}
+		ksmbd_share_config_put(sc);
+		sc = new_sc;
+	}
+
 	tree_conn->user = sess->user;
 	tree_conn->share_conf = sc;
 	status.tree_conn = tree_conn;
--- a/fs/ksmbd/smb2pdu.c
+++ b/fs/ksmbd/smb2pdu.c
@@ -1985,6 +1985,7 @@ out_err1:
 		rsp->hdr.Status = STATUS_SUCCESS;
 		rc = 0;
 		break;
+	case -ESTALE:
 	case -ENOENT:
 	case KSMBD_TREE_CONN_STATUS_NO_SHARE:
 		rsp->hdr.Status = STATUS_BAD_NETWORK_NAME;


