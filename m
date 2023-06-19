Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5EA71095B
	for <patches@lists.linux.dev>; Mon, 19 Jun 2023 10:33:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43767C433C0;
	Mon, 19 Jun 2023 10:33:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1687170807;
	bh=4EsQkUWGg4c61tIikPX9SeCOUW/Iu6y91stx+mB+4aA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pdr7xWKpLGPbVEFHlaEHn6GW2lsG5jxMBjYtP+qe6swUpoPino4YFI3wqiBm/90zu
	 45k6kYoGteuHg1vi1F6wXtI9AGo+ONGOErf1bi6kffXlAMTyeQyGD7ECBBfgvAhmgb
	 Z83y6Wh+HIovdvRI4NIaXwO3ZSscjqpgvo4Mr1ag=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chih-Yen Chang <cc85nod@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 007/187] ksmbd: validate smb request protocol id
Date: Mon, 19 Jun 2023 12:27:05 +0200
Message-ID: <20230619102157.976534972@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230619102157.579823843@linuxfoundation.org>
References: <20230619102157.579823843@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Namjae Jeon <linkinjeon@kernel.org>

[ Upstream commit 1c1bcf2d3ea061613119b534f57507c377df20f9 ]

This patch add the validation for smb request protocol id.
If it is not one of the four ids(SMB1_PROTO_NUMBER, SMB2_PROTO_NUMBER,
SMB2_TRANSFORM_PROTO_NUM, SMB2_COMPRESSION_TRANSFORM_ID), don't allow
processing the request. And this will fix the following KASAN warning
also.

[   13.905265] BUG: KASAN: slab-out-of-bounds in init_smb2_rsp_hdr+0x1b9/0x1f0
[   13.905900] Read of size 16 at addr ffff888005fd2f34 by task kworker/0:2/44
...
[   13.908553] Call Trace:
[   13.908793]  <TASK>
[   13.908995]  dump_stack_lvl+0x33/0x50
[   13.909369]  print_report+0xcc/0x620
[   13.910870]  kasan_report+0xae/0xe0
[   13.911519]  kasan_check_range+0x35/0x1b0
[   13.911796]  init_smb2_rsp_hdr+0x1b9/0x1f0
[   13.912492]  handle_ksmbd_work+0xe5/0x820

Cc: stable@vger.kernel.org
Reported-by: Chih-Yen Chang <cc85nod@gmail.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ksmbd/connection.c |  5 +++--
 fs/ksmbd/smb_common.c | 14 +++++++++++++-
 2 files changed, 16 insertions(+), 3 deletions(-)

diff --git a/fs/ksmbd/connection.c b/fs/ksmbd/connection.c
index e11d4a1e63d73..2a717d158f02e 100644
--- a/fs/ksmbd/connection.c
+++ b/fs/ksmbd/connection.c
@@ -364,8 +364,6 @@ int ksmbd_conn_handler_loop(void *p)
 			break;
 
 		memcpy(conn->request_buf, hdr_buf, sizeof(hdr_buf));
-		if (!ksmbd_smb_request(conn))
-			break;
 
 		/*
 		 * We already read 4 bytes to find out PDU size, now
@@ -383,6 +381,9 @@ int ksmbd_conn_handler_loop(void *p)
 			continue;
 		}
 
+		if (!ksmbd_smb_request(conn))
+			break;
+
 		if (((struct smb2_hdr *)smb2_get_msg(conn->request_buf))->ProtocolId ==
 		    SMB2_PROTO_NUMBER) {
 			if (pdu_size < SMB2_MIN_SUPPORTED_HEADER_SIZE)
diff --git a/fs/ksmbd/smb_common.c b/fs/ksmbd/smb_common.c
index af0c2a9b85290..569e5eecdf3db 100644
--- a/fs/ksmbd/smb_common.c
+++ b/fs/ksmbd/smb_common.c
@@ -158,7 +158,19 @@ int ksmbd_verify_smb_message(struct ksmbd_work *work)
  */
 bool ksmbd_smb_request(struct ksmbd_conn *conn)
 {
-	return conn->request_buf[0] == 0;
+	__le32 *proto = (__le32 *)smb2_get_msg(conn->request_buf);
+
+	if (*proto == SMB2_COMPRESSION_TRANSFORM_ID) {
+		pr_err_ratelimited("smb2 compression not support yet");
+		return false;
+	}
+
+	if (*proto != SMB1_PROTO_NUMBER &&
+	    *proto != SMB2_PROTO_NUMBER &&
+	    *proto != SMB2_TRANSFORM_PROTO_NUM)
+		return false;
+
+	return true;
 }
 
 static bool supported_protocol(int idx)
-- 
2.39.2



