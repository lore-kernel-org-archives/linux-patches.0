Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC058145B0B;
	Tue, 27 Feb 2024 13:48:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709041715; cv=none; b=JksJrDubuwmOE0/CblM0bFwe+X0HU5aJUWAwWbhyy77iK79TRj68NuVNlgBjHCFuHe/D/fF7Kgb8ucYn+5VC4fbHubBS+BVh3Jttvy3CNNTQ0D08KHeIDvPWCude8+KPnPvYhjbKjHrb2MxU2bEBq0gBNKEeqenj47fqgak1f1U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709041715; c=relaxed/simple;
	bh=p+7Enuo6COZYqYhlrXTIL1N0jHECdd/2z3MucEKRuMA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uhD+iguoBpJIoIwruBWYqlXtEf3OcRdIBBU4L0q1rSMVQWHxtaRunvOOGTnUtOEa/oRTGvNHggaMgbEnjqck7dB1mo9T6zNIeteNPVxpwh31Pr11pSmQj45mg+N9sl2uXzfadgywM+WnkQF44X6C0oVSAW5I8RId7/quy0ObtPI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k/CdKoyU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k/CdKoyU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69520C433C7;
	Tue, 27 Feb 2024 13:48:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709041714;
	bh=p+7Enuo6COZYqYhlrXTIL1N0jHECdd/2z3MucEKRuMA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=k/CdKoyUrZtjJEYgHDbHVKBWhs1Ma3fx1R1PSWTbQVhRGicbLy2j5QK3jcbxqqhzs
	 IW72d1yibs+BhVkF8qm0h7m96QsQgGCtzeoidRjNoVr32NnwX+hnv2hUPLu7XkV572
	 ellVmYVD6r5alCiG9FCFyN6fbLoBovmfnaapAXrM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Christian A. Ehrhardt" <lk@c--e.de>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 045/299] usb: ucsi_acpi: Quirk to ack a connector change ack cmd
Date: Tue, 27 Feb 2024 14:22:36 +0100
Message-ID: <20240227131627.433152519@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131625.847743063@linuxfoundation.org>
References: <20240227131625.847743063@linuxfoundation.org>
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

From: Christian A. Ehrhardt <lk@c--e.de>

[ Upstream commit f3be347ea42dbb0358cd8b2d8dc543a23b70a976 ]

The PPM on some Dell laptops seems to expect that the ACK_CC_CI
command to clear the connector change notification is in turn
followed by another ACK_CC_CI to acknowledge the ACK_CC_CI command
itself. This is in violation of the UCSI spec that states:

    "The only notification that is not acknowledged by the OPM is
     the command completion notification for the ACK_CC_CI or the
     PPM_RESET command."

Add a quirk to send this ack anyway.
Apply the quirk to all Dell systems.

On the first command that acks a connector change send a dummy
command to determine if it runs into a timeout. Only activate
the quirk if it does. This ensure that we do not break Dell
systems that do not need the quirk.

Signed-off-by: "Christian A. Ehrhardt" <lk@c--e.de>
Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Link: https://lore.kernel.org/r/20240121204123.275441-4-lk@c--e.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/typec/ucsi/ucsi_acpi.c | 71 ++++++++++++++++++++++++++++--
 1 file changed, 68 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/typec/ucsi/ucsi_acpi.c b/drivers/usb/typec/ucsi/ucsi_acpi.c
index fa222080887d5..928eacbeb21ac 100644
--- a/drivers/usb/typec/ucsi/ucsi_acpi.c
+++ b/drivers/usb/typec/ucsi/ucsi_acpi.c
@@ -25,6 +25,8 @@ struct ucsi_acpi {
 	unsigned long flags;
 	guid_t guid;
 	u64 cmd;
+	bool dell_quirk_probed;
+	bool dell_quirk_active;
 };
 
 static int ucsi_acpi_dsm(struct ucsi_acpi *ua, int func)
@@ -126,12 +128,73 @@ static const struct ucsi_operations ucsi_zenbook_ops = {
 	.async_write = ucsi_acpi_async_write
 };
 
