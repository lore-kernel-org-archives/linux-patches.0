Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DE3F171A9
	for <patches@lists.linux.dev>; Mon, 22 May 2023 19:26:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F733C433D2;
	Mon, 22 May 2023 19:26:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684783608;
	bh=7WQMsDnkLJaAHW6RZwpPou3kFutnRgwSnTU7HM1QZHY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HPbg8buGZsbtFPiT8/77yI3rVaMZwV0kpE+g6RGIlljzJ/0dSJ+NHdco795+kpXk9
	 ybG1ZRMbI7sypixQY0WdVe/uiZ63jHLqRtBLS9D+hx6Lo5E4vd8rFOS3H1rd2iHOZY
	 UhLDTHmyUkyf/dD3kJcoVktm1s6RFXD9dBWAynOI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Forza <forza@tnonline.net>,
	Dmitry Bogdanov <d.bogdanov@yadro.com>,
	Mike Christie <michael.christie@oracle.com>,
	Maurizio Lombardi <mlombard@redhat.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 084/292] scsi: target: iscsit: Free cmds before session free
Date: Mon, 22 May 2023 20:07:21 +0100
Message-Id: <20230522190408.073775591@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230522190405.880733338@linuxfoundation.org>
References: <20230522190405.880733338@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Dmitry Bogdanov <d.bogdanov@yadro.com>

[ Upstream commit d8990b5a4d065f38f35d69bcd627ec5a7f8330ca ]

Commands from recovery entries are freed after session has been closed.
That leads to use-after-free at command free or NPE with such call trace:

Time2Retain timer expired for SID: 1, cleaning up iSCSI session.
BUG: kernel NULL pointer dereference, address: 0000000000000140
RIP: 0010:sbitmap_queue_clear+0x3a/0xa0
Call Trace:
 target_release_cmd_kref+0xd1/0x1f0 [target_core_mod]
 transport_generic_free_cmd+0xd1/0x180 [target_core_mod]
 iscsit_free_cmd+0x53/0xd0 [iscsi_target_mod]
 iscsit_free_connection_recovery_entries+0x29d/0x320 [iscsi_target_mod]
 iscsit_close_session+0x13a/0x140 [iscsi_target_mod]
 iscsit_check_post_dataout+0x440/0x440 [iscsi_target_mod]
 call_timer_fn+0x24/0x140

Move cleanup of recovery enrties to before session freeing.

Reported-by: Forza <forza@tnonline.net>
Signed-off-by: Dmitry Bogdanov <d.bogdanov@yadro.com>
Signed-off-by: Mike Christie <michael.christie@oracle.com>
Link: https://lore.kernel.org/r/20230319015620.96006-7-michael.christie@oracle.com
Reviewed-by: Maurizio Lombardi <mlombard@redhat.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/target/iscsi/iscsi_target.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
index 3f7a9f7f5f4e3..07e196b44b91d 100644
--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -4531,6 +4531,9 @@ int iscsit_close_session(struct iscsit_session *sess, bool can_sleep)
 	iscsit_stop_time2retain_timer(sess);
 	spin_unlock_bh(&se_tpg->session_lock);
 
+	if (sess->sess_ops->ErrorRecoveryLevel == 2)
+		iscsit_free_connection_recovery_entries(sess);
+
 	/*
 	 * transport_deregister_session_configfs() will clear the
 	 * struct se_node_acl->nacl_sess pointer now as a iscsi_np process context
@@ -4554,9 +4557,6 @@ int iscsit_close_session(struct iscsit_session *sess, bool can_sleep)
 
 	transport_deregister_session(sess->se_sess);
 
-	if (sess->sess_ops->ErrorRecoveryLevel == 2)
-		iscsit_free_connection_recovery_entries(sess);
-
 	iscsit_free_all_ooo_cmdsns(sess);
 
 	spin_lock_bh(&se_tpg->session_lock);
-- 
2.39.2



