Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FF803D522C;
	Wed,  8 Apr 2026 18:26:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775672770; cv=none; b=MRDGlzoAMIcLtYCiqFxK2YSEEL68e3rUOpMPvv6kRqf0DDr/7GTfTt03J21/D92epFb84AjsS5Sx15vNZWA7YDOKmbHe2lU6/gp2l7Y8Nu/4zpRc/sTErwbXs0VeBh2iKM9QLODVm5UC71YKYhUr7TrrZ2Gb1cKyi/evoFbGIag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775672770; c=relaxed/simple;
	bh=anGkHQOj3qjiIi0Ci1IPvbTqjfINji4KIYsePEoJiLs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sfEK7s+da6Iylhwjnsw3vYn05Je9rNGKpnr4YkKKRNo/P9DzcF7W1UoAPTBaT+H9vavmI9D4zXPbad1l24w6eZavZi0s69YGrlTLUKMPb5/fBYPRchzsgrtVF1D9URnexs1bwlDEg49KcB9RttDkVWNL8xYDyjNSp+Q7ykZwSyY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sieKdaqs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sieKdaqs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA04FC19421;
	Wed,  8 Apr 2026 18:26:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775672770;
	bh=anGkHQOj3qjiIi0Ci1IPvbTqjfINji4KIYsePEoJiLs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sieKdaqsyOUPq+MFNWCPh8Tl6VmpwN1wb/XLIgg/Pqxft4j45a6K7jC6glM0eSNGh
	 Zs/cghBMPq1YtC6bpZA9/kvAnkrEbqoQ8jJnZeHy47oMFVgfcBkz8eWGZr/FrRdPEl
	 r2RrUJ0JaYWGh+r8IAMrmJLVJk+Hy3nJEsnVtsrM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonathan Cameron <jic23@kernel.org>,
	Linus Walleij <linusw@kernel.org>,
	Ethan Tidmore <ethantidmore06@gmail.com>,
	Andy Shevchenko <andriy.shevchenko@intel.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.6 103/160] iio: gyro: mpu3050: Fix out-of-sequence free_irq()
Date: Wed,  8 Apr 2026 20:03:10 +0200
Message-ID: <20260408175917.030423114@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175913.177092714@linuxfoundation.org>
References: <20260408175913.177092714@linuxfoundation.org>
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

From: Ethan Tidmore <ethantidmore06@gmail.com>

commit d14116f6529fa085b1a1b1f224dc9604e4d2a29c upstream.

The triggered buffer is initialized before the IRQ is requested. The
removal path currently calls iio_triggered_buffer_cleanup() before
free_irq(). This violates the expected LIFO.

Place free_irq() in the correct location relative to
iio_triggered_buffer_cleanup().

Fixes: 3904b28efb2c7 ("iio: gyro: Add driver for the MPU-3050 gyroscope")
Suggested-by: Jonathan Cameron <jic23@kernel.org>
Reviewed-by: Linus Walleij <linusw@kernel.org>
Signed-off-by: Ethan Tidmore <ethantidmore06@gmail.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@intel.com>
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/gyro/mpu3050-core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/iio/gyro/mpu3050-core.c
+++ b/drivers/iio/gyro/mpu3050-core.c
@@ -1288,9 +1288,9 @@ void mpu3050_common_remove(struct device
 	pm_runtime_get_sync(dev);
 	pm_runtime_put_noidle(dev);
 	pm_runtime_disable(dev);
-	iio_triggered_buffer_cleanup(indio_dev);
 	if (mpu3050->irq)
 		free_irq(mpu3050->irq, mpu3050->trig);
+	iio_triggered_buffer_cleanup(indio_dev);
 	mpu3050_power_down(mpu3050);
 }
 


