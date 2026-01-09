Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3C7533032C;
	Fri,  9 Jan 2026 12:39:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767962380; cv=none; b=bLL+F+W5XabhDAa1MRKN7V/0N0jwJKkmj3aNXiQ5HE6eYXsB7JRdsRU5BxAz21ufAHQVklbdGcUdvYn3SB+nKdSPwBxzH8A0BkblsYqNWJoBPg0zp+u1Ibtqg9DHHNeIHnJrSjONoFUuCJgLHUHpu7hcPKyq2mMX+LHh7TaxaP8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767962380; c=relaxed/simple;
	bh=J8A2agOGpqN6ecCbX9/+d5CN7vZsP0x0uq5NfVc3nlg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sjWCWOtK7V6hSIMq1ldf7TfMKx+Zv1JCPhmgJrfYcE+sim/iOyzGQQgDwO15RZClSHsxZff5rUntoYYrj1Uy2HoxOB4p09+x8xlpfBM9wZMKP+5G7RQV5h2gmZE3EHd7LnpSJqVKnoQC0SAGjeRAhp+YlwmsxaG3+tntQuFopTA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UBxKiWcC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UBxKiWcC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BD4CC4CEF1;
	Fri,  9 Jan 2026 12:39:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767962379;
	bh=J8A2agOGpqN6ecCbX9/+d5CN7vZsP0x0uq5NfVc3nlg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UBxKiWcCc12TVGJh0Eq/oWzyJkCgH8RMu7eo7C5XgfpQpGHYLM2/csUXblbf6dITP
	 Kft5v6ntrzs7L+P3vKbBDTqmsNbHis0VO+5yg8TGrInkwU3tXwfJytUfPvQPEBl5+o
	 E1te4H+ZnPlKEKfzw5YQ8WxYbUMt0gQjDAP8QPcE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Ma Ke <make24@iscas.ac.cn>
Subject: [PATCH 6.1 343/634] intel_th: Fix error handling in intel_th_output_open
Date: Fri,  9 Jan 2026 12:40:21 +0100
Message-ID: <20260109112130.430517576@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112117.407257400@linuxfoundation.org>
References: <20260109112117.407257400@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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


