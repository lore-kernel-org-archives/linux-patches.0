Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C10F10E0;
	Fri,  6 Dec 2024 14:47:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733496471; cv=none; b=DpJtylQiBErJCZ/tmecVwFT58Dzl5aOqdcsJyM6OQanjZBkdQTbN5Mhd//4tnIp1oJEGBGwgTXQ5HVuKqcRRjh3xTHTkVL4g8aWLJ1RM9cSDtxfhsP2TNazBnSPxPuhtXsKPKQZPegPB6gTqRL2CKaTUiO/YKee67kki1w27QQo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733496471; c=relaxed/simple;
	bh=D1XAZ3Hw+EaU7EI5RsQwiI0rtNTJf6CkB2JZq65S4xA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q4XGDykhbfwlIs/Y49ACAiOeWzJlaWKxqm6UlPKcztUm1LmiwR1/160N3cWIOzDprb5RnbT2Myzd2MXqKeayRo82atMuq+Q6gxhXfoSb4KHCEsVJyEkLsqSxKLohG9xZwElzpiHiTfimZQMA9uJDZChG0W1F7cIz7xae+s21c6I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=X432l4bp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X432l4bp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC293C4CED1;
	Fri,  6 Dec 2024 14:47:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733496471;
	bh=D1XAZ3Hw+EaU7EI5RsQwiI0rtNTJf6CkB2JZq65S4xA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=X432l4bpPYedz/YuUk3vg7n2PFvekBilH6wydIAgtRZvrSgBAUYzChSOXRObualE0
	 oKy6U7m3uhMMKDZyhBiQJiB3GyOyHp0LLWSC1oBjAdUse5NtikJSBy4TZ71j5iYj0J
	 hHRov/GllrUQYJC5zRExxHjrYltvUz+ZWMoPQ9Ag=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cristian Marussi <cristian.marussi@arm.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Sudeep Holla <sudeep.holla@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 016/676] firmware: arm_scmi: Reject clear channel request on A2P
Date: Fri,  6 Dec 2024 15:27:15 +0100
Message-ID: <20241206143653.991496122@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
User-Agent: quilt/0.67
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

[ Upstream commit a0a18e91eb3a6ef75a6de69dc00f206b913e3848 ]

The clear channel transport operation is supposed to be called exclusively
on the P2A channel from the agent, since it relinquishes the ownership of
the channel to the platform, after this latter has initiated some sort of
P2A communication.

Make sure that, if it is ever called on a A2P, is logged and ignored.

Signed-off-by: Cristian Marussi <cristian.marussi@arm.com>
Reviewed-by: Florian Fainelli <florian.fainelli@broadcom.com>
Message-Id: <20241021171544.2579551-1-cristian.marussi@arm.com>
Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/arm_scmi/common.h | 2 ++
 drivers/firmware/arm_scmi/driver.c | 6 ++++++
 2 files changed, 8 insertions(+)

diff --git a/drivers/firmware/arm_scmi/common.h b/drivers/firmware/arm_scmi/common.h
index 00b165d1f502d..039f686f4580d 100644
--- a/drivers/firmware/arm_scmi/common.h
+++ b/drivers/firmware/arm_scmi/common.h
@@ -163,6 +163,7 @@ void scmi_protocol_release(const struct scmi_handle *handle, u8 protocol_id);
  *      used to initialize this channel
  * @dev: Reference to device in the SCMI hierarchy corresponding to this
  *	 channel
+ * @is_p2a: A flag to identify a channel as P2A (RX)
  * @rx_timeout_ms: The configured RX timeout in milliseconds.
  * @handle: Pointer to SCMI entity handle
  * @no_completion_irq: Flag to indicate that this channel has no completion
@@ -174,6 +175,7 @@ void scmi_protocol_release(const struct scmi_handle *handle, u8 protocol_id);
 struct scmi_chan_info {
 	int id;
 	struct device *dev;
+	bool is_p2a;
 	unsigned int rx_timeout_ms;
 	struct scmi_handle *handle;
 	bool no_completion_irq;
diff --git a/drivers/firmware/arm_scmi/driver.c b/drivers/firmware/arm_scmi/driver.c
index 3962683e2af9d..efa9698c876a0 100644
--- a/drivers/firmware/arm_scmi/driver.c
+++ b/drivers/firmware/arm_scmi/driver.c
@@ -855,6 +855,11 @@ static inline void scmi_xfer_command_release(struct scmi_info *info,
 static inline void scmi_clear_channel(struct scmi_info *info,
 				      struct scmi_chan_info *cinfo)
 {
+	if (!cinfo->is_p2a) {
+		dev_warn(cinfo->dev, "Invalid clear on A2P channel !\n");
+		return;
+	}
+
 	if (info->desc->ops->clear_channel)
 		info->desc->ops->clear_channel(cinfo);
 }
@@ -2319,6 +2324,7 @@ static int scmi_chan_setup(struct scmi_info *info, struct device_node *of_node,
 	if (!cinfo)
 		return -ENOMEM;
 
+	cinfo->is_p2a = !tx;
 	cinfo->rx_timeout_ms = info->desc->max_rx_timeout_ms;
 
 	/* Create a unique name for this transport device */
-- 
2.43.0



