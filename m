Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14C0D1DFDB2;
	Wed,  6 Nov 2024 12:26:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730895966; cv=none; b=i5VyFOWrb4V4Aio52jlMIAdCn0Yxrzj5J55xFOB1oEVtkh64WADQB+9iq0m7MXFZKSZAdHOzhF48cH/19vINcS0pthsnhMifERnn2oMRU64mU1+9Lh3g7N2ro8WcRwgLi4TaYnCmISW6KhSh+SbU2k1S2LNcR+axnDkLaY08uAI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730895966; c=relaxed/simple;
	bh=W7kpHVh2V/NOpRhM7wtSSO0eUPZGmLX0Ft290FDTP7s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TukwXZGMBCzucmzp1bDOiyr0habVn5YSt3QvlNZcbyRfibYI/62SZEPztfgLYAIMCPLauLJ1w3iFolZGAU2qCmK5sMLfTPnKiBC3MGKee2M9MoHdhIyy2nv4yJ+L51ywNhsPRaYCjuL8AFo34ceYlXSkfDjJsr9Z58mSHWCWZSU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kCAOSUou; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kCAOSUou"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 506ADC4CECD;
	Wed,  6 Nov 2024 12:26:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730895965;
	bh=W7kpHVh2V/NOpRhM7wtSSO0eUPZGmLX0Ft290FDTP7s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kCAOSUouiHP7CVVO56SYrjw+/Ur+6YmZ8oGj09PBLwZSLzqLIgGmotzvaFmLWg0nT
	 2A8eakH7TDI2pH8gTvPjML8WgubGT3IreSByENatNYSjHsLkwBntz8SP8Qo+FcJ0Ol
	 /UPJSfl6TutnTdcgxoGBeFw6kkP/WnbNTq/6VvOE=
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
Subject: [PATCH 6.11 009/245] wifi: iwlegacy: Fix "field-spanning write" warning in il_enqueue_hcmd()
Date: Wed,  6 Nov 2024 13:01:02 +0100
Message-ID: <20241106120319.473879944@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120319.234238499@linuxfoundation.org>
References: <20241106120319.234238499@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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
index 9d33a66a49b59..4616293ec0cf4 100644
--- a/drivers/net/wireless/intel/iwlegacy/common.c
+++ b/drivers/net/wireless/intel/iwlegacy/common.c
@@ -3122,6 +3122,7 @@ il_enqueue_hcmd(struct il_priv *il, struct il_host_cmd *cmd)
 	struct il_cmd_meta *out_meta;
 	dma_addr_t phys_addr;
 	unsigned long flags;
+	u8 *out_payload;
 	u32 idx;
 	u16 fix_size;
 
@@ -3157,6 +3158,16 @@ il_enqueue_hcmd(struct il_priv *il, struct il_host_cmd *cmd)
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
@@ -3170,7 +3181,7 @@ il_enqueue_hcmd(struct il_priv *il, struct il_host_cmd *cmd)
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



