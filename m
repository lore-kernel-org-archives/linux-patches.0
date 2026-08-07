Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E182D471268;
	Fri,  7 Aug 2026 15:36:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786116964; cv=none; b=F7AjH9mQTTs4DmdEQKzxa24CDRAIjGIHaiitqro/fiNVv/BMlFCAw1ekuN7m0vpr9dijlC60wf7beR4D6elmsk50BSdQiksAtSk01vi8BkuA8hGwk+i9HLl+AmZsotbvvr7D4BXB7Jf0nOKrk8XOB9iKnr9n9Ogx9xYiDYnVIeo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786116964; c=relaxed/simple;
	bh=ovGTTfU0IkAZk57J4mW41t2doJkKMRSIyzBLHzEGQzI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rNSJ2zUCQ5pzVVRT2dTBbmcSNWnNPvELcUbWWqwc8B9PdUix2Bkh+1lKI30oYlUXQFIrra5fUp7nnrNT+2atAmSLtUvZkKB1OSA0MFYsMkm34rMelaoHY2o0Tp73Fq3LdWlmr0J9VhnOlt46ZJGCLlEcaYCU2b+NufT/hDYF180=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AdcdjNpm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AdcdjNpm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49E1B1F000E9;
	Fri,  7 Aug 2026 15:36:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786116962;
	bh=i2KK1i53tACO/UslS1WQiIG8orkS3px3aafhHu77laA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AdcdjNpmEFKfd6vVGR7ABkZ4mQ6yyDDeid69IQ0JlBod04hBz+voiH3ZDLJQICDEB
	 X4O1cteUU647aOVq9z5uo0ZIE5arem5yc9dReoKZpcBQHl0LwODRicrxaC7kGed/hz
	 oBL6p000PYL94OWtHspUh7PyvFkRTjAUq4H7QRtQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	TanZheng <tanzheng@kylinos.cn>,
	Mike Christie <michael.christie@oracle.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 151/438] scsi: target: iblock: Fix wrong PR ops NULL check for PREEMPT/RELEASE
Date: Fri,  7 Aug 2026 16:35:47 +0200
Message-ID: <20260807143431.228162204@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143428.008222056@linuxfoundation.org>
References: <20260807143428.008222056@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
index 1087d1d17c36d..ea65d39fef884 100644
--- a/drivers/target/target_core_iblock.c
+++ b/drivers/target/target_core_iblock.c
@@ -906,7 +906,7 @@ static sense_reason_t iblock_execute_pr_out(struct se_cmd *cmd, u8 sa, u64 key,
 		break;
 	case PRO_PREEMPT:
 	case PRO_PREEMPT_AND_ABORT:
-		if (!ops->pr_clear) {
+		if (!ops->pr_preempt) {
 			pr_err("block_device does not support pr_preempt.\n");
 			return TCM_UNSUPPORTED_SCSI_OPCODE;
 		}
@@ -916,8 +916,8 @@ static sense_reason_t iblock_execute_pr_out(struct se_cmd *cmd, u8 sa, u64 key,
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



