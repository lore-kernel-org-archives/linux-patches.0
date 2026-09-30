Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78D6F3559C9;
	Wed, 30 Sep 2026 15:45:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790783123; cv=none; b=GMfT8sOEf3PQxWyXU0PIthB/q7LV23aG1ltoqFQh120z1ZVOgya13Hi3E73xbvIcGlUvmit9Ug8Z4cY0q66s01ovGwdhF5Uh4IfUbEJ3xnQT+CuxP2X6ucQ0U0u83jTha/bX4CCyuVoirIXx/dN15MCOqdCGKKpZjivly8eVNa4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790783123; c=relaxed/simple;
	bh=a52US3lj3jOHTGFEjX2bdThpnf9NXH9DxhEvE0UoiM4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RV9WulDcl8J4RRmBqmamj+cc2yka4JmpjFmumnLH9EvN9oSIYfybcLloX3ub/thYCfdBSCkprKqhvRoKEvizslUnureyA0gdioTCJlXjLqO+ZX0Penr5c6tExeARLW+9Lkk5WbjSEa+1D39YDG45mAQekXs1a6+CHG4Nf7FuN2w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uNaJITxJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uNaJITxJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED5031F00893;
	Wed, 30 Sep 2026 15:45:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790783117;
	bh=aXXqv8rN5Y6KzlEvUPPpmcvJyIteJF6AVPFKtdmp+U0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uNaJITxJZGi6f721KGyGYND3mcLhlyu1ItV4jCQcIvAQI4wSZp7vMw+ZUJqRDtYNL
	 P2AX+u5E3YuFvwXxADe62qQHL0zQz5vT+TYPUcqqDkkpxxWMCxXWBE0ZEe/Xcii2GM
	 xW296MeoPjLeuEkO39lZFHqAWWQu0G/orGQkuvNg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maurizio Lombardi <mlombard@redhat.com>,
	Laurence Oberman <loberman@redhat.com>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 285/595] scsi: target: iscsi: Fix hang for aborted WRITE_PENDING commands
Date: Wed, 30 Sep 2026 17:22:58 +0200
Message-ID: <20260930152353.829594519@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152347.700140858@linuxfoundation.org>
References: <20260930152347.700140858@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index ddeaf0f69639b..e2ba02c27b5e5 100644
--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -1528,8 +1528,10 @@ __iscsit_check_dataout_hdr(struct iscsi_conn *conn, void *buf,
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



