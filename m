Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 379528BF4
	for <patches@lists.linux.dev>; Mon, 15 May 2023 16:33:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9046AC433EF;
	Mon, 15 May 2023 16:33:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684168388;
	bh=U0MFm+//bs8H8UtF/UNLuHVEYwO6v/YHt4yfLLZsFNc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jSfQFepscGTwbVfdgZHaFCvhMRytcECtUf3v5mKqlNTmOSfbrh/4w+/jAl25JbQ4P
	 VKjO8FYeXV9Z/Pk5tD3DfKjt+EfgEc7yJi9+CpGpNUkz4JILrIZNIKP9iOK6rUtnQ2
	 i1rn0pepEo9FOoGitv5/Tl0V6jnx5uPtD2mPLTJU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mike Christie <michael.christie@oracle.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 034/116] scsi: target: iscsit: Fix TAS handling during conn cleanup
Date: Mon, 15 May 2023 18:25:31 +0200
Message-Id: <20230515161659.404583375@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230515161658.228491273@linuxfoundation.org>
References: <20230515161658.228491273@linuxfoundation.org>
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
index d9fcef82ddf59..d801f5b388b8a 100644
--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -4088,9 +4088,12 @@ static void iscsit_release_commands_from_conn(struct iscsi_conn *conn)
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
@@ -4098,11 +4101,10 @@ static void iscsit_release_commands_from_conn(struct iscsi_conn *conn)
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



