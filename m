Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AA8F168DC
	for <patches@lists.linux.dev>; Mon, 22 May 2023 19:28:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECB40C433D2;
	Mon, 22 May 2023 19:28:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684783681;
	bh=x94HLNRbcLTPOqzvs73lGBziHJYvCWq2DfQX91kQl4k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oQe9JswS9779ddBGDI6y+IOeMucRSAXCViTri9TVrmpoOF57PyK9R8oERCyK4xYx8
	 NTXAxt51t9sx8edc0jD60wv8WmvhpmCMFQjsEgbxtd2WN/PlM6G9rCXaM4ZJDL73wY
	 pmZ/sKuT7wTVMiy0L79d2rS9PBd1R0A8LtSFdExQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Samuel=20=C4=8Cavoj?= <samuel@cavoj.net>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 127/292] usb: typec: ucsi: acpi: add quirk for ASUS Zenbook UM325
Date: Mon, 22 May 2023 20:08:04 +0100
Message-Id: <20230522190409.142255780@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230522190405.880733338@linuxfoundation.org>
References: <20230522190405.880733338@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Samuel Čavoj <samuel@cavoj.net>

[ Upstream commit 326e1c208f3f24d14b93f910b8ae32c94923d22c ]

On some ACPI platforms (namely the ASUS Zenbook UM325) the _DSM method must
not be called after a notification is received but instead the mailbox
should be read immediately from RAM. This is because the ACPI interrupt
handler destroys the CCI in ERAM after copying to system memory, and when
_DSM is later called to perform a second copy, it retrieves a garbage
value.

Instead, the _DSM(read) method should only be called when necessary, i.e.
for polling the state after reset and for retrieving the version. Other
reads should not call _DSM and only peek into the RAM region.

This adds a separate read operation for the Zenbook that syncs the
ACPI mailbox only with polled commands.

Link: https://lore.kernel.org/linux-usb/20210823180626.tb6m7h5tp6adhvt2@fastboi.localdomain/
Signed-off-by: Samuel Čavoj <samuel@cavoj.net>
[ heikki : handling everything in ucsi_acpi.c with DMI quirk ]
Signed-off-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Link: https://lore.kernel.org/r/20230405134456.49607-1-heikki.krogerus@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/typec/ucsi/ucsi_acpi.c | 44 ++++++++++++++++++++++++++++--
 1 file changed, 42 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/typec/ucsi/ucsi_acpi.c b/drivers/usb/typec/ucsi/ucsi_acpi.c
index 62206a6b8ea75..217355f1f9b94 100644
--- a/drivers/usb/typec/ucsi/ucsi_acpi.c
+++ b/drivers/usb/typec/ucsi/ucsi_acpi.c
@@ -9,6 +9,7 @@
 #include <linux/platform_device.h>
 #include <linux/module.h>
 #include <linux/acpi.h>
+#include <linux/dmi.h>
 
 #include "ucsi.h"
 
@@ -23,6 +24,7 @@ struct ucsi_acpi {
 	struct completion complete;
 	unsigned long flags;
 	guid_t guid;
+	u64 cmd;
 };
 
 static int ucsi_acpi_dsm(struct ucsi_acpi *ua, int func)
@@ -62,6 +64,7 @@ static int ucsi_acpi_async_write(struct ucsi *ucsi, unsigned int offset,
 	struct ucsi_acpi *ua = ucsi_get_drvdata(ucsi);
 
 	memcpy(ua->base + offset, val, val_len);
+	ua->cmd = *(u64 *)val;
 
 	return ucsi_acpi_dsm(ua, UCSI_DSM_FUNC_WRITE);
 }
@@ -93,13 +96,46 @@ static const struct ucsi_operations ucsi_acpi_ops = {
 	.async_write = ucsi_acpi_async_write
 };
 
+static int
+ucsi_zenbook_read(struct ucsi *ucsi, unsigned int offset, void *val, size_t val_len)
+{
+	struct ucsi_acpi *ua = ucsi_get_drvdata(ucsi);
+	int ret;
+
+	if (offset == UCSI_VERSION || UCSI_COMMAND(ua->cmd) == UCSI_PPM_RESET) {
+		ret = ucsi_acpi_dsm(ua, UCSI_DSM_FUNC_READ);
+		if (ret)
+			return ret;
+	}
+
+	memcpy(val, ua->base + offset, val_len);
+
+	return 0;
+}
+
+static const struct ucsi_operations ucsi_zenbook_ops = {
+	.read = ucsi_zenbook_read,
+	.sync_write = ucsi_acpi_sync_write,
+	.async_write = ucsi_acpi_async_write
+};
+
+static const struct dmi_system_id zenbook_dmi_id[] = {
+	{
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "ASUSTeK COMPUTER INC."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "ZenBook UX325UA_UM325UA"),
+		},
+	},
+	{ }
+};
+
 static void ucsi_acpi_notify(acpi_handle handle, u32 event, void *data)
 {
 	struct ucsi_acpi *ua = data;
 	u32 cci;
 	int ret;
 
-	ret = ucsi_acpi_read(ua->ucsi, UCSI_CCI, &cci, sizeof(cci));
+	ret = ua->ucsi->ops->read(ua->ucsi, UCSI_CCI, &cci, sizeof(cci));
 	if (ret)
 		return;
 
@@ -114,6 +150,7 @@ static void ucsi_acpi_notify(acpi_handle handle, u32 event, void *data)
 static int ucsi_acpi_probe(struct platform_device *pdev)
 {
 	struct acpi_device *adev = ACPI_COMPANION(&pdev->dev);
+	const struct ucsi_operations *ops = &ucsi_acpi_ops;
 	struct ucsi_acpi *ua;
 	struct resource *res;
 	acpi_status status;
@@ -143,7 +180,10 @@ static int ucsi_acpi_probe(struct platform_device *pdev)
 	init_completion(&ua->complete);
 	ua->dev = &pdev->dev;
 
-	ua->ucsi = ucsi_create(&pdev->dev, &ucsi_acpi_ops);
+	if (dmi_check_system(zenbook_dmi_id))
+		ops = &ucsi_zenbook_ops;
+
+	ua->ucsi = ucsi_create(&pdev->dev, ops);
 	if (IS_ERR(ua->ucsi))
 		return PTR_ERR(ua->ucsi);
 
-- 
2.39.2



