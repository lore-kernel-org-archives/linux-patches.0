Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D78A534E75A;
	Wed, 30 Sep 2026 19:12:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790795536; cv=none; b=tmngVKOnRlEuzStkQkwEFK+584GIQkKY+CqIxJzzCilQS4h0pw234Dt0VEJmq7/LnCyCMTrbXZmRzMYdRTQaWmiWySNgK9o9r/aacl2b2KFaU4NEnPFdaaeoKxaNxftmv9Af9zxB6ipERqnsUCJqPkBYiBBI+Q9QlFI2skWmq7c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790795536; c=relaxed/simple;
	bh=CPbCCvVvkm8w8Rg8KDClXAam4ROhj75W5muC1Gfg8UY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R5XjNqgQt8ZXc69gE1paxQxddrWdueHHzdkDh89ZhXXbtnO/0y7fFB23mOfj2ls+ep9tLa9EtIFjSBFYkWLXFPBo+EL6+p03+L9+4I6QGKUy9mKPluPfhTaPgJVK1zkGcsSOTPB5ScCvzb9fe5XL669QDa8qYA5tAG2+VOPpPDE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ISMHzaPw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ISMHzaPw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 406401F000FF;
	Wed, 30 Sep 2026 19:12:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790795534;
	bh=Bwe+B94IfGxBJ96TsBKgvu3dZxWmF6dLd92WC/dokok=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ISMHzaPwB9gdLMivc7pmOT7VBnRlUE4f0ffvVhO85iKcub/EySAL7+6psAk0Z6al1
	 45KmW6ozrt6Hiim8sgR8rpHp7IZeIdpOKJbAHAJ9XQq+MceUE6oZxE3fKZjfsQE6Zw
	 0emhOQFl9ZAcvHBYvCRWi7Ai8iZJne8WDpH6KJBc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maurizio Lombardi <mlombard@redhat.com>,
	Laurence Oberman <loberman@redhat.com>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0594/1193] scsi: target: iscsi: Fix hang for aborted WRITE_PENDING commands
Date: Wed, 30 Sep 2026 17:21:18 +0200
Message-ID: <20260930152447.442032523@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

From: Maurizio Lombardi <mlombard@redhat.com>

[ Upstream commit d5869dae5080e976d4b03cc33eb7ceb527f242bf ]

When a LUN_RESET aborts a WRITE command that is in the
TRANSPORT_WRITE_PENDING state, the target core sets CMD_T_ABORTED and
waits for the frontend to finish processing.

If the initiator subsequently sends the remaining dataout PDUs,
__iscsit_check_dataout_hdr() catches the payload, stops the dataout
timer if the sequence is final and finally dumps the data.  However, the
iSCSI target doesn't trigger the completion process for these aborted
commands. Because of this, the abort path hangs indefinitely in
target_put_cmd_and_wait(), leading to a deadlocked target worker thread.

Fix this by explicitly calling target_complete_cmd() when the final
dataout PDU is received for an aborted WRITE command.
target_complete_cmd() detects the CMD_T_ABORTED flag and cleanly routes
the command into target_abort_work, allowing the abort completion to
successfully unblock.

Signed-off-by: Maurizio Lombardi <mlombard@redhat.com>
Reviewed-by: Laurence Oberman <loberman@redhat.com>
Link: https://patch.msgid.link/20260717143828.76291-2-mlombard@redhat.com
Signed-off-by: Martin K. Petersen (Oracle) <mkp@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/target/iscsi/iscsi_target.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
index 5cad086853503..6fd2dc866aa53 100644
--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -1567,8 +1567,10 @@ __iscsit_check_dataout_hdr(struct iscsit_conn *conn, void *buf,
 		 */
 		if (se_cmd->transport_state & CMD_T_ABORTED) {
 			if (hdr->flags & ISCSI_FLAG_CMD_FINAL &&
-			    --cmd->outstanding_r2ts < 1)
+			    --cmd->outstanding_r2ts < 1) {
 				iscsit_stop_dataout_timer(cmd);
+				target_complete_cmd(se_cmd, SAM_STAT_TASK_ABORTED);
+			}
 
 			return iscsit_dump_data_payload(conn, payload_length, 1);
 		}
-- 
2.53.0



