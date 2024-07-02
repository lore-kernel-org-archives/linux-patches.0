Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 745E41BD005;
	Tue,  2 Jul 2024 17:32:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719941522; cv=none; b=ZI0SnBx7kz0+q+eD8SSRbVFAPbxc5/2LbOivQBCabtDTOJLsl6/rEuiyOoFirVmr933Q2Z02GE0V23dG1CB0yaGOvurXLCw4ndt1JTP0RpLD80D8QYX/9qCvnq1fhxOEy0cBKSTpMCLz0rfLYXc8qY9MHBrLOvF4WNn1RoJpaPY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719941522; c=relaxed/simple;
	bh=FBQZ8n/OQ4G8/3Fofd5wL3/EB9aH7MF5pGFjMJF0kRw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B7N25oZRsRG6Wv7mmHsaJohcv2L3L00T7KuJ+zT++YRA7a6Bmwmy6FdvrpNj+ur1cDHlZ7QP5P5tUNg5IbsjOKczzLdwgQ3n8dn0oWEBVcJpxNXx+1/8YRQvkux5yjD61/3WmwWe641EdE41rD/7dGK+l1G2PjEWM/eFVZSo34A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GhH1JgVz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GhH1JgVz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6167C116B1;
	Tue,  2 Jul 2024 17:32:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719941522;
	bh=FBQZ8n/OQ4G8/3Fofd5wL3/EB9aH7MF5pGFjMJF0kRw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GhH1JgVzpdPY6tBr90FkSnbDAyHTFrpocxSzuI3px3NKfLVeX7l5oxHLUgLoJ+Nux
	 KdiUQhbJLsdOtvdxbxekkPO1K3MfLIFUWlXBL4Zc2trLA3o4wY3omwyavs5YyLPGOY
	 n1ALAuNVA4J1oeHwE2tLbRYsoq34eMU+EL1AkOjc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fabrice Gasnier <fabrice.gasnier@foss.st.com>,
	stable <stable@kernel.org>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>
Subject: [PATCH 6.1 089/128] usb: ucsi: stm32: fix command completion handling
Date: Tue,  2 Jul 2024 19:04:50 +0200
Message-ID: <20240702170229.588760268@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240702170226.231899085@linuxfoundation.org>
References: <20240702170226.231899085@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fabrice Gasnier <fabrice.gasnier@foss.st.com>

commit 8e1ec117efdfd4b2f59f57bd0ad16b4edf5b963f upstream.

Sometimes errors are seen, when doing DR swap, like:
[   24.672481] ucsi-stm32g0-i2c 0-0035: UCSI_GET_PDOS failed (-5)
[   24.720188] ucsi-stm32g0-i2c 0-0035: ucsi_handle_connector_change:
 GET_CONNECTOR_STATUS failed (-5)

There may be some race, which lead to read CCI, before the command complete
flag is set, hence returning -EIO. Similar fix has been done also in
ucsi_acpi [1].

In case of a spurious or otherwise delayed notification it is
possible that CCI still reports the previous completion. The
UCSI spec is aware of this and provides two completion bits in
CCI, one for normal commands and one for acks. As acks and commands
alternate the notification handler can determine if the completion
bit is from the current command.

To fix this add the ACK_PENDING bit for ucsi_stm32g0 and only complete
commands if the completion bit matches.

[1] https://lore.kernel.org/lkml/20240121204123.275441-3-lk@c--e.de/

Fixes: 72849d4fcee7 ("usb: typec: ucsi: stm32g0: add support for stm32g0 controller")
Signed-off-by: Fabrice Gasnier <fabrice.gasnier@foss.st.com>
Link: https://lore.kernel.org/stable/20240612124656.2305603-1-fabrice.gasnier%40foss.st.com
Cc: stable <stable@kernel.org>
Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Link: https://lore.kernel.org/r/20240612124656.2305603-1-fabrice.gasnier@foss.st.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/typec/ucsi/ucsi_stm32g0.c |   19 +++++++++++++++----
 1 file changed, 15 insertions(+), 4 deletions(-)

--- a/drivers/usb/typec/ucsi/ucsi_stm32g0.c
+++ b/drivers/usb/typec/ucsi/ucsi_stm32g0.c
@@ -64,6 +64,7 @@ struct ucsi_stm32g0 {
 	struct completion complete;
 	struct device *dev;
 	unsigned long flags;
+#define ACK_PENDING	2
 	const char *fw_name;
 	struct ucsi *ucsi;
 	bool suspended;
@@ -395,9 +396,13 @@ static int ucsi_stm32g0_sync_write(struc
 				   size_t len)
 {
 	struct ucsi_stm32g0 *g0 = ucsi_get_drvdata(ucsi);
+	bool ack = UCSI_COMMAND(*(u64 *)val) == UCSI_ACK_CC_CI;
 	int ret;
 
-	set_bit(COMMAND_PENDING, &g0->flags);
+	if (ack)
+		set_bit(ACK_PENDING, &g0->flags);
+	else
+		set_bit(COMMAND_PENDING, &g0->flags);
 
 	ret = ucsi_stm32g0_async_write(ucsi, offset, val, len);
 	if (ret)
@@ -405,9 +410,14 @@ static int ucsi_stm32g0_sync_write(struc
 
 	if (!wait_for_completion_timeout(&g0->complete, msecs_to_jiffies(5000)))
 		ret = -ETIMEDOUT;
+	else
+		return 0;
 
 out_clear_bit:
-	clear_bit(COMMAND_PENDING, &g0->flags);
+	if (ack)
+		clear_bit(ACK_PENDING, &g0->flags);
+	else
+		clear_bit(COMMAND_PENDING, &g0->flags);
 
 	return ret;
 }
@@ -428,8 +438,9 @@ static irqreturn_t ucsi_stm32g0_irq_hand
 	if (UCSI_CCI_CONNECTOR(cci))
 		ucsi_connector_change(g0->ucsi, UCSI_CCI_CONNECTOR(cci));
 
-	if (test_bit(COMMAND_PENDING, &g0->flags) &&
-	    cci & (UCSI_CCI_ACK_COMPLETE | UCSI_CCI_COMMAND_COMPLETE))
+	if (cci & UCSI_CCI_ACK_COMPLETE && test_and_clear_bit(ACK_PENDING, &g0->flags))
+		complete(&g0->complete);
+	if (cci & UCSI_CCI_COMMAND_COMPLETE && test_and_clear_bit(COMMAND_PENDING, &g0->flags))
 		complete(&g0->complete);
 
 	return IRQ_HANDLED;


