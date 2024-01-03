Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D9711C294;
	Wed,  3 Jan 2024 17:07:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Yw0gOrlf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77275C433C7;
	Wed,  3 Jan 2024 17:07:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1704301634;
	bh=t0liVBdPmng35TdNoGIzS+p6jPmoKQg+yh9V9ie9YXI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Yw0gOrlfa53MtL/WUbGsQFFL+r7WvtJDzJv8AhdN+0wkhWSs/8Kc0B8jtEe9b6ciV
	 RnJ4tUJ13aajUcwt3wF30ftZOmqrfZMec26nNPUGw8Qqe3lMhhdozzGPVxjNBC2z3C
	 8ZKUDbp4a01GShQnwbvyQjyie40ek3uGGwzVzLas=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 81/95] spi: Introduce spi_get_device_match_data() helper
Date: Wed,  3 Jan 2024 17:55:29 +0100
Message-ID: <20240103164906.216472937@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240103164853.921194838@linuxfoundation.org>
References: <20240103164853.921194838@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit aea672d054a21782ed8450c75febb6ba3c208ca4 ]

The proposed spi_get_device_match_data() helper is for retrieving
a driver data associated with the ID in an ID table. First, it tries
to get driver data of the device enumerated by firmware interface
(usually Device Tree or ACPI). If none is found it falls back to
the SPI ID table matching.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Link: https://lore.kernel.org/r/20221020195421.10482-1-andriy.shevchenko@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: ee4d79055aee ("iio: imu: adis16475: add spi_device_id table")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi.c       | 12 ++++++++++++
 include/linux/spi/spi.h |  3 +++
 2 files changed, 15 insertions(+)

diff --git a/drivers/spi/spi.c b/drivers/spi/spi.c
index 06dd1be54925e..d4b186a35bb22 100644
--- a/drivers/spi/spi.c
+++ b/drivers/spi/spi.c
@@ -335,6 +335,18 @@ const struct spi_device_id *spi_get_device_id(const struct spi_device *sdev)
 }
 EXPORT_SYMBOL_GPL(spi_get_device_id);
 
+const void *spi_get_device_match_data(const struct spi_device *sdev)
+{
+	const void *match;
+
+	match = device_get_match_data(&sdev->dev);
+	if (match)
+		return match;
+
+	return (const void *)spi_get_device_id(sdev)->driver_data;
+}
+EXPORT_SYMBOL_GPL(spi_get_device_match_data);
+
 static int spi_match_device(struct device *dev, struct device_driver *drv)
 {
 	const struct spi_device	*spi = to_spi_device(dev);
diff --git a/include/linux/spi/spi.h b/include/linux/spi/spi.h
index 6b0b686f6f904..9ab3dab9568ae 100644
--- a/include/linux/spi/spi.h
+++ b/include/linux/spi/spi.h
@@ -1499,6 +1499,9 @@ extern void spi_unregister_device(struct spi_device *spi);
 extern const struct spi_device_id *
 spi_get_device_id(const struct spi_device *sdev);
 
+extern const void *
+spi_get_device_match_data(const struct spi_device *sdev);
+
 static inline bool
 spi_transfer_is_last(struct spi_controller *ctlr, struct spi_transfer *xfer)
 {
-- 
2.43.0



