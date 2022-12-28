Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 481531C08
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 16:55:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB4B5C433D2;
	Wed, 28 Dec 2022 16:55:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672246523;
	bh=meXrmIHc4uB22MVvnpTkZ0t6/lXPGSax7WRu1NPzbQo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1+BztY/A8cGPsYiB4eq0LtUrxM9RQHTNpZZQ55lsov3LuWGvx6aOiuTwWboLqnxzq
	 e6kCoaPG0cEGw/z3j3TNgnb6izbSSdBnUxaUtYmQ1XkNzBt5XPxdRT7d2YAKKphe09
	 qmIZstzDwPSThoMb5EpSbGsB0G/Wt3yJ+BUeIVPA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maurizio Lombardi <mlombard@redhat.com>,
	Mike Christie <michael.christie@oracle.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1061/1146] scsi: target: iscsi: Fix a race condition between login_work and the login thread
Date: Wed, 28 Dec 2022 15:43:20 +0100
Message-Id: <20221228144359.099188882@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Maurizio Lombardi <mlombard@redhat.com>

[ Upstream commit fec1b2fa62c162d03f5dcd7b03e3c89d3116d49f ]

In case a malicious initiator sends some random data immediately after a
login PDU; the iscsi_target_sk_data_ready() callback will schedule the
login_work and, at the same time, the negotiation may end without clearing
the LOGIN_FLAGS_INITIAL_PDU flag (because no additional PDU exchanges are
required to complete the login).

The login has been completed but the login_work function will find the
LOGIN_FLAGS_INITIAL_PDU flag set and will never stop from rescheduling
itself; at this point, if the initiator drops the connection, the
iscsit_conn structure will be freed, login_work will dereference a released
socket structure and the kernel crashes.

BUG: kernel NULL pointer dereference, address: 0000000000000230
PF: supervisor write access in kernel mode
PF: error_code(0x0002) - not-present page
Workqueue: events iscsi_target_do_login_rx [iscsi_target_mod]
RIP: 0010:_raw_read_lock_bh+0x15/0x30
Call trace:
 iscsi_target_do_login_rx+0x75/0x3f0 [iscsi_target_mod]
 process_one_work+0x1e8/0x3c0

Fix this bug by forcing login_work to stop after the login has been
completed and the socket callbacks have been restored.

Add a comment to clearify the return values of iscsi_target_do_login()

Signed-off-by: Maurizio Lombardi <mlombard@redhat.com>
Link: https://lore.kernel.org/r/20221115125638.102517-1-mlombard@redhat.com
Reviewed-by: Mike Christie <michael.christie@oracle.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/target/iscsi/iscsi_target_nego.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target_nego.c b/drivers/target/iscsi/iscsi_target_nego.c
index f2919319ad38..ff49c8f3fe24 100644
--- a/drivers/target/iscsi/iscsi_target_nego.c
+++ b/drivers/target/iscsi/iscsi_target_nego.c
@@ -1018,6 +1018,13 @@ static int iscsi_target_handle_csg_one(struct iscsit_conn *conn, struct iscsi_lo
 	return 0;
 }
 
+/*
+ * RETURN VALUE:
+ *
+ *  1 = Login successful
+ * -1 = Login failed
+ *  0 = More PDU exchanges required
+ */
 static int iscsi_target_do_login(struct iscsit_conn *conn, struct iscsi_login *login)
 {
 	int pdu_count = 0;
@@ -1363,12 +1370,13 @@ int iscsi_target_start_negotiation(
 		ret = -1;
 
 	if (ret < 0) {
-		cancel_delayed_work_sync(&conn->login_work);
 		iscsi_target_restore_sock_callbacks(conn);
 		iscsi_remove_failed_auth_entry(conn);
 	}
-	if (ret != 0)
+	if (ret != 0) {
+		cancel_delayed_work_sync(&conn->login_work);
 		iscsi_target_nego_release(conn);
+	}
 
 	return ret;
 }
-- 
2.35.1



