Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D93935BDC3;
	Fri,  9 Jan 2026 12:09:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767960545; cv=none; b=QJ2tlgy5RL6b2IjjaQm/d5A9OOY8RveQDY6XrWTzHWnoCXGgVcY/u7Ksj48QBWJfsu+JpNPVZUON9OVqXwgUC4hVU/Qd9vGfpd77rEDExyJQdreBtywwg4yxnMEj9t1LHT8ywzlZThVkJSjwsHIHr/gncF+2BDyfPsJL1mnE+kA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767960545; c=relaxed/simple;
	bh=lSdJNrI98EkvGiF6fv7o1gcJrVx8QS9ijpsj6JpDpbc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NOJ5tgUYzg8+cs1MaqnQRg6IVZD0ziCwoYW/X4I+jPVNOAgoYgKZ5gIL9hWG78znsGVqEsTMl2PH/vbsFq31ETDRfHzBTGcZFBbBNbho3GB5AWojH6hgpC+EphfWatkWUepX+qyzrYfhvywWWAGlPenrsi2tuJxBapxc9O+oGM8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fh15djPo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fh15djPo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DA53C19421;
	Fri,  9 Jan 2026 12:09:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767960544;
	bh=lSdJNrI98EkvGiF6fv7o1gcJrVx8QS9ijpsj6JpDpbc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fh15djPotGTu5fCDj4Yd+TNrki/51jhm1Dc9e6CBHPVRuKDc7qO1G/j1Sz+W2ZvuO
	 cLn6OBgn5oap8l4r7wjPB4SJJDLS/qLW6TngDkRKHHoyROEP+AW8NYDtJjziJIwJBl
	 AWiI58HBgBrvY/m2REcK/pdQ3UgPlbNpXEjCo6vI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Ma Ke <make24@iscas.ac.cn>
Subject: [PATCH 6.6 442/737] intel_th: Fix error handling in intel_th_output_open
Date: Fri,  9 Jan 2026 12:39:41 +0100
Message-ID: <20260109112150.619392476@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
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


