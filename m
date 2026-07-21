Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70C8E46AA70;
	Tue, 21 Jul 2026 15:34:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784648056; cv=none; b=oX3eJsxtj0uV+yxb/qjrS2L0evbfuiAR25jVbovfZi1hcwIdVKjfD4Php9k0onxaRpacNCgjlxjjDxBdWBO9bZTdZbFg1W0UGdHaKvt1leNkp7H1F9j0BYi1gCqAAEUYZvW4HdLlMmwwDGkSdIoZkU7SN26Uy3W1ypmv/V6MwcY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784648056; c=relaxed/simple;
	bh=z2WHGKiYla5A3XE3TMYNQ+tuMIeOKTWLPg2lLnVb88I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YNvLsBgiUeQRw49q1cbsr2a8K/LQTRxzc0JDXpdY2fUpW/LBuoJFVEfN+meERUA7uUW9GHx6STv5DPJWVM4nANhpvIJsdk/KFs/flX4xBUdKqE79gZfzvGPmqV+8zf7gWB27yEIZHMAC2HlhK2T78Q3Qpac5QYvgPOKrDozzEGA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y5VoE547; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y5VoE547"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C071E1F000E9;
	Tue, 21 Jul 2026 15:34:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784648055;
	bh=ngPYAbl3CuUUvUjsnBdJfZCf0De7T7X3Iw1ON3DoYGU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Y5VoE547aASoxbUShmdUINc5zKtYIB5puY6Rc0NcL3l2irW13G1mJMOoJwhFh63X4
	 kfnHpIGc9eoynnjLjaBuIBdnRnbBijepT7aqgda22ImPl/ziO8iyX7Gvaxm0bQp3Jl
	 2+ctdBMcOgJ5E4nrTGFaVDCnbRjLN1eX95MyO2cs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Mario Limonciello (AMD)" <superm1@kernel.org>,
	Lizhi Hou <lizhi.hou@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0055/2077] accel/amdxdna: Fix order of canceled mailbox messages
Date: Tue, 21 Jul 2026 16:55:28 +0200
Message-ID: <20260721152553.989215355@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lizhi Hou <lizhi.hou@amd.com>

[ Upstream commit c83ad8ea6b0a53f1ed61ae0b4b9606bdfe338b33 ]

Mailbox message IDs are allocated cyclically. When destroying a mailbox
channel, pending messages are canceled starting from message ID 0. This
results in an incorrect cancellation order when the ID of the last posted
message wraps around and is smaller than the ID of the first posted
message.

Fix this by canceling pending messages starting from the next available
message ID, ensuring the correct ordering across wraparound.

Fixes: a37d78470bcc ("accel/amdxdna: Replace idr api with xarray")
Reviewed-by: Mario Limonciello (AMD) <superm1@kernel.org>
Signed-off-by: Lizhi Hou <lizhi.hou@amd.com>
Link: https://patch.msgid.link/20260413181843.670796-1-lizhi.hou@amd.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/accel/amdxdna/amdxdna_mailbox.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/accel/amdxdna/amdxdna_mailbox.c b/drivers/accel/amdxdna/amdxdna_mailbox.c
index e681a090752df4..d3639a2ea23951 100644
--- a/drivers/accel/amdxdna/amdxdna_mailbox.c
+++ b/drivers/accel/amdxdna/amdxdna_mailbox.c
@@ -538,7 +538,9 @@ void xdna_mailbox_stop_channel(struct mailbox_channel *mb_chann)
 	drain_workqueue(mb_chann->work_q);
 
 	/* We can clean up and release resources */
-	xa_for_each(&mb_chann->chan_xa, msg_id, mb_msg)
+	xa_for_each_start(&mb_chann->chan_xa, msg_id, mb_msg, mb_chann->next_msgid)
+		mailbox_release_msg(mb_chann, mb_msg);
+	xa_for_each_range(&mb_chann->chan_xa, msg_id, mb_msg, 0, mb_chann->next_msgid - 1)
 		mailbox_release_msg(mb_chann, mb_msg);
 	xa_destroy(&mb_chann->chan_xa);
 
-- 
2.53.0



