Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7DDF280012;
	Tue, 27 May 2025 17:39:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748367551; cv=none; b=Oh2GkkTkGoUEMEz63rdHbVMd+XRVIlcydqkKYg5DOnLrYM7f4NDymOL7ODQu9ZM53fPgssczpjdia2YRmaSNMIRc+/qLsd3g5tihpw1tq9/gLDFIu/JPeZ3YgBM06oPn+kXMsXxi0W8nz+yfAk5hQwfi6kLjlHGCSTffzT00gK8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748367551; c=relaxed/simple;
	bh=6LkWA0VrzGAOlC9C8QUtnOBKddMXidAzGbQKWPOKm4Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Imxmb/A8kPkRPBn+8VP99eY+3HQehTBVaEBXUdrDXDfjig6DEZBF5jkaIqAKTODJG8qJBSJemlNgWUPlvxwmmZk9qAUO8Jhhw9LK1YatJJhkHeiFLUpw1WhAIKi9Mn38p4959UfYdKmeQoM3w3YAAQUL05DLys0a+WzzAwgSi6k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FPU+0oc0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FPU+0oc0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4829FC4CEE9;
	Tue, 27 May 2025 17:39:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748367551;
	bh=6LkWA0VrzGAOlC9C8QUtnOBKddMXidAzGbQKWPOKm4Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FPU+0oc0kjrr31pJaQNHgwhtbrZKYbPuWL9/2TYV5s7Mm8ADpj2VpKDlspf1dBO5E
	 jlWc1g0XkEx6npvQBZhiFtQe7XntXumsi/r4OO+KBGsBP6zBKuSobPKzIkA5FpauNH
	 Dg5DAdVeDl+rsRgXNtM5p/I/CmRUsSBiMTBBmO3Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiaofei Tan <tanxiaofei@huawei.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 424/783] ACPI: HED: Always initialize before evged
Date: Tue, 27 May 2025 18:23:41 +0200
Message-ID: <20250527162530.391981530@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xiaofei Tan <tanxiaofei@huawei.com>

[ Upstream commit cccf6ee090c8c133072d5d5b52ae25f3bc907a16 ]

When the HED driver is built-in, it initializes after evged because they
both are at the same initcall level, so the initialization ordering
depends on the Makefile order.  However, this prevents RAS records
coming in between the evged driver initialization and the HED driver
initialization from being handled.

If the number of such RAS records is above the APEI HEST error source
number, the HEST resources may be exhausted, and that may affect
subsequent RAS error reporting.

To fix this issue, change the initcall level of HED to subsys_initcall
and prevent the driver from being built as a module by changing ACPI_HED
in Kconfig from "tristate" to "bool".

Signed-off-by: Xiaofei Tan <tanxiaofei@huawei.com>
Link: https://patch.msgid.link/20250212063408.927666-1-tanxiaofei@huawei.com
[ rjw: Changelog edits ]
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/Kconfig | 2 +-
 drivers/acpi/hed.c   | 7 ++++++-
 2 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/acpi/Kconfig b/drivers/acpi/Kconfig
index d81b55f5068c4..7f10aa38269d2 100644
--- a/drivers/acpi/Kconfig
+++ b/drivers/acpi/Kconfig
@@ -452,7 +452,7 @@ config ACPI_SBS
 	  the modules will be called sbs and sbshc.
 
 config ACPI_HED
-	tristate "Hardware Error Device"
+	bool "Hardware Error Device"
 	help
 	  This driver supports the Hardware Error Device (PNP0C33),
 	  which is used to report some hardware errors notified via
diff --git a/drivers/acpi/hed.c b/drivers/acpi/hed.c
index 7652515a6be1e..3499f86c411e3 100644
--- a/drivers/acpi/hed.c
+++ b/drivers/acpi/hed.c
@@ -80,7 +80,12 @@ static struct acpi_driver acpi_hed_driver = {
 		.remove = acpi_hed_remove,
 	},
 };
-module_acpi_driver(acpi_hed_driver);
+
+static int __init acpi_hed_driver_init(void)
+{
+	return acpi_bus_register_driver(&acpi_hed_driver);
+}
+subsys_initcall(acpi_hed_driver_init);
 
 MODULE_AUTHOR("Huang Ying");
 MODULE_DESCRIPTION("ACPI Hardware Error Device Driver");
-- 
2.39.5



