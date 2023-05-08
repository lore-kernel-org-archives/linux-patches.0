Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A5C4168CF
	for <patches@lists.linux.dev>; Mon,  8 May 2023 11:11:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82120C433EF;
	Mon,  8 May 2023 11:11:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683544306;
	bh=NmQ9S07EWOcHjHpT33NuPI/wRgG+XzcY4Cfz1QHexdY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hLFkf91WO48zy+xTMI7dZ/D41IVWWq6HiiVcn58hqewdqMWFHYuSNuv5Ugyd7AA7q
	 C/G25M1R6fMzcvcfTiqjdgYZzwCR6ml5ZIx2pqryMY8o+Uqf9S/sPpm6nqjNmeH0fA
	 /RYtwSDXTbdEIrJiIRgrz6LmKhjUuPsQA/m5zpas=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mike Christie <michael.christie@oracle.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 367/694] scsi: target: iscsit: Fix TAS handling during conn cleanup
Date: Mon,  8 May 2023 11:43:22 +0200
Message-Id: <20230508094444.662356277@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094432.603705160@linuxfoundation.org>
References: <20230508094432.603705160@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Mike Christie <michael.christie@oracle.com>

[ Upstream commit cc79da306ebb2edb700c3816b90219223182ac3c ]

Fix a bug added in commit f36199355c64 ("scsi: target: iscsi: Fix cmd abort
fabric stop race").

If CMD_T_TAS is set on the se_cmd we must call iscsit_free_cmd() to do the
last put on the cmd and free it, because the connection is down and we will
not up sending the response and doing the put from the normal I/O
path.

Add a check for CMD_T_TAS in iscsit_release_commands_from_conn() so we now
detect this case and run iscsit_free_cmd().

Fixes: f36199355c64 ("scsi: target: iscsi: Fix cmd abort fabric stop race")
Signed-off-by: Mike Christie <michael.christie@oracle.com>
Link: https://lore.kernel.org/r/20230319015620.96006-9-michael.christie@oracle.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/target/iscsi/iscsi_target.c | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
index 83b0071412294..3f7a9f7f5f4e3 100644
--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -4220,9 +4220,12 @@ static void iscsit_release_commands_from_conn(struct iscsit_conn *conn)
 	list_for_each_entry_safe(cmd, cmd_tmp, &tmp_list, i_conn_node) {
 		struct se_cmd *se_cmd = &cmd->se_cmd;
 
-		if (se_cmd->se_tfo != NULL) {
-			spin_lock_irq(&se_cmd->t_state_lock);
-			if (se_cmd->transport_state & CMD_T_ABORTED) {
+		if (!se_cmd->se_tfo)
+			continue;
+
+		spin_lock_irq(&se_cmd->t_state_lock);
+		if (se_cmd->transport_state & CMD_T_ABORTED) {
+			if (!(se_cmd->transport_state & CMD_T_TAS))
 				/*
 				 * LIO's abort path owns the cleanup for this,
 				 * so put it back on the list and let
@@ -4230,11 +4233,10 @@ static void iscsit_release_commands_from_conn(struct iscsit_conn *conn)
 				 */
 				list_move_tail(&cmd->i_conn_node,
 					       &conn->conn_cmd_list);
-			} else {
-				se_cmd->transport_state |= CMD_T_FABRIC_STOP;
-			}
-			spin_unlock_irq(&se_cmd->t_state_lock);
+		} else {
+			se_cmd->transport_state |= CMD_T_FABRIC_STOP;
 		}
+		spin_unlock_irq(&se_cmd->t_state_lock);
 	}
 	spin_unlock_bh(&conn->cmd_lock);
 
-- 
2.39.2



