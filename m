Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2037C30C360;
	Mon, 13 Apr 2026 16:38:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776098285; cv=none; b=VtPF3hBS8wfURyDsL45Uv5nrOWN7EX4GsbyyNypseGzEeknfmU/LCDbUG01vyFT7Qkd55eyunvUt6VEvylWcwanSzPKgOT3TljMwom5hYiIx0lzTXe/Fvj1EGlQBfNfGBe1RV+gkXlzIPBUtfukI3S9pZRULgpjvLXc9sEK5wuU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776098285; c=relaxed/simple;
	bh=LzXzT/LOKbq0unDqU6aWVD09lLpWINI8CoD2wlkaN0s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SB+vNWLWNML8SYxKTeA8JccqUlLRVecPa5ff2NbwxDnDQTGKejzywxYu2/4RQR3h357ZYP+is6q+Q2xyB0AAZJkrZGRS5lS7KHVOxEKN2AUmp2VKweFV95P4CoZ6MJ/53laF23d9DvEvzFwOcPMmaia8IojbfS48hbNfTI8YyWs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vuW7ANeD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vuW7ANeD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA80EC2BCAF;
	Mon, 13 Apr 2026 16:38:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776098285;
	bh=LzXzT/LOKbq0unDqU6aWVD09lLpWINI8CoD2wlkaN0s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vuW7ANeDTdqFip2L5gd5z4J1wwYLjZ3K/dU6pDHcH7hsbeIieoJc18usCBhCpsLtO
	 3a19gMhz4eXBzV5BZGkNgLw7pIBx4wpR5fqr7FiO08PCkk6YNRRv56pnnXQg2uLjgg
	 Dl9hpFPGvrs4yMMZxGGLcoMQHLvX+CR9p4ISai5o=
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
Subject: [PATCH 5.15 465/570] iio: gyro: mpu3050: Fix out-of-sequence free_irq()
Date: Mon, 13 Apr 2026 17:59:56 +0200
Message-ID: <20260413155847.887065054@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155830.386096114@linuxfoundation.org>
References: <20260413155830.386096114@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1291,9 +1291,9 @@ int mpu3050_common_remove(struct device
 	pm_runtime_get_sync(dev);
 	pm_runtime_put_noidle(dev);
 	pm_runtime_disable(dev);
-	iio_triggered_buffer_cleanup(indio_dev);
 	if (mpu3050->irq)
 		free_irq(mpu3050->irq, mpu3050->trig);
+	iio_triggered_buffer_cleanup(indio_dev);
 	mpu3050_power_down(mpu3050);
 
 	return 0;


