Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C1452AF05;
	Tue,  3 Dec 2024 14:53:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733237623; cv=none; b=hny7vcSN8kqq/b1HuTM0ITBQpxPBobQjbDq38ZaANK+sDPrF/qxoEn6tAJgyNaCEpFfp79Iq2zdviCsjXVrTzDVY/fUGLc6XnOxfEfmpd9dGy0lzLyxSE1q18qPMl7HDSJ90njm0JYvBgFypqYJfMR1CNSgEs3vb3cvim9p+GHw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733237623; c=relaxed/simple;
	bh=bJSsHmv4RV6Tw6uLHEt20SLT0Ok0+2yJJSCjKnM0/b0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QGp9bBK3kaD3BROrEGR6Nam76HNkn3T6O2I0dd60Z0AapzythVW7OY/Qofiy/hNttxXTiIpREIo5/Q/d4+S8DvTAOnc1p5NdJnN24L7N1wgSfjjtRyKFHKJd97cRSWUl8HCL2F0xYV6WHkq3DfVJw8FQtxc7IDU0d/ZPYDg+Eq0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PwDe6nz+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PwDe6nz+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EADCAC4CECF;
	Tue,  3 Dec 2024 14:53:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733237623;
	bh=bJSsHmv4RV6Tw6uLHEt20SLT0Ok0+2yJJSCjKnM0/b0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PwDe6nz+Q+ZjGjzgWkOmWOEtAF/CR7rTQrNKRgI5hUyQoUqpgj9HS2U/ORjMAtjUd
	 hY4cxZS5ltvcHAzRfCf61zmkDVMR+GeyKDnqO19Lv2tmmFgM9Nwc3r/RbxtdPXv0Ux
	 bxJ9Xrh1q+lu1nsqdPxfJxPMDxrs2yx1uoA4SkG0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cristian Marussi <cristian.marussi@arm.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Sudeep Holla <sudeep.holla@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 023/817] firmware: arm_scmi: Reject clear channel request on A2P
Date: Tue,  3 Dec 2024 15:33:15 +0100
Message-ID: <20241203143956.549172526@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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
index 4b8c5250cdb57..cd30499b2555f 100644
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
index dc09f2d755f41..80b44bd1a3f3e 100644
--- a/drivers/firmware/arm_scmi/driver.c
+++ b/drivers/firmware/arm_scmi/driver.c
@@ -1034,6 +1034,11 @@ static inline void scmi_xfer_command_release(struct scmi_info *info,
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
@@ -2614,6 +2619,7 @@ static int scmi_chan_setup(struct scmi_info *info, struct device_node *of_node,
 	if (!cinfo)
 		return -ENOMEM;
 
+	cinfo->is_p2a = !tx;
 	cinfo->rx_timeout_ms = info->desc->max_rx_timeout_ms;
 
 	/* Create a unique name for this transport device */
-- 
2.43.0



