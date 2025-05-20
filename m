Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A2E524888F;
	Tue, 20 May 2025 14:14:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747750455; cv=none; b=serOUF1st3Lxxgm2jBJxEjzCWGxO95b7ZCJsCBFjsafKbttjakwBDkYeJhllQv2o2fNxkOQvFSSyJiIg5UFx87zLhCmWysF2jGGcK3I7E8pBRHgT2PX5kgrTVOzAe67pINtm30TFyjLPxCLPCqxgAakqHO80E6Bt9d/eLcymv5w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747750455; c=relaxed/simple;
	bh=s2VASlfuuHTzkMBDnt7jMSC2/BK6h7VKziBNg92csO8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kNqX/mimdPJF9TGbqeumPzEXbNtMzbP7IZEXgQ8V9xushwNUZJap9nepsjsKkPzjENwGtmPFKO9gvTuNlhDGus1AJTmuuJef54qWxTYsa0IrSVDjoA1vHctfNBBEsuZqwv61d/xyzwBGKRLiR5RWjyyjwAZD4hfBM8OUG8eq47Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f6udUrOm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f6udUrOm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19631C4CEE9;
	Tue, 20 May 2025 14:14:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747750454;
	bh=s2VASlfuuHTzkMBDnt7jMSC2/BK6h7VKziBNg92csO8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=f6udUrOmnLD3HN2C7Vo2yChuHbbMQMlgWoNvfeejROQgLmMdMDHj+1zkQpeuV9l/2
	 X5Sa+JPtM67JVksbALlb3kGyBqOSKSOTlhrPpvL5hjxvIjDJcVMyyyK9jY2bcCd2Bi
	 XTDbBA+UxNqx3X+OGo5va9htp0JkssqvtcxX2etU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Naveen Krishna Chatradhi <naveenkrishna.chatradhi@amd.com>,
	Gregory Price <gourry@gourry.net>,
	Suma Hegde <suma.hegde@amd.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 006/145] platform/x86/amd/hsmp: Make amd_hsmp and hsmp_acpi as mutually exclusive drivers
Date: Tue, 20 May 2025 15:49:36 +0200
Message-ID: <20250520125810.797034396@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250520125810.535475500@linuxfoundation.org>
References: <20250520125810.535475500@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Suma Hegde <suma.hegde@amd.com>

[ Upstream commit 0581d384f344ed0a963dd27cbff3c7af80c189e7 ]

amd_hsmp and hsmp_acpi are intended to be mutually exclusive drivers and
amd_hsmp is for legacy platforms. To achieve this, it is essential to
check for the presence of the ACPI device in plat.c. If the hsmp ACPI
device entry is found, allow the hsmp_acpi driver to manage the hsmp
and return an error from plat.c.

Additionally, rename the driver from amd_hsmp to hsmp_acpi to prevent
"Driver 'amd_hsmp' is already registered, aborting..." error in case
both drivers are loaded simultaneously.

Also, support both platform device based and ACPI based probing for
family 0x1A models 0x00 to 0x0F, implement only ACPI based probing
for family 0x1A, models 0x10 to 0x1F. Return false from
legacy_hsmp_support() for this platform.
This aligns with the condition check in is_f1a_m0h().

Link: https://lore.kernel.org/platform-driver-x86/aALZxvHWmphNL1wa@gourry-fedora-PF4VCD3F/
Fixes: 7d3135d16356 ("platform/x86/amd/hsmp: Create separate ACPI, plat and common drivers")
Reviewed-by: Naveen Krishna Chatradhi <naveenkrishna.chatradhi@amd.com>
Co-developed-by: Gregory Price <gourry@gourry.net>
Signed-off-by: Gregory Price <gourry@gourry.net>
Signed-off-by: Suma Hegde <suma.hegde@amd.com>
Link: https://lore.kernel.org/r/20250425102357.266790-1-suma.hegde@amd.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/amd/hsmp/acpi.c | 3 +--
 drivers/platform/x86/amd/hsmp/hsmp.h | 1 +
 drivers/platform/x86/amd/hsmp/plat.c | 6 +++++-
 3 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/platform/x86/amd/hsmp/acpi.c b/drivers/platform/x86/amd/hsmp/acpi.c
index c1eccb3c80c5c..eaae044e4f824 100644
--- a/drivers/platform/x86/amd/hsmp/acpi.c
+++ b/drivers/platform/x86/amd/hsmp/acpi.c
@@ -27,9 +27,8 @@
 
 #include "hsmp.h"
 
-#define DRIVER_NAME		"amd_hsmp"
+#define DRIVER_NAME		"hsmp_acpi"
 #define DRIVER_VERSION		"2.3"
-#define ACPI_HSMP_DEVICE_HID	"AMDI0097"
 
 /* These are the strings specified in ACPI table */
 #define MSG_IDOFF_STR		"MsgIdOffset"
diff --git a/drivers/platform/x86/amd/hsmp/hsmp.h b/drivers/platform/x86/amd/hsmp/hsmp.h
index af8b21f821d66..d58d4f0c20d55 100644
--- a/drivers/platform/x86/amd/hsmp/hsmp.h
+++ b/drivers/platform/x86/amd/hsmp/hsmp.h
@@ -23,6 +23,7 @@
 
 #define HSMP_CDEV_NAME		"hsmp_cdev"
 #define HSMP_DEVNODE_NAME	"hsmp"
+#define ACPI_HSMP_DEVICE_HID    "AMDI0097"
 
 struct hsmp_mbaddr_info {
 	u32 base_addr;
diff --git a/drivers/platform/x86/amd/hsmp/plat.c b/drivers/platform/x86/amd/hsmp/plat.c
index b9782a078dbd2..81931e808bbc8 100644
--- a/drivers/platform/x86/amd/hsmp/plat.c
+++ b/drivers/platform/x86/amd/hsmp/plat.c
@@ -11,6 +11,7 @@
 
 #include <asm/amd_hsmp.h>
 
+#include <linux/acpi.h>
 #include <linux/build_bug.h>
 #include <linux/device.h>
 #include <linux/module.h>
@@ -266,7 +267,7 @@ static bool legacy_hsmp_support(void)
 		}
 	case 0x1A:
 		switch (boot_cpu_data.x86_model) {
-		case 0x00 ... 0x1F:
+		case 0x00 ... 0x0F:
 			return true;
 		default:
 			return false;
@@ -288,6 +289,9 @@ static int __init hsmp_plt_init(void)
 		return ret;
 	}
 
+	if (acpi_dev_present(ACPI_HSMP_DEVICE_HID, NULL, -1))
+		return -ENODEV;
+
 	hsmp_pdev = get_hsmp_pdev();
 	if (!hsmp_pdev)
 		return -ENOMEM;
-- 
2.39.5



