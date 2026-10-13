Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE86E47604A;
	Tue, 13 Oct 2026 12:16:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791893820; cv=none; b=ujkm8oUo2qJayKzTSzwYYB2letwN7ZoS0ZM+i/hNvIWbYXIp1h/4ZwhEKh3q9C2h/6RlyXGHh3Kx15sJdFRMmvIGQUPHgEsvlX5pfFKddF/dxsxa78BzYqJY5703uoIzfzIusdE+sV2Tt47ey7nV6Ia+sP0brzXrnFBoSxGDgoM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791893820; c=relaxed/simple;
	bh=fDsIG8ylMa1hJ4Li4UODogqPnZSqG0QjBU7Sgfns81Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a2BmI1c89XfD0TCUib1bl+FwBqR7P+JaMojrkQcXtIn1HtTz7xxzTf/YOvvA2g2/hPRVLvbozpQUOj7tS3/2LngX4IMXUHKwtOctSimga7U6HP5iqdZ5WJbN9JcUoWd1mDjH0HEjeHh601pEzttXYYCUcCxoVCreHYP6QfJ9PRQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WEPYntqj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WEPYntqj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 425561F000FF;
	Tue, 13 Oct 2026 12:16:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791893818;
	bh=anlwuzw60BFVui/npDAL+g+bwW11Xi14AGuwnLLDBrQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WEPYntqjagMO4sx5ExG3agSVsoQqVzwiWXq9ER9kg2AnDOMKY3nNt+JV4NZ/Au/2N
	 9FoDL37aggeqHF73/H9QBZm1/C2GKNJYAbJjWf87QMB1U1Xu+dPAAsyQNJGd6bD10R
	 9Vbr+yPoxzm27VPzS0wmDnuBIKUKZr/+D3RDK0GI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jay Buddhabhatti <jay.buddhabhatti@amd.com>,
	Michal Simek <michal.simek@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 354/621] drivers: firmware: xilinx: Add unique family code for all platforms
Date: Tue, 13 Oct 2026 13:35:49 +0200
Message-ID: <20261013112929.251353728@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jay Buddhabhatti <jay.buddhabhatti@amd.com>

[ Upstream commit e66f4c35e375346943bfe2a0990e97253f74440f ]

The family code is currently derived from the PMC_TAP_IDCODE register
value, but there are issues where Versal, Versal NET, and future
platforms share the same family code. Additionally for some platforms
have identical subfamily code, making it challenging to differentiate
between platforms based on the family and subfamily codes. To resolve
this, a new family code member is added to the platform data, initialized
with unique values. This change enables better platform distinction via
the compatible string.

Signed-off-by: Jay Buddhabhatti <jay.buddhabhatti@amd.com>
Link: https://lore.kernel.org/r/20250701123851.1314531-3-jay.buddhabhatti@amd.com
Signed-off-by: Michal Simek <michal.simek@amd.com>
Stable-dep-of: fb4459353384 ("soc: xilinx: Fix race condition in event registration")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/xilinx/zynqmp.c     | 26 ++++++++++++++++++++++++--
 include/linux/firmware/xlnx-zynqmp.h |  5 +++++
 2 files changed, 29 insertions(+), 2 deletions(-)

diff --git a/drivers/firmware/xilinx/zynqmp.c b/drivers/firmware/xilinx/zynqmp.c
index dc9c5d32108d5..e62197a37c32e 100644
--- a/drivers/firmware/xilinx/zynqmp.c
+++ b/drivers/firmware/xilinx/zynqmp.c
@@ -72,6 +72,15 @@ struct pm_api_feature_data {
 	struct hlist_node hentry;
 };
 
+struct platform_fw_data {
+	/*
+	 * Family code for platform.
+	 */
+	const u32 family_code;
+};
+
+static struct platform_fw_data *active_platform_fw_data;
+
 static const struct mfd_cell firmware_devs[] = {
 	{
 		.name = "zynqmp_power_controller",
@@ -2014,6 +2023,11 @@ static int zynqmp_firmware_probe(struct platform_device *pdev)
 	if (ret)
 		return ret;
 
+	/* Get platform-specific firmware data from device tree match */
+	active_platform_fw_data = (struct platform_fw_data *)device_get_match_data(dev);
+	if (!active_platform_fw_data)
+		return -EINVAL;
+
 	/* Get SiP SVC version number */
 	ret = zynqmp_pm_get_sip_svc_version(&sip_svc_version);
 	if (ret)
@@ -2114,9 +2128,17 @@ static void zynqmp_firmware_sync_state(struct device *dev)
 		dev_warn(dev, "failed to release power management to firmware\n");
 }
 
+static const struct platform_fw_data platform_fw_data_versal = {
+	.family_code = PM_VERSAL_FAMILY_CODE,
+};
+
+static const struct platform_fw_data platform_fw_data_zynqmp = {
+	.family_code = PM_ZYNQMP_FAMILY_CODE,
+};
+
 static const struct of_device_id zynqmp_firmware_of_match[] = {
-	{.compatible = "xlnx,zynqmp-firmware"},
-	{.compatible = "xlnx,versal-firmware"},
+	{.compatible = "xlnx,zynqmp-firmware", .data = &platform_fw_data_zynqmp},
+	{.compatible = "xlnx,versal-firmware", .data = &platform_fw_data_versal},
 	{},
 };
 MODULE_DEVICE_TABLE(of, zynqmp_firmware_of_match);
diff --git a/include/linux/firmware/xlnx-zynqmp.h b/include/linux/firmware/xlnx-zynqmp.h
index 2f1c71f0cea76..790cbe7937bd6 100644
--- a/include/linux/firmware/xlnx-zynqmp.h
+++ b/include/linux/firmware/xlnx-zynqmp.h
@@ -54,6 +54,11 @@
 #define ZYNQMP_FAMILY_CODE 0x23
 #define VERSAL_FAMILY_CODE 0x26
 
+/* Family codes */
+#define PM_ZYNQMP_FAMILY_CODE 0x1 /* ZynqMP family code */
+#define PM_VERSAL_FAMILY_CODE 0x2 /* Versal family code */
+#define PM_VERSAL_NET_FAMILY_CODE 0x3 /* Versal NET family code */
+
 /* When all subfamily of platform need to support */
 #define ALL_SUB_FAMILY_CODE		0x00
 #define VERSAL_SUB_FAMILY_CODE		0x01
-- 
2.53.0



