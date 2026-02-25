Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3ECD8248886;
	Wed, 25 Feb 2026 01:45:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983912; cv=none; b=sfz5cjsxLqTz5x2lAcpl7FmjCh3fwanRRdUQ14guUSk1BYua5uIcHOGGOAVyOn1Q9Bw3/oLKCaenbghhk81kRQI98uu+Z+oQ6kVfajY5+L9rA71U+O0S0wU4VEKQKC8PjKgbm9HffPj7hLFbtpNaBqY03BPKwn9lgKldhWiLav8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983912; c=relaxed/simple;
	bh=mSzzWtLveh7GHqTIk9y+KV6qAEipi39rclCFfuam5Qk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sy4E3vpM2LiPF/zldmhQp9de/Pji28stkDyW6CAgPUjjCqyGUitLdnzEJNvdfRgsQbPevmvIY8qOfWfbSGhJzXXykmKdfCSvXk+WJUGjGQOkWvcZcK9oEJkH6XvCS03c5M9rw3n2L21HIXnw/tiGBWInV1qUS2lZwVNdntqgkq8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mY3447MI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mY3447MI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F391AC19423;
	Wed, 25 Feb 2026 01:45:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983912;
	bh=mSzzWtLveh7GHqTIk9y+KV6qAEipi39rclCFfuam5Qk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mY3447MIRrsyib1O7t8a1dUGvZroQD5OHbFk2hCGsH+IVRo5Oycn01D7mb1P/8YP1
	 +z5FDQidYaxvGK7XcSzPalKeSVq0CdS7sWb2tOFf/O1ORI57ZuYQpBiIUOft0h04ZJ
	 1IRDQ4NV4PJQoJMWL/tDdSmEehbR7CJNimqzCehs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Mario Limonciello (AMD)" <superm1@kernel.org>,
	Lizhi Hou <lizhi.hou@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 178/641] accel/amdxdna: Fix race where send ring appears full due to delayed head update
Date: Tue, 24 Feb 2026 17:18:24 -0800
Message-ID: <20260225012353.342244531@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012348.915798704@linuxfoundation.org>
References: <20260225012348.915798704@linuxfoundation.org>
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
index 6634a4d5717ff..a80c77a478bff 100644
--- a/drivers/accel/amdxdna/amdxdna_mailbox.c
+++ b/drivers/accel/amdxdna/amdxdna_mailbox.c
@@ -206,26 +206,34 @@ mailbox_send_msg(struct mailbox_channel *mb_chann, struct mailbox_msg *mb_msg)
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
@@ -237,9 +245,6 @@ mailbox_send_msg(struct mailbox_channel *mb_chann, struct mailbox_msg *mb_msg)
 			    mb_msg->pkg.header.id);
 
 	return 0;
-
-no_space:
-	return -ENOSPC;
 }
 
 static int
-- 
2.51.0



