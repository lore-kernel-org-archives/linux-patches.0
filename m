Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9A75381AE4;
	Fri,  7 Aug 2026 15:03:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786115043; cv=none; b=tDz2iMVzbKvl7quL35sxP0zzlOxxydjEHm9UiiI2fdljjUy3y93mMVZg2NhBBux5g4/R61Tu0r9EVwD7yKjolaccUp6yNkoInk6QCmXI/AzrHn9m48S1M8OBEU8BxkNa8A6I26Tb7CwbaK3Xf6BCB+cvLLvA5XxTvyyrSkONyAQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786115043; c=relaxed/simple;
	bh=uM3O1z7vn9flzdsfEKe4esY1O9tL6K+LIRQkvu9Ia0s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H+I9XKXx843wT2s2ItrBhqwN0dL0n3dLSUGn5GpNEZ1zDp6mCMUlZ59ZzwKQvri9IulDfeoWf9kQr7eTehMhQRLDp/Tc5GFwhpGcQX3fTNpK8Q8WwyF8tb8OFEpVxzx09i4iKyw+PkcWtTL7xP1VfaoJuKPxTpUj2oiDU9GdtrE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sNvRD15k; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sNvRD15k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3179D1F000E9;
	Fri,  7 Aug 2026 15:03:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786115036;
	bh=t2IfnWqXxWs0Fxj1sNyMikMPiyO1ARWPSDu+KO3iXuc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sNvRD15kYCncxcFxUowFQAJBGk6Sqx2BsffuS68MSCASojc/yvGpF25ugUUOyx4Bt
	 fdnQ75mcBpuC/3Gv1bOKz33LZFy57+cUTUZj/8ekB5CDZcct99txFGmVONtHQxDn8+
	 rqEb44VYfJ4m59dRQ4Q9H2PUW+MPBxuJH1PXD6j8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leon Romanovsky <leonro@nvidia.com>,
	Mike Christie <michael.christie@oracle.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 133/396] scsi: target: Clear cmd_cnt when initial counter enrollment fails
Date: Fri,  7 Aug 2026 16:34:53 +0200
Message-ID: <20260807143427.173391631@linuxfoundation.org>
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

From: Leon Romanovsky <leonro@nvidia.com>

[ Upstream commit a8ddfd2425bbbafadae8700d63ed8a61a4109878 ]

When target_get_sess_cmd() fails during session shutdown because
percpu_ref_tryget_live() returns false, the command keeps the
se_cmd->cmd_cnt pointer that __target_init_cmd() assigned earlier
without owning a reference. Final release through
target_release_cmd_kref() then issues an unmatched percpu_ref_put().

Commit 8e288be8606a ("scsi: target: Pass in cmd counter to use during
cmd setup") moved the cmd_cnt assignment ahead of the reference
acquisition.  Clear se_cmd->cmd_cnt whenever the initial
target_get_sess_cmd() fails in target_init_cmd() and
target_submit_tmr(), so release performs exactly one matching put per
acquired reference.

Fixes: 8e288be8606a ("scsi: target: Pass in cmd counter to use during cmd setup")
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Reviewed-by: Mike Christie <michael.christie@oracle.com>
Link: https://patch.msgid.link/20260722-reference-count-underflow-in-target-v1-1-63ab664f12fd@nvidia.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/target/target_core_transport.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 88544c911949c..5ad2dcf730cd2 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -1691,6 +1691,7 @@ int target_init_cmd(struct se_cmd *se_cmd, struct se_session *se_sess,
 		    u32 data_length, int task_attr, int data_dir, int flags)
 {
 	struct se_portal_group *se_tpg;
+	int ret;
 
 	se_tpg = se_sess->se_tpg;
 	BUG_ON(!se_tpg);
@@ -1720,7 +1721,11 @@ int target_init_cmd(struct se_cmd *se_cmd, struct se_session *se_sess,
 	 * necessary for fabrics using TARGET_SCF_ACK_KREF that expect a second
 	 * kref_put() to happen during fabric packet acknowledgement.
 	 */
-	return target_get_sess_cmd(se_cmd, flags & TARGET_SCF_ACK_KREF);
+	ret = target_get_sess_cmd(se_cmd, flags & TARGET_SCF_ACK_KREF);
+	if (ret)
+		se_cmd->cmd_cnt = NULL;
+
+	return ret;
 }
 EXPORT_SYMBOL_GPL(target_init_cmd);
 
@@ -1996,8 +2001,10 @@ int target_submit_tmr(struct se_cmd *se_cmd, struct se_session *se_sess,
 	 * allocation failure.
 	 */
 	ret = core_tmr_alloc_req(se_cmd, fabric_tmr_ptr, tm_type, gfp);
-	if (ret < 0)
+	if (ret < 0) {
+		se_cmd->cmd_cnt = NULL;
 		return -ENOMEM;
+	}
 
 	if (tm_type == TMR_ABORT_TASK)
 		se_cmd->se_tmr_req->ref_task_tag = tag;
@@ -2005,6 +2012,7 @@ int target_submit_tmr(struct se_cmd *se_cmd, struct se_session *se_sess,
 	/* See target_submit_cmd for commentary */
 	ret = target_get_sess_cmd(se_cmd, flags & TARGET_SCF_ACK_KREF);
 	if (ret) {
+		se_cmd->cmd_cnt = NULL;
 		core_tmr_release_req(se_cmd->se_tmr_req);
 		return ret;
 	}
-- 
2.53.0



