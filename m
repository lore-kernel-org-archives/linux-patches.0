Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38B47258ED7;
	Mon, 18 Aug 2025 12:56:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755521795; cv=none; b=OgIV4sQH/YaWv32Vzx+xDye0I+oS3JYn4GOMXY4Ucsf2TLvePxD3nc202GbHkOJlKQOljDtWpX01QpP0feo417Uue/PR5MgYHc536C3RcdifaoboWcS6gSDID6PruRvjjWUiK5o7jMO3uVKXFFJ6kWLFa1mjOUaSO8zIfTFvmNQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755521795; c=relaxed/simple;
	bh=tnTtb+VaSmikiX39VpYKC9pANqTvREJ0tpUSsaVTxmY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ernJQu7b0HYxfJC65UziUi2fEGDQ2Wa5Lxv9d9owuZbLE3xlIfeULHb37AxX245FvGq4PNhuINTQoSj1x3BfvLAotihHK5m1t3dZ6KcSKIzqVhp+8hnNDVeQmGo66tE8WA530e+6HFKsTw2H6DWx2uPl2zTYN7aip2WHH/9h9Hc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bFty7qok; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bFty7qok"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C467C4CEEB;
	Mon, 18 Aug 2025 12:56:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755521795;
	bh=tnTtb+VaSmikiX39VpYKC9pANqTvREJ0tpUSsaVTxmY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bFty7qokVWbIh/zFxqrGto7CXnzRgHs4Hs61aNcgLLy2yNlO8ym0SnQNhH3wbPcT8
	 SQNAqDlSbQlfrMn6qGYKiEiKD/M/zKVRR7VlVLF4YE/gbWUFy7C2G0Y/Fl2hDLV/rJ
	 4S0SzRTpY8k6H0v1USrvjytYHCXn/HCPK8NAB5pY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peng Fan <peng.fan@nxp.com>,
	Sudeep Holla <sudeep.holla@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 125/444] firmware: arm_scmi: power_control: Ensure SCMI_SYSPOWER_IDLE is set early during resume
Date: Mon, 18 Aug 2025 14:42:31 +0200
Message-ID: <20250818124453.600927095@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124448.879659024@linuxfoundation.org>
References: <20250818124448.879659024@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peng Fan <peng.fan@nxp.com>

[ Upstream commit 9a0658d3991e6c82df87584b253454842f22f965 ]

Fix a race condition where a second suspend notification from another
SCMI agent wakes the system before SCMI_SYSPOWER_IDLE is set, leading
to ignored suspend requests. This is due to interrupts triggering early
execution of `scmi_userspace_notifier()` before the SCMI state is updated.

To resolve this, set SCMI_SYSPOWER_IDLE earlier in the device resume
path, prior to `thaw_processes()`. This ensures the SCMI state is
correct when the notifier runs, allowing the system to suspend again
as expected.

On some platforms using SCMI, SCP cannot distinguish between CPU idle
and suspend since both result in cluster power-off. By explicitly setting
the idle state early, the Linux SCMI agent can correctly re-suspend in
response to external notifications.

Signed-off-by: Peng Fan <peng.fan@nxp.com>
Message-Id: <20250704-scmi-pm-v2-2-9316cec2f9cc@nxp.com>
Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../firmware/arm_scmi/scmi_power_control.c    | 22 ++++++++++++++-----
 1 file changed, 17 insertions(+), 5 deletions(-)

diff --git a/drivers/firmware/arm_scmi/scmi_power_control.c b/drivers/firmware/arm_scmi/scmi_power_control.c
index 21f467a92942..ab0cee0d4bec 100644
--- a/drivers/firmware/arm_scmi/scmi_power_control.c
+++ b/drivers/firmware/arm_scmi/scmi_power_control.c
@@ -46,6 +46,7 @@
 #include <linux/math.h>
 #include <linux/module.h>
 #include <linux/mutex.h>
+#include <linux/pm.h>
 #include <linux/printk.h>
 #include <linux/reboot.h>
 #include <linux/scmi_protocol.h>
@@ -324,12 +325,7 @@ static int scmi_userspace_notifier(struct notifier_block *nb,
 
 static void scmi_suspend_work_func(struct work_struct *work)
 {
-	struct scmi_syspower_conf *sc =
-		container_of(work, struct scmi_syspower_conf, suspend_work);
-
 	pm_suspend(PM_SUSPEND_MEM);
-
-	sc->state = SCMI_SYSPOWER_IDLE;
 }
 
 static int scmi_syspower_probe(struct scmi_device *sdev)
@@ -354,6 +350,7 @@ static int scmi_syspower_probe(struct scmi_device *sdev)
 	sc->required_transition = SCMI_SYSTEM_MAX;
 	sc->userspace_nb.notifier_call = &scmi_userspace_notifier;
 	sc->dev = &sdev->dev;
+	dev_set_drvdata(&sdev->dev, sc);
 
 	INIT_WORK(&sc->suspend_work, scmi_suspend_work_func);
 
@@ -363,6 +360,18 @@ static int scmi_syspower_probe(struct scmi_device *sdev)
 						       NULL, &sc->userspace_nb);
 }
 
+static int scmi_system_power_resume(struct device *dev)
+{
+	struct scmi_syspower_conf *sc = dev_get_drvdata(dev);
+
+	sc->state = SCMI_SYSPOWER_IDLE;
+	return 0;
+}
+
+static const struct dev_pm_ops scmi_system_power_pmops = {
+	SET_SYSTEM_SLEEP_PM_OPS(NULL, scmi_system_power_resume)
+};
+
 static const struct scmi_device_id scmi_id_table[] = {
 	{ SCMI_PROTOCOL_SYSTEM, "syspower" },
 	{ },
@@ -370,6 +379,9 @@ static const struct scmi_device_id scmi_id_table[] = {
 MODULE_DEVICE_TABLE(scmi, scmi_id_table);
 
 static struct scmi_driver scmi_system_power_driver = {
+	.driver	= {
+		.pm = &scmi_system_power_pmops,
+	},
 	.name = "scmi-system-power",
 	.probe = scmi_syspower_probe,
 	.id_table = scmi_id_table,
-- 
2.39.5



