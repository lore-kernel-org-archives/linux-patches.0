Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B314B35504A;
	Tue,  6 Jan 2026 17:24:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767720292; cv=none; b=slG8dkd110A0e39Ajv0uLrcQTM3MhsA/CzmiF5rVtho1J0hCKrg78yA7VWe7bOi5w5e4pu3aLGvnXowCdQD9ONZKIN4uUIUb6pBXB0DxlKL5tMF38uyU6f5S0JFs1OP0B2kIPIhPcDG688Bl+BhpP49jK/YjiS/KmEp0PRfV2oE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767720292; c=relaxed/simple;
	bh=XhJ6Bni8WqfrY/dNHusOsO9XGWvX+Ax8ISUT5bQmVQM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Eyq5WSMi5AlItrByP6g/vpWZWd6uPrCDtMdCfABvVUMionOq+ucAcZjN8in/D/hWNn4bGgW1waAcerfHPnS/jGxgtj+fbYrRVu8Bo9l4LUeHjWjKzTqSqnB8kWhCa5YreUOohGV9s35/eh7pRSC7Q40ICp6/qOQem0Z/2HFKH1M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GLUljeyK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GLUljeyK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4EFBC116C6;
	Tue,  6 Jan 2026 17:24:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767720292;
	bh=XhJ6Bni8WqfrY/dNHusOsO9XGWvX+Ax8ISUT5bQmVQM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GLUljeyK+8VaqfnuuVHo5oG+x3zUrBjk+J6g7m2RVWo7GGqLBrkwm5zCO0zIIbA44
	 n94hTddqUtp0VkWKH8KbIa72cjp0pgd4jf1BTEwCZvaIuwF1OlcSfUjR1YyNwMyCb7
	 p+jsVJDT26QMkoMDPI3CfElIUn6OpfJ+JB3sxOhY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Ma Ke <make24@iscas.ac.cn>
Subject: [PATCH 6.12 192/567] intel_th: Fix error handling in intel_th_output_open
Date: Tue,  6 Jan 2026 17:59:34 +0100
Message-ID: <20260106170458.428327958@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170451.332875001@linuxfoundation.org>
References: <20260106170451.332875001@linuxfoundation.org>
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


