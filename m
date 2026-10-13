Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 230CA4E4C4B;
	Tue, 13 Oct 2026 12:42:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791895351; cv=none; b=Ux+pPsfXBoC+q9JkboHQZXdhXHFygWkMsKAI0KtjNo0gkL8cEGvHdhrLsi/7J+Cvys042K3HISSguZMlC2YfP6yxFehJModPh5qYi2aUwELrp1Tf5HdNEq3xNg7FdufmHRAja7mWpWkQKDMFr+iA/HKTlddSx3XXH7GSaT8oGGQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791895351; c=relaxed/simple;
	bh=81Me+wn2rO1SXOpJ66Z65N7yjz1IyOXrhYd3qHTh1vk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PYusq/3NnStKmPdn1qhEnNAk7DyEDK/vGJ9qQK37QuWeF926jkYZjA2j1+x3jcW+InGQ0PfdIgr5s/W+Cqg1erNt7kF6tEedGWR5pv3t9Xh1ox1RqU2P71MTK7vZL5BTX6G4R4/RGSa/JzjLGD71g9O+AlvFw4hdRUYGjXwcUmc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JOTy+qtm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JOTy+qtm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75CB71F000FF;
	Tue, 13 Oct 2026 12:42:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791895350;
	bh=LJv/Bnfywfc7FZmln29L303ErWykcfCcieSV8wwrDtE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JOTy+qtmFGo8aTfyOhiXZxgQnQEMUFraZeoBZH6V9asxinkVQxKsoiYFWOgV4y/W2
	 bkY6drvW3V6zefNLOgwXRiu5pNIV9S3ysP948GX+f1+R+dHwCFdeS/IEHlzT1DAEIl
	 lZ1OrhOcItziWh+RtsAh+oKbMoYalSkH1NSp/Ox0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arka Mondal <arkamondalofficial@gmail.com>,
	Andy Shevchenko <andriy.shevchenko@intel.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Subject: [PATCH 6.12 245/497] iio: imu: adis16480: fix unprotected debugfs reads
Date: Tue, 13 Oct 2026 13:36:52 +0200
Message-ID: <20261013112913.710865313@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112907.864180619@linuxfoundation.org>
References: <20261013112907.864180619@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -310,9 +310,9 @@ static void adis16480_debugfs_init(struc
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


