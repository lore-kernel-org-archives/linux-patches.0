Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B8243451AF;
	Fri, 21 Nov 2025 13:48:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763732901; cv=none; b=mooU0tFcgtvQarwGtkFKfG0UtjQw9sK1HlY7OVX73aMafrTUI6GiT2qJmUMrxx3y3H4gm6g7kJ8FI1lEbPKquN77CRsuC4GlFduEJzXlHb6ZpXtz8GilCf5EWQ0Gu5PStwDWc7L9ljdCRzLojNp5clIZcZsJkpXiU/IE2EVOM30=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763732901; c=relaxed/simple;
	bh=ENojRCHsYBNRuGrak3pSIwYGwOXzHbU9xDhd/ncYtRc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JlTXJg+3Iq0NXR2mxyr9pBpM+qQiz68mBkaiWrU617BjSeV97sWNubEpC34uJj4HP6jkRHirpSzuAN4S1IuK7NNtdA2ExnKCFPc12rBQFKzAh1pptpGnxkPbd5r8N4Bup8uGhiVTfFfbQHkqdhiVDD6MNBIYCi940p18B5nDTNY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rAkWIW0/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rAkWIW0/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36BD3C4CEF1;
	Fri, 21 Nov 2025 13:48:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763732900;
	bh=ENojRCHsYBNRuGrak3pSIwYGwOXzHbU9xDhd/ncYtRc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rAkWIW0/JgCvB5jBJKqdc9i+tHlzDsCzdX2XXemQC3cbcdKvqj1mxUa42Ut7N107K
	 KZbAJgta3W21wCUKnY2Gbje8UpltEA0ljYGt56p4BoV51qLhnnSJDarDvgAz1ywVF5
	 nJdGj6W5RTadJDIHiFq49IzmWFhAhpIsIDMDno5g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Mario Limonciello (AMD)" <superm1@kernel.org>,
	Benjamin Tissoires <bentiss@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 239/529] HID: i2c-hid: Resolve touchpad issues on Dell systems during S4
Date: Fri, 21 Nov 2025 14:08:58 +0100
Message-ID: <20251121130239.522193928@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130230.985163914@linuxfoundation.org>
References: <20251121130230.985163914@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Mario Limonciello (AMD) <superm1@kernel.org>

[ Upstream commit 7d62beb102d6fa9a4e5e874be7fbf47a62fcc4f6 ]

Dell systems utilize an EC-based touchpad emulation when the ACPI
touchpad _DSM is not invoked. This emulation acts as a secondary
master on the I2C bus, designed for scenarios where the I2C touchpad
driver is absent, such as in BIOS menus. Typically, loading the
i2c-hid module triggers the _DSM at initialization, disabling the
EC-based emulation.

However, if the i2c-hid module is missing from the boot kernel
used for hibernation snapshot restoration, the _DSM remains
uncalled, resulting in dual masters on the I2C bus and
subsequent arbitration errors. This issue arises when i2c-hid
resides in the rootfs instead of the kernel or initramfs.

To address this, switch from using the SYSTEM_SLEEP_PM_OPS()
macro to dedicated callbacks, introducing a specific
callback for restoring the S4 image. This callback ensures
the _DSM is invoked.

Signed-off-by: Mario Limonciello (AMD) <superm1@kernel.org>
Signed-off-by: Benjamin Tissoires <bentiss@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/i2c-hid/i2c-hid-acpi.c |  8 ++++++++
 drivers/hid/i2c-hid/i2c-hid-core.c | 28 +++++++++++++++++++++++++++-
 drivers/hid/i2c-hid/i2c-hid.h      |  2 ++
 3 files changed, 37 insertions(+), 1 deletion(-)

diff --git a/drivers/hid/i2c-hid/i2c-hid-acpi.c b/drivers/hid/i2c-hid/i2c-hid-acpi.c
index 1b49243adb16a..abd700a101f46 100644
--- a/drivers/hid/i2c-hid/i2c-hid-acpi.c
+++ b/drivers/hid/i2c-hid/i2c-hid-acpi.c
@@ -76,6 +76,13 @@ static int i2c_hid_acpi_get_descriptor(struct i2c_hid_acpi *ihid_acpi)
 	return hid_descriptor_address;
 }
 
