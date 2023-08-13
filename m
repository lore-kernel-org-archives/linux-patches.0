Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3E579446
	for <patches@lists.linux.dev>; Sun, 13 Aug 2023 21:33:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EF6BC433C7;
	Sun, 13 Aug 2023 21:33:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691962426;
	bh=6w60sbFKMYmVG66+dYlN5FMzeWBOFAW6DGEOx/KgqSA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ii3GWTCmUnXBlQStnrinx9o6/6HrsBOiK0GCpSWgJvJ9QX6hIUhHoQNOkxoE4A3yf
	 U+9EwlIhIkhxFmN5cuo959Q06tpslMCu7+FRyIIOaPGDqYnFEVE6XopaFopdK9idEA
	 6tlaxJr0Xfovq86WyQjXJxeZ5863Oty5AyNnaPPg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Long Li <leo.lilong@huawei.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.1 005/149] ksmbd: validate command request size
Date: Sun, 13 Aug 2023 23:17:30 +0200
Message-ID: <20230813211718.924332134@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230813211718.757428827@linuxfoundation.org>
References: <20230813211718.757428827@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Long Li <leo.lilong@huawei.com>

commit 5aa4fda5aa9c2a5a7bac67b4a12b089ab81fee3c upstream.

In commit 2b9b8f3b68ed ("ksmbd: validate command payload size"), except
for SMB2_OPLOCK_BREAK_HE command, the request size of other commands
is not checked, it's not expected. Fix it by add check for request
size of other commands.

Cc: stable@vger.kernel.org
Fixes: 2b9b8f3b68ed ("ksmbd: validate command payload size")
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Long Li <leo.lilong@huawei.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/server/smb2misc.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/fs/smb/server/smb2misc.c
+++ b/fs/smb/server/smb2misc.c
@@ -380,13 +380,13 @@ int ksmbd_smb2_check_message(struct ksmb
 	}
 
 	if (smb2_req_struct_sizes[command] != pdu->StructureSize2) {
-		if (command == SMB2_OPLOCK_BREAK_HE &&
-		    le16_to_cpu(pdu->StructureSize2) != OP_BREAK_STRUCT_SIZE_20 &&
-		    le16_to_cpu(pdu->StructureSize2) != OP_BREAK_STRUCT_SIZE_21) {
+		if (!(command == SMB2_OPLOCK_BREAK_HE &&
+		    (le16_to_cpu(pdu->StructureSize2) == OP_BREAK_STRUCT_SIZE_20 ||
+		    le16_to_cpu(pdu->StructureSize2) == OP_BREAK_STRUCT_SIZE_21))) {
 			/* special case for SMB2.1 lease break message */
 			ksmbd_debug(SMB,
-				    "Illegal request size %d for oplock break\n",
-				    le16_to_cpu(pdu->StructureSize2));
+				"Illegal request size %u for command %d\n",
+				le16_to_cpu(pdu->StructureSize2), command);
 			return 1;
 		}
 	}


