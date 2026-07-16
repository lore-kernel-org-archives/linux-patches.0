Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D51BA3BED2D;
	Thu, 16 Jul 2026 13:39:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784209161; cv=none; b=Qc9u3gKeGzH5v8kA1UVz8HZPmRNii68zrURvT6x8QoMvGeJYWScmeAJ+SnKrAvJM8L4QKXjd80WaC0utj61q9pDs3XpKIQlMG3Rm0CexLLuedlkzdp+NIEWO6yw8CcbEluqQbIru+tx8HOe9gbJ+O2efiQKbp7vub4RG81E/5lw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784209161; c=relaxed/simple;
	bh=tV1G2ADWClrTZ+Jy36IsV8qqBpfHPqLpxzxwNs4jIJY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RECR4Szq90YOqhpTXCZVKwym63yttTKaT4Jnu6eFdk2voMU8mcWeRnQNpboovCp3JSG/ecbkXj7M2yRVl6bOhhlAJd/3WwMjtsZnSUdRehjrlJp9T4LT4yhnzx07N2Qksjjzc2hwk5U9OzCkEcFcSdF7yI0SPymzTAsFUljCsIw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l67JCihD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l67JCihD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 470121F000E9;
	Thu, 16 Jul 2026 13:39:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784209160;
	bh=L0PgQR+pKj+iQJHr2kIfPi3QBB7BRFf3U7y70wRxY54=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=l67JCihD162acJWgp/IwyQu0OEupZ+qvMK3eGPlDJIlM7iv4jw4FMpTnBVdPFSzrO
	 OgiP/DRhf+ERFSRvhcv+KxihecDsdSHpAK6IBUWhTrRcMEBTVZGm8PFAN9dppurDW2
	 PD91wWt4keIfKY5VQso/CvPVOdVJ5A3sWw/aJBWo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stepan Ionichev <sozdayvek@gmail.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <jic23@kernel.org>
Subject: [PATCH 7.1 073/518] iio: proximity: vl53l0x: notify trigger and clear IRQ on error paths
Date: Thu, 16 Jul 2026 15:25:41 +0200
Message-ID: <20260716133049.384546997@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133047.772246337@linuxfoundation.org>
References: <20260716133047.772246337@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stepan Ionichev <sozdayvek@gmail.com>

commit be843b0579f872ec7590d825e2c9a656d4790c4b upstream.

vl53l0x_trigger_handler() returns directly on the I2C read failure
paths without calling iio_trigger_notify_done() or vl53l0x_clear_irq().

A single transient i2c_smbus_read_i2c_block_data() failure (negative
errno or a short read) therefore leaves two pieces of state behind:

  - iio_trigger_notify_done() never decrements the trigger's use_count,
    so iio_trigger_poll_nested() silently drops further dispatches
    (see industrialio-trigger.c, the !atomic_read(&trig->use_count)
    guard);
  - vl53l0x_clear_irq() never writes SYSTEM_INTERRUPT_CLEAR, so the
    chip keeps the DRDY interrupt asserted.

The sensor's buffer mode stays wedged from then on, recoverable only
by re-binding the driver. The sibling driver vl53l1x-i2c.c handles
exactly the same case correctly by jumping to a "notify_and_clear_irq"
label that always calls both helpers; mirror that here.

The bogus negative-int return value cast to irqreturn_t also goes
away as a side effect.

Fixes: 762186c6e7b1 ("iio: proximity: vl53l0x-i2c: Added continuous mode support")
Signed-off-by: Stepan Ionichev <sozdayvek@gmail.com>
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <jic23@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/proximity/vl53l0x-i2c.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- a/drivers/iio/proximity/vl53l0x-i2c.c
+++ b/drivers/iio/proximity/vl53l0x-i2c.c
@@ -87,15 +87,14 @@ static irqreturn_t vl53l0x_trigger_handl
 	ret = i2c_smbus_read_i2c_block_data(data->client,
 					VL_REG_RESULT_RANGE_STATUS,
 					sizeof(buffer), buffer);
-	if (ret < 0)
-		return ret;
-	else if (ret != 12)
-		return -EREMOTEIO;
+	if (ret != 12)
+		goto done;
 
 	scan.chan = get_unaligned_be16(&buffer[10]);
 	iio_push_to_buffers_with_ts(indio_dev, &scan, sizeof(scan),
 				    iio_get_time_ns(indio_dev));
 
+done:
 	iio_trigger_notify_done(indio_dev->trig);
 	vl53l0x_clear_irq(data);
 


