Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCC3034D3BE;
	Fri,  9 Oct 2026 14:52:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791557552; cv=none; b=QNdKgLrMnBKSLXveTsGF1LsnOxpy5lCmYJWW/GltLdiLOQCAIgX5fQdBug8D4ypLr2wjKS7MSiATWH4jTVyIyoCyAGF7uj0RUtQKZ3ypAIycVPyJ7dnpxOBvJMYfuOV+ZfeOxegFdhZng3e74LLBaj9MlW/cTO+MzO2gOSUsJFA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791557552; c=relaxed/simple;
	bh=uAlXx7TMcpUnzwGb5oPbckdHkyE/8oBbvBvt5vOIs6E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RNwlMGfISxN2EXwTb9KJRTSaXVbeTRPyeyO3UI/lWDHBLm7bP0N37owN0iv+1E2/r1HynOjghPWJG7ukyPVrue/Y6Gg7TnOWlcQubDZ1l8VNWgbG/VTcJDJs9AIpqArhGgc7F0TtCssOoxViF5v3dt8kZ+mrx7tdzPGU477ZHWs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AN9a8uA3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AN9a8uA3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 062701F000FF;
	Fri,  9 Oct 2026 14:52:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791557549;
	bh=tUD0U2f3xE8qTjLxRyMoi9yktrCJ7d++/69Yp9Vu+0Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AN9a8uA3bbaLlGL7r4eSmM23+jd0jzbo3sKnX37oZMdP+dR0PPzN270qml4ZFO8vc
	 xXk7Ttged0Q5Ax7xQ0HJXlDxOlt+U/270teg8xvQsIobOFezwESWVkOnCTA8mQjoUp
	 JWHHnpDJwdTMNAC0pTdFY1SHX6cKuWHYLa7NaP6c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arka Mondal <arkamondalofficial@gmail.com>,
	Andy Shevchenko <andriy.shevchenko@intel.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Subject: [PATCH 7.2 400/428] iio: gyro: adis16136: fix unprotected debugfs reads
Date: Fri,  9 Oct 2026 16:12:17 +0200
Message-ID: <20261009140955.001876505@linuxfoundation.org>
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

commit 2b498df75d6c29aa3e760127ae0f0003df598b53 upstream.

The serial_number file operations are open coded and never call
debugfs_file_get(), which debugfs_create_file_unsafe() requires.
debugfs_remove_recursive() therefore does not wait for a read in
progress, and unbind frees the iio_dev underneath it.

Use debugfs_create_file() instead.

Fixes: 9aaea09b4cbd ("gyro:adis16136: fix debugfs_simple_attr.cocci warnings")
Signed-off-by: Arka Mondal <arkamondalofficial@gmail.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@intel.com>
Cc: stable@vger.kernel.org
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/gyro/adis16136.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/iio/gyro/adis16136.c
+++ b/drivers/iio/gyro/adis16136.c
@@ -145,7 +145,7 @@ static int adis16136_debugfs_init(struct
 	struct adis16136 *adis16136 = iio_priv(indio_dev);
 	struct dentry *d = iio_get_debugfs_dentry(indio_dev);
 
-	debugfs_create_file_unsafe("serial_number", 0400,
+	debugfs_create_file("serial_number", 0400,
 		d, adis16136, &adis16136_serial_fops);
 	debugfs_create_file_unsafe("product_id", 0400,
 		d, adis16136, &adis16136_product_id_fops);


