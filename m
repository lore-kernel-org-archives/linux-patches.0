Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D6961EF928;
	Wed,  6 Nov 2024 12:49:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730897391; cv=none; b=cybVidexyNQKYRO/XsF2Vnrx7ov0nctbM73C3tgF7L8rjILp+M/ViwwBJxruFoLYj9SLecBB3Vc7W4Sm+CKBLNzNoAowWHg969yIzcRpJ+ipl0LisRGnh/7wBlT2zANJ62+kFsj+dAZBLxRSbYX9LqddCI5Z6H4nDbycBMBXBbE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730897391; c=relaxed/simple;
	bh=yp+6Oc+zChMHK5V5H+g5zB6ajr3E9eKjX1xhz1mtHiU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=h1xSEMcrfRgJqkMCOUtJ4T1OBJ1dKKHJ8G5H2pN7oFuhEHCMsUrrrWdc1h5IIoi8ovnGWyXyePcWFi+GPLd4DbQchsX4439/+kJH5GFh+VzBt2b/tcRaa3mqE1x3f8KPeVv5T4Vvdkemvi6bQbSVZ2AIA7VX0z9fZ+RpBuU98OE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xIExpmPT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xIExpmPT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85CA9C4CECD;
	Wed,  6 Nov 2024 12:49:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730897390;
	bh=yp+6Oc+zChMHK5V5H+g5zB6ajr3E9eKjX1xhz1mtHiU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xIExpmPT9cQ+PQBdV9Bf2V3F002U2hi2jsvHPEwUOmxS6m3uiF4YgTFTxSAS0gMyX
	 Kw8NGd0v+StX+Fj9RYj9lB3X+96/gQ/fat6iJQ+pqPos44sXq+uinMJ3N4TJ1r3JM8
	 p2SCjUUTowtLNEleSjFWmg3Aqfro6GOLHaF1F75o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Martin-=C3=89ric=20Racine?= <martin-eric.racine@iki.fi>,
	Ben Hutchings <ben@decadent.org.uk>,
	Brandon Nielsen <nielsenb@jetfuse.net>,
	Stanislaw Gruszka <stf_xl@wp.pl>,
	Kalle Valo <kvalo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 008/151] wifi: iwlegacy: Fix "field-spanning write" warning in il_enqueue_hcmd()
Date: Wed,  6 Nov 2024 13:03:16 +0100
Message-ID: <20241106120309.070998720@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120308.841299741@linuxfoundation.org>
References: <20241106120308.841299741@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ben Hutchings <ben@decadent.org.uk>

[ Upstream commit d4cdc46ca16a5c78b36c5b9b6ad8cac09d6130a0 ]

iwlegacy uses command buffers with a payload size of 320
bytes (default) or 4092 bytes (huge).  The struct il_device_cmd type
describes the default buffers and there is no separate type describing
the huge buffers.

The il_enqueue_hcmd() function works with both default and huge
buffers, and has a memcpy() to the buffer payload.  The size of
this copy may exceed 320 bytes when using a huge buffer, which
now results in a run-time warning:

    memcpy: detected field-spanning write (size 1014) of single field "&out_cmd->cmd.payload" at drivers/net/wireless/intel/iwlegacy/common.c:3170 (size 320)

To fix this:

- Define a new struct type for huge buffers, with a correctly sized
  payload field
- When using a huge buffer in il_enqueue_hcmd(), cast the command
  buffer pointer to that type when looking up the payload field

Reported-by: Martin-Éric Racine <martin-eric.racine@iki.fi>
References: https://bugs.debian.org/1062421
References: https://bugzilla.kernel.org/show_bug.cgi?id=219124
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Fixes: 54d9469bc515 ("fortify: Add run-time WARN for cross-field memcpy()")
Tested-by: Martin-Éric Racine <martin-eric.racine@iki.fi>
Tested-by: Brandon Nielsen <nielsenb@jetfuse.net>
Acked-by: Stanislaw Gruszka <stf_xl@wp.pl>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://patch.msgid.link/ZuIhQRi/791vlUhE@decadent.org.uk
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlegacy/common.c | 13 ++++++++++++-
 drivers/net/wireless/intel/iwlegacy/common.h | 12 ++++++++++++
 2 files changed, 24 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlegacy/common.c b/drivers/net/wireless/intel/iwlegacy/common.c
index 96002121bb8b2..9fa38221c4311 100644
--- a/drivers/net/wireless/intel/iwlegacy/common.c
+++ b/drivers/net/wireless/intel/iwlegacy/common.c
@@ -3119,6 +3119,7 @@ il_enqueue_hcmd(struct il_priv *il, struct il_host_cmd *cmd)
 	struct il_cmd_meta *out_meta;
 	dma_addr_t phys_addr;
 	unsigned long flags;
+	u8 *out_payload;
 	u32 idx;
 	u16 fix_size;
 
@@ -3154,6 +3155,16 @@ il_enqueue_hcmd(struct il_priv *il, struct il_host_cmd *cmd)
 	out_cmd = txq->cmd[idx];
 	out_meta = &txq->meta[idx];
 
+	/* The payload is in the same place in regular and huge
+	 * command buffers, but we need to let the compiler know when
+	 * we're using a larger payload buffer to avoid "field-
+	 * spanning write" warnings at run-time for huge commands.
+	 */
+	if (cmd->flags & CMD_SIZE_HUGE)
+		out_payload = ((struct il_device_cmd_huge *)out_cmd)->cmd.payload;
+	else
+		out_payload = out_cmd->cmd.payload;
+
 	if (WARN_ON(out_meta->flags & CMD_MAPPED)) {
 		spin_unlock_irqrestore(&il->hcmd_lock, flags);
 		return -ENOSPC;
@@ -3167,7 +3178,7 @@ il_enqueue_hcmd(struct il_priv *il, struct il_host_cmd *cmd)
 		out_meta->callback = cmd->callback;
 
 	out_cmd->hdr.cmd = cmd->id;
-	memcpy(&out_cmd->cmd.payload, cmd->data, cmd->len);
+	memcpy(out_payload, cmd->data, cmd->len);
 
 	/* At this point, the out_cmd now has all of the incoming cmd
 	 * information */
diff --git a/drivers/net/wireless/intel/iwlegacy/common.h b/drivers/net/wireless/intel/iwlegacy/common.h
index 69687fcf963fc..027dae5619a37 100644
--- a/drivers/net/wireless/intel/iwlegacy/common.h
+++ b/drivers/net/wireless/intel/iwlegacy/common.h
@@ -560,6 +560,18 @@ struct il_device_cmd {
 
 #define TFD_MAX_PAYLOAD_SIZE (sizeof(struct il_device_cmd))
 
+/**
+ * struct il_device_cmd_huge
+ *
+ * For use when sending huge commands.
+ */
+struct il_device_cmd_huge {
+	struct il_cmd_header hdr;	/* uCode API */
+	union {
+		u8 payload[IL_MAX_CMD_SIZE - sizeof(struct il_cmd_header)];
+	} __packed cmd;
+} __packed;
+
 struct il_host_cmd {
 	const void *data;
 	unsigned long reply_page;
-- 
2.43.0



