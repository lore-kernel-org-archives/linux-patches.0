Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8D7AC142
	for <patches@lists.linux.dev>; Mon,  4 Sep 2023 18:31:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E1CFC433C8;
	Mon,  4 Sep 2023 18:31:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1693852306;
	bh=/EpjbTuJF+MFVAJwPqdFJj5dQ2i/fq7pWlwWVsviXsk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J2D4IppmwnNSRry8GF0FHkCQ2I4+je4AeI5qJzEUMJ4EQc3nYtpKrddAmvdGtZ5r8
	 tQudOMSbjNXzsiswvSj9l0LKckV1SRejRfE8QuX+khV1dr5iGp1zSgQVFlV+9Qx49D
	 4pPPxmnyA5QG4HovHN/vdmv5AoxL8cj8hv4MBTpY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.5 05/34] ksmbd: replace one-element array with flex-array member in struct smb2_ea_info
Date: Mon,  4 Sep 2023 19:29:52 +0100
Message-ID: <20230904182948.849684118@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230904182948.594404081@linuxfoundation.org>
References: <20230904182948.594404081@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Namjae Jeon <linkinjeon@kernel.org>

commit 0ba5439d9afa2722e7728df56f272c89987540a4 upstream.

UBSAN complains about out-of-bounds array indexes on 1-element arrays in
struct smb2_ea_info.

UBSAN: array-index-out-of-bounds in fs/smb/server/smb2pdu.c:4335:15
index 1 is out of range for type 'char [1]'
CPU: 1 PID: 354 Comm: kworker/1:4 Not tainted 6.5.0-rc4 #1
Hardware name: VMware, Inc. VMware Virtual Platform/440BX Desktop
Reference Platform, BIOS 6.00 07/22/2020
Workqueue: ksmbd-io handle_ksmbd_work [ksmbd]
Call Trace:
 <TASK>
 __dump_stack linux/lib/dump_stack.c:88
 dump_stack_lvl+0x48/0x70 linux/lib/dump_stack.c:106
 dump_stack+0x10/0x20 linux/lib/dump_stack.c:113
 ubsan_epilogue linux/lib/ubsan.c:217
 __ubsan_handle_out_of_bounds+0xc6/0x110 linux/lib/ubsan.c:348
 smb2_get_ea linux/fs/smb/server/smb2pdu.c:4335
 smb2_get_info_file linux/fs/smb/server/smb2pdu.c:4900
 smb2_query_info+0x63ae/0x6b20 linux/fs/smb/server/smb2pdu.c:5275
 __process_request linux/fs/smb/server/server.c:145
 __handle_ksmbd_work linux/fs/smb/server/server.c:213
 handle_ksmbd_work+0x348/0x10b0 linux/fs/smb/server/server.c:266
 process_one_work+0x85a/0x1500 linux/kernel/workqueue.c:2597
 worker_thread+0xf3/0x13a0 linux/kernel/workqueue.c:2748
 kthread+0x2b7/0x390 linux/kernel/kthread.c:389
 ret_from_fork+0x44/0x90 linux/arch/x86/kernel/process.c:145
 ret_from_fork_asm+0x1b/0x30 linux/arch/x86/entry/entry_64.S:304
 </TASK>

Cc: stable@vger.kernel.org
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/server/smb2pdu.c |    2 +-
 fs/smb/server/smb2pdu.h |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -4308,7 +4308,7 @@ static int smb2_get_ea(struct ksmbd_work
 		if (!strncmp(name, XATTR_USER_PREFIX, XATTR_USER_PREFIX_LEN))
 			name_len -= XATTR_USER_PREFIX_LEN;
 
-		ptr = (char *)(&eainfo->name + name_len + 1);
+		ptr = eainfo->name + name_len + 1;
 		buf_free_len -= (offsetof(struct smb2_ea_info, name) +
 				name_len + 1);
 		/* bailout if xattr can't fit in buf_free_len */
--- a/fs/smb/server/smb2pdu.h
+++ b/fs/smb/server/smb2pdu.h
@@ -361,7 +361,7 @@ struct smb2_ea_info {
 	__u8   Flags;
 	__u8   EaNameLength;
 	__le16 EaValueLength;
-	char name[1];
+	char name[];
 	/* optionally followed by value */
 } __packed; /* level 15 Query */
 


