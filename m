Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 014C71863
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 15:46:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AFFBC433EF;
	Wed, 28 Dec 2022 15:46:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672242370;
	bh=6mjoa0UUO+VjLIgUKRi7R2TLiowgOOeAG487pIy3nus=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1N7wOfSrzn0eIiWGepEoARXC0kTmTfTOzZ6yPHPzDnmswfD1Huw7+v5wet1D7oTae
	 ea9kwhwt3+cEDIj7gdaY/etobJrbhQUQ06dhYEFEPvDlLKRzQ1I7WJItktE6kigVxd
	 bpuWjknXz203Z6BkFOC+ii+W9k1vNRVhdU/K04dc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Walle <michael@walle.cc>,
	Tudor Ambarus <tudor.ambarus@microchip.com>,
	Takahiro Kuwano <Takahiro.Kuwano@infineon.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0362/1146] mtd: spi-nor: hide jedec_id sysfs attribute if not present
Date: Wed, 28 Dec 2022 15:31:41 +0100
Message-Id: <20221228144339.999710132@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Michael Walle <michael@walle.cc>

[ Upstream commit 7d388551b6888f3725e6c957f472526b35161a5b ]

Some non-jedec compliant flashes (like the Everspin flashes) don't have
an ID at all. Hide the attribute in this case.

Fixes: 36ac02286265 ("mtd: spi-nor: add initial sysfs support")
Signed-off-by: Michael Walle <michael@walle.cc>
Signed-off-by: Tudor Ambarus <tudor.ambarus@microchip.com>
Reviewed-by: Takahiro Kuwano <Takahiro.Kuwano@infineon.com>
Link: https://lore.kernel.org/r/20220810220654.1297699-2-michael@walle.cc
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../ABI/testing/sysfs-bus-spi-devices-spi-nor      |  3 +++
 drivers/mtd/spi-nor/sysfs.c                        | 14 ++++++++++++++
 2 files changed, 17 insertions(+)

diff --git a/Documentation/ABI/testing/sysfs-bus-spi-devices-spi-nor b/Documentation/ABI/testing/sysfs-bus-spi-devices-spi-nor
index d76cd3946434..e9ef69aef20b 100644
--- a/Documentation/ABI/testing/sysfs-bus-spi-devices-spi-nor
+++ b/Documentation/ABI/testing/sysfs-bus-spi-devices-spi-nor
@@ -5,6 +5,9 @@ Contact:	linux-mtd@lists.infradead.org
 Description:	(RO) The JEDEC ID of the SPI NOR flash as reported by the
 		flash device.
 
+		The attribute is not present if the flash doesn't support
+		the "Read JEDEC ID" command (9Fh). This is the case for
+		non-JEDEC compliant flashes.
 
 What:		/sys/bus/spi/devices/.../spi-nor/manufacturer
 Date:		April 2021
diff --git a/drivers/mtd/spi-nor/sysfs.c b/drivers/mtd/spi-nor/sysfs.c
index 9aec9d8a98ad..4c3b351aef24 100644
--- a/drivers/mtd/spi-nor/sysfs.c
+++ b/drivers/mtd/spi-nor/sysfs.c
@@ -67,6 +67,19 @@ static struct bin_attribute *spi_nor_sysfs_bin_entries[] = {
 	NULL
 };
 
+static umode_t spi_nor_sysfs_is_visible(struct kobject *kobj,
+					struct attribute *attr, int n)
+{
+	struct spi_device *spi = to_spi_device(kobj_to_dev(kobj));
+	struct spi_mem *spimem = spi_get_drvdata(spi);
+	struct spi_nor *nor = spi_mem_get_drvdata(spimem);
+
+	if (attr == &dev_attr_jedec_id.attr && !nor->info->id_len)
+		return 0;
+
+	return 0444;
+}
+
 static umode_t spi_nor_sysfs_is_bin_visible(struct kobject *kobj,
 					    struct bin_attribute *attr, int n)
 {
@@ -82,6 +95,7 @@ static umode_t spi_nor_sysfs_is_bin_visible(struct kobject *kobj,
 
 static const struct attribute_group spi_nor_sysfs_group = {
 	.name		= "spi-nor",
+	.is_visible	= spi_nor_sysfs_is_visible,
 	.is_bin_visible	= spi_nor_sysfs_is_bin_visible,
 	.attrs		= spi_nor_sysfs_entries,
 	.bin_attrs	= spi_nor_sysfs_bin_entries,
-- 
2.35.1



