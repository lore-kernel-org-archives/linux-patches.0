Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AF721BDEC;
	Wed,  3 Jan 2024 17:02:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AG7a7xss"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA303C433C8;
	Wed,  3 Jan 2024 17:02:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1704301321;
	bh=17R4zPop7ed6EcAIS5zj1PFkiuXnPelZ5EZeVkGE+jY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AG7a7xssOamnGddj3N3ZexmY3KWz7E5iVyONxIe+lxYgCMe6FqZiGhVcqXD4iLA/X
	 W6xBFO9o2BBlAeEzbfjYdA6OSs0a3G5gEHxmPlfvdVESamqFfUFa2/4qw8+wVTEccm
	 d07tD93TETWOr/n8wa+jQjLJ6X5EmD1wHFnATv28=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 076/100] spi: Introduce spi_get_device_match_data() helper
Date: Wed,  3 Jan 2024 17:55:05 +0100
Message-ID: <20240103164907.483411209@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240103164856.169912722@linuxfoundation.org>
References: <20240103164856.169912722@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 5d046be8b2dd5..dfce0f7d4c640 100644
--- a/drivers/spi/spi.c
+++ b/drivers/spi/spi.c
@@ -360,6 +360,18 @@ const struct spi_device_id *spi_get_device_id(const struct spi_device *sdev)
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
index 877395e075afe..635a05c30283c 100644
--- a/include/linux/spi/spi.h
+++ b/include/linux/spi/spi.h
@@ -1515,6 +1515,9 @@ extern void spi_unregister_device(struct spi_device *spi);
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



