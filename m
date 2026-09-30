Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0706509F06;
	Wed, 30 Sep 2026 18:06:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790791608; cv=none; b=EB/nTvwkhVts7ZbhrVUSFg5Bl+5XsBTEmkAD+Ro/ENCPwIQFKLN2RCgyxaZsW6XOx7nPP31ZlL5xXmVDqEtTT74VqGn/MzFswaK1WdYUkBlPwB6pFrvd/gEpGRIkznquPTQxShsJw+dZrYSJnLHJ340Xr97BP+P3yjNkkEtsbTw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790791608; c=relaxed/simple;
	bh=v2Tiw3yjpaPrNu5INcCk1MNz97QBZWFz6NkxxnzvwXk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xi5adBAUUSOdKNtrpk1WimppNTuwkvsgZxesVAOczs0sR/8PtXSJI3GO4hRgWHMyQb346C2AKd4KcKS8df3lxVr4EwXv+yJEqLAyb81o5B6GXvnJ5hIy8Y31e7ov8r8i+W/dO473t1ekvnYwDRFr+VCJzj4tft+wpCYqbvoiewE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WwYDaWI9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WwYDaWI9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 184571F000FF;
	Wed, 30 Sep 2026 18:06:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790791607;
	bh=nBgGAZvtjjQNKvM99gX+GsSfATq8IG37TmAk+1KMbVY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WwYDaWI9c5YJDZ/MxPqxSaxyQHButcEMZTInvc0NzAQsh39GRNIiV6MAHcl6zdnCY
	 yLJ619G/urKMir/Wu7SSBOIyAGXfSItlxr/GN06ZtHLIIlR8BftFcGMxiJfoxv93xS
	 GkXYcZgQbhVuc7UltSiPdW57C52PQW3Wq492u67A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Bogdanov <d.bogdanov@yadro.com>,
	Mike Christie <michael.christie@oracle.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 360/752] scsi: target: iscsi: Handle abort for WRITE_PENDING cmds
Date: Wed, 30 Sep 2026 17:23:50 +0200
Message-ID: <20260930152406.072104756@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index c7bd7759a5acd..30b21e65779de 100644
--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -26,6 +26,7 @@
 #include <target/target_core_base.h>
 #include <target/target_core_fabric.h>
 
+#include <target/target_core_backend.h>
 #include <target/iscsi/iscsi_target_core.h>
 #include "iscsi_target_parameters.h"
 #include "iscsi_target_seq_pdu_list.h"
@@ -4104,6 +4105,16 @@ static void iscsit_release_commands_from_conn(struct iscsi_conn *conn)
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



