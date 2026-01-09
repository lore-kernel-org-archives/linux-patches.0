Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E37DC336EDA;
	Fri,  9 Jan 2026 12:37:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767962265; cv=none; b=ro+8itSEm75J5LQz/9c40s7MC+ANe0BRcTA6pDXa/X8esEB1ScH9g0QUhG/QsrDv7GsOdR5OCMQgCXB7zX+MDovl955JqyVBpSSzpKWrfYrKFtnJDeQVJwKHWu8/5Mz1rE/+rfuGR7aomYJjGZZD42cOcRCry/Hr9OVIFhy8T6Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767962265; c=relaxed/simple;
	bh=nyVg/81JEWLhc5UrfDldTk1nRRkyMPhbSS6Kbp3f1ic=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QwvF9idItCezS+VWS3JBdju1SzES4gRF2ap5gv81BSLi5ElHsP9/CcqobuZN0z2O2zmif5kwaPIL4Y9CFt6ZI5oEh26VqBCd6Z+dvdKqS94Nxu+PiQyb303t6kIMTTYxl307HsSu+TpWpB+3uskxwyorx7fEMNJ+l0F56yoafOk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dDWI3M7U; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dDWI3M7U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 741C0C4CEF1;
	Fri,  9 Jan 2026 12:37:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767962264;
	bh=nyVg/81JEWLhc5UrfDldTk1nRRkyMPhbSS6Kbp3f1ic=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dDWI3M7URkoqktatLetRP3qdyBcnkO749teO7LAUodMDX67zWHfQV7qNn6RD44GtL
	 VOXS5eKVOvC835ekPD8O+zmYeZlUL9vbvwzico9ok3WSL5pdc5we7AoZ48F2zdnaql
	 KTAJv6jqRH/tlaRpmS19LHcsDF92UesFfGwU+SzI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tony Battersby <tonyb@cybernetics.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 304/634] scsi: qla2xxx: Use reinit_completion on mbx_intr_comp
Date: Fri,  9 Jan 2026 12:39:42 +0100
Message-ID: <20260109112128.973147431@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112117.407257400@linuxfoundation.org>
References: <20260109112117.407257400@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tony Battersby <tonyb@cybernetics.com>

[ Upstream commit 957aa5974989fba4ae4f807ebcb27f12796edd4d ]

If a mailbox command completes immediately after
wait_for_completion_timeout() times out, ha->mbx_intr_comp could be left
in an inconsistent state, causing the next mailbox command not to wait
for the hardware.  Fix by reinitializing the completion before use.

Signed-off-by: Tony Battersby <tonyb@cybernetics.com>
Link: https://patch.msgid.link/11b6485e-0bfd-4784-8f99-c06a196dad94@cybernetics.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/qla2xxx/qla_mbx.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index 77b23d9dcb3c..33a499dea7ad 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -253,6 +253,7 @@ qla2x00_mailbox_command(scsi_qla_host_t *vha, mbx_cmd_t *mcp)
 	/* Issue set host interrupt command to send cmd out. */
 	ha->flags.mbox_int = 0;
 	clear_bit(MBX_INTERRUPT, &ha->mbx_cmd_flags);
+	reinit_completion(&ha->mbx_intr_comp);
 
 	/* Unlock mbx registers and wait for interrupt */
 	ql_dbg(ql_dbg_mbx, vha, 0x100f,
@@ -279,6 +280,7 @@ qla2x00_mailbox_command(scsi_qla_host_t *vha, mbx_cmd_t *mcp)
 			    "cmd=%x Timeout.\n", command);
 			spin_lock_irqsave(&ha->hardware_lock, flags);
 			clear_bit(MBX_INTR_WAIT, &ha->mbx_cmd_flags);
+			reinit_completion(&ha->mbx_intr_comp);
 			spin_unlock_irqrestore(&ha->hardware_lock, flags);
 
 			if (chip_reset != ha->chip_reset) {
-- 
2.51.0



