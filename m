Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BF2433121F;
	Wed,  8 Apr 2026 18:46:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775673961; cv=none; b=DTGQmZlVvCW4y7Pn1IPJ8u4Mv73X+4OrAzTOpBwJ47U7httVnqGSr9YvNjaq/K/ACXHy7VdZBO/Wed7k3+2DSRXXus5JQ5vLCx+huBATE10iUMzfxOahiVOqm+CG7phOrGlD0tJ1o9xLYoOZXd1ygJ2NkvEPy5lCzZqmQFvtl8w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775673961; c=relaxed/simple;
	bh=0guFoUsvn7ap/eYN2C29cfgR4pQij0yB/pewo+R9h+U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GpiGW+m9fAU2YiPEp7twWG11WjMBCUF8AXS56rLpkDWYlDExANyrYDQnSw4OOkmwvP6g9jnGb6be1tNzX27wvTCY6FP/5y0NXfxfAV83dUEeMjOrv4WkQuRyYbzP2pPPw1bisMDYZEuqwl6xsLi+O0hcINHWCuxEow9nEWTGgQc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ihpjYMCq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ihpjYMCq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80F42C19421;
	Wed,  8 Apr 2026 18:46:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775673960;
	bh=0guFoUsvn7ap/eYN2C29cfgR4pQij0yB/pewo+R9h+U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ihpjYMCqtJ/Ny4sSdcWLuZoWKv9DJfYD74M277+d66EIMZ85GrlAgp/jLjdZRa3Uf
	 kQYn+qQ0r5wm2KFewAH6bn3Jsx+kT6dkQIhoYCIeNs/zDHQ7SHqY8AAgtqXXA5hX9r
	 usfW27bbNMnXk8x3oRidA8YpfRTaRo8A4tOweTZM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Walleij <linusw@kernel.org>,
	Ethan Tidmore <ethantidmore06@gmail.com>,
	Andy Shevchenko <andriy.shevchenko@intel.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.12 156/242] iio: gyro: mpu3050: Fix irq resource leak
Date: Wed,  8 Apr 2026 20:03:16 +0200
Message-ID: <20260408175932.929507923@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175927.064985309@linuxfoundation.org>
References: <20260408175927.064985309@linuxfoundation.org>
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
@@ -1132,11 +1132,16 @@ static int mpu3050_trigger_probe(struct
 
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


