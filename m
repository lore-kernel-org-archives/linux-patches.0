Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5CEC28E0;
	Fri,  7 Aug 2026 15:21:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786116111; cv=none; b=XP/bSJsBIxrMDeR/UZkGyg3qkWTQyRwvKbXStxUSqnKY3GDixgbQOYZEPiCXJi5jVM0c/L9WoD5cv67J8FF5YYsD7/BmhFBdFZ60YNB6yoK73ZA8iNaGlGbNnkWbaEBHyRkfpx9nmdz80zBgN0XPVL532ePRs/nEP1vPGA9V82Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786116111; c=relaxed/simple;
	bh=CAxO7qMcuFCx0XIj2oehmzjxg+4po7n8BVRhCfXa3Wg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uy5r3n2ovne2VFaN6C/k8HwfePtlqxWGLTUj8TdpvM2yuwXAYgH6OMaaoizcuNUzQ1fLdjlL2NBZVD54oPUS5M17w2ROiKlRjnktrgi92znbknZ/oK4nne13AwXvEpEfBH5FUF55Qu+9UQnUr2AO1kj1pFsZLkP6E1Xm77nVZXY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lO29ix5h; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lO29ix5h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0471F1F00A3A;
	Fri,  7 Aug 2026 15:21:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786116110;
	bh=NbqGlSMRO5MOXo8XOJXm7zITBK5cIlt4WhEGP399Y54=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lO29ix5htlxFeNXTddk8H3WpYPKZXt6Byxi0+z0qmtSModvdcutzbYXdIp6GahlaE
	 NEhodlqUD1HvL4zAP7lMntHZBEA/WFARN1uCDKqhUmJ656zHf6TGGagP1C3ssaxxg4
	 zemUMOkZFchqeQoFxz2kNI5IoBLAeCZ63o+miSbk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	TanZheng <tanzheng@kylinos.cn>,
	Mike Christie <michael.christie@oracle.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 072/261] scsi: target: iblock: Fix wrong PR ops NULL check for PREEMPT/RELEASE
Date: Fri,  7 Aug 2026 16:37:09 +0200
Message-ID: <20260807143416.939131532@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143415.358597922@linuxfoundation.org>
References: <20260807143415.358597922@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index a6a06a5f74834..4d025163569ac 100644
--- a/drivers/target/target_core_iblock.c
+++ b/drivers/target/target_core_iblock.c
@@ -885,7 +885,7 @@ static sense_reason_t iblock_execute_pr_out(struct se_cmd *cmd, u8 sa, u64 key,
 		break;
 	case PRO_PREEMPT:
 	case PRO_PREEMPT_AND_ABORT:
-		if (!ops->pr_clear) {
+		if (!ops->pr_preempt) {
 			pr_err("block_device does not support pr_preempt.\n");
 			return TCM_UNSUPPORTED_SCSI_OPCODE;
 		}
@@ -895,8 +895,8 @@ static sense_reason_t iblock_execute_pr_out(struct se_cmd *cmd, u8 sa, u64 key,
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



