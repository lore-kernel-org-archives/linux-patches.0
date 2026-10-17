Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0646D3A48E4;
	Sat, 17 Oct 2026 17:08:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792256905; cv=none; b=U1vGGnBFeVIDmfBwDElErtY0eRB7P0XDP2Pflo2iDbOwYExeOXnq3cLV0WedY7WRTo2rhn40KpiGOoUPumporolNSTrH+Mc0D7/K+hJ5gHZcZELP6Dl99sdnkJ8riUx5P8FP8JgzYq5/DBVv9bndqOZgGUfZjIaOv3pn7t4PXCY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792256905; c=relaxed/simple;
	bh=9j97Dj0MGXsTHHwigL8epJW412F/4lhzZa1l6R3uxG4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Pyx0cvk72Z24L7UXRS0fTJSxS0pl52PRqeStQ1OUk5F5EKfiCuuIbTNxtKvq6FZ9gxW0QXuKexOp5njlsNvLtnhurKTCOmfPyXfYv80fh2cToZMF/RrO5zK6JAZjCvI2W7iiuMXK1aYcHjv0QQ9TWwfZl/veYOcdEt7JHr+e3vY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=O6kSJORs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="O6kSJORs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 544981F000C5;
	Sat, 17 Oct 2026 17:08:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792256903;
	bh=cmBh51My96gghprL68AtbCG6uN2Azo2oxRW5tZ+Mmpo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=O6kSJORsz08YYMuD0JHGRG/r8JmgYBGUyhnSwoWuTwnf7Fc+nrhrYQ5PB9LyA7MJd
	 ClD4tS0csLD0U9XcmBhDtOgUVB3Wr2Z50x5k6OFcmdvUAHiwG49cBwRj+FwDwyG0iA
	 qWk/W1qUmmE3hLoMhgZlZ7HKw/7LITP+GR/RxsYU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arka Mondal <arkamondalofficial@gmail.com>,
	Andy Shevchenko <andriy.shevchenko@intel.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Subject: [PATCH 6.6 0346/1674] iio: imu: adis16480: fix unprotected debugfs reads
Date: Sat, 17 Oct 2026 17:43:38 +0200
Message-ID: <20261017160440.010316866@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -302,9 +302,9 @@ static int adis16480_debugfs_init(struct
 	struct adis16480 *adis16480 = iio_priv(indio_dev);
 	struct dentry *d = iio_get_debugfs_dentry(indio_dev);
 
-	debugfs_create_file_unsafe("firmware_revision", 0400,
+	debugfs_create_file("firmware_revision", 0400,
 		d, adis16480, &adis16480_firmware_revision_fops);
-	debugfs_create_file_unsafe("firmware_date", 0400,
+	debugfs_create_file("firmware_date", 0400,
 		d, adis16480, &adis16480_firmware_date_fops);
 	debugfs_create_file_unsafe("serial_number", 0400,
 		d, adis16480, &adis16480_serial_number_fops);


