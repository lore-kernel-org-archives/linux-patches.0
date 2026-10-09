Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44E79274FDF;
	Fri,  9 Oct 2026 14:52:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791557559; cv=none; b=iFgxs9OhDXnfPH4ZdO7POxIW8LBksBMBwHkbOkfMqFTdkJBrcek+Y2/QrHQCcTgHOrJLvs1QKeeNTHHpig3GqRs6bSwG5LUZ6MzpXmZ4cYTZ5cbHNsqTLfoihbuvBv8ZDE8WEWIbHVgG1b4PMJY9sNRgbP35sFlgeMHqyaqj2gw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791557559; c=relaxed/simple;
	bh=mDXdpPAxpjktARMApYUjdAByPIoPL+znQ3lQp8Taedk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n2VPdAcZqI8bhTs9k8lJF8acldTB1yL2EwY07JdGWE2f5kgVWTbb4ZbqKVnT/Sqm0a3hHiQ36E+G4cgHrIJHtAS/iAVhvh0juy88fr/PLAfhldLvdEBnIeAyFAdfGhiJumjvLwZc90bxZFnLDDYUgNwjKsW3RABKoh1TW3CVC1c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v0LiY3zf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v0LiY3zf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 999541F000FF;
	Fri,  9 Oct 2026 14:52:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791557558;
	bh=HeU2hA/YTrbY2uZDcjHwK9Wl45yOyawA3YD8eyOb5Ew=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=v0LiY3zfCmAboqDeAQA/RIx5L/o8DRiFg9v3PlTYSvGzCqc/isK6t/z/vWHcgK3rd
	 MWgu4zjZXxK4+jpcmCwro0p8BrnuPzz4pfjYQWqUub9unfEuFJh2k8yJr/C+qtcsa3
	 TRUR+NaSsh57ujYeextMPIfalhuMh4/VLDTM0+MU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arka Mondal <arkamondalofficial@gmail.com>,
	Andy Shevchenko <andriy.shevchenko@intel.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Subject: [PATCH 7.2 403/428] iio: imu: adis16480: fix unprotected debugfs reads
Date: Fri,  9 Oct 2026 16:12:20 +0200
Message-ID: <20261009140955.071521871@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140946.008206689@linuxfoundation.org>
References: <20261009140946.008206689@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arka Mondal <arkamondalofficial@gmail.com>

commit e1dea54496f90a62318cf4eeaa1e9ef8316e92b6 upstream.

The firmware_revision and firmware_date file operations are open coded
and never call debugfs_file_get(), which debugfs_create_file_unsafe()
requires. debugfs_remove_recursive() therefore does not wait for a read
in progress, and unbind frees the iio_dev underneath it.

Use debugfs_create_file() instead.

Fixes: 9bf94f836e32 ("imu:adis16480: fix debugfs_simple_attr.cocci warnings")
Signed-off-by: Arka Mondal <arkamondalofficial@gmail.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@intel.com>
Cc: stable@vger.kernel.org
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/imu/adis16480.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/iio/imu/adis16480.c
+++ b/drivers/iio/imu/adis16480.c
@@ -309,9 +309,9 @@ static void adis16480_debugfs_init(struc
 	if (!IS_ENABLED(CONFIG_DEBUG_FS))
 		return;
 
-	debugfs_create_file_unsafe("firmware_revision", 0400,
+	debugfs_create_file("firmware_revision", 0400,
 		d, adis16480, &adis16480_firmware_revision_fops);
-	debugfs_create_file_unsafe("firmware_date", 0400,
+	debugfs_create_file("firmware_date", 0400,
 		d, adis16480, &adis16480_firmware_date_fops);
 	debugfs_create_file_unsafe("serial_number", 0400,
 		d, adis16480, &adis16480_serial_number_fops);


