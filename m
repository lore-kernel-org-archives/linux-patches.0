Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA5CF27F737;
	Tue, 27 May 2025 17:04:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748365443; cv=none; b=UxePAIueEFORVrmbNfCQIQ8neX8SDOYGWuOj9FxnWkHwnIqb9lyqOFSzfUPK5nCXkzoPUru9dPC1tt9uZiUiRvu7EVSm/upYzATrSA1PNVOZlQegGoyjv1/J3dRtpcgLPwArsAYEJ2JZXXErIRlHbRySEuNAT/DVxjbB0yziGWU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748365443; c=relaxed/simple;
	bh=aiHKf8WUxiNJKLFtg26AWC6qXnb1SyPwZDtIXBgpBT4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d29sk3JAQYABgx0GeCJvZPqgzzakqWwqvf3VULEfzG08D0101xftngvwpqxwr6L19smR8viHXeSDrjmqFc7+J8S80bT+hRQB+yQSwviWeHgri5f8BMw+gZWIWMaNZvcSn5HTvPmyXYGJ+1JIJR+On0GgVnjotuHZ777VuwTFMQ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g2+0if9P; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g2+0if9P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D008DC4CEE9;
	Tue, 27 May 2025 17:04:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748365443;
	bh=aiHKf8WUxiNJKLFtg26AWC6qXnb1SyPwZDtIXBgpBT4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g2+0if9Pc2fpxfeZYgO5QKNj+Al4RhJqIOMQ42myXdepnkgD3xpfG65iCr1cs/lW+
	 FjiSUXOY/Vp5Fu5ctXWDyo0JlGZve28xnReVMVdswabAFunA4jCYOP9Cbg3eR3PoHG
	 UOCdlKh9+yE6Vp0k3WMXypIhVKHgx+sZczcNxfzk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiaofei Tan <tanxiaofei@huawei.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 347/626] ACPI: HED: Always initialize before evged
Date: Tue, 27 May 2025 18:24:00 +0200
Message-ID: <20250527162459.121218437@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162445.028718347@linuxfoundation.org>
References: <20250527162445.028718347@linuxfoundation.org>
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
index d67f63d93b2ab..89fa569d63702 100644
--- a/drivers/acpi/Kconfig
+++ b/drivers/acpi/Kconfig
@@ -443,7 +443,7 @@ config ACPI_SBS
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



