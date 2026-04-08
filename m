Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC90A3D75AF;
	Wed,  8 Apr 2026 18:59:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775674785; cv=none; b=KLhvIGkTyLp+G0fslpL21EcTPptgeSOIYJrpc/HjBbJTlqq0i4q0OjabCnm+Iyd5WtYcItuYkhT7bEnMRu/8OPXtQg4zk26YDmJOWUMajALSpTncDXf+rtGexv6opRGZVLPxm36fqQFuLlkTC8+mpy5fgCLyEMsH1OtJYbOvu2I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775674785; c=relaxed/simple;
	bh=S7fm5s8NjZBive+/qZtwt5FH4kh5iIyFppSAFCOzCxw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qIMHWhxbfs11sOJwfeMVWFL1N33CdEYFCRjNSRG9zIg/fBF9Yftve4N217oed868b9On08TGcKilepkrpO5xXCIS+4S7Vfin+t0tZQJvyH2xVF7OfMWDlBKIpI7Lg+dIFp3JUOFT5269lRaj8qWarWCjqEbJtS3UZ+kDkjgHhdo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0YUB6iv2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0YUB6iv2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 496EBC19421;
	Wed,  8 Apr 2026 18:59:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775674785;
	bh=S7fm5s8NjZBive+/qZtwt5FH4kh5iIyFppSAFCOzCxw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0YUB6iv2aVvi3dcEidsc+8zx7jCGQWa+cF958M8cxdNzSjWt27yynrchQ75XRRhfD
	 yGjmcWTjts7FL/ALiI2gCrqhA8XiLH6zbEIoNWIQlETK0I627A1H8yTfeJCq9YesNs
	 gPM4QE1tiTHgFqa7YhnIfXts7EwB4UmnUsSM1ubs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Walleij <linusw@kernel.org>,
	Ethan Tidmore <ethantidmore06@gmail.com>,
	Andy Shevchenko <andriy.shevchenko@intel.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.19 232/311] iio: gyro: mpu3050: Fix irq resource leak
Date: Wed,  8 Apr 2026 20:03:52 +0200
Message-ID: <20260408175948.059744678@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175939.393281918@linuxfoundation.org>
References: <20260408175939.393281918@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ethan Tidmore <ethantidmore06@gmail.com>

commit 4216db1043a3be72ef9c2b7b9f393d7fa72496e6 upstream.

The interrupt handler is setup but only a few lines down if
iio_trigger_register() fails the function returns without properly
releasing the handler.

Add cleanup goto to resolve resource leak.

Detected by Smatch:
drivers/iio/gyro/mpu3050-core.c:1128 mpu3050_trigger_probe() warn:
'irq' from request_threaded_irq() not released on lines: 1124.

Fixes: 3904b28efb2c7 ("iio: gyro: Add driver for the MPU-3050 gyroscope")
Reviewed-by: Linus Walleij <linusw@kernel.org>
Signed-off-by: Ethan Tidmore <ethantidmore06@gmail.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@intel.com>
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/gyro/mpu3050-core.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/drivers/iio/gyro/mpu3050-core.c
+++ b/drivers/iio/gyro/mpu3050-core.c
@@ -1129,11 +1129,16 @@ static int mpu3050_trigger_probe(struct
 
 	ret = iio_trigger_register(mpu3050->trig);
 	if (ret)
-		return ret;
+		goto err_iio_trigger;
 
 	indio_dev->trig = iio_trigger_get(mpu3050->trig);
 
 	return 0;
+
+err_iio_trigger:
+	free_irq(mpu3050->irq, mpu3050->trig);
+
+	return ret;
 }
 
 int mpu3050_common_probe(struct device *dev,