-static const struct dmi_system_id zenbook_dmi_id[] = {
+/*
+ * Some Dell laptops expect that an ACK command with the
+ * UCSI_ACK_CONNECTOR_CHANGE bit set is followed by a (separate)
+ * ACK command that only has the UCSI_ACK_COMMAND_COMPLETE bit set.
+ * If this is not done events are not delivered to OSPM and
+ * subsequent commands will timeout.
+ */
+static int
+ucsi_dell_sync_write(struct ucsi *ucsi, unsigned int offset,
+		     const void *val, size_t val_len)
+{
+	struct ucsi_acpi *ua = ucsi_get_drvdata(ucsi);
+	u64 cmd = *(u64 *)val, ack = 0;
+	int ret;
+
+	if (UCSI_COMMAND(cmd) == UCSI_ACK_CC_CI &&
+	    cmd & UCSI_ACK_CONNECTOR_CHANGE)
+		ack = UCSI_ACK_CC_CI | UCSI_ACK_COMMAND_COMPLETE;
+
+	ret = ucsi_acpi_sync_write(ucsi, offset, val, val_len);
+	if (ret != 0)
+		return ret;
+	if (ack == 0)
+		return ret;
+
+	if (!ua->dell_quirk_probed) {
+		ua->dell_quirk_probed = true;
+
+		cmd = UCSI_GET_CAPABILITY;
+		ret = ucsi_acpi_sync_write(ucsi, UCSI_CONTROL, &cmd,
+					   sizeof(cmd));
+		if (ret == 0)
+			return ucsi_acpi_sync_write(ucsi, UCSI_CONTROL,
+						    &ack, sizeof(ack));
+		if (ret != -ETIMEDOUT)
+			return ret;
+
+		ua->dell_quirk_active = true;
+		dev_err(ua->dev, "Firmware bug: Additional ACK required after ACKing a connector change.\n");
+		dev_err(ua->dev, "Firmware bug: Enabling workaround\n");
+	}
+
+	if (!ua->dell_quirk_active)
+		return ret;
+
+	return ucsi_acpi_sync_write(ucsi, UCSI_CONTROL, &ack, sizeof(ack));
+}
+
+static const struct ucsi_operations ucsi_dell_ops = {
+	.read = ucsi_acpi_read,
+	.sync_write = ucsi_dell_sync_write,
+	.async_write = ucsi_acpi_async_write
+};
+
+static const struct dmi_system_id ucsi_acpi_quirks[] = {
 	{
 		.matches = {
 			DMI_MATCH(DMI_SYS_VENDOR, "ASUSTeK COMPUTER INC."),
 			DMI_MATCH(DMI_PRODUCT_NAME, "ZenBook UX325UA_UM325UA"),
 		},
+		.driver_data = (void *)&ucsi_zenbook_ops,
+	},
+	{
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
+		},
+		.driver_data = (void *)&ucsi_dell_ops,
 	},
 	{ }
 };
@@ -160,6 +223,7 @@ static int ucsi_acpi_probe(struct platform_device *pdev)
 {
 	struct acpi_device *adev = ACPI_COMPANION(&pdev->dev);
 	const struct ucsi_operations *ops = &ucsi_acpi_ops;
+	const struct dmi_system_id *id;
 	struct ucsi_acpi *ua;
 	struct resource *res;
 	acpi_status status;
@@ -189,8 +253,9 @@ static int ucsi_acpi_probe(struct platform_device *pdev)
 	init_completion(&ua->complete);
 	ua->dev = &pdev->dev;
 
-	if (dmi_check_system(zenbook_dmi_id))
-		ops = &ucsi_zenbook_ops;
+	id = dmi_first_match(ucsi_acpi_quirks);
+	if (id)
+		ops = id->driver_data;
 
 	ua->ucsi = ucsi_create(&pdev->dev, ops);
 	if (IS_ERR(ua->ucsi))
-- 
2.43.0



