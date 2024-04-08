Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A1634D5AB;
	Mon,  8 Apr 2024 13:38:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712583529; cv=none; b=gM5Y1RRqYM8bYH52YYityljGhWVfKH244jN25mlLj+IBFaI2mr1aYM2JFmDBhmvimniX6e5YaR4T7+RN7tMxsZu2AzHgo/saysU0MPP9izuJSyhWHguDtZJ8JUcvHHlhcIOP6hMt6OVBlqWeQ+Q7p3lg2HJJgtN+90EpsDB7OlM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712583529; c=relaxed/simple;
	bh=fbLNr2HrVWyL+ayQwE7FMOZjFmpCwI53uFePQtDc3MM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pHTsq8WDLKsqVRtJ/Q6Eialy4hwYpAdR3jACZNDvEgmoh6qors3isrcSXl1ji69TRvfVXybmBe0Hd+yhZ9kPXKzY9hJ5UYssR3A6bHhXQJeVsOu2WQsAbTu/t1rBi8mPv8IqxQ65mlLVCASX/woLnnU/4x2ZHtSyeRO9TS+yvGo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cugKGSzz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cugKGSzz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6D76C433C7;
	Mon,  8 Apr 2024 13:38:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712583529;
	bh=fbLNr2HrVWyL+ayQwE7FMOZjFmpCwI53uFePQtDc3MM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cugKGSzzQ8QB6dm7bkcwwL1KvSoE6SaemBzNfok4qqlWHW01L8YGhKAUuzctAclhC
	 Xy6D7CfQgydIHq0J376mhghETyiN20RD02HNhFSrTxFfAFEy1VDE2qnIBIoXdaSE9F
	 ciACqXPpYCa1IKzr7PwBfNsVI6GXMlF/pShJFEa8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chao Ma <machao2019@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.6 205/252] ksmbd: validate payload size in ipc response
Date: Mon,  8 Apr 2024 14:58:24 +0200
Message-ID: <20240408125313.014753772@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125306.643546457@linuxfoundation.org>
References: <20240408125306.643546457@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


