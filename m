Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04BB210FC
	for <patches@lists.linux.dev>; Wed,  7 Jun 2023 20:28:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77A4DC4339B;
	Wed,  7 Jun 2023 20:28:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1686169726;
	bh=SsD+8MWkXX+FemRO8ZfLQHI4DzyQWYT0DLCAckXl4jM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=I8LWy91O+BeJrU2QvYExY9sxlCz+pgSoSRNqiXETOrUnTJ8kCBu1qenR7P0RKy8qt
	 y/W457NziM+Z+5gRwZ3XB8HD48UNWY3F6cKaGR6MLc9E3cTNUqb4nB70tdF8+czmYr
	 edSDi55+k9qLw4+jVkXcJTZrOHW7yUYuctOXrOXI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans de Goede <hdegoede@redhat.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Marius Hoch <mail@mariushoch.de>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.3 190/286] iio: accel: st_accel: Fix invalid mount_matrix on devices without ACPI _ONT method
Date: Wed,  7 Jun 2023 22:14:49 +0200
Message-ID: <20230607200929.475654733@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230607200922.978677727@linuxfoundation.org>
References: <20230607200922.978677727@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Hans de Goede <hdegoede@redhat.com>

commit 79b8ded9d9c595db9bd5b2f62f5f738b36de1e22 upstream.

When apply_acpi_orientation() fails, st_accel_common_probe() will fall back
to iio_read_mount_matrix(), which checks for a mount-matrix device property
and if that is not set falls back to the identity matrix.

But when a sensor has no ACPI companion fwnode, or when the ACPI fwnode
does not have a "_ONT" method apply_acpi_orientation() was returning 0,
causing iio_read_mount_matrix() to never get called resulting in an
invalid mount_matrix:

[root@fedora ~]# cat /sys/bus/iio/devices/iio\:device0/mount_matrix
(null), (null), (null); (null), (null), (null); (null), (null), (null)

Fix this by making apply_acpi_orientation() always return an error when
it did not set the mount_matrix.

Fixes: 3d8ad94bb175 ("iio: accel: st_sensors: Support generic mounting matrix")
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Tested-by: Marius Hoch <mail@mariushoch.de>
Link: https://lore.kernel.org/r/20230416212409.310936-1-hdegoede@redhat.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/accel/st_accel_core.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/iio/accel/st_accel_core.c
+++ b/drivers/iio/accel/st_accel_core.c
@@ -1290,12 +1290,12 @@ static int apply_acpi_orientation(struct
 
 	adev = ACPI_COMPANION(indio_dev->dev.parent);
 	if (!adev)
-		return 0;
+		return -ENXIO;
 
 	/* Read _ONT data, which should be a package of 6 integers. */
 	status = acpi_evaluate_object(adev->handle, "_ONT", NULL, &buffer);
 	if (status == AE_NOT_FOUND) {
-		return 0;
+		return -ENXIO;
 	} else if (ACPI_FAILURE(status)) {
 		dev_warn(&indio_dev->dev, "failed to execute _ONT: %d\n",
 			 status);


