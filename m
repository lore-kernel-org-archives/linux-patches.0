Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F162B7D3E5;
	Mon,  8 Apr 2024 13:22:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712582527; cv=none; b=mmJId2Y6mp4cq1PJwjiVSH9i+Ng7fwflwLJSikaCe1jW27aWrodjU7sDzAKez5EihbR7txStX8LHEYZIBN8lqf95HfVmsUfPRVbEBwMonbyIJauB6qlc3gqqLmlOlksHv0eC/9PtLQhq/THpqG3mjIOSAsIKmu15wCYDEhuiaKs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712582527; c=relaxed/simple;
	bh=wfPdAQjbSjBW/VseT28m+VpQrF75ahI+jC/rqCHuG+U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m0ByZ5pluOo0yD2NbwtsibZfJoqrUiHtlfEZ/cqTxy2wqO8NobWgvj3Oi4nmckC/xQk+itg4/e3VnGqOFjMiYzh4vR25EZ2eW5AdaW4kSks7tIv3r6esdbqBSR1UPcUIHO5BEs4RxckQ+Vr6CoFPcTrVlI1FFAnmx/570IGstKw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NlAbXR3H; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NlAbXR3H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79511C433C7;
	Mon,  8 Apr 2024 13:22:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712582526;
	bh=wfPdAQjbSjBW/VseT28m+VpQrF75ahI+jC/rqCHuG+U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NlAbXR3HavEDhTofF/JnUbNxPRr4rMYPpL/+t7psubfi6rMTFo+Xn1hAVJXN9uktT
	 FYbh+nfLm6W3GCsGT03L9bFcx3V2DooDhjWCZiUmy2m73RusZUYmBPqhEWfD2wnUDe
	 P/+yI7jG4NOmlWnrplXI9KsNA7yfqtXpaRBcobeg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chao Ma <machao2019@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.1 113/138] ksmbd: validate payload size in ipc response
Date: Mon,  8 Apr 2024 14:58:47 +0200
Message-ID: <20240408125259.745114488@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125256.218368873@linuxfoundation.org>
References: <20240408125256.218368873@linuxfoundation.org>
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

From: Namjae Jeon <linkinjeon@kernel.org>

commit a677ebd8ca2f2632ccdecbad7b87641274e15aac upstream.

If installing malicious ksmbd-tools, ksmbd.mountd can return invalid ipc
response to ksmbd kernel server. ksmbd should validate payload size of
ipc response from ksmbd.mountd to avoid memory overrun or
slab-out-of-bounds. This patch validate 3 ipc response that has payload.

Cc: stable@vger.kernel.org
Reported-by: Chao Ma <machao2019@gmail.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/server/ksmbd_netlink.h     |    3 ++-
 fs/smb/server/mgmt/share_config.c |    7 ++++++-
 fs/smb/server/transport_ipc.c     |   37 +++++++++++++++++++++++++++++++++++++
 3 files changed, 45 insertions(+), 2 deletions(-)

--- a/fs/smb/server/ksmbd_netlink.h
+++ b/fs/smb/server/ksmbd_netlink.h
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
--- a/fs/smb/server/mgmt/share_config.c
+++ b/fs/smb/server/mgmt/share_config.c
@@ -158,7 +158,12 @@ static struct ksmbd_share_config *share_
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
--- a/fs/smb/server/transport_ipc.c
+++ b/fs/smb/server/transport_ipc.c
@@ -65,6 +65,7 @@ struct ipc_msg_table_entry {
 	struct hlist_node	ipc_table_hlist;
 
 	void			*response;
+	unsigned int		msg_sz;
 };
 
 static struct delayed_work ipc_timer_work;
@@ -275,6 +276,7 @@ static int handle_response(int type, voi
 		}
 
 		memcpy(entry->response, payload, sz);
+		entry->msg_sz = sz;
 		wake_up_interruptible(&entry->wait);
 		ret = 0;
 		break;
@@ -453,6 +455,34 @@ out:
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
@@ -477,6 +507,13 @@ static void *ipc_msg_send_request(struct
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


