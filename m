Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97B604D6C21;
	Fri,  9 Oct 2026 14:42:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791556977; cv=none; b=qNH4WPrV2ONTtLrEU7EVBJtEsRMVH3AJLWoQ0UaLCINIsdTXFXCxeEyceM46MkHzSnkPa67gaMDmEXIzvtLuGBiy/ZuPAaV0zOu/s0oP5lIQP0JcYGsc4TrvZh/3xxBm+ACu/6KWMXhiQzPDndl0uDSOp5nec02KrvnmpW7IPi4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791556977; c=relaxed/simple;
	bh=whNMYYSkY9vpP4fVxMxnZVyghY4R8Kj1Xh7zz67AYlg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ORTMQ/KePThYQABvRrixZnAnlY9Mni6th0m2+731OwhAMuzno5Bfp8FASZtQhnXwXZAtR8xxhTeexk9eT19ZmqufULR6LeBkhDgrraxtz20P/OS7HaUDCYDV9YMguRGEnHOP3WzOqBjeYWngdDzSTAuW9nOtZkGwQEH66Juf5MA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iJrJt9fS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iJrJt9fS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01EDE1F000FF;
	Fri,  9 Oct 2026 14:42:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791556976;
	bh=VlNRUuMDx0dvcl4BfAOwZFBqDLDiI/fa+0xjFTY9qow=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iJrJt9fSMiC3jF7Va/AvfNdNwKRetRgGn78bZRNF7F6zkONHw0t2BcBWNxde5GC5n
	 ayNE7xoAmjmS7GzkIsOQtNR0sNFbGpoMWBgwMyDfw/rWaO/1TiN0JBCv9OHmW8WgBe
	 8AEFQjtdD3SiXGZ+oeSgcqGrLkLcEbqPXY5gOM4U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arka Mondal <arkamondalofficial@gmail.com>,
	Andy Shevchenko <andriy.shevchenko@intel.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Subject: [PATCH 6.18 327/403] iio: imu: adis16480: fix unprotected debugfs reads
Date: Fri,  9 Oct 2026 16:11:28 +0200
Message-ID: <20261009140959.880413408@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140952.119038291@linuxfoundation.org>
References: <20261009140952.119038291@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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


