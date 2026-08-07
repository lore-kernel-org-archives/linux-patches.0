Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29D7C277CA5;
	Fri,  7 Aug 2026 14:46:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786114001; cv=none; b=Ykzt1U4XdtHHiHGJKV56a8XJJGhBMpQzqxPfFaPaYjI32wFGkdGIa4d3pu/fH40plPSxwYiNgASJyiYAWzZtW6mwdaye8Ju/H1zHzjbZaP9ujd7kEBYKFbWrXiQ5huO2toEio9v8V9IfQN1fPPHriTtCESatKY0kthEHT/UWW/w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786114001; c=relaxed/simple;
	bh=Oa34WHHduc2YUui8rR1r3TtW0liWX3vh6px3r/uAaV4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XpfQZqJXZe3Xh/mePBEoEZXMKi1ML+Qmm1eUj9G40KFrnzevkxixx3ZlhqyiTGgm3nNstUthyb4K3vAiFv9MjGE3ttMCx++aqCWN87u0LetcS96hM2/4q1XK6xtTvAPjFjLZ+g2UWKBw6wpz6tSWkuGUW2Z1wyjp63BOatH2RrI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Lh5ubznM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Lh5ubznM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FA811F000E9;
	Fri,  7 Aug 2026 14:46:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786114000;
	bh=Ge0xrDkUmWbU8zRecDU3QXzOoma0Cv/lSWQ3ydKejTg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Lh5ubznMtMv2txvfh9ilRcSUIYQC9dZvYCsxandL/rGVwdVRarvFeI+RZfRTbT4m3
	 9DbrCrYIgG9amAbzRBVIPnHBdJTJavvp15iG/9TJxGktKg71c/ZcgggfRTHQqyliGY
	 TH3V8P6Im3sucg3cNULuK9ji7FMMtT/Wp5X/Uo8M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	TanZheng <tanzheng@kylinos.cn>,
	Mike Christie <michael.christie@oracle.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 108/337] scsi: target: iblock: Fix wrong PR ops NULL check for PREEMPT/RELEASE
Date: Fri,  7 Aug 2026 16:35:11 +0200
Message-ID: <20260807143420.877143079@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143418.516897842@linuxfoundation.org>
References: <20260807143418.516897842@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: TanZheng <tanzheng@kylinos.cn>

[ Upstream commit 9c33222bd387312874fbe36ca8002e5c945b9653 ]

In the iblock_execute_pr_out() function, PRO_PREEMPT,
PRO_PREEMPT_AND_ABORT, and PRO_RELEASE all perform callback capability
checks through ops->pr_clear. The error check allows unimplemented hooks
to pass through the gate, resulting dereferencing a NULL function
pointer.

Check whether the hooks that need to be called are supported.

Fixes: 394f81184882 ("scsi: target: Add block PR support to iblock")
Signed-off-by: TanZheng <tanzheng@kylinos.cn>
Reviewed-by: Mike Christie <michael.christie@oracle.com>
Link: https://patch.msgid.link/20260724075850.280699-1-kensanya@163.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/target/target_core_iblock.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/target/target_core_iblock.c b/drivers/target/target_core_iblock.c
index c8dc92a7d63e6..0a232abee8f58 100644
--- a/drivers/target/target_core_iblock.c
+++ b/drivers/target/target_core_iblock.c
@@ -891,7 +891,7 @@ static sense_reason_t iblock_execute_pr_out(struct se_cmd *cmd, u8 sa, u64 key,
 		break;
 	case PRO_PREEMPT:
 	case PRO_PREEMPT_AND_ABORT:
-		if (!ops->pr_clear) {
+		if (!ops->pr_preempt) {
 			pr_err("block_device does not support pr_preempt.\n");
 			return TCM_UNSUPPORTED_SCSI_OPCODE;
 		}
@@ -901,8 +901,8 @@ static sense_reason_t iblock_execute_pr_out(struct se_cmd *cmd, u8 sa, u64 key,
 				      sa == PRO_PREEMPT_AND_ABORT);
 		break;
 	case PRO_RELEASE:
-		if (!ops->pr_clear) {
-			pr_err("block_device does not support pr_pclear.\n");
+		if (!ops->pr_release) {
+			pr_err("block_device does not support pr_release.\n");
 			return TCM_UNSUPPORTED_SCSI_OPCODE;
 		}
 
-- 
2.53.0



