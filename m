Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17F7633E355;
	Fri,  7 Aug 2026 15:21:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786116120; cv=none; b=dOi7+nUSSoOuxFllZ+Cay2ZYluXhShyUWXgADs/Ew2yLgulIMckvwwSUWQwVOExeHhrC2Y/OrvmI6IzKBVEt1nEaQWQVclGMMbpQ+v/n0gQoqPFFIsV1FRY64UyEM2cgqXacAt1vx+8VYMHFPmQbMB+Zi3sL8SQHzH4sZUAOBFY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786116120; c=relaxed/simple;
	bh=g4Ikw+pTMeLkiE5ZVJyKUa6ogikRTy48YMM3DJzEaJk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EQo0NnaxcMOSVMz/BnGA11mf/BlPzfuFoBWcKRwGz+mpPuNI9rb4jYkP40b3Ll3/OqrrKUDns33rV/wWfDpg86arJWKWrourGJLvHCVtrwD3WgrqJpJ9+LqZIa6zByScz8dG7MblT/QahkZatsXE/WPqMDdutOgRkPUdyXUlGXI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lhOZFLQr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lhOZFLQr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A8581F000E9;
	Fri,  7 Aug 2026 15:21:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786116119;
	bh=MXOqFAMW61SaJMkgD3gh5Pbx4kwIoHUYdSqvaSoJkLk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lhOZFLQrTBc/mnBKRNw31yNqth/DhkFRpHgfPQz6fEww+ZFuO3BUO8UlloBV9MnNL
	 5hnC+YxR4LS+BNPW16UHAnahh3voBT+K+4D4cDz6VmOXzXw0gC8AfwawZBapEhCXG/
	 xInc3D15ZUfuyZJRWgjW1C7ObQ7oIrmXENttzkhU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leon Romanovsky <leonro@nvidia.com>,
	Mike Christie <michael.christie@oracle.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 075/261] scsi: target: Clear cmd_cnt when initial counter enrollment fails
Date: Fri,  7 Aug 2026 16:37:12 +0200
Message-ID: <20260807143417.003839983@linuxfoundation.org>
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
index b9a144a59dff3..f4e3ba173dbe3 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -1670,6 +1670,7 @@ int target_init_cmd(struct se_cmd *se_cmd, struct se_session *se_sess,
 		    u32 data_length, int task_attr, int data_dir, int flags)
 {
 	struct se_portal_group *se_tpg;
+	int ret;
 
 	se_tpg = se_sess->se_tpg;
 	BUG_ON(!se_tpg);
@@ -1699,7 +1700,11 @@ int target_init_cmd(struct se_cmd *se_cmd, struct se_session *se_sess,
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
 
@@ -1994,8 +1999,10 @@ int target_submit_tmr(struct se_cmd *se_cmd, struct se_session *se_sess,
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
@@ -2003,6 +2010,7 @@ int target_submit_tmr(struct se_cmd *se_cmd, struct se_session *se_sess,
 	/* See target_submit_cmd for commentary */
 	ret = target_get_sess_cmd(se_cmd, flags & TARGET_SCF_ACK_KREF);
 	if (ret) {
+		se_cmd->cmd_cnt = NULL;
 		core_tmr_release_req(se_cmd->se_tmr_req);
 		return ret;
 	}
-- 
2.53.0



