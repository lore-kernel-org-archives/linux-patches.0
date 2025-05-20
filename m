Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAD412459F3;
	Tue, 20 May 2025 14:01:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747749676; cv=none; b=ZXUEVzfGf7JI0FDgfgeJGYUJRrEnUiW/IyqaFsStCceTitdD4a5M1wBmGtGf+aumAVxGhbQ9pp+1iz6Y5a3jUI/BvdmzfkTqwKbXEmfbkWBq5LfyemTvccH5V/ivjWCGMX4AFgfbENeMksfIWUF/ACs24yTeSkP9E5miyGCu5Yc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747749676; c=relaxed/simple;
	bh=1jYue2ejbg8X2S7zWR3YvKOhQisXRUWuOOh3zW4H0Q4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fQQ/ecwQqTWRfLKqAW5d6VeHePoK+Y3JsBsqkfGF+2qqHH43ozdVASR5AvfhEnWDCS8HGYO9BFc8+NtNLzcEKO7RMJALDBoNHUlC+t4dn8YntUlomaALjLWYAlizhDU6OVzA40r1C2YhYzBlS6DMnnvZPeGonN4D3mFZq9R8sSY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AI4TIksy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AI4TIksy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DC2FC4CEE9;
	Tue, 20 May 2025 14:01:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747749676;
	bh=1jYue2ejbg8X2S7zWR3YvKOhQisXRUWuOOh3zW4H0Q4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AI4TIksyPKH9dipwzumA4d8Q6/N+PbKTLGlncynlYQ9zYOrdlGPcnTEXQJ+faMGHp
	 xC5oJxBVvMDuLMM4GTkKE95WX0GPi/iiqj+Zq4aNkNfDz34bXZUlQkx7ZQGTffcIMn
	 2riCNpS2nYnTjaHvKTRCnLb0M+Y8zesnTKqd/nsc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cristian Marussi <cristian.marussi@arm.com>,
	Sudeep Holla <sudeep.holla@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 016/117] firmware: arm_scmi: Add message dump traces for bad and unexpected replies
Date: Tue, 20 May 2025 15:49:41 +0200
Message-ID: <20250520125804.627745420@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250520125803.981048184@linuxfoundation.org>
References: <20250520125803.981048184@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cristian Marussi <cristian.marussi@arm.com>

[ Upstream commit 5076ab66db1671a5cd9ecfb857d1949e36a33142 ]

It is useful to have message dump traces for any invalid/bad/unexpected
replies. Let us add traces for the same as well as late-timed-out,
out-of-order and unexpected/spurious messages.

Signed-off-by: Cristian Marussi <cristian.marussi@arm.com>
Link: https://lore.kernel.org/r/20240325204620.1437237-4-cristian.marussi@arm.com
Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
Stable-dep-of: c23c03bf1faa ("firmware: arm_scmi: Fix timeout checks on polling path")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/arm_scmi/driver.c  | 10 ++++++++++
 drivers/firmware/arm_scmi/mailbox.c |  3 +++
 2 files changed, 13 insertions(+)

diff --git a/drivers/firmware/arm_scmi/driver.c b/drivers/firmware/arm_scmi/driver.c
index b3c2a199b2afb..f66a16d3671f1 100644
--- a/drivers/firmware/arm_scmi/driver.c
+++ b/drivers/firmware/arm_scmi/driver.c
@@ -852,6 +852,9 @@ scmi_xfer_command_acquire(struct scmi_chan_info *cinfo, u32 msg_hdr)
 			"Message for %d type %d is not expected!\n",
 			xfer_id, msg_type);
 		spin_unlock_irqrestore(&minfo->xfer_lock, flags);
+
+		scmi_bad_message_trace(cinfo, msg_hdr, MSG_UNEXPECTED);
+
 		return xfer;
 	}
 	refcount_inc(&xfer->users);
@@ -876,6 +879,9 @@ scmi_xfer_command_acquire(struct scmi_chan_info *cinfo, u32 msg_hdr)
 		dev_err(cinfo->dev,
 			"Invalid message type:%d for %d - HDR:0x%X  state:%d\n",
 			msg_type, xfer_id, msg_hdr, xfer->state);
+
+		scmi_bad_message_trace(cinfo, msg_hdr, MSG_INVALID);
+
 		/* On error the refcount incremented above has to be dropped */
 		__scmi_xfer_put(minfo, xfer);
 		xfer = ERR_PTR(-EINVAL);
@@ -917,6 +923,9 @@ static void scmi_handle_notification(struct scmi_chan_info *cinfo,
 	if (IS_ERR(xfer)) {
 		dev_err(dev, "failed to get free message slot (%ld)\n",
 			PTR_ERR(xfer));
+
+		scmi_bad_message_trace(cinfo, msg_hdr, MSG_NOMEM);
+
 		scmi_clear_channel(info, cinfo);
 		return;
 	}
@@ -1036,6 +1045,7 @@ void scmi_rx_callback(struct scmi_chan_info *cinfo, u32 msg_hdr, void *priv)
 		break;
 	default:
 		WARN_ONCE(1, "received unknown msg_type:%d\n", msg_type);
+		scmi_bad_message_trace(cinfo, msg_hdr, MSG_UNKNOWN);
 		break;
 	}
 }
diff --git a/drivers/firmware/arm_scmi/mailbox.c b/drivers/firmware/arm_scmi/mailbox.c
index 8e513f70b75d4..f1d5e3fba35e0 100644
--- a/drivers/firmware/arm_scmi/mailbox.c
+++ b/drivers/firmware/arm_scmi/mailbox.c
@@ -58,6 +58,9 @@ static void rx_callback(struct mbox_client *cl, void *m)
 	 */
 	if (cl->knows_txdone && !shmem_channel_free(smbox->shmem)) {
 		dev_warn(smbox->cinfo->dev, "Ignoring spurious A2P IRQ !\n");
+		scmi_bad_message_trace(smbox->cinfo,
+				       shmem_read_header(smbox->shmem),
+				       MSG_MBOX_SPURIOUS);
 		return;
 	}
 
-- 
2.39.5



