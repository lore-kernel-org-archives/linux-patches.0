Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04F473F9F50;
	Sat, 12 Sep 2026 09:03:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789203788; cv=none; b=Oq3f9r7NuGfMK5kGMT6pnHq9SdSohb9FIrWCjBfQjHDGa+jrC6KrsqDjteHl9FgzzcckKgzYuDxYYT2IIKywSPmUFMN7PgD0ykZc35xWw5lbZSTVkagtVCumoQGC8xCEcpo1to204FR6gEwbIJ2mh3is3hZUP2StYWR0lqRGsD8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789203788; c=relaxed/simple;
	bh=s0z9K4mBlxolsQ7aetNaqtAtg2/L4N1vu0jEjPIWM/c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UjVhcjBxKYPUK6vymmu1C0+qyZQCGzhoIiYrbuHsIItAYcPPqwYn+wrKNYhcVrHEVg9ibZlGKID4ye/VRhM+CHzR6+v9SyEROW1R8lhQq+4ZIDQPfgPX3Y50+dLWH1FOLKXxhqo/F74PBzc3tEsP3dB7VF24Vgr5pPujBGW81iY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t1CWIo5h; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t1CWIo5h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBB101F000FF;
	Sat, 12 Sep 2026 09:03:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789203786;
	bh=6XzxECJ+su/Pnnc+0sG573Fc8vSscM5zVvwLoIwvAiE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=t1CWIo5h8lHjaMGKUqfsbspdQICNwHu3AeFrokjeOuJNj9bDopmkJrhi9T/KJ0FDd
	 h7eotdEMD6cb0TPCGfnqvuIoVZB0eQqiRSn6cTNku0QQ7pck2LOzWnKLo2I3Zizriv
	 drkwXaJePfhAmeE/DZGZ/yyX2rsDJR+WwswK5a1M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Jassi Brar <jassisinghbrar@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1480/1815] mailbox: riscv-sbi-mpxy: validate RPMI notification lengths
Date: Sat, 12 Sep 2026 08:53:50 +0200
Message-ID: <20260912065723.750990776@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pengpeng Hou <pengpeng@iscas.ac.cn>

[ Upstream commit 11d5af151bcbe78f5a579e0faecd3be9cea0399a ]

The SBI return value controls how many bytes are copied from shared
memory into the RPMI notification buffer. It is not validated against
the negotiated shared-memory size before that copy. The event walker
also uses a reversed loop condition and can inspect a short event record.

Validate the complete notification length before copying it, iterate only
while a full event header remains, and stop when a declared event payload
extends beyond the copied notification data.

Fixes: bf3022a4eb11 ("mailbox: Add RISC-V SBI message proxy (MPXY) based mailbox driver")
Assisted-by: Codex:gpt-5
Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Signed-off-by: Jassi Brar <jassisinghbrar@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mailbox/riscv-sbi-mpxy-mbox.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/mailbox/riscv-sbi-mpxy-mbox.c b/drivers/mailbox/riscv-sbi-mpxy-mbox.c
index 7c9c006b7244a..714f7fb97a2fd 100644
--- a/drivers/mailbox/riscv-sbi-mpxy-mbox.c
+++ b/drivers/mailbox/riscv-sbi-mpxy-mbox.c
@@ -314,8 +314,13 @@ static int mpxy_get_notifications(u32 channel_id,
 			 channel_id, 0, 0, 0, 0, 0);
 	if (sret.error)
 		goto err_put_cpu;
+	if (sret.value < 0 || mpxy_shmem_size < sizeof(*notif_data) ||
+	    sret.value > mpxy_shmem_size - sizeof(*notif_data)) {
+		put_cpu();
+		return -EOVERFLOW;
+	}
 
-	memcpy(notif_data, mpxy->shmem, sret.value + 16);
+	memcpy(notif_data, mpxy->shmem, sret.value + sizeof(*notif_data));
 	*events_data_len = sret.value;
 
 err_put_cpu:
@@ -480,11 +485,14 @@ static void mpxy_mbox_peek_rpmi_data(struct mbox_chan *chan,
 	struct rpmi_mbox_message msg;
 	unsigned long pos = 0;
 
-	while (pos < events_data_len && (events_data_len - pos) <= sizeof(*event)) {
+	while (events_data_len - pos >= sizeof(*event)) {
 		event = (struct rpmi_notification_event *)(notif->events_data + pos);
 
 		msg.type = RPMI_MBOX_MSG_TYPE_NOTIFICATION_EVENT;
 		msg.notif.event_datalen = le16_to_cpu(event->event_datalen);
+		if (msg.notif.event_datalen >
+		    events_data_len - pos - sizeof(*event))
+			break;
 		msg.notif.event_id = event->event_id;
 		msg.notif.event_data = event->event_data;
 		msg.error = 0;
-- 
2.53.0



