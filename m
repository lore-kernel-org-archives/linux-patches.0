Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD9FB473C6D;
	Fri,  7 Aug 2026 15:03:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786115020; cv=none; b=gUe3ChufzOSqixKxbiPLgaXkSUWcrjNgmMcO60RJAIPEtJokIkFfCYLoGBLOlAO0s6JR5D5klfUVjDT2DXWgIc2GxdWDVQjLdnGeGCtj78bBd1W0DkdRJ0SlelXizPtAZEyajl/lfGCFVjekCBRRb3z/0wQ3q+ybGZDyhIbZEV8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786115020; c=relaxed/simple;
	bh=bTe85utvoXI67fvcBcUNo4sSs80ybWIAOCV/wauNiuA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uGQwOff/VdunAfNGEuxQ/+Hc38hhkCclkSGn3aZbL/xSHaLWsOQPtavvMCPAxJZsX1eJZ+xPsC9HxnEWk2EBHEXKfkDxXQy6sCw5apg9KR2SnIoDrvUktgmzLVx1uzi9KDxcvDMTQeLtRtny7uKpH9BYmNfi1qDYYBUvk0p5rFw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=crv2Jsnn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="crv2Jsnn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 138751F000E9;
	Fri,  7 Aug 2026 15:03:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786115019;
	bh=FuUpIUInvp+E+BA7ekK9joK2hbX083NUHKWkyyQ1k7E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=crv2JsnnEiTKYG0LxTNM+MB/a0TvV/LgshPfoPfzP5cELBmAaWwkSr4hwXG8wONyE
	 WECTB19duwbtDn7Tk9W842t3sGxkufM2OdBeI/16oc+aBzpzO7B1UDa4pZcFJmGQ2o
	 1tGsNMLEODKa0h6x9+wWhfJNyNqTR+fWV0UWsoCM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	TanZheng <tanzheng@kylinos.cn>,
	Mike Christie <michael.christie@oracle.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 128/396] scsi: target: iblock: Fix wrong PR ops NULL check for PREEMPT/RELEASE
Date: Fri,  7 Aug 2026 16:34:48 +0200
Message-ID: <20260807143427.069196662@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143424.272339768@linuxfoundation.org>
References: <20260807143424.272339768@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 66c292b7d74bc..4ec322f371bc2 100644
--- a/drivers/target/target_core_iblock.c
+++ b/drivers/target/target_core_iblock.c
@@ -902,7 +902,7 @@ static sense_reason_t iblock_execute_pr_out(struct se_cmd *cmd, u8 sa, u64 key,
 		break;
 	case PRO_PREEMPT:
 	case PRO_PREEMPT_AND_ABORT:
-		if (!ops->pr_clear) {
+		if (!ops->pr_preempt) {
 			pr_err("block_device does not support pr_preempt.\n");
 			return TCM_UNSUPPORTED_SCSI_OPCODE;
 		}
@@ -912,8 +912,8 @@ static sense_reason_t iblock_execute_pr_out(struct se_cmd *cmd, u8 sa, u64 key,
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



