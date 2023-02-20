Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A0C263B8
	for <patches@lists.linux.dev>; Mon, 20 Feb 2023 13:52:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 856A2C4339B;
	Mon, 20 Feb 2023 13:52:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1676901126;
	bh=oPJHD+dMAaWecX0omUJerSrS8jVbgB3VJkGMVr5D3Po=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iontSw2/m6Haysro4QCg1up+WpUUX8VfjGeKcL2KzBCrWpnfrh723bSx27H9lNd0r
	 68UgMMY0J0PQljGbMhDEMjUcjYxpiHVcHwobFDKKMDk1IaW1j/7Q/4OWYM7gn/9naQ
	 VyywDxZ3MBWnhAH/yNviJBSPbgM+yLJ3kLFMJ8Xw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kai-Heng Feng <kai.heng.feng@canonical.com>,
	Xaver Hugl <xaver.hugl@gmail.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH 5.15 40/83] platform/x86/amd: pmc: Disable IRQ1 wakeup for RN/CZN
Date: Mon, 20 Feb 2023 14:36:13 +0100
Message-Id: <20230220133555.051807437@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230220133553.669025851@linuxfoundation.org>
References: <20230220133553.669025851@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Mario Limonciello <mario.limonciello@amd.com>

commit 8e60615e8932167057b363c11a7835da7f007106 upstream.

By default when the system is configured for low power idle in the FADT
the keyboard is set up as a wake source.  This matches the behavior that
Windows uses for Modern Standby as well.

It has been reported that a variety of AMD based designs there are
spurious wakeups are happening where two IRQ sources are active.

For example:
```
PM: Triggering wakeup from IRQ 9
PM: Triggering wakeup from IRQ 1
```

In these designs IRQ 9 is the ACPI SCI and IRQ 1 is the keyboard.
One way to trigger this problem is to suspend the laptop and then unplug
the AC adapter.  The SOC will be in a hardware sleep state and plugging
in the AC adapter returns control to the kernel's s2idle loop.

Normally if just IRQ 9 was active the s2idle loop would advance any EC
transactions and no other IRQ being active would cause the s2idle loop
to put the SOC back into hardware sleep state.

When this bug occurred IRQ 1 is also active even if no keyboard activity
occurred. This causes the s2idle loop to break and the system to wake.

This is a platform firmware bug triggering IRQ1 without keyboard activity.
This occurs in Windows as well, but Windows will enter "SW DRIPS" and
then with no activity enters back into "HW DRIPS" (hardware sleep state).

This issue affects Renoir, Lucienne, Cezanne, and Barcelo platforms. It
does not happen on newer systems such as Mendocino or Rembrandt.

It's been fixed in newer platform firmware.  To avoid triggering the bug
on older systems check the SMU F/W version and adjust the policy at suspend
time for s2idle wakeup from keyboard on these systems. A lot of thought
and experimentation has been given around the timing of disabling IRQ1,
and to make it work the "suspend" PM callback is restored.

Reported-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
Reported-by: Xaver Hugl <xaver.hugl@gmail.com>
Link: https://gitlab.freedesktop.org/drm/amd/-/issues/2115
Link: https://gitlab.freedesktop.org/drm/amd/-/issues/1951
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Link: https://lore.kernel.org/r/20230120191519.15926-1-mario.limonciello@amd.com
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
[ This has been hand modified for missing dependency commits. ]
Link: https://gitlab.freedesktop.org/drm/amd/-/issues/1921#note_1770257
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/platform/x86/amd-pmc.c |   37 +++++++++++++++++++++++++++++++++++++
 1 file changed, 37 insertions(+)

--- a/drivers/platform/x86/amd-pmc.c
+++ b/drivers/platform/x86/amd-pmc.c
@@ -20,6 +20,7 @@
 #include <linux/module.h>
 #include <linux/pci.h>
 #include <linux/platform_device.h>
+#include <linux/serio.h>
 #include <linux/suspend.h>
 #include <linux/seq_file.h>
 #include <linux/uaccess.h>
@@ -412,12 +413,48 @@ static int amd_pmc_get_os_hint(struct am
 	return -EINVAL;
 }
 
+static int amd_pmc_czn_wa_irq1(struct amd_pmc_dev *pdev)
+{
+	struct device *d;
+	int rc;
+
+	if (!pdev->major) {
+		rc = amd_pmc_get_smu_version(pdev);
+		if (rc)
+			return rc;
+	}
+
+	if (pdev->major > 64 || (pdev->major == 64 && pdev->minor > 65))
+		return 0;
+
+	d = bus_find_device_by_name(&serio_bus, NULL, "serio0");
+	if (!d)
+		return 0;
+	if (device_may_wakeup(d)) {
+		dev_info_once(d, "Disabling IRQ1 wakeup source to avoid platform firmware bug\n");
+		disable_irq_wake(1);
+		device_set_wakeup_enable(d, false);
+	}
+	put_device(d);
+
+	return 0;
+}
+
 static int __maybe_unused amd_pmc_suspend(struct device *dev)
 {
 	struct amd_pmc_dev *pdev = dev_get_drvdata(dev);
 	int rc;
 	u8 msg;
 
+	if (pdev->cpu_id == AMD_CPU_ID_CZN) {
+		int rc = amd_pmc_czn_wa_irq1(pdev);
+
+		if (rc) {
+			dev_err(pdev->dev, "failed to adjust keyboard wakeup: %d\n", rc);
+			return rc;
+		}
+	}
+
 	/* Reset and Start SMU logging - to monitor the s0i3 stats */
 	amd_pmc_send_cmd(pdev, 0, NULL, SMU_MSG_LOG_RESET, 0);
 	amd_pmc_send_cmd(pdev, 0, NULL, SMU_MSG_LOG_START, 0);


