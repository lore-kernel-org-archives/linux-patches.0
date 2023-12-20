Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12A8E3FB33;
	Wed, 20 Dec 2023 16:15:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xBjBg3Qv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C686C433C7;
	Wed, 20 Dec 2023 16:15:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1703088922;
	bh=R7AG6JSfIxRDKhkpyfVaiLH/MPYMpSVFzqASvRl9zas=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xBjBg3Qv62eDtN1eNfmiVvA9yVnfdZeH5jwe54SWXxbfy6W1JnsUob3QT/oJ9a/er
	 EP9H9sePW8XjJ6rroLGqXXTqs8oaumN/uytePxPAqcNCU2v1baopKuKVDMp2EZexUj
	 b0xrXDDpvK7dOSqo1qxQxIzCeKwc8c91z7l+W8o4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 5.15 108/159] ksmbd: use kvzalloc instead of kvmalloc
Date: Wed, 20 Dec 2023 17:09:33 +0100
Message-ID: <20231220160936.386596064@linuxfoundation.org>
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

[ Upstream commit 81a94b27847f7d2e499415db14dd9dc7c22b19b0 ]

Use kvzalloc instead of kvmalloc.

Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ksmbd/smb2pdu.c       |    8 ++++----
 fs/ksmbd/transport_ipc.c |    4 ++--
 fs/ksmbd/vfs.c           |    4 ++--
 3 files changed, 8 insertions(+), 8 deletions(-)

--- a/fs/ksmbd/smb2pdu.c
+++ b/fs/ksmbd/smb2pdu.c
@@ -544,7 +544,7 @@ int smb2_allocate_rsp_buf(struct ksmbd_w
 	if (le32_to_cpu(hdr->NextCommand) > 0)
 		sz = large_sz;
 
-	work->response_buf = kvmalloc(sz, GFP_KERNEL | __GFP_ZERO);
+	work->response_buf = kvzalloc(sz, GFP_KERNEL);
 	if (!work->response_buf)
 		return -ENOMEM;
 
@@ -6104,7 +6104,7 @@ static noinline int smb2_read_pipe(struc
 		}
 
 		work->aux_payload_buf =
-			kvmalloc(rpc_resp->payload_sz, GFP_KERNEL | __GFP_ZERO);
+			kvmalloc(rpc_resp->payload_sz, GFP_KERNEL);
 		if (!work->aux_payload_buf) {
 			err = -ENOMEM;
 			goto out;
@@ -6261,7 +6261,7 @@ int smb2_read(struct ksmbd_work *work)
 	ksmbd_debug(SMB, "filename %pD, offset %lld, len %zu\n",
 		    fp->filp, offset, length);
 
-	work->aux_payload_buf = kvmalloc(length, GFP_KERNEL | __GFP_ZERO);
+	work->aux_payload_buf = kvzalloc(length, GFP_KERNEL);
 	if (!work->aux_payload_buf) {
 		err = -ENOMEM;
 		goto out;
@@ -6410,7 +6410,7 @@ static ssize_t smb2_write_rdma_channel(s
 	int ret;
 	ssize_t nbytes;
 
-	data_buf = kvmalloc(length, GFP_KERNEL | __GFP_ZERO);
+	data_buf = kvzalloc(length, GFP_KERNEL);
 	if (!data_buf)
 		return -ENOMEM;
 
--- a/fs/ksmbd/transport_ipc.c
+++ b/fs/ksmbd/transport_ipc.c
@@ -228,7 +228,7 @@ static struct ksmbd_ipc_msg *ipc_msg_all
 	struct ksmbd_ipc_msg *msg;
 	size_t msg_sz = sz + sizeof(struct ksmbd_ipc_msg);
 
-	msg = kvmalloc(msg_sz, GFP_KERNEL | __GFP_ZERO);
+	msg = kvzalloc(msg_sz, GFP_KERNEL);
 	if (msg)
 		msg->sz = sz;
 	return msg;
@@ -267,7 +267,7 @@ static int handle_response(int type, voi
 			       entry->type + 1, type);
 		}
 
-		entry->response = kvmalloc(sz, GFP_KERNEL | __GFP_ZERO);
+		entry->response = kvzalloc(sz, GFP_KERNEL);
 		if (!entry->response) {
 			ret = -ENOMEM;
 			break;
--- a/fs/ksmbd/vfs.c
+++ b/fs/ksmbd/vfs.c
@@ -436,7 +436,7 @@ static int ksmbd_vfs_stream_write(struct
 	}
 
 	if (v_len < size) {
-		wbuf = kvmalloc(size, GFP_KERNEL | __GFP_ZERO);
+		wbuf = kvzalloc(size, GFP_KERNEL);
 		if (!wbuf) {
 			err = -ENOMEM;
 			goto out;
@@ -853,7 +853,7 @@ ssize_t ksmbd_vfs_listxattr(struct dentr
 	if (size <= 0)
 		return size;
 
-	vlist = kvmalloc(size, GFP_KERNEL | __GFP_ZERO);
+	vlist = kvzalloc(size, GFP_KERNEL);
 	if (!vlist)
 		return -ENOMEM;
 


