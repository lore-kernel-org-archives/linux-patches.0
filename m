Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2261139B48E;
	Thu, 15 Jan 2026 17:26:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768497962; cv=none; b=H6Kgks3TTmyyBl9udboJ3aC0KR8AB/NaPWL4hqy0Qiok+kvZLDZau8W8klWjlUznAniaL8zCX8KwWd/WmvM1fkg+K8OBbkGjXK3YXhYLY6GMCnDAfQeWfs4FKZFVhjqkUOwHoCsQNOIo+TGm4P764cFJtEQhhXNDkXIieFWqmKk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768497962; c=relaxed/simple;
	bh=JnAslVT1a4dy1vksvC3hSS0k13A33q8x5+twjV81m+A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CWxLbgRoYyk9iQ6igGavqReavOjYvRLXxGieHKY5yIeNT++4iF9JZ+cto9aITCYdNFNYyl6FR9EGZVc4JLzGdo45aNJHloZdeDJzqjZVlXx4hOJOR1Cyb+c8vZhSYvlgMKDl38t4OSJNYIZPO6z0cpxIehUKCfi+XV8BXp76TRA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QRaHXe0W; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QRaHXe0W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E573C116D0;
	Thu, 15 Jan 2026 17:26:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768497961;
	bh=JnAslVT1a4dy1vksvC3hSS0k13A33q8x5+twjV81m+A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QRaHXe0WDP1Qbl8GTkmk3wJubI5P0398m4W+vSDLfkcI3mFuXKFw8yha7seg3Z4uo
	 t40+vkMMtyLBzMKYcsSJyy9lG0okQ6p/ho6zGrhtEW/jlx7nh9jwCM0+clG1vk+NzF
	 edUrJw1RsiuZcPVnio7ovHy8R9O57gGheLfg3/e0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tony Battersby <tonyb@cybernetics.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 264/554] scsi: qla2xxx: Use reinit_completion on mbx_intr_comp
Date: Thu, 15 Jan 2026 17:45:30 +0100
Message-ID: <20260115164255.787434018@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164246.225995385@linuxfoundation.org>
References: <20260115164246.225995385@linuxfoundation.org>
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
index 7a28582b1f73..771b323a5194 100644
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



