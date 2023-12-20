Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E33A1482C2;
	Wed, 20 Dec 2023 16:16:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DhJj1sl1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12FCBC433C8;
	Wed, 20 Dec 2023 16:16:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1703088996;
	bh=JgiS6lLoDwhSsTFF/DG12p4rkbpZ2dGzYUgqF8rizCo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DhJj1sl19FgYwOlZstrY7xkhqjTgp3+V/ZqAn14bkrp2Tod3h7KfqM7xPgI43nFRx
	 vFcIqdqVZpPDVBm30C7TkDLKbRyKv82WokHfygiIZcCi8h+KuNI5NGuxh2rlYvwH2w
	 wKs7iJrkhRS3CTNNTUEzPRhVUg+9WI/hvVj6YZk8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	luosili <rootlab@huawei.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 5.15 133/159] ksmbd: fix race condition from parallel smb2 logoff requests
Date: Wed, 20 Dec 2023 17:09:58 +0100
Message-ID: <20231220160937.534625209@linuxfoundation.org>
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

[ Upstream commit 7ca9da7d873ee8024e9548d3366101c2b6843eab ]

If parallel smb2 logoff requests come in before closing door, running
request count becomes more than 1 even though connection status is set to
KSMBD_SESS_NEED_RECONNECT. It can't get condition true, and sleep forever.
This patch fix race condition problem by returning error if connection
status was already set to KSMBD_SESS_NEED_RECONNECT.

Reported-by: luosili <rootlab@huawei.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ksmbd/smb2pdu.c |   24 ++++++++++++++++--------
 1 file changed, 16 insertions(+), 8 deletions(-)

--- a/fs/ksmbd/smb2pdu.c
+++ b/fs/ksmbd/smb2pdu.c
@@ -2164,17 +2164,17 @@ int smb2_session_logoff(struct ksmbd_wor
 
 	ksmbd_debug(SMB, "request\n");
 
-	sess_id = le64_to_cpu(req->hdr.SessionId);
-
-	rsp->StructureSize = cpu_to_le16(4);
-	err = ksmbd_iov_pin_rsp(work, rsp, sizeof(struct smb2_logoff_rsp));
-	if (err) {
-		rsp->hdr.Status = STATUS_INSUFFICIENT_RESOURCES;
+	ksmbd_conn_lock(conn);
+	if (!ksmbd_conn_good(conn)) {
+		ksmbd_conn_unlock(conn);
+		rsp->hdr.Status = STATUS_NETWORK_NAME_DELETED;
 		smb2_set_err_rsp(work);
-		return err;
+		return -ENOENT;
 	}
-
+	sess_id = le64_to_cpu(req->hdr.SessionId);
 	ksmbd_all_conn_set_status(sess_id, KSMBD_SESS_NEED_RECONNECT);
+	ksmbd_conn_unlock(conn);
+
 	ksmbd_close_session_fds(work);
 	ksmbd_conn_wait_idle(conn, sess_id);
 
@@ -2196,6 +2196,14 @@ int smb2_session_logoff(struct ksmbd_wor
 	ksmbd_free_user(sess->user);
 	sess->user = NULL;
 	ksmbd_all_conn_set_status(sess_id, KSMBD_SESS_NEED_NEGOTIATE);
+
+	rsp->StructureSize = cpu_to_le16(4);
+	err = ksmbd_iov_pin_rsp(work, rsp, sizeof(struct smb2_logoff_rsp));
+	if (err) {
+		rsp->hdr.Status = STATUS_INSUFFICIENT_RESOURCES;
+		smb2_set_err_rsp(work);
+		return err;
+	}
 	return 0;
 }
 


