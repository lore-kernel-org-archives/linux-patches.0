Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B5D84FC8E0;
	Wed, 30 Sep 2026 15:45:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790783116; cv=none; b=Pj0qWUEybIKFs/QlBuhkzt3GhcDRCn3zNGWIlqvq1DydsRh77iiBI54yLB7COS0pdIAjSMs90VlA1h5Q8WHp3GmUdKhtWgNMO10wzhVI28wRyHcdKLcGrKwvTh7PNYSwQFI9HnIMy1V4T/rzc0dA+w3zcVFFUrnItM5odNa9bTc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790783116; c=relaxed/simple;
	bh=BdPMF3THI6RA+/HAhaIu1NHuRqzyGdoVcMjrncjzlNo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ptyeOywohdq/j6vZ2O+yPlv1shDi8AYgyFr6Flp2ICBGl7iP+JEBWsPiUbrPsT8I9U64rNOlDil5oxqlCypJ03C66Cx1bqKvr9ukip/BcBlWUoQYXFovvhDR4HjUowRZRvB8xojtRRIVwzWOBO937SWyMMxcfYaHUuMo7+0T6uM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fVSFwtET; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fVSFwtET"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D12C1F00898;
	Wed, 30 Sep 2026 15:45:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790783111;
	bh=Ys/8FFQjdu3ERRvHN0uZsPwKfk2M1Fg6ky6eygf9GmY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fVSFwtETZDl3id0dFrM3oiKzICXF1tIOaqFvau5nLvPCIX4O6Zss/G5Ff2onORD5p
	 2lf00jJcz9yuFtTagDWHwzetGgMjJGvACYgdxwWvi6Vk6dn09uSlUiTI0RXW/USetG
	 5HeZbrMI7RhaXKadKFlU9qKNuYfMhUJWicjGqia8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Bogdanov <d.bogdanov@yadro.com>,
	Mike Christie <michael.christie@oracle.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 284/595] scsi: target: iscsi: Handle abort for WRITE_PENDING cmds
Date: Wed, 30 Sep 2026 17:22:57 +0200
Message-ID: <20260930152353.808356280@linuxfoundation.org>
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

From: Dmitry Bogdanov <d.bogdanov@yadro.com>

[ Upstream commit ea87981a0ee8fb8ced1c87d004a541b60623ff97 ]

Sometimes an initiator does not send data for a WRITE command and tries to
abort it. The abort hangs waiting for frontend driver completion. iSCSI
driver waits for data and that timeout eventually initiates connection
reinstatment. The connection closing releases the commands in the
connection, but those aborted commands still did not handle the abort and
did not decrease a command ref counter. Because of that the connection
reinstatement hangs indefinitely and prevents re-login for that initiator.

Add handling in TCM of the abort for the WRITE_PENDING commands at
connection closing moment to make it possible to release them.

Signed-off-by: Dmitry Bogdanov <d.bogdanov@yadro.com>
[mnc: Rebase and expand comment]
Signed-off-by: Mike Christie <michael.christie@oracle.com>
Link: https://lore.kernel.org/r/20230319015620.96006-10-michael.christie@oracle.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/target/iscsi/iscsi_target.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
index 17835c878caeb..ddeaf0f69639b 100644
--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -26,6 +26,7 @@
 #include <target/target_core_base.h>
 #include <target/target_core_fabric.h>
 
+#include <target/target_core_backend.h>
 #include <target/iscsi/iscsi_target_core.h>
 #include "iscsi_target_parameters.h"
 #include "iscsi_target_seq_pdu_list.h"
@@ -4102,6 +4103,16 @@ static void iscsit_release_commands_from_conn(struct iscsi_conn *conn)
 		} else {
 			se_cmd->transport_state |= CMD_T_FABRIC_STOP;
 		}
+
+		if (cmd->se_cmd.t_state == TRANSPORT_WRITE_PENDING) {
+			/*
+			 * We never submitted the cmd to LIO core, so we have
+			 * to tell LIO to perform the completion process.
+			 */
+			spin_unlock_irq(&se_cmd->t_state_lock);
+			target_complete_cmd(&cmd->se_cmd, SAM_STAT_TASK_ABORTED);
+			continue;
+		}
 		spin_unlock_irq(&se_cmd->t_state_lock);
 	}
 	spin_unlock_bh(&conn->cmd_lock);
-- 
2.53.0



