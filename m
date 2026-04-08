Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A315928C87C;
	Wed,  8 Apr 2026 18:35:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775673338; cv=none; b=nqKaGQ3VVn+f7czsioR7McVBta2yGCda+oZRFncjcCW7WhvAcuXnuOtdGVtRAku4mk1VvzrFVpvR1MOdPSjgGldvqteaF5sRZLY6mUXUQQvGxs1DHtWImgalDGtTvDLNa64vFKay6Nrs/wX/G9vE3E1XDMzumCO/YKUwrn7vQlc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775673338; c=relaxed/simple;
	bh=yXTNGJvLs0zlCVqucgS1ACywAkN65X+WBqcBB1uOpVw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EzfdskScqB828Pkz/Bip8VeyTPWmNbo5c0Jcw2VU+7B1Ck6vmZEywqsG9ix4mWFBqg5qV/KkqRSXYsLh/EsNDgxjimiaiA2t/na+oYoPcAgXd2BYAj0NZ1IUUR/HEfe9W5YORvYAIeyHEiuZ0GXohLsFIQE6+6oLQNxhguz2Rlw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qX8V4/9R; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qX8V4/9R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1579BC19421;
	Wed,  8 Apr 2026 18:35:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775673338;
	bh=yXTNGJvLs0zlCVqucgS1ACywAkN65X+WBqcBB1uOpVw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qX8V4/9R9ddO6lasG/Pde6ao7UoKeJfFIW3/DXckQNmabSFQN+V6YCDXuNA6G8UwO
	 2foV85CZjCiBe+Vjlv+GQCPUviTjui0zqGClRHjWyJUN6x5EL7dgaXoSI0wEn93DOy
	 lwQaexnFyUY2dvEfRWuj/vQY11qc6V0AUQ1astpU=
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
Subject: [PATCH 6.18 194/277] iio: gyro: mpu3050: Fix out-of-sequence free_irq()
Date: Wed,  8 Apr 2026 20:02:59 +0200
Message-ID: <20260408175941.107333795@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175933.836769063@linuxfoundation.org>
References: <20260408175933.836769063@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1278,9 +1278,9 @@ void mpu3050_common_remove(struct device
 	pm_runtime_get_sync(dev);
 	pm_runtime_put_noidle(dev);
 	pm_runtime_disable(dev);
-	iio_triggered_buffer_cleanup(indio_dev);
 	if (mpu3050->irq)
 		free_irq(mpu3050->irq, mpu3050->trig);
+	iio_triggered_buffer_cleanup(indio_dev);
 	mpu3050_power_down(mpu3050);
 }
 


