Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 511CB14389D;
	Tue, 23 Apr 2024 21:46:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713908775; cv=none; b=PEg4A11jnK+Q7gNYO0Cdd5ecBm4N7ZsEomZjvHXRr/zV1itYHETdTpaqyuFz9Xid7MoH0FKT4at0p7gKUIyCfMNVqCinVJUcCQob5PrSQ60C/AQmgdR7BdLS4xaCHD+Kypy9QPqCgHOgBREqp5KtmBHrbXqPuDF4u+zjRoZZ+A8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713908775; c=relaxed/simple;
	bh=swYQ2ScqIWmC0c5blmRAbXtubh5anPe+A7zzF5nPlvI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HPVTQDBpQMewO1MkTrKZTq4h1Nxb3cjGKOkcbDNz/1wgNi0Yh6fAZyNlXWP1+Y2qFRBPOcjllRpNT1wa9IIJynf1far8LBVz0Wu6oWZk5PJFA0a6qpFxLcL3igMXnKdkXnFCELdgR9rEkYmZeBf9B9UITbixuUCq8E1iB9pp3cM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EVTAG/zK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EVTAG/zK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22F5FC32781;
	Tue, 23 Apr 2024 21:46:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713908775;
	bh=swYQ2ScqIWmC0c5blmRAbXtubh5anPe+A7zzF5nPlvI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EVTAG/zKCT00ASWi26pCArUfx1lMOb0GEf6VdmiTJhuw32BuSDT+5oNsvcww34qzf
	 w1LKPGoql+hwYNReI+ESV0gfrhGEWeFVmrVaIoS5Wb56wzK0JM8d/jObuEn2Asx1Fg
	 2ZYBt5CZNzger5OPwvp8SyQyOlO+x7mcqPZT2CeY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chao Ma <machao2019@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 02/71] ksmbd: validate payload size in ipc response
Date: Tue, 23 Apr 2024 14:39:15 -0700
Message-ID: <20240423213844.211966035@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240423213844.122920086@linuxfoundation.org>
References: <20240423213844.122920086@linuxfoundation.org>
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

[ Upstream commit a677ebd8ca2f2632ccdecbad7b87641274e15aac ]

If installing malicious ksmbd-tools, ksmbd.mountd can return invalid ipc
response to ksmbd kernel server. ksmbd should validate payload size of
ipc response from ksmbd.mountd to avoid memory overrun or
slab-out-of-bounds. This patch validate 3 ipc response that has payload.

Cc: stable@vger.kernel.org
Reported-by: Chao Ma <machao2019@gmail.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ksmbd/ksmbd_netlink.h     |  3 ++-
 fs/ksmbd/mgmt/share_config.c |  7 ++++++-
 fs/ksmbd/transport_ipc.c     | 37 ++++++++++++++++++++++++++++++++++++
 3 files changed, 45 insertions(+), 2 deletions(-)

diff --git a/fs/ksmbd/ksmbd_netlink.h b/fs/ksmbd/ksmbd_netlink.h
index ecffcb8a1557a..dc30cd0f6acd0 100644
--- a/fs/ksmbd/ksmbd_netlink.h
+++ b/fs/ksmbd/ksmbd_netlink.h
@@ -166,7 +166,8 @@ struct ksmbd_share_config_response {
 	__u16	force_uid;
 	__u16	force_gid;
 	__s8	share_name[KSMBD_REQ_MAX_SHARE_NAME];
-	__u32	reserved[112];		/* Reserved room */
+	__u32	reserved[111];		/* Reserved room */
+	__u32	payload_sz;
 	__u32	veto_list_sz;
 	__s8	____payload[];
 };
diff --git a/fs/ksmbd/mgmt/share_config.c b/fs/ksmbd/mgmt/share_config.c
index 328a412259dc1..a2f0a2edceb8a 100644
--- a/fs/ksmbd/mgmt/share_config.c
+++ b/fs/ksmbd/mgmt/share_config.c
@@ -158,7 +158,12 @@ static struct ksmbd_share_config *share_config_request(struct unicode_map *um,
 	share->name = kstrdup(name, GFP_KERNEL);
 
 	if (!test_share_config_flag(share, KSMBD_SHARE_FLAG_PIPE)) {
-		share->path = kstrdup(ksmbd_share_config_path(resp),
+		int path_len = PATH_MAX;
+
+		if (resp->payload_sz)
+			path_len = resp->payload_sz - resp->veto_list_sz;
+
+		share->path = kstrndup(ksmbd_share_config_path(resp), path_len,
 				      GFP_KERNEL);
 		if (share->path)
 			share->path_sz = strlen(share->path);
diff --git a/fs/ksmbd/transport_ipc.c b/fs/ksmbd/transport_ipc.c
index 2c9662e327990..d62ebbff1e0f4 100644
--- a/fs/ksmbd/transport_ipc.c
+++ b/fs/ksmbd/transport_ipc.c
@@ -65,6 +65,7 @@ struct ipc_msg_table_entry {
 	struct hlist_node	ipc_table_hlist;
 
 	void			*response;
+	unsigned int		msg_sz;
 };
 
 static struct delayed_work ipc_timer_work;
@@ -274,6 +275,7 @@ static int handle_response(int type, void *payload, size_t sz)
 		}
 
 		memcpy(entry->response, payload, sz);
+		entry->msg_sz = sz;
 		wake_up_interruptible(&entry->wait);
 		ret = 0;
 		break;
@@ -452,6 +454,34 @@ static int ipc_msg_send(struct ksmbd_ipc_msg *msg)
 	return ret;
 }
 
+static int ipc_validate_msg(struct ipc_msg_table_entry *entry)
+{
+	unsigned int msg_sz = entry->msg_sz;
+
+	if (entry->type == KSMBD_EVENT_RPC_REQUEST) {
+		struct ksmbd_rpc_command *resp = entry->response;
+
+		msg_sz = sizeof(struct ksmbd_rpc_command) + resp->payload_sz;
+	} else if (entry->type == KSMBD_EVENT_SPNEGO_AUTHEN_REQUEST) {
+		struct ksmbd_spnego_authen_response *resp = entry->response;
+
+		msg_sz = sizeof(struct ksmbd_spnego_authen_response) +
+				resp->session_key_len + resp->spnego_blob_len;
+	} else if (entry->type == KSMBD_EVENT_SHARE_CONFIG_REQUEST) {
+		struct ksmbd_share_config_response *resp = entry->response;
+
+		if (resp->payload_sz) {
+			if (resp->payload_sz < resp->veto_list_sz)
+				return -EINVAL;
+
+			msg_sz = sizeof(struct ksmbd_share_config_response) +
+					resp->payload_sz;
+		}
+	}
+
+	return entry->msg_sz != msg_sz ? -EINVAL : 0;
+}
+
 static void *ipc_msg_send_request(struct ksmbd_ipc_msg *msg, unsigned int handle)
 {
 	struct ipc_msg_table_entry entry;
@@ -476,6 +506,13 @@ static void *ipc_msg_send_request(struct ksmbd_ipc_msg *msg, unsigned int handle
 	ret = wait_event_interruptible_timeout(entry.wait,
 					       entry.response != NULL,
 					       IPC_WAIT_TIMEOUT);
+	if (entry.response) {
+		ret = ipc_validate_msg(&entry);
+		if (ret) {
+			kvfree(entry.response);
+			entry.response = NULL;
+		}
+	}
 out:
 	down_write(&ipc_msg_table_lock);
 	hash_del(&entry.ipc_table_hlist);
-- 
2.43.0



