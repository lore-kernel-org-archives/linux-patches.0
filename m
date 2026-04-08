Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A06C83537FC;
	Wed,  8 Apr 2026 18:16:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775672190; cv=none; b=KfteOC5ThAzuEahZISJxjs8HGrrNJLnfXBt2Ay1SqQwh1LApINbvXiBg13KjeWarJ0uZJNa1Q9X82QBQNZy8doeZNcMu8kgKjh1Tgp4Rp5WCnMAHtDcKBm2M9UNQOgrOJKo40JpMNEBfpuXUWlAB+wDzg+GFB7qPv1+HSk6qZqA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775672190; c=relaxed/simple;
	bh=zuHgtBMLZD1EtAERve2NCev3ZstjyAXASE5Cb8sE4hA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=skVeQ49GUytQPoGUSyRaTltmMysqnc4jQZxTa6pS+dVyFv0hq4pJ78RZ7qsTEvoGZNdasiiGb8yi3j5TLsjtObczvKYwqb+CfFaYShHhXDnxwdRI+R4hfTeS8bHzSar5AC2ZRDn58+db94wjzxOZohnhcNaLFWHdI4EG2VoxQMg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bs1hUf/7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bs1hUf/7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36D9BC19421;
	Wed,  8 Apr 2026 18:16:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775672190;
	bh=zuHgtBMLZD1EtAERve2NCev3ZstjyAXASE5Cb8sE4hA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bs1hUf/7I326D2yqcIUp2jR/lWjBbMnI5N28a9DLEMYln+T0lR6NLtbSIccgn5+Tq
	 SVGkSMzJXDUdN88Wgz7R1bpDU4fA9W5AE+SJYKn2MkdeCDr0sSOFMgvDXLD5ylH+Lw
	 f3StxgmKXMSC4ZJAfopyGUdpy3trdFo0e/Bi4ZW4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Walleij <linusw@kernel.org>,
	Ethan Tidmore <ethantidmore06@gmail.com>,
	Andy Shevchenko <andriy.shevchenko@intel.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.1 223/312] iio: gyro: mpu3050: Fix incorrect free_irq() variable
Date: Wed,  8 Apr 2026 20:02:20 +0200
Message-ID: <20260408175942.085610649@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175933.715315542@linuxfoundation.org>
References: <20260408175933.715315542@linuxfoundation.org>
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

From: Ethan Tidmore <ethantidmore06@gmail.com>

commit edb11a1aef4011a4b7b22cc3c3396c6fe371f4a6 upstream.

The handler for the IRQ part of this driver is mpu3050->trig but,
in the teardown free_irq() is called with handler mpu3050.

Use correct IRQ handler when calling free_irq().

Fixes: 3904b28efb2c7 ("iio: gyro: Add driver for the MPU-3050 gyroscope")
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
@@ -1279,7 +1279,7 @@ void mpu3050_common_remove(struct device
 	pm_runtime_disable(dev);
 	iio_triggered_buffer_cleanup(indio_dev);
 	if (mpu3050->irq)
-		free_irq(mpu3050->irq, mpu3050);
+		free_irq(mpu3050->irq, mpu3050->trig);
 	iio_device_unregister(indio_dev);
 	mpu3050_power_down(mpu3050);
 }


