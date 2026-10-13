Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DA7E48A2C7;
	Tue, 13 Oct 2026 12:42:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791895342; cv=none; b=LNqcdJQpINWYac5Z8k2im9h+mouR66FhPEbK5Zuxg20yFxVmauV8Z1AumVKoS8iSkmMcPSZ4dZwVdYVlp9e/4SjPBv2MNi4GXOzCjOjUGrjTGo/v4yPZT4RVR5c4H8q9/5wuVflyWzrJ/f13QfivK8MpP+Ddac2BWJU6GprVdoI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791895342; c=relaxed/simple;
	bh=tX+td8t8eMAxM/5kgJzENKyg3HA/YSkl2MvLWjs31rY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Cza/arTvDbl2q4KnwVUH4AL7FNNMEgc4YWbK3uJBUHWSrNKZjRQYg2xmkrOpVd4jK0Epb2FKIdmBRk5+RprgEgGobb/JeKxlstJ72kCO+2CIF1OnJCLJLE8SrxSLhLy9ZklS2pj5jrvuDGZ5BIv/0qoZJy9ReKgmZbiY+eETmwQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pirCnUTM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pirCnUTM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC5541F000FF;
	Tue, 13 Oct 2026 12:42:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791895341;
	bh=JIDPbXJKfIVM9xCBjDhoZjDYyfF8gLZs9l3L68o5DY4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pirCnUTMZ1q09WBoDHwRuTyCww4njM1LUWvsdS4CySQvocVTP4sbCvYbtzufTo7Ea
	 Bzq5wEmlr4HXFSFo919dSnkyMekO6yZ1K6Am4Xfc8P5TbsiS0JVEYLJ0Zk9P45qzaV
	 pI5tgs9Jn6MWearYuV8NK8O9iNpYWI+CX6+BTwgU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonathan Cameron <jic23@kernel.org>,
	Marco Chen <marcochen.dev@gmail.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Subject: [PATCH 6.12 243/497] iio: health: max30102: fix NULL dereference in interrupt handler
Date: Tue, 13 Oct 2026 13:36:50 +0200
Message-ID: <20261013112913.663180275@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112907.864180619@linuxfoundation.org>
References: <20261013112907.864180619@linuxfoundation.org>
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

From: Marco Chen <marcochen.dev@gmail.com>

commit f0ea4824deebf21dacfbe397c4b0a5fd3e745a8d upstream.

The interrupt is requested in max30102_probe() and stays enabled
for the lifetime of the device, but indio_dev->active_scan_mask is only
valid while a buffer is enabled. When an interrupt arrives while no
buffer is enabled, the handler dereferences the NULL active_scan_mask:

  Unable to handle kernel NULL pointer dereference at virtual address 0000000000000000
  Call trace:
   __bitmap_weight+0x64/0x98 (P)
   max30102_interrupt_handler+0x48/0x160 [max30102]

Call max30102_fifo_count() at the top of the handler and return early
unless it reports a FIFO sample is ready. Because FIFO_RDY is the only
interrupt source enabled in max30102_chip_init(), an invocation of
max30102_interrupt_handler() without the FIFO_RDY interrupt status bit
set carries no data to read and can return before touching
active_scan_mask. A negative return from max30102_fifo_count()
indicates a failed interrupt status read and is treated the same way.

Fixes: 90579b69e94b ("iio: health: max30102: Add MAX30105 support")
Suggested-by: Jonathan Cameron <jic23@kernel.org>
Signed-off-by: Marco Chen <marcochen.dev@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/health/max30102.c |   12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

--- a/drivers/iio/health/max30102.c
+++ b/drivers/iio/health/max30102.c
@@ -292,9 +292,15 @@ static irqreturn_t max30102_interrupt_ha
 {
 	struct iio_dev *indio_dev = private;
 	struct max30102_data *data = iio_priv(indio_dev);
-	unsigned int measurements = bitmap_weight(indio_dev->active_scan_mask,
-						  iio_get_masklength(indio_dev));
-	int ret, cnt = 0;
+	unsigned int measurements;
+	int ret, cnt;
+
+	cnt = max30102_fifo_count(data);
+	if (cnt <= 0)
+		return IRQ_HANDLED;
+
+	measurements = bitmap_weight(indio_dev->active_scan_mask,
+				     iio_get_masklength(indio_dev));
 
 	mutex_lock(&data->lock);
 


