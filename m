Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D98A2F003A;
	Thu,  3 Jul 2025 15:18:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751555881; cv=none; b=uXoO5J6ca9SloN6HgLvvgATCRzniHMnHZldjmL0S4QFT+mpjsiNV4v1h0fxbosuVuH/tCk50UrM+RAsjWrgnBjZWAB1HEW1vWfujZpIhbTIrif718DmnMJupzGYb3xdQKQGurBDCv7aMWOb5l2aQqJawvneabCNik0vt+bp0lOo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751555881; c=relaxed/simple;
	bh=3I25Dy4gEiNii7cbFNaUgdDCRePs4G6PufoK2MCFZzI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T+mOQg2P6VFUm0kgNypmdhrWKXoz+gRM2vCXbIIV6J2nRLTSJuEDD+DKgB8s/v3Lwc2qFXt9Vif2DxedNwlDxlR49ZyQH7IHR1Ky4qYWJ0EhRfRwRE2EglBSnQZVVfbKs8rUHU2eJ6AYSWg+XvCZIeyR512XhnXk1IkrCoZfbSI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=i05ggkb1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i05ggkb1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1476C4CEE3;
	Thu,  3 Jul 2025 15:18:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751555881;
	bh=3I25Dy4gEiNii7cbFNaUgdDCRePs4G6PufoK2MCFZzI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=i05ggkb1xK1U7ko1HJQgZ/KkhDtkQIZDbal9yn1dSfTHL0BVpnV8USy7D0gPw+cqK
	 iXRRzOtJORTcj3OWu7GtIIazqfPpSoFpfewHxt4vUjV8+KFmbQBfNF1SPgRMWf8qE6
	 /uikOw011W/+RV19EeBgusS500qzoNxXklD7iIEU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cristian Marussi <cristian.marussi@arm.com>,
	Sudeep Holla <sudeep.holla@arm.com>
Subject: [PATCH 6.6 138/139] firmware: arm_scmi: Add a common helper to check if a message is supported
Date: Thu,  3 Jul 2025 16:43:21 +0200
Message-ID: <20250703143946.574282468@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703143941.182414597@linuxfoundation.org>
References: <20250703143941.182414597@linuxfoundation.org>
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

commit 637b6d6cae9c42db5a9525da67c991294924d2cd upstream.

A common helper is provided to check if a specific protocol message is
supported or not.

Signed-off-by: Cristian Marussi <cristian.marussi@arm.com>
Link: https://lore.kernel.org/r/20240212123233.1230090-3-cristian.marussi@arm.com
Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/firmware/arm_scmi/driver.c    |   34 ++++++++++++++++++++++++++++++++++
 drivers/firmware/arm_scmi/protocols.h |    4 ++++
 2 files changed, 38 insertions(+)

--- a/drivers/firmware/arm_scmi/driver.c
+++ b/drivers/firmware/arm_scmi/driver.c
@@ -1820,10 +1820,44 @@ static void scmi_common_fastchannel_db_r
 #endif
 }
 
+/**
+ * scmi_protocol_msg_check  - Check protocol message attributes
+ *
+ * @ph: A reference to the protocol handle.
+ * @message_id: The ID of the message to check.
+ * @attributes: A parameter to optionally return the retrieved message
+ *		attributes, in case of Success.
+ *
+ * An helper to check protocol message attributes for a specific protocol
+ * and message pair.
+ *
+ * Return: 0 on SUCCESS
+ */
+static int scmi_protocol_msg_check(const struct scmi_protocol_handle *ph,
+				   u32 message_id, u32 *attributes)
+{
+	int ret;
+	struct scmi_xfer *t;
+
+	ret = xfer_get_init(ph, PROTOCOL_MESSAGE_ATTRIBUTES,
+			    sizeof(__le32), 0, &t);
+	if (ret)
+		return ret;
+
+	put_unaligned_le32(message_id, t->tx.buf);
+	ret = do_xfer(ph, t);
+	if (!ret && attributes)
+		*attributes = get_unaligned_le32(t->rx.buf);
+	xfer_put(ph, t);
+
+	return ret;
+}
+
 static const struct scmi_proto_helpers_ops helpers_ops = {
 	.extended_name_get = scmi_common_extended_name_get,
 	.iter_response_init = scmi_iterator_init,
 	.iter_response_run = scmi_iterator_run,
+	.protocol_msg_check = scmi_protocol_msg_check,
 	.fastchannel_init = scmi_common_fastchannel_init,
 	.fastchannel_db_ring = scmi_common_fastchannel_db_ring,
 };
--- a/drivers/firmware/arm_scmi/protocols.h
+++ b/drivers/firmware/arm_scmi/protocols.h
@@ -250,6 +250,8 @@ struct scmi_fc_info {
  *			provided in @ops.
  * @iter_response_run: A common helper to trigger the run of a previously
  *		       initialized iterator.
+ * @protocol_msg_check: A common helper to check is a specific protocol message
+ *			is supported.
  * @fastchannel_init: A common helper used to initialize FC descriptors by
  *		      gathering FC descriptions from the SCMI platform server.
  * @fastchannel_db_ring: A common helper to ring a FC doorbell.
@@ -262,6 +264,8 @@ struct scmi_proto_helpers_ops {
 				    unsigned int max_resources, u8 msg_id,
 				    size_t tx_size, void *priv);
 	int (*iter_response_run)(void *iter);
+	int (*protocol_msg_check)(const struct scmi_protocol_handle *ph,
+				  u32 message_id, u32 *attributes);
 	void (*fastchannel_init)(const struct scmi_protocol_handle *ph,
 				 u8 describe_id, u32 message_id,
 				 u32 valid_size, u32 domain,


