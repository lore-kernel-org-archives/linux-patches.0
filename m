Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5DE72459E5;
	Tue, 20 May 2025 14:02:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747749773; cv=none; b=V/0uyrQ17jpl6MGTaXRfU6PQmBgKwrXq8TtaoPPZovxKrElDbW9wnTYhKxy2L2DiK+NBP0UfiG05eAB1A2iPzmWyJIqYVPJmwadOCmXZCikfTlDJ5aH+aXd//rY38a6CrjmvCM1tbWl/n0vMKSdayAkXzHL3KWQeRDzo4VGQlCE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747749773; c=relaxed/simple;
	bh=gAtjiDEf3DVfev6ldemrV9uV/jyiVPErqpl+u8cwO9s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Mj8lB64DyPge6gtBn6JoBGLa82AZxqrx0Sq7lIsqVrRcrwDG/DJ1Xuipanh/CEz8kU4xqaKgY/8hkfBd1fEFTsZzxLFMd6OuzZdoEp5LwHvlhp3hTLgb601V6TBa0CpzqX9Nd5b3W3/sMbGsNgqWvpZXXqlSK2Mmqw+ydR/0fvI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ImjlEqae; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ImjlEqae"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 424BAC4CEEF;
	Tue, 20 May 2025 14:02:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747749773;
	bh=gAtjiDEf3DVfev6ldemrV9uV/jyiVPErqpl+u8cwO9s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ImjlEqaeyo3WZm3PEBvjj2s6h72VKV8OptBMvhkslCIh2Xgifv+BfxXUK6OtrPFrt
	 UaIUml4hM9h3liIVwyq3JPkYs0ioNY/HtQqcmebUcjHfUYz7Z8Q+eGi7XRWS21wFwn
	 6HnkXQs3Mcf+kPl+VNXJ4dHawyoHbOUMeOyKrI0M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cristian Marussi <cristian.marussi@arm.com>,
	Sudeep Holla <sudeep.holla@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 015/117] firmware: arm_scmi: Add helper to trace bad messages
Date: Tue, 20 May 2025 15:49:40 +0200
Message-ID: <20250520125804.588539159@linuxfoundation.org>
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

[ Upstream commit 5dc0e0b1f0ea2b55031f84a365962b9b45869b98 ]

Upon reception of malformed and unexpected timed-out SCMI messages, it is
not possible to trace those bad messages in their entirety, because usually
we cannot even retrieve the payload, or it is just not reliable.

Add a helper to trace at least the content of the header of the received
message while associating a meaningful tag and error code.

Signed-off-by: Cristian Marussi <cristian.marussi@arm.com>
Link: https://lore.kernel.org/r/20240325204620.1437237-3-cristian.marussi@arm.com
Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
Stable-dep-of: c23c03bf1faa ("firmware: arm_scmi: Fix timeout checks on polling path")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/arm_scmi/common.h | 11 +++++++++
 drivers/firmware/arm_scmi/driver.c | 39 ++++++++++++++++++++++++++++++
 2 files changed, 50 insertions(+)

diff --git a/drivers/firmware/arm_scmi/common.h b/drivers/firmware/arm_scmi/common.h
index 039f686f4580d..e26a2856a0e3d 100644
--- a/drivers/firmware/arm_scmi/common.h
+++ b/drivers/firmware/arm_scmi/common.h
@@ -303,6 +303,17 @@ extern const struct scmi_desc scmi_optee_desc;
 
 void scmi_rx_callback(struct scmi_chan_info *cinfo, u32 msg_hdr, void *priv);
 
+enum scmi_bad_msg {
+	MSG_UNEXPECTED = -1,
+	MSG_INVALID = -2,
+	MSG_UNKNOWN = -3,
+	MSG_NOMEM = -4,
+	MSG_MBOX_SPURIOUS = -5,
+};
+
+void scmi_bad_message_trace(struct scmi_chan_info *cinfo, u32 msg_hdr,
+			    enum scmi_bad_msg err);
+
 /* shmem related declarations */
 struct scmi_shared_mem;
 
diff --git a/drivers/firmware/arm_scmi/driver.c b/drivers/firmware/arm_scmi/driver.c
index efa9698c876a0..b3c2a199b2afb 100644
--- a/drivers/firmware/arm_scmi/driver.c
+++ b/drivers/firmware/arm_scmi/driver.c
@@ -687,6 +687,45 @@ scmi_xfer_lookup_unlocked(struct scmi_xfers_info *minfo, u16 xfer_id)
 	return xfer ?: ERR_PTR(-EINVAL);
 }
 
+/**
+ * scmi_bad_message_trace  - A helper to trace weird messages
+ *
+ * @cinfo: A reference to the channel descriptor on which the message was
+ *	   received
+ * @msg_hdr: Message header to track
+ * @err: A specific error code used as a status value in traces.
+ *
+ * This helper can be used to trace any kind of weird, incomplete, unexpected,
+ * timed-out message that arrives and as such, can be traced only referring to
+ * the header content, since the payload is missing/unreliable.
+ */
+void scmi_bad_message_trace(struct scmi_chan_info *cinfo, u32 msg_hdr,
+			    enum scmi_bad_msg err)
+{
+	char *tag;
+	struct scmi_info *info = handle_to_scmi_info(cinfo->handle);
+
+	switch (MSG_XTRACT_TYPE(msg_hdr)) {
+	case MSG_TYPE_COMMAND:
+		tag = "!RESP";
+		break;
+	case MSG_TYPE_DELAYED_RESP:
+		tag = "!DLYD";
+		break;
+	case MSG_TYPE_NOTIFICATION:
+		tag = "!NOTI";
+		break;
+	default:
+		tag = "!UNKN";
+		break;
+	}
+
+	trace_scmi_msg_dump(info->id, cinfo->id,
+			    MSG_XTRACT_PROT_ID(msg_hdr),
+			    MSG_XTRACT_ID(msg_hdr), tag,
+			    MSG_XTRACT_TOKEN(msg_hdr), err, NULL, 0);
+}
+
 /**
  * scmi_msg_response_validate  - Validate message type against state of related
  * xfer
-- 
2.39.5



