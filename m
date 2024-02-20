Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73A08612D7;
	Tue, 20 Feb 2024 21:13:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708463602; cv=none; b=RFs0swuEQAxmd/63RDD4/F2CvjEeRloQ6gkCjKphCX4Ixr7IZmjarVuMS9zT/IkKBpHWLXOLoCH+EFn7Q3Cl/ss6d3lZHB8QnTq6FVSIVTQ3I+TDOOZpvUygv6JjwQKCeCIl5Uma5D7DFZf3pXNzjEF2L6qjfcohecuwNhmkNMs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708463602; c=relaxed/simple;
	bh=2wMMIwF8YLezvV3vXWcRRF0yMjUhK4VWeAtTD/Mpyrk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rotIvfS5sB8ZEpqtRsqiOYzUF0Tz4siisod4yn+LRqgixFED9RpD+5Oqir+Qmv4dBgcDIAJAZlfuJjWpueQjdHIK6JVlLRT1tfhH68cbRMOH6o8TIw11rmjpGEI2yYQvx2cG6NfIXLR9Kj9A564EWFpKueWiKCz9UCbukpoJwws=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xllYpzVr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xllYpzVr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6ED8C433C7;
	Tue, 20 Feb 2024 21:13:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708463602;
	bh=2wMMIwF8YLezvV3vXWcRRF0yMjUhK4VWeAtTD/Mpyrk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xllYpzVrqpejXEsBVk31SYPhzIKeAXzKCHvlarCL7J2WhSw96iopjQMjxC0s5m0hi
	 BmJdecTynOuMH8mPvDV1+uvFkT5UwBPB6xhqvgXhgUhaz83sHXDBUMDNiMeq5AjV+g
	 T16DCKBGhrN6l30iRP7u9Q1Hzl1owLkl2F2YJddY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cosmin Tanislav <demonsingur@gmail.com>,
	Nuno Sa <nuno.sa@analog.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 095/331] iio: adc: ad4130: only set GPIO_CTRL if pin is unused
Date: Tue, 20 Feb 2024 21:53:31 +0100
Message-ID: <20240220205640.564967769@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205637.572693592@linuxfoundation.org>
References: <20240220205637.572693592@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Cosmin Tanislav <demonsingur@gmail.com>

[ Upstream commit 78367c32bebfe833cd30c855755d863a4ff3fdee ]

Currently, GPIO_CTRL bits are set even if the pins are used for
measurements.

GPIO_CTRL bits should only be set if the pin is not used for
other functionality.

Fix this by only setting the GPIO_CTRL bits if the pin has no
other function.

Fixes: 62094060cf3a ("iio: adc: ad4130: add AD4130 driver")
Signed-off-by: Cosmin Tanislav <demonsingur@gmail.com>
Reviewed-by: Nuno Sa <nuno.sa@analog.com>
Link: https://lore.kernel.org/r/20240207132007.253768-2-demonsingur@gmail.com
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/adc/ad4130.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/iio/adc/ad4130.c b/drivers/iio/adc/ad4130.c
index bbdae66d1f1d..e650ebd167b0 100644
--- a/drivers/iio/adc/ad4130.c
+++ b/drivers/iio/adc/ad4130.c
@@ -1900,10 +1900,14 @@ static int ad4130_setup(struct iio_dev *indio_dev)
 		return ret;
 
 	/*
-	 * Configure all GPIOs for output. If configured, the interrupt function
-	 * of P2 takes priority over the GPIO out function.
+	 * Configure unused GPIOs for output. If configured, the interrupt
+	 * function of P2 takes priority over the GPIO out function.
 	 */
-	val =  AD4130_IO_CONTROL_GPIO_CTRL_MASK;
+	val = 0;
+	for (i = 0; i < AD4130_MAX_GPIOS; i++)
+		if (st->pins_fn[i + AD4130_AIN2_P1] == AD4130_PIN_FN_NONE)
+			val |= FIELD_PREP(AD4130_IO_CONTROL_GPIO_CTRL_MASK, BIT(i));
+
 	val |= FIELD_PREP(AD4130_IO_CONTROL_INT_PIN_SEL_MASK, st->int_pin_sel);
 
 	ret = regmap_write(st->regmap, AD4130_IO_CONTROL_REG, val);
-- 
2.43.0



