Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11CBB22579E;
	Wed, 25 Feb 2026 01:30:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983050; cv=none; b=XKGAldat9Jy2FM278UbeRBlo7mscM5Tm4y0ny6kJPt2jx6kV25PfQ+4MwLmmLtnWoIu6dGFknd3AEGmNFB/xlBo5QBn50A3XnTcJnyguqWFdKTSJ04BD5ueqgRihW2CS5gqZYtgSkl1LGWUCipYcnqpXkmjnIUNczrgG7YXpsPI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983050; c=relaxed/simple;
	bh=oSNGAD5pZtxoKHVpnbEji5FfKOmvPW9rccNis2cIjN0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UZFphbISXfxEzhYEcxpKeO+k6bxyLMMsH+nAxJZOK6H3rJSB3iEUrIH1/+WAAUu8Bo83lyV0/kS56GTTEV15sv05Y5nPAev3JnmblyN/mePq4/+7esxy8tUpS3YW+Aa2kmwVbB3iL5CTUH0DRuhxAvywA/YczZ4KTTcGA7XtERQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Nm4TJ3sv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Nm4TJ3sv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5E1BC116D0;
	Wed, 25 Feb 2026 01:30:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983050;
	bh=oSNGAD5pZtxoKHVpnbEji5FfKOmvPW9rccNis2cIjN0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Nm4TJ3sv78lXdk3CiH7rF2ymC+2lfQzS0ul8V7Mso9/qNhcWBHvZx1MMFydeHU+Kd
	 mhql1BE8dSlrvtN3RZ1v6aHVywLtkjaBJEG5iXcGMALP7o1LtAQJL8E5zs7zk/+eVz
	 IvYuGwmj/IEKeheHQiSIuMkxlvyGC1MsE/vvHIkg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Mario Limonciello (AMD)" <superm1@kernel.org>,
	Lizhi Hou <lizhi.hou@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 207/781] accel/amdxdna: Fix race where send ring appears full due to delayed head update
Date: Tue, 24 Feb 2026 17:15:16 -0800
Message-ID: <20260225012404.792801155@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lizhi Hou <lizhi.hou@amd.com>

[ Upstream commit 343f5683cfa443000904c88ce2e23656375fc51c ]

The firmware sends a response and interrupts the driver before advancing
the mailbox send ring head pointer. As a result, the driver may observe
the response and attempt to send a new request before the firmware has
updated the head pointer. In this window, the send ring still appears
full, causing the driver to incorrectly fail the send operation.

This race can be triggered more easily in a multithreaded environment,
leading to unexpected and spurious "send ring full" failures.

To address this, poll the send ring head pointer for up to 100us before
returning a full-ring condition. This allows the firmware time to update
the head pointer.

Fixes: b87f920b9344 ("accel/amdxdna: Support hardware mailbox")
Reviewed-by: Mario Limonciello (AMD) <superm1@kernel.org>
Signed-off-by: Lizhi Hou <lizhi.hou@amd.com>
Link: https://patch.msgid.link/20251211045125.1724604-1-lizhi.hou@amd.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/accel/amdxdna/amdxdna_mailbox.c | 27 +++++++++++++++----------
 1 file changed, 16 insertions(+), 11 deletions(-)

diff --git a/drivers/accel/amdxdna/amdxdna_mailbox.c b/drivers/accel/amdxdna/amdxdna_mailbox.c
index 858df97cd3fbd..8b72cf6bd6e4d 100644
--- a/drivers/accel/amdxdna/amdxdna_mailbox.c
+++ b/drivers/accel/amdxdna/amdxdna_mailbox.c
@@ -207,26 +207,34 @@ mailbox_send_msg(struct mailbox_channel *mb_chann, struct mailbox_msg *mb_msg)
 	u32 head, tail;
 	u32 start_addr;
 	u32 tmp_tail;
+	int ret;
 
 	head = mailbox_get_headptr(mb_chann, CHAN_RES_X2I);
 	tail = mb_chann->x2i_tail;
-	ringbuf_size = mailbox_get_ringbuf_size(mb_chann, CHAN_RES_X2I);
+	ringbuf_size = mailbox_get_ringbuf_size(mb_chann, CHAN_RES_X2I) - sizeof(u32);
 	start_addr = mb_chann->res[CHAN_RES_X2I].rb_start_addr;
 	tmp_tail = tail + mb_msg->pkg_size;
 
-	if (tail < head && tmp_tail >= head)
-		goto no_space;
-
-	if (tail >= head && (tmp_tail > ringbuf_size - sizeof(u32) &&
-			     mb_msg->pkg_size >= head))
-		goto no_space;
 
-	if (tail >= head && tmp_tail > ringbuf_size - sizeof(u32)) {
+check_again:
+	if (tail >= head && tmp_tail > ringbuf_size) {
 		write_addr = mb_chann->mb->res.ringbuf_base + start_addr + tail;
 		writel(TOMBSTONE, write_addr);
 
 		/* tombstone is set. Write from the start of the ringbuf */
 		tail = 0;
+		tmp_tail = tail + mb_msg->pkg_size;
+	}
+
+	if (tail < head && tmp_tail >= head) {
+		ret = read_poll_timeout(mailbox_get_headptr, head,
+					tmp_tail < head || tail >= head,
+					1, 100, false, mb_chann, CHAN_RES_X2I);
+		if (ret)
+			return ret;
+
+		if (tail >= head)
+			goto check_again;
 	}
 
 	write_addr = mb_chann->mb->res.ringbuf_base + start_addr + tail;
@@ -238,9 +246,6 @@ mailbox_send_msg(struct mailbox_channel *mb_chann, struct mailbox_msg *mb_msg)
 			    mb_msg->pkg.header.id);
 
 	return 0;
-
-no_space:
-	return -ENOSPC;
 }
 
 static int
-- 
2.51.0



