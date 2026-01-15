Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C30D234216C;
	Thu, 15 Jan 2026 17:52:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768499565; cv=none; b=gaccC+euT/5RTxAPZaT0qJZTJ0O6wlM38ZVLFVoU6uvvoF0MTO5T78kV+b07ivbxAlcCKrXUa4ncUWwkYiK0EVOx7LD+F6kKWAoKMEC/s2jFkjA9X7KRWISbm23H0vNR2P/0Au4xC1ERqZIznYPIGfn785Crq9c8VDxqx0O9itQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768499565; c=relaxed/simple;
	bh=iuhIp+QCeHrIkwxmuy6kJSrNDM8oX5t815fKMzR3Fkk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZeMOyzprkhIuPs71PjS3X7rkc4qzoO9Z9k/reIeAU6eKY6jCysFoxVNqst9eXBq01GhftQ+RGb9ZZpfx6UInXHSnY5NikGFU8/0k7E/gh3bI1Kr5Jo7SAMDH6XGsZoUW+sDAQvmyHloG6S+oT8hqRYZ3DgPUl9La2B3bxJr1bgg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eeQs9oWX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eeQs9oWX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 079DBC116D0;
	Thu, 15 Jan 2026 17:52:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768499565;
	bh=iuhIp+QCeHrIkwxmuy6kJSrNDM8oX5t815fKMzR3Fkk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eeQs9oWXmPL3NUxmZl4/mVT1CMAt4Ng32C+J0LcoInhwF8w0IL8ZGJqYQ8w4XbYnW
	 XDA2Yb6weCAhhn97F01XXt6oywqyarNF6FEZUHD+H2i6AGRxH5I6WPw7Grn2l53Xzz
	 fNQCtYKTGhD9Mye97VZs94XOQ68MFf0SwZqborOc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Ma Ke <make24@iscas.ac.cn>
Subject: [PATCH 5.10 238/451] intel_th: Fix error handling in intel_th_output_open
Date: Thu, 15 Jan 2026 17:47:19 +0100
Message-ID: <20260115164239.503412459@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164230.864985076@linuxfoundation.org>
References: <20260115164230.864985076@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ma Ke <make24@iscas.ac.cn>

commit 6d5925b667e4ed9e77c8278cc215191d29454a3f upstream.

intel_th_output_open() calls bus_find_device_by_devt() which
internally increments the device reference count via get_device(), but
this reference is not properly released in several error paths. When
device driver is unavailable, file operations cannot be obtained, or
the driver's open method fails, the function returns without calling
put_device(), leading to a permanent device reference count leak. This
prevents the device from being properly released and could cause
resource exhaustion over time.

Found by code review.

Cc: stable <stable@kernel.org>
Fixes: 39f4034693b7 ("intel_th: Add driver infrastructure for Intel(R) Trace Hub devices")
Signed-off-by: Ma Ke <make24@iscas.ac.cn>
Link: https://patch.msgid.link/20251112091723.35963-1-make24@iscas.ac.cn
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hwtracing/intel_th/core.c |   20 +++++++++++++++-----
 1 file changed, 15 insertions(+), 5 deletions(-)

--- a/drivers/hwtracing/intel_th/core.c
+++ b/drivers/hwtracing/intel_th/core.c
@@ -810,13 +810,17 @@ static int intel_th_output_open(struct i
 	int err;
 
 	dev = bus_find_device_by_devt(&intel_th_bus, inode->i_rdev);
-	if (!dev || !dev->driver)
-		return -ENODEV;
+	if (!dev || !dev->driver) {
+		err = -ENODEV;
+		goto out_no_device;
+	}
 
 	thdrv = to_intel_th_driver(dev->driver);
 	fops = fops_get(thdrv->fops);
-	if (!fops)
-		return -ENODEV;
+	if (!fops) {
+		err = -ENODEV;
+		goto out_put_device;
+	}
 
 	replace_fops(file, fops);
 
@@ -824,10 +828,16 @@ static int intel_th_output_open(struct i
 
 	if (file->f_op->open) {
 		err = file->f_op->open(inode, file);
-		return err;
+		if (err)
+			goto out_put_device;
 	}
 
 	return 0;
+
+out_put_device:
+	put_device(dev);
+out_no_device:
+	return err;
 }
 
 static const struct file_operations intel_th_output_fops = {


