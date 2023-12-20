Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE098487A9;
	Wed, 20 Dec 2023 16:11:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UiQhFDqg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E39D4C433C7;
	Wed, 20 Dec 2023 16:11:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1703088686;
	bh=kT2A1FaapFhyZcTkPSfj+QOPMao2BC9eWr63ceiH9PM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UiQhFDqgGqeN3ojdNseerUaaahnv2zz6UCJQvT5p+k2YAsmBI+4sTykjWX1zRjisG
	 TLCf6t06ikY4rFt4/8qAsnQzBlc2eLucyvdXaCFBy5rJfsFqLBEzXa43JRk9lZyhZw
	 Iprvv9OXM0dTth3e7lBGU5428/nmuRpaUrKxL7JY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yufan Chen <wiz.chen@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 5.15 021/159] ksmbd: add smb-direct shutdown
Date: Wed, 20 Dec 2023 17:08:06 +0100
Message-ID: <20231220160932.267735336@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Namjae Jeon <linkinjeon@kernel.org>

[ Upstream commit 136dff3a6b71dc16c30b35cc390feb0bfc32ed50 ]

When killing ksmbd server after connecting rdma, ksmbd threads does not
terminate properly because the rdma connection is still alive.
This patch add shutdown operation to disconnect rdma connection while
ksmbd threads terminate.

Signed-off-by: Yufan Chen <wiz.chen@gmail.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ksmbd/connection.c     |    9 ++++++++-
 fs/ksmbd/connection.h     |    1 +
 fs/ksmbd/transport_rdma.c |   10 ++++++++++
 3 files changed, 19 insertions(+), 1 deletion(-)

--- a/fs/ksmbd/connection.c
+++ b/fs/ksmbd/connection.c
@@ -399,17 +399,24 @@ out:
 static void stop_sessions(void)
 {
 	struct ksmbd_conn *conn;
+	struct ksmbd_transport *t;
 
 again:
 	read_lock(&conn_list_lock);
 	list_for_each_entry(conn, &conn_list, conns_list) {
 		struct task_struct *task;
 
-		task = conn->transport->handler;
+		t = conn->transport;
+		task = t->handler;
 		if (task)
 			ksmbd_debug(CONN, "Stop session handler %s/%d\n",
 				    task->comm, task_pid_nr(task));
 		conn->status = KSMBD_SESS_EXITING;
+		if (t->ops->shutdown) {
+			read_unlock(&conn_list_lock);
+			t->ops->shutdown(t);
+			read_lock(&conn_list_lock);
+		}
 	}
 	read_unlock(&conn_list_lock);
 
--- a/fs/ksmbd/connection.h
+++ b/fs/ksmbd/connection.h
@@ -110,6 +110,7 @@ struct ksmbd_conn_ops {
 struct ksmbd_transport_ops {
 	int (*prepare)(struct ksmbd_transport *t);
 	void (*disconnect)(struct ksmbd_transport *t);
+	void (*shutdown)(struct ksmbd_transport *t);
 	int (*read)(struct ksmbd_transport *t, char *buf,
 		    unsigned int size, int max_retries);
 	int (*writev)(struct ksmbd_transport *t, struct kvec *iovs, int niov,
--- a/fs/ksmbd/transport_rdma.c
+++ b/fs/ksmbd/transport_rdma.c
@@ -1459,6 +1459,15 @@ static void smb_direct_disconnect(struct
 	free_transport(st);
 }
 
+static void smb_direct_shutdown(struct ksmbd_transport *t)
+{
+	struct smb_direct_transport *st = smb_trans_direct_transfort(t);
+
+	ksmbd_debug(RDMA, "smb-direct shutdown cm_id=%p\n", st->cm_id);
+
+	smb_direct_disconnect_rdma_work(&st->disconnect_work);
+}
+
 static int smb_direct_cm_handler(struct rdma_cm_id *cm_id,
 				 struct rdma_cm_event *event)
 {
@@ -2207,6 +2216,7 @@ out:
 static struct ksmbd_transport_ops ksmbd_smb_direct_transport_ops = {
 	.prepare	= smb_direct_prepare,
 	.disconnect	= smb_direct_disconnect,
+	.shutdown	= smb_direct_shutdown,
 	.writev		= smb_direct_writev,
 	.read		= smb_direct_read,
 	.rdma_read	= smb_direct_rdma_read,


