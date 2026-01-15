Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 738653C00AA;
	Thu, 15 Jan 2026 17:49:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768499388; cv=none; b=TgKPNihIX3UFrCXe4Cn+kYeIfIFXqeJY5OkJ6qw/hamQaxXHse6Yqej9Ds6NLo+ysPKz7mLdnZxDbuZ5NWpsuKmI506MXMogv+dqp+/waeLyYPANLn1XQTnKaIJBMu78tL5H5Fnye3plx6sDprM9WnX9MnpEYY/MHdo8YN7LuKg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768499388; c=relaxed/simple;
	bh=0ZBtzssjPq1dkW0lFk+sL2Ad0+saExS8wAy94+nOrhI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XLYLQ7aopsjbcLmq2Vx9/QpoDfgHUWMJVFNIOY44NH9gwtirlyWIJRCOaAEwV6fn/97n5wWieFqGJOJ+6tIDP32bf4RptGQPsS3HL3LnUD666/VO9woQJNBC6DIMfV9emZkM7W0lrssSKXLOjfx4SlKJYSbRYGJTGMZh3DmvoTQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kkZpjyWP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kkZpjyWP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1C47C16AAE;
	Thu, 15 Jan 2026 17:49:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768499388;
	bh=0ZBtzssjPq1dkW0lFk+sL2Ad0+saExS8wAy94+nOrhI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kkZpjyWPJdKckaLmyU84F/05w3MB9uRw4Sj0AEanccNRRjWKId9JwOaMkACGbaDbQ
	 nvGi76VtPxhutHgmNOt5jduxfCRb6HBBhKZFLQyjRAYKFdwrgw5JmO0ZuW1IxHOiiH
	 Mk9a2bOo1lN1m5X04qGx5zIIReOxS5ccgYzGfd8U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tony Battersby <tonyb@cybernetics.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 210/451] scsi: qla2xxx: Use reinit_completion on mbx_intr_comp
Date: Thu, 15 Jan 2026 17:46:51 +0100
Message-ID: <20260115164238.497629469@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164230.864985076@linuxfoundation.org>
References: <20260115164230.864985076@linuxfoundation.org>
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
index 8b7c71e779a7..aa6a68e235c9 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -249,6 +249,7 @@ qla2x00_mailbox_command(scsi_qla_host_t *vha, mbx_cmd_t *mcp)
 	/* Issue set host interrupt command to send cmd out. */
 	ha->flags.mbox_int = 0;
 	clear_bit(MBX_INTERRUPT, &ha->mbx_cmd_flags);
+	reinit_completion(&ha->mbx_intr_comp);
 
 	/* Unlock mbx registers and wait for interrupt */
 	ql_dbg(ql_dbg_mbx, vha, 0x100f,
@@ -275,6 +276,7 @@ qla2x00_mailbox_command(scsi_qla_host_t *vha, mbx_cmd_t *mcp)
 			    "cmd=%x Timeout.\n", command);
 			spin_lock_irqsave(&ha->hardware_lock, flags);
 			clear_bit(MBX_INTR_WAIT, &ha->mbx_cmd_flags);
+			reinit_completion(&ha->mbx_intr_comp);
 			spin_unlock_irqrestore(&ha->hardware_lock, flags);
 
 			if (chip_reset != ha->chip_reset) {
-- 
2.51.0



