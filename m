Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B437222561;
	Mon,  2 Jun 2025 14:14:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748873682; cv=none; b=AlNnCdWC7Xjv4+6f37hVVciG+aaH3EJRU011TZlGR/nC0W4Ez6BbWKmReyfYd2eD8Ri2dvEsT8dvsBpZmo+ZFWI+e6kAMp0SjcluwFBQvQr2bQA47S6fr5ZVCWzO5n8Q+zG8POe+7YDCJ6yGKDFKcANqyGD9fXCuN1jXKLxDqwo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748873682; c=relaxed/simple;
	bh=nUhOAswYnFs6tENK49peOkI2FuSsNhRzhO9sH9DHD6s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZllQNf2xgkQ/NRtjU/ZT4TmEpXMHJVkRI/F1uSJ34Fs69+mD53neNyKeSmHA6zZ7/gem7dg+EHnS7GxMChAysjBXokjYW3Dqbs7UvB4H6MJus2VKx5n5USYeaZiiveuMpGd7X2arce35j+/6ms9j/MaYwX7luW7xeFsC0yXxYlw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LmypIN1y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LmypIN1y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3947C4CEEB;
	Mon,  2 Jun 2025 14:14:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748873682;
	bh=nUhOAswYnFs6tENK49peOkI2FuSsNhRzhO9sH9DHD6s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LmypIN1ybnPqQQkeDCrJMpMhTNNtkfWGNSZ6PXCByiOikYjlbwLDZuoZF1BoNYvlW
	 WigD/zipQBoMKD36SD8M1T6JFmBJi/pd2DzopBHfOBLa1ZCfkAvQC7nTXCzXNhv4Wu
	 c+XYZ/tn316H30xZ2eCAlQsn0r8XEN/jzX1tJvQI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiaofei Tan <tanxiaofei@huawei.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 218/444] ACPI: HED: Always initialize before evged
Date: Mon,  2 Jun 2025 15:44:42 +0200
Message-ID: <20250602134349.757218211@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134340.906731340@linuxfoundation.org>
References: <20250602134340.906731340@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index cee82b473dc50..648228831f5e8 100644
--- a/drivers/acpi/Kconfig
+++ b/drivers/acpi/Kconfig
@@ -438,7 +438,7 @@ config ACPI_SBS
 	  the modules will be called sbs and sbshc.
 
 config ACPI_HED
-	tristate "Hardware Error Device"
+	bool "Hardware Error Device"
 	help
 	  This driver supports the Hardware Error Device (PNP0C33),
 	  which is used to report some hardware errors notified via
diff --git a/drivers/acpi/hed.c b/drivers/acpi/hed.c
index 46c6f8c35b436..2e01eaa8d8cd5 100644
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



