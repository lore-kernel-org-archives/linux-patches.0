Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DE7E495C8;
	Wed, 20 Dec 2023 16:16:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FXwyJHfx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DDD9C433C8;
	Wed, 20 Dec 2023 16:16:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1703088985;
	bh=1Xb2vydDABW8f3ZSL+ZlMY8Sx5mMS6kCnkhjkhn5T/Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FXwyJHfx+NUKP/wE9tJGvbfmyM0xwHkwhpsiodH+PHzqA9Y6w7asv5g/wMFsoUxlp
	 DTCwoFuej1pqnu+bCC+VbdLS9NtNCgAZQPxI52Hrnvr2Dlq7I4zUqSBEY0OdJwaAFj
	 hQJCpluBdxwYeMkj3FJbKNgEPylMoEYmUqxCjwKQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chih-Yen Chang <cc85nod@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 5.15 099/159] ksmbd: fix out-of-bound read in parse_lease_state()
Date: Wed, 20 Dec 2023 17:09:24 +0100
Message-ID: <20231220160935.967406725@linuxfoundation.org>
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

[ Upstream commit fc6c6a3c324c1b3e93a03d0cfa3749c781f23de0 ]

This bug is in parse_lease_state, and it is caused by the missing check
of `struct create_context`. When the ksmbd traverses the create_contexts,
it doesn't check if the field of `NameOffset` and `Next` is valid,
The KASAN message is following:

[    6.664323] BUG: KASAN: slab-out-of-bounds in parse_lease_state+0x7d/0x280
[    6.664738] Read of size 2 at addr ffff888005c08988 by task kworker/0:3/103
...
[    6.666644] Call Trace:
[    6.666796]  <TASK>
[    6.666933]  dump_stack_lvl+0x33/0x50
[    6.667167]  print_report+0xcc/0x620
[    6.667903]  kasan_report+0xae/0xe0
[    6.668374]  kasan_check_range+0x35/0x1b0
[    6.668621]  parse_lease_state+0x7d/0x280
[    6.668868]  smb2_open+0xbe8/0x4420
[    6.675137]  handle_ksmbd_work+0x282/0x820

Use smb2_find_context_vals() to find smb2 create request lease context.
smb2_find_context_vals validate create context fields.

Cc: stable@vger.kernel.org
Reported-by: Chih-Yen Chang <cc85nod@gmail.com>
Tested-by: Chih-Yen Chang <cc85nod@gmail.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ksmbd/oplock.c |   70 ++++++++++++++++++++----------------------------------
 1 file changed, 26 insertions(+), 44 deletions(-)

--- a/fs/ksmbd/oplock.c
+++ b/fs/ksmbd/oplock.c
@@ -1415,56 +1415,38 @@ void create_lease_buf(u8 *rbuf, struct l
  */
 struct lease_ctx_info *parse_lease_state(void *open_req)
 {
-	char *data_offset;
 	struct create_context *cc;
-	unsigned int next = 0;
-	char *name;
-	bool found = false;
 	struct smb2_create_req *req = (struct smb2_create_req *)open_req;
-	struct lease_ctx_info *lreq = kzalloc(sizeof(struct lease_ctx_info),
-		GFP_KERNEL);
+	struct lease_ctx_info *lreq;
+
+	cc = smb2_find_context_vals(req, SMB2_CREATE_REQUEST_LEASE, 4);
+	if (IS_ERR_OR_NULL(cc))
+		return NULL;
+
+	lreq = kzalloc(sizeof(struct lease_ctx_info), GFP_KERNEL);
 	if (!lreq)
 		return NULL;
 
-	data_offset = (char *)req + le32_to_cpu(req->CreateContextsOffset);
-	cc = (struct create_context *)data_offset;
-	do {
-		cc = (struct create_context *)((char *)cc + next);
-		name = le16_to_cpu(cc->NameOffset) + (char *)cc;
-		if (le16_to_cpu(cc->NameLength) != 4 ||
-		    strncmp(name, SMB2_CREATE_REQUEST_LEASE, 4)) {
-			next = le32_to_cpu(cc->Next);
-			continue;
-		}
-		found = true;
-		break;
-	} while (next != 0);
-
-	if (found) {
-		if (sizeof(struct lease_context_v2) == le32_to_cpu(cc->DataLength)) {
-			struct create_lease_v2 *lc = (struct create_lease_v2 *)cc;
-
-			memcpy(lreq->lease_key, lc->lcontext.LeaseKey, SMB2_LEASE_KEY_SIZE);
-			lreq->req_state = lc->lcontext.LeaseState;
-			lreq->flags = lc->lcontext.LeaseFlags;
-			lreq->duration = lc->lcontext.LeaseDuration;
-			memcpy(lreq->parent_lease_key, lc->lcontext.ParentLeaseKey,
-			       SMB2_LEASE_KEY_SIZE);
-			lreq->version = 2;
-		} else {
-			struct create_lease *lc = (struct create_lease *)cc;
-
-			memcpy(lreq->lease_key, lc->lcontext.LeaseKey, SMB2_LEASE_KEY_SIZE);
-			lreq->req_state = lc->lcontext.LeaseState;
-			lreq->flags = lc->lcontext.LeaseFlags;
-			lreq->duration = lc->lcontext.LeaseDuration;
-			lreq->version = 1;
-		}
-		return lreq;
-	}
+	if (sizeof(struct lease_context_v2) == le32_to_cpu(cc->DataLength)) {
+		struct create_lease_v2 *lc = (struct create_lease_v2 *)cc;
 
-	kfree(lreq);
-	return NULL;
+		memcpy(lreq->lease_key, lc->lcontext.LeaseKey, SMB2_LEASE_KEY_SIZE);
+		lreq->req_state = lc->lcontext.LeaseState;
+		lreq->flags = lc->lcontext.LeaseFlags;
+		lreq->duration = lc->lcontext.LeaseDuration;
+		memcpy(lreq->parent_lease_key, lc->lcontext.ParentLeaseKey,
+				SMB2_LEASE_KEY_SIZE);
+		lreq->version = 2;
+	} else {
+		struct create_lease *lc = (struct create_lease *)cc;
+
+		memcpy(lreq->lease_key, lc->lcontext.LeaseKey, SMB2_LEASE_KEY_SIZE);
+		lreq->req_state = lc->lcontext.LeaseState;
+		lreq->flags = lc->lcontext.LeaseFlags;
+		lreq->duration = lc->lcontext.LeaseDuration;
+		lreq->version = 1;
+	}
+	return lreq;
 }
 
 /**


