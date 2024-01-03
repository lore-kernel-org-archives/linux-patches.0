Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 441A61BDF1;
	Wed,  3 Jan 2024 17:13:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bv1nYESf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8CF6C433C7;
	Wed,  3 Jan 2024 17:12:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1704301980;
	bh=vJEYn18HCkJx+JDpNdZijEzvZHRdbguVimER5tWylK0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bv1nYESfnF8JbtZSo10/wnnlDVykc5gdQCDqyFNKKDwwUvqedmYcyEBJQTVM2oadD
	 wlvAnbJ4laqstwXQoNEuxs8IQsTyxxxYkMF7i1QPWH1ARKzAwVzJQ2Uwv9MGp2yl7M
	 aev0rfR9Zm/gfszkFLq5o0pbdV58C1W3j+lLQHcQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 12/49] ksmbd: move setting SMB2_FLAGS_ASYNC_COMMAND and AsyncId
Date: Wed,  3 Jan 2024 17:55:32 +0100
Message-ID: <20240103164836.889898134@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240103164834.970234661@linuxfoundation.org>
References: <20240103164834.970234661@linuxfoundation.org>
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

[ Upstream commit 9ac45ac7cf65b0623ceeab9b28b307a08efa22dc ]

Directly set SMB2_FLAGS_ASYNC_COMMAND flags and AsyncId in smb2 header of
interim response instead of current response header.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/smb2pdu.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index e58504d0e9c1e..de71532651d97 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -657,13 +657,9 @@ smb2_get_name(const char *src, const int maxlen, struct nls_table *local_nls)
 
 int setup_async_work(struct ksmbd_work *work, void (*fn)(void **), void **arg)
 {
-	struct smb2_hdr *rsp_hdr;
 	struct ksmbd_conn *conn = work->conn;
 	int id;
 
-	rsp_hdr = ksmbd_resp_buf_next(work);
-	rsp_hdr->Flags |= SMB2_FLAGS_ASYNC_COMMAND;
-
 	id = ksmbd_acquire_async_msg_id(&conn->async_ida);
 	if (id < 0) {
 		pr_err("Failed to alloc async message id\n");
@@ -671,7 +667,6 @@ int setup_async_work(struct ksmbd_work *work, void (*fn)(void **), void **arg)
 	}
 	work->asynchronous = true;
 	work->async_id = id;
-	rsp_hdr->Id.AsyncId = cpu_to_le64(id);
 
 	ksmbd_debug(SMB,
 		    "Send interim Response to inform async request id : %d\n",
@@ -723,6 +718,8 @@ void smb2_send_interim_resp(struct ksmbd_work *work, __le32 status)
 	       __SMB2_HEADER_STRUCTURE_SIZE);
 
 	rsp_hdr = smb2_get_msg(in_work->response_buf);
+	rsp_hdr->Flags |= SMB2_FLAGS_ASYNC_COMMAND;
+	rsp_hdr->Id.AsyncId = cpu_to_le64(work->async_id);
 	smb2_set_err_rsp(in_work);
 	rsp_hdr->Status = status;
 
-- 
2.43.0



