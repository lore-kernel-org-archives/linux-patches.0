Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4CB7305665;
	Fri,  7 Aug 2026 14:46:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786114010; cv=none; b=uVRTy8xvFS4A+8TsR4gUFpmwTf+d+VVfdFgc47LGQ3SnsSSoku6RLQCjuQsWuKAd9oz4OUJ6JHIW1+iNItdsl6GmirmKElCYu1U0Lb5Hv47PrmiyOcfbwmezz0Uu2e2Qxb1QtGg8IOvlmDF61JHSjkC7dBH7XICQaz9m6TUUFiQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786114010; c=relaxed/simple;
	bh=ZKz5bi5wDVbbhwI0Uc9GhyHmy3/EGTf0CG6s6QO/emU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P3FQCFEScaVK8LVCW1XmHFnkurawt8oTIcZatfb0BE9M4zy8d7VYjWgo1QjK2ETRfdwKwvOPXM+Q74vrYvtlPeXiXBwit7nMWQhj018d1AuAbm3Xek/pQKvsTeVjxSvkTFxggEYDITfcuwkrTdiS0o+05oB1c7inSaM1dwuNX6s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FVglmMH4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FVglmMH4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6C261F000E9;
	Fri,  7 Aug 2026 14:46:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786114008;
	bh=UzFy95JY2XIOPoSXF2t9PkDwb66zbAgGgdRbxBTjB1s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FVglmMH4wRvTGGKzbMsQTWioK2gi4ujQU5UZOJUcUvA5FyxVpmu9b5bOHfvF8CLOT
	 Da9QIYf2nAY5ff4t/+7W0S2NvkDVR+ml34T7FKF3oFZf+LRm0bdANgE8NPp8mefsMo
	 q+qaYNxTgbVuhUCvo4l++RYNaB5D3Y1joml+q4ds=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leon Romanovsky <leonro@nvidia.com>,
	Mike Christie <michael.christie@oracle.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 111/337] scsi: target: Clear cmd_cnt when initial counter enrollment fails
Date: Fri,  7 Aug 2026 16:35:14 +0200
Message-ID: <20260807143420.939618841@linuxfoundation.org>
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
index cf9834f958c9c..3dc49f6c7832e 100644
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



