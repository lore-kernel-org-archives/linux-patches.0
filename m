Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 336349460;
	Mon, 29 Dec 2025 16:22:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767025367; cv=none; b=gQFtP8UdcHMZCI0g880hAHwdMZNHEPBZf1boCijfYHWUwtDGsIocvrdkUBUhbfizKr7jmGxCLjF1vxL3kgP7j0KYml/BETuHbsINKlS/2mrjIaKj9opuYyLpRUK5QkgFsdsOvY7yubulGuPw+aZh0fbyHAcIlPlWUHs9u/ZP1us=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767025367; c=relaxed/simple;
	bh=YKHL7PWts6T79MWrs8qr1RtqjWBtyI6mMjqpZmj8N8c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Lf/VULwQ6/wKgItFvE/9BYhn1DHqpRWhwAsu+ncvKumueE5ojrjWeT7SnDwTdNEbEZmXiKVlMmBGxpHSrXD/FMm251ALJE7VrUTVo8UvF+rZci57Ebtoc9X7a03nn2LESkHujwJJeBQonvjG4Wr3RG3pVk9e1n3VueRzrt5LovM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pOeZDRA2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pOeZDRA2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADA42C4CEF7;
	Mon, 29 Dec 2025 16:22:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767025367;
	bh=YKHL7PWts6T79MWrs8qr1RtqjWBtyI6mMjqpZmj8N8c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pOeZDRA2kq1Z3oVfTj2pNhla+17mKIwgYMQwNzHb/FmWWW1GH86iV2VM2A79+5l8j
	 MmucsqvlpVYJ43drPOPUv48W0IPGAaI21tMyu6Vro/7PN45cJHlMoZhrE5MSJNGGsq
	 QadL2l61FrUbc1fpABGqFGflVH/62HQUjXVboK6k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tony Battersby <tonyb@cybernetics.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 188/430] scsi: qla2xxx: Use reinit_completion on mbx_intr_comp
Date: Mon, 29 Dec 2025 17:09:50 +0100
Message-ID: <20251229160731.275144869@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251229160724.139406961@linuxfoundation.org>
References: <20251229160724.139406961@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 32eb0ce8b170..1f01576f044b 100644
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



