Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F43C1E86C;
	Mon,  1 Apr 2024 16:33:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711989200; cv=none; b=R4Rf0KWCSz0ZYxeLdQmgsA4fdGpJPjpN1se3DEamRkEpo0u2pUga3frcdsA+yTqzG8hH61CF5q1yKtLCicNqIbEQaW0k1iMO0mqkX2u9QyiIrFltxlWdhW1sv5610/CHxzVSwWY+zj1Uy0/PNvgfN4feGwS39oQWhbs3tjZZ7y0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711989200; c=relaxed/simple;
	bh=z3KSeOSYiq+WY+JgAItntzKi67GgFvOc7hIdK84VINc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l2/jv6Z83Tr61qyvLZU/H7ziAghE9uHZMRP9LC3hOCr6QYNv/YLwutiYjgBTGWSy0Cea79/GaPRV4gG8tm/mSJNem5LXynFoz/LLszbem/gmOe25YUh8bz+pc1FmVtUrupY4lXARpFRUGID30T4mN4ccQYWa2+3vEti+JW7K2XM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=scrE6HUV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="scrE6HUV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB9DDC433C7;
	Mon,  1 Apr 2024 16:33:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711989200;
	bh=z3KSeOSYiq+WY+JgAItntzKi67GgFvOc7hIdK84VINc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=scrE6HUV065F5nW5m78QDAxDbsrpyt5xVf2CV3yJej/EVkbjSkV5Za+B5vNnCShQ0
	 4MnbWIpqLLdS92zu0Mf1oX3LtwrJRZxpQeJdDly6KHt3gsSxPqwzGbiWO2wNHfPPHu
	 u1NTgjroPYRbF+V7PJ+GqKxik5t1iz+0y6U09beA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Christian A. Ehrhardt" <lk@c--e.de>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	Neil Armstrong <neil.armstrong@linaro.org>
Subject: [PATCH 6.7 410/432] usb: typec: ucsi_acpi: Refactor and fix DELL quirk
Date: Mon,  1 Apr 2024 17:46:37 +0200
Message-ID: <20240401152605.616248539@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152553.125349965@linuxfoundation.org>
References: <20240401152553.125349965@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian A. Ehrhardt <lk@c--e.de>

commit 6aaceb7d9cd00f3e065dc4b054ecfe52c5253b03 upstream.

Some DELL systems don't like UCSI_ACK_CC_CI commands with the
UCSI_ACK_CONNECTOR_CHANGE but not the UCSI_ACK_COMMAND_COMPLETE
bit set. The current quirk still leaves room for races because
it requires two consecutive ACK commands to be sent.

Refactor and significantly simplify the quirk to fix this:
Send a dummy command and bundle the connector change ack with the
command completion ack in a single UCSI_ACK_CC_CI command.
This removes the need to probe for the quirk.

While there define flag bits for struct ucsi_acpi->flags in ucsi_acpi.c
and don't re-use definitions from ucsi.h for struct ucsi->flags.

Fixes: f3be347ea42d ("usb: ucsi_acpi: Quirk to ack a connector change ack cmd")
Cc: stable@vger.kernel.org
Signed-off-by: Christian A. Ehrhardt <lk@c--e.de>
Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Tested-by: Neil Armstrong <neil.armstrong@linaro.org> # on SM8550-QRD
Link: https://lore.kernel.org/r/20240320073927.1641788-5-lk@c--e.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/typec/ucsi/ucsi_acpi.c |   71 ++++++++++++++++---------------------
 1 file changed, 31 insertions(+), 40 deletions(-)

--- a/drivers/usb/typec/ucsi/ucsi_acpi.c
+++ b/drivers/usb/typec/ucsi/ucsi_acpi.c
@@ -23,10 +23,11 @@ struct ucsi_acpi {
 	void *base;
 	struct completion complete;
 	unsigned long flags;
+#define UCSI_ACPI_SUPPRESS_EVENT	0
+#define UCSI_ACPI_COMMAND_PENDING	1
+#define UCSI_ACPI_ACK_PENDING		2
 	guid_t guid;
 	u64 cmd;
-	bool dell_quirk_probed;
-	bool dell_quirk_active;
 };
 
 static int ucsi_acpi_dsm(struct ucsi_acpi *ua, int func)