+static void i2c_hid_acpi_restore_sequence(struct i2chid_ops *ops)
+{
+	struct i2c_hid_acpi *ihid_acpi = container_of(ops, struct i2c_hid_acpi, ops);
+
+	i2c_hid_acpi_get_descriptor(ihid_acpi);
+}
+
 static void i2c_hid_acpi_shutdown_tail(struct i2chid_ops *ops)
 {
 	struct i2c_hid_acpi *ihid_acpi = container_of(ops, struct i2c_hid_acpi, ops);
@@ -96,6 +103,7 @@ static int i2c_hid_acpi_probe(struct i2c_client *client)
 
 	ihid_acpi->adev = ACPI_COMPANION(dev);
 	ihid_acpi->ops.shutdown_tail = i2c_hid_acpi_shutdown_tail;
+	ihid_acpi->ops.restore_sequence = i2c_hid_acpi_restore_sequence;
 
 	ret = i2c_hid_acpi_get_descriptor(ihid_acpi);
 	if (ret < 0)
diff --git a/drivers/hid/i2c-hid/i2c-hid-core.c b/drivers/hid/i2c-hid/i2c-hid-core.c
index 3dcdd3368b463..172b783274201 100644
--- a/drivers/hid/i2c-hid/i2c-hid-core.c
+++ b/drivers/hid/i2c-hid/i2c-hid-core.c
@@ -937,6 +937,14 @@ static void i2c_hid_core_shutdown_tail(struct i2c_hid *ihid)
 	ihid->ops->shutdown_tail(ihid->ops);
 }
 
+static void i2c_hid_core_restore_sequence(struct i2c_hid *ihid)
+{
+	if (!ihid->ops->restore_sequence)
+		return;
+
+	ihid->ops->restore_sequence(ihid->ops);
+}
+
 static int i2c_hid_core_suspend(struct i2c_hid *ihid, bool force_poweroff)
 {
 	struct i2c_client *client = ihid->client;
@@ -1320,8 +1328,26 @@ static int i2c_hid_core_pm_resume(struct device *dev)
 	return i2c_hid_core_resume(ihid);
 }
 
+static int i2c_hid_core_pm_restore(struct device *dev)
+{
+	struct i2c_client *client = to_i2c_client(dev);
+	struct i2c_hid *ihid = i2c_get_clientdata(client);
+
+	if (ihid->is_panel_follower)
+		return 0;
+
+	i2c_hid_core_restore_sequence(ihid);
+
+	return i2c_hid_core_resume(ihid);
+}
+
 const struct dev_pm_ops i2c_hid_core_pm = {
-	SYSTEM_SLEEP_PM_OPS(i2c_hid_core_pm_suspend, i2c_hid_core_pm_resume)
+	.suspend = pm_sleep_ptr(i2c_hid_core_pm_suspend),
+	.resume = pm_sleep_ptr(i2c_hid_core_pm_resume),
+	.freeze = pm_sleep_ptr(i2c_hid_core_pm_suspend),
+	.thaw = pm_sleep_ptr(i2c_hid_core_pm_resume),
+	.poweroff = pm_sleep_ptr(i2c_hid_core_pm_suspend),
+	.restore = pm_sleep_ptr(i2c_hid_core_pm_restore),
 };
 EXPORT_SYMBOL_GPL(i2c_hid_core_pm);
 
diff --git a/drivers/hid/i2c-hid/i2c-hid.h b/drivers/hid/i2c-hid/i2c-hid.h
index 2c7b66d5caa0f..1724a435c783a 100644
--- a/drivers/hid/i2c-hid/i2c-hid.h
+++ b/drivers/hid/i2c-hid/i2c-hid.h
@@ -27,11 +27,13 @@ static inline u32 i2c_hid_get_dmi_quirks(const u16 vendor, const u16 product)
  * @power_up: do sequencing to power up the device.
  * @power_down: do sequencing to power down the device.
  * @shutdown_tail: called at the end of shutdown.
+ * @restore_sequence: hibernation restore sequence.
  */
 struct i2chid_ops {
 	int (*power_up)(struct i2chid_ops *ops);
 	void (*power_down)(struct i2chid_ops *ops);
 	void (*shutdown_tail)(struct i2chid_ops *ops);
+	void (*restore_sequence)(struct i2chid_ops *ops);
 };
 
 int i2c_hid_core_probe(struct i2c_client *client, struct i2chid_ops *ops,
-- 
2.51.0



