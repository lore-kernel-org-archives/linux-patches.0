Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B32CD134C7
	for <patches@lists.linux.dev>; Mon, 26 Jun 2023 18:15:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2ED9C433C8;
	Mon, 26 Jun 2023 18:15:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1687803354;
	bh=1s+3K2boAs13FPzN8Y58AAOHn3J/E5gF7TQ/ZhrrL1w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GOhppau0i7dn2T3/pwmz4KOfUqyAFklsts7r+yc+tWRa6rHMWPk5Dlyn9VYpvac//
	 PyZKqfNvSTktfgJFyu3G0kN2lzmuWPI5VQPa6ri5SErh6GAWMd5+Gtyg0mU3fEPYjk
	 dE8azobeYTEc00V5yI1sQtnyoSDdbuKkhr3nso/o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chih-Yen Chang <cc85nod@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.3 008/199] ksmbd: validate command payload size
Date: Mon, 26 Jun 2023 20:08:34 +0200
Message-ID: <20230626180806.016123118@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230626180805.643662628@linuxfoundation.org>
References: <20230626180805.643662628@linuxfoundation.org>
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

commit 2b9b8f3b68edb3d67d79962f02e26dbb5ae3808d upstream.

->StructureSize2 indicates command payload size. ksmbd should validate
this size with rfc1002 length before accessing it.
This patch remove unneeded check and add the validation for this.

[    8.912583] BUG: KASAN: slab-out-of-bounds in ksmbd_smb2_check_message+0x12a/0xc50
[    8.913051] Read of size 2 at addr ffff88800ac7d92c by task kworker/0:0/7
...
[    8.914967] Call Trace:
[    8.915126]  <TASK>
[    8.915267]  dump_stack_lvl+0x33/0x50
[    8.915506]  print_report+0xcc/0x620
[    8.916558]  kasan_report+0xae/0xe0
[    8.917080]  kasan_check_range+0x35/0x1b0
[    8.917334]  ksmbd_smb2_check_message+0x12a/0xc50
[    8.917935]  ksmbd_verify_smb_message+0xae/0xd0
[    8.918223]  handle_ksmbd_work+0x192/0x820
[    8.918478]  process_one_work+0x419/0x760
[    8.918727]  worker_thread+0x2a2/0x6f0
[    8.919222]  kthread+0x187/0x1d0
[    8.919723]  ret_from_fork+0x1f/0x30
[    8.919954]  </TASK>

Cc: stable@vger.kernel.org
Reported-by: Chih-Yen Chang <cc85nod@gmail.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ksmbd/smb2misc.c |   23 ++++++++++++-----------
 1 file changed, 12 insertions(+), 11 deletions(-)

--- a/fs/ksmbd/smb2misc.c
+++ b/fs/ksmbd/smb2misc.c
@@ -351,6 +351,7 @@ int ksmbd_smb2_check_message(struct ksmb
 	int command;
 	__u32 clc_len;  /* calculated length */
 	__u32 len = get_rfc1002_len(work->request_buf);
+	__u32 req_struct_size;
 
 	if (le32_to_cpu(hdr->NextCommand) > 0)
 		len = le32_to_cpu(hdr->NextCommand);
@@ -373,17 +374,9 @@ int ksmbd_smb2_check_message(struct ksmb
 	}
 
 	if (smb2_req_struct_sizes[command] != pdu->StructureSize2) {
-		if (command != SMB2_OPLOCK_BREAK_HE &&
-		    (hdr->Status == 0 || pdu->StructureSize2 != SMB2_ERROR_STRUCTURE_SIZE2_LE)) {
-			/* error packets have 9 byte structure size */
-			ksmbd_debug(SMB,
-				    "Illegal request size %u for command %d\n",
-				    le16_to_cpu(pdu->StructureSize2), command);
-			return 1;
-		} else if (command == SMB2_OPLOCK_BREAK_HE &&
-			   hdr->Status == 0 &&
-			   le16_to_cpu(pdu->StructureSize2) != OP_BREAK_STRUCT_SIZE_20 &&
-			   le16_to_cpu(pdu->StructureSize2) != OP_BREAK_STRUCT_SIZE_21) {
+		if (command == SMB2_OPLOCK_BREAK_HE &&
+		    le16_to_cpu(pdu->StructureSize2) != OP_BREAK_STRUCT_SIZE_20 &&
+		    le16_to_cpu(pdu->StructureSize2) != OP_BREAK_STRUCT_SIZE_21) {
 			/* special case for SMB2.1 lease break message */
 			ksmbd_debug(SMB,
 				    "Illegal request size %d for oplock break\n",
@@ -392,6 +385,14 @@ int ksmbd_smb2_check_message(struct ksmb
 		}
 	}
 
+	req_struct_size = le16_to_cpu(pdu->StructureSize2) +
+		__SMB2_HEADER_STRUCTURE_SIZE;
+	if (command == SMB2_LOCK_HE)
+		req_struct_size -= sizeof(struct smb2_lock_element);
+
+	if (req_struct_size > len + 1)
+		return 1;
+
 	if (smb2_calc_size(hdr, &clc_len))
 		return 1;
 