@@ -79,9 +80,9 @@ static int ucsi_acpi_sync_write(struct u
 	int ret;
 
 	if (ack)
-		set_bit(ACK_PENDING, &ua->flags);
+		set_bit(UCSI_ACPI_ACK_PENDING, &ua->flags);
 	else
-		set_bit(COMMAND_PENDING, &ua->flags);
+		set_bit(UCSI_ACPI_COMMAND_PENDING, &ua->flags);
 
 	ret = ucsi_acpi_async_write(ucsi, offset, val, val_len);
 	if (ret)
@@ -92,9 +93,9 @@ static int ucsi_acpi_sync_write(struct u
 
 out_clear_bit:
 	if (ack)
-		clear_bit(ACK_PENDING, &ua->flags);
+		clear_bit(UCSI_ACPI_ACK_PENDING, &ua->flags);
 	else
-		clear_bit(COMMAND_PENDING, &ua->flags);
+		clear_bit(UCSI_ACPI_COMMAND_PENDING, &ua->flags);
 
 	return ret;
 }
@@ -129,51 +130,40 @@ static const struct ucsi_operations ucsi
 };
 
 /*
- * Some Dell laptops expect that an ACK command with the
- * UCSI_ACK_CONNECTOR_CHANGE bit set is followed by a (separate)
- * ACK command that only has the UCSI_ACK_COMMAND_COMPLETE bit set.
- * If this is not done events are not delivered to OSPM and
- * subsequent commands will timeout.
+ * Some Dell laptops don't like ACK commands with the
+ * UCSI_ACK_CONNECTOR_CHANGE but not the UCSI_ACK_COMMAND_COMPLETE
+ * bit set. To work around this send a dummy command and bundle the
+ * UCSI_ACK_CONNECTOR_CHANGE with the UCSI_ACK_COMMAND_COMPLETE
+ * for the dummy command.
  */
 static int
 ucsi_dell_sync_write(struct ucsi *ucsi, unsigned int offset,
 		     const void *val, size_t val_len)
 {
 	struct ucsi_acpi *ua = ucsi_get_drvdata(ucsi);
-	u64 cmd = *(u64 *)val, ack = 0;
+	u64 cmd = *(u64 *)val;
+	u64 dummycmd = UCSI_GET_CAPABILITY;
 	int ret;
 
-	if (UCSI_COMMAND(cmd) == UCSI_ACK_CC_CI &&
-	    cmd & UCSI_ACK_CONNECTOR_CHANGE)
-		ack = UCSI_ACK_CC_CI | UCSI_ACK_COMMAND_COMPLETE;
+	if (cmd == (UCSI_ACK_CC_CI | UCSI_ACK_CONNECTOR_CHANGE)) {
+		cmd |= UCSI_ACK_COMMAND_COMPLETE;
 
-	ret = ucsi_acpi_sync_write(ucsi, offset, val, val_len);
-	if (ret != 0)
-		return ret;
-	if (ack == 0)
-		return ret;
-
-	if (!ua->dell_quirk_probed) {
-		ua->dell_quirk_probed = true;
+		/*
+		 * The UCSI core thinks it is sending a connector change ack
+		 * and will accept new connector change events. We don't want
+		 * this to happen for the dummy command as its response will
+		 * still report the very event that the core is trying to clear.
+		 */
+		set_bit(UCSI_ACPI_SUPPRESS_EVENT, &ua->flags);
+		ret = ucsi_acpi_sync_write(ucsi, UCSI_CONTROL, &dummycmd,
+					   sizeof(dummycmd));
+		clear_bit(UCSI_ACPI_SUPPRESS_EVENT, &ua->flags);
 
-		cmd = UCSI_GET_CAPABILITY;
-		ret = ucsi_acpi_sync_write(ucsi, UCSI_CONTROL, &cmd,
-					   sizeof(cmd));
-		if (ret == 0)
-			return ucsi_acpi_sync_write(ucsi, UCSI_CONTROL,
-						    &ack, sizeof(ack));
-		if (ret != -ETIMEDOUT)
+		if (ret < 0)
 			return ret;
-
-		ua->dell_quirk_active = true;
-		dev_err(ua->dev, "Firmware bug: Additional ACK required after ACKing a connector change.\n");
-		dev_err(ua->dev, "Firmware bug: Enabling workaround\n");
 	}
 
-	if (!ua->dell_quirk_active)
-		return ret;
-
-	return ucsi_acpi_sync_write(ucsi, UCSI_CONTROL, &ack, sizeof(ack));
+	return ucsi_acpi_sync_write(ucsi, UCSI_CONTROL, &cmd, sizeof(cmd));
 }
 
 static const struct ucsi_operations ucsi_dell_ops = {
@@ -209,13 +199,14 @@ static void ucsi_acpi_notify(acpi_handle
 	if (ret)
 		return;
 
-	if (UCSI_CCI_CONNECTOR(cci))
+	if (UCSI_CCI_CONNECTOR(cci) &&
+	    !test_bit(UCSI_ACPI_SUPPRESS_EVENT, &ua->flags))
 		ucsi_connector_change(ua->ucsi, UCSI_CCI_CONNECTOR(cci));
 
 	if (cci & UCSI_CCI_ACK_COMPLETE && test_bit(ACK_PENDING, &ua->flags))
 		complete(&ua->complete);
 	if (cci & UCSI_CCI_COMMAND_COMPLETE &&
-	    test_bit(COMMAND_PENDING, &ua->flags))
+	    test_bit(UCSI_ACPI_COMMAND_PENDING, &ua->flags))
 		complete(&ua->complete);
 }
 


