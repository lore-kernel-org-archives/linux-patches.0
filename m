Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B2D44C623;
	Wed, 20 Dec 2023 16:12:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FH2LKEVd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90E78C433C8;
	Wed, 20 Dec 2023 16:12:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1703088754;
	bh=l8LfDieN5XQVolirVdw76eygsHiSP/OP7FWJ7bsUsGI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FH2LKEVdwrnaCrWKZcqXLJNkdxYuwwhmR2EIhrXN6VxWrm0QRFJe4ZV38/24srS0U
	 HB6UauejBHZHh8Ran4DeeiqaFz04dWNxDuM298G0P05Kxexfj/S4mp8okyU3/QPlW5
	 0tgJzXAfDG5tINJ52zMBd4QgIgyjctznxGGNbRT0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jakob Koschel <jakobkoschel@gmail.com>,
	Hyunchul Lee <hyc.lee@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 5.15 029/159] ksmbd: replace usage of found with dedicated list iterator variable
Date: Wed, 20 Dec 2023 17:08:14 +0100
Message-ID: <20231220160932.638163907@linuxfoundation.org>
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

From: Jakob Koschel <jakobkoschel@gmail.com>

[ Upstream commit edf5f0548fbb77e20b898460dc25281b0f4d974d ]

To move the list iterator variable into the list_for_each_entry_*()
macro in the future it should be avoided to use the list iterator
variable after the loop body.

To *never* use the list iterator variable after the loop it was
concluded to use a separate iterator variable instead of a
found boolean [1].

This removes the need to use a found variable and simply checking if
the variable was set, can determine if the break/goto was hit.

Link: https://lore.kernel.org/all/CAHk-=wgRr_D8CB-D9Kg-c=EHreAsk5SqXPwr9Y7k9sA6cWXJ6w@mail.gmail.com/
Signed-off-by: Jakob Koschel <jakobkoschel@gmail.com>
Reviewed-by: Hyunchul Lee <hyc.lee@gmail.com>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ksmbd/smb2pdu.c |   21 ++++++++++-----------
 1 file changed, 10 insertions(+), 11 deletions(-)

--- a/fs/ksmbd/smb2pdu.c
+++ b/fs/ksmbd/smb2pdu.c
@@ -6691,8 +6691,7 @@ int smb2_cancel(struct ksmbd_work *work)
 	struct ksmbd_conn *conn = work->conn;
 	struct smb2_hdr *hdr = smb2_get_msg(work->request_buf);
 	struct smb2_hdr *chdr;
-	struct ksmbd_work *cancel_work = NULL;
-	int canceled = 0;
+	struct ksmbd_work *cancel_work = NULL, *iter;
 	struct list_head *command_list;
 
 	ksmbd_debug(SMB, "smb2 cancel called on mid %llu, async flags 0x%x\n",
@@ -6702,11 +6701,11 @@ int smb2_cancel(struct ksmbd_work *work)
 		command_list = &conn->async_requests;
 
 		spin_lock(&conn->request_lock);
-		list_for_each_entry(cancel_work, command_list,
+		list_for_each_entry(iter, command_list,
 				    async_request_entry) {
-			chdr = smb2_get_msg(cancel_work->request_buf);
+			chdr = smb2_get_msg(iter->request_buf);
 
-			if (cancel_work->async_id !=
+			if (iter->async_id !=
 			    le64_to_cpu(hdr->Id.AsyncId))
 				continue;
 
@@ -6714,7 +6713,7 @@ int smb2_cancel(struct ksmbd_work *work)
 				    "smb2 with AsyncId %llu cancelled command = 0x%x\n",
 				    le64_to_cpu(hdr->Id.AsyncId),
 				    le16_to_cpu(chdr->Command));
-			canceled = 1;
+			cancel_work = iter;
 			break;
 		}
 		spin_unlock(&conn->request_lock);
@@ -6722,24 +6721,24 @@ int smb2_cancel(struct ksmbd_work *work)
 		command_list = &conn->requests;
 
 		spin_lock(&conn->request_lock);
-		list_for_each_entry(cancel_work, command_list, request_entry) {
-			chdr = smb2_get_msg(cancel_work->request_buf);
+		list_for_each_entry(iter, command_list, request_entry) {
+			chdr = smb2_get_msg(iter->request_buf);
 
 			if (chdr->MessageId != hdr->MessageId ||
-			    cancel_work == work)
+			    iter == work)
 				continue;
 
 			ksmbd_debug(SMB,
 				    "smb2 with mid %llu cancelled command = 0x%x\n",
 				    le64_to_cpu(hdr->MessageId),
 				    le16_to_cpu(chdr->Command));
-			canceled = 1;
+			cancel_work = iter;
 			break;
 		}
 		spin_unlock(&conn->request_lock);
 	}
 
-	if (canceled) {
+	if (cancel_work) {
 		cancel_work->state = KSMBD_WORK_CANCELLED;
 		if (cancel_work->cancel_fn)
 			cancel_work->cancel_fn(cancel_work->cancel_argv);


