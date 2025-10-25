Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37636309EFB;
	Sat, 25 Oct 2025 16:23:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761409399; cv=none; b=ELgidESwA7tllMuRBm8RdqIgqfHEk7R0iG98dYPxuzOIz/FDsX8jdCXbFoMucDWcuJBYPSMtYCnIMGziXpILckLREm1wbDIwAZMi5sx5204G+3tuTJUVvo8cPJE6qCuO/AlB3OZWbJojDkUacattji2gMSy5l6Uh8cl1ymQEKlo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761409399; c=relaxed/simple;
	bh=lCnyAgnT7PDM/leRfqeFf60I3fmD2796CUK2LBvSXqQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kC8nLhZ9BR0Q/1Y1/OHvzgi92+oygLREx/aW7KrNnltdJp/ApH41AOUO0vCw4GVjO0uJPpflIjPaJI1qZ+OvZzVK4V6TO0RaSxcPCxEP/9fmAnYwdY+L1R3p23aXYfGtLrQ/TS/YJdpetZw+5BPfHXs/wqzBxkoM+d1tXs4y0Ks=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=f4ufs38X; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="f4ufs38X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97026C4CEF5;
	Sat, 25 Oct 2025 16:23:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761409399;
	bh=lCnyAgnT7PDM/leRfqeFf60I3fmD2796CUK2LBvSXqQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=f4ufs38X9OJd7PVGduI11iCs6SYtvoBlDSIRGjWd68DyMdK+GGPQ0atj1rvcB2h15
	 Ljs9aTV8N+ip2ENCzJpgxfrvCAsVpwSnbqkO0TLlX7Lxs8vbV54Ijwees6K9Z9nV2b
	 +2y4ZG4LKxM4VzSOc7tpI4obTrVmMubToqh8BTB88AhwuOlA82tNAeGO9BAkDI2Fpt
	 cUdH6b9NbpU1IZBgfaCDOLu4JLT6diax98wwPjf9Pl8/PnGYRiju4QKhl/LaK16NP+
	 aLk9+zDjra5k3O0UmqPdTnDVk+u1rTG+deyu4CyDviWRaxaRFDpo0/jCW53UumQf5P
	 Ydkfp1FIffxVA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: "Mario Limonciello (AMD)" <superm1@kernel.org>,
	Benjamin Tissoires <bentiss@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	alexander.deucher@amd.com,
	alexandre.f.demers@gmail.com,
	jikos@kernel.org,
	dianders@chromium.org,
	alex.vinarskis@gmail.com,
	treapking@chromium.org,
	dan.carpenter@linaro.org,
	kl@kl.wtf,
	guanwentao@uniontech.com
Subject: [PATCH AUTOSEL 6.17-6.6] HID: i2c-hid: Resolve touchpad issues on Dell systems during S4
Date: Sat, 25 Oct 2025 11:58:56 -0400
Message-ID: <20251025160905.3857885-305-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251025160905.3857885-1-sashal@kernel.org>
References: <20251025160905.3857885-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.17.5
Content-Transfer-Encoding: 8bit

From: "Mario Limonciello (AMD)" <superm1@kernel.org>

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

LLM Generated explanations, may be completely bogus:

YES
- `drivers/hid/i2c-hid/i2c-hid-acpi.c:79-107` adds
  `i2c_hid_acpi_restore_sequence()` so the ACPI backend re-runs
  `i2c_hid_acpi_get_descriptor()` during S4 restore, explicitly invoking
  the touchpad `_DSM` to shut off the EC emulation and eliminate the
  dual-master arbitration errors that break Dell touchpads when the
  resume kernel lacks i2c-hid.
- `drivers/hid/i2c-hid/i2c-hid-core.c:964-1401` introduces
  `i2c_hid_core_restore_sequence()` and a dedicated
  `i2c_hid_core_pm_restore()` callback, wiring the new hook into the
  hibernation restore path while keeping suspend/freeze/thaw/poweroff
  behaviour identical to the previous `SYSTEM_SLEEP_PM_OPS()` setup;
  only the restore flow gains the extra firmware handshake.
- `drivers/hid/i2c-hid/i2c-hid.h:32-36` extends `struct i2chid_ops` with
  an optional `restore_sequence` pointer; all back-ends populate this
  struct via zeroed allocations, so non-ACPI transports simply skip the
  hook, containing the change to the affected platform.
- The patch fixes a concrete, user-visible hibernation bug without
  altering normal resume logic, reuses already-tested `_DSM` code, and
  adds only an idempotent call during restore, making it a low-risk,
  well-scoped candidate for stable backporting.
- Recommended follow-up: run an S4 hibernation/resume cycle on an
  affected Dell system with i2c-hid built as a module to confirm the
  arbitration errors disappear.

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
index 30ebde1273be3..63f46a2e57882 100644
--- a/drivers/hid/i2c-hid/i2c-hid-core.c
+++ b/drivers/hid/i2c-hid/i2c-hid-core.c
@@ -961,6 +961,14 @@ static void i2c_hid_core_shutdown_tail(struct i2c_hid *ihid)
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
@@ -1370,8 +1378,26 @@ static int i2c_hid_core_pm_resume(struct device *dev)
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

