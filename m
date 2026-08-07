Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E2F74766BC;
	Fri,  7 Aug 2026 15:36:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786116979; cv=none; b=nv+df6QseRqAHJGvDLS/bJSVuW2Zy1C07EHnx9d5IIV9QFEXdz3BAYu/iSyqekIdO3JfYPXg6cnJAREB7EVFdXoPAfuhFnPURfWPdOoRANwD7rLKL0zB7zCrIEvARQ58f/zyCyifrcr8xb0gbQNmtwpBdrA1bqRnihmO7nwe/Ww=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786116979; c=relaxed/simple;
	bh=V/k0C+/OaG0GdQ1RDT3N8mYhe04yvPDSoWLom+7IXW4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ILVfnlYLg5RJInJNPfLfaS5NZqm9xa5eYmEpdyUY0FWHAsZPdC1BGyQ1Gz/8gMFuqRGazWwOhZrUj3WrQhfky57zn3jLryCBn5AQ6s73brd54kyFzYlnI90vqs6GTvjHulsXUTPXgS524yVW0lWOP7zUnZHLqb++ccssruYt1c0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dyUptvjt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dyUptvjt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C4321F000E9;
	Fri,  7 Aug 2026 15:36:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786116977;
	bh=nsSThzKLpI04GuwHG2pHERLgQTjRE69Z2+9z7AqhuSI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dyUptvjtX4dhEO5Anqm4bMxUR48UtLe0NewrcJ6IEXkLaEt7AW9gnBkKm+pyvfBB2
	 upCbYm9eYLbINIEY/b8wffRGiZtQgQcI0UOMjUM/3y3BQsVfMCtimCwYxHnTav3ROp
	 XCNzIhT+GNb9yQ1mTFffnnPzdsN73qbdXtPbDWAU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leon Romanovsky <leonro@nvidia.com>,
	Mike Christie <michael.christie@oracle.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 155/438] scsi: target: Clear cmd_cnt when initial counter enrollment fails
Date: Fri,  7 Aug 2026 16:35:51 +0200
Message-ID: <20260807143431.341260729@linuxfoundation.org>
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
index fad03a15c969e..dcfe945949167 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -1734,6 +1734,7 @@ int target_init_cmd(struct se_cmd *se_cmd, struct se_session *se_sess,
 		    u32 data_length, int task_attr, int data_dir, int flags)
 {
 	struct se_portal_group *se_tpg;
+	int ret;
 
 	se_tpg = se_sess->se_tpg;
 	BUG_ON(!se_tpg);
@@ -1763,7 +1764,11 @@ int target_init_cmd(struct se_cmd *se_cmd, struct se_session *se_sess,
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
 
@@ -2039,8 +2044,10 @@ int target_submit_tmr(struct se_cmd *se_cmd, struct se_session *se_sess,
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
@@ -2048,6 +2055,7 @@ int target_submit_tmr(struct se_cmd *se_cmd, struct se_session *se_sess,
 	/* See target_submit_cmd for commentary */
 	ret = target_get_sess_cmd(se_cmd, flags & TARGET_SCF_ACK_KREF);
 	if (ret) {
+		se_cmd->cmd_cnt = NULL;
 		core_tmr_release_req(se_cmd->se_tmr_req);
 		return ret;
 	}
-- 
2.53.0



