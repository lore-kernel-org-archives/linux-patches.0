Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 581A635E93B;
	Sat, 17 Oct 2026 17:13:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792257203; cv=none; b=Vac7L4Z94CfcoddZqyfKGw0er+PuhkL5EX/YOCAFlqBfLCnyEvyAZazSjKvMBYnoWTx8bNDaDMOoNUPd10wr6u/c+LNXnRkVMYszYKirLzKQhkxiL+FhM69xXa4M2KlaQM00SNIsxNB2zLw2qt4ybE7kRdia1+yYSSRpJEQQ7tM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792257203; c=relaxed/simple;
	bh=2V5PzzoQpjooAC1RuF7g2JvfWBgDTtwpeDSCWeUiMdg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LdMTYONOuKK1MvCikoWYdcSYVnmHxkOhvYByCstMWD9ObN3pMli4aXvgTQ346PPuDM0kxGR//ZECO79vl8PnHrWqTwqFlOaSbHOzTvkicUsiNHEvaGt8xmOIwbiDBhKjMOC27QDWFOpt73JA3Yi3wM784Idu3vfwWOyS5iiJFB4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LGqai293; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LGqai293"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 731581F000C4;
	Sat, 17 Oct 2026 17:13:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792257202;
	bh=mVs88NZ4P4BtVFsmn0oAD4O3yueH5WeuPy+cApg5vgU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LGqai293nyRi3yGDrn9z3SkZ3D7M0EWOdmSTpJcshyjrfAj1RZdPoDgCaS+SPe0OH
	 71pFFUz8WSlAGNTXmRdmFgCMz0wDSnmRrjAer9IE/rAVoOWMm6okhC3Sg/4iBN86OM
	 p5ibt/M3YMGC/ZcUWLozBM1di6HM07VsJL4YgFZg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonathan Cameron <jic23@kernel.org>,
	Marco Chen <marcochen.dev@gmail.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0432/1674] iio: health: max30102: fix NULL dereference in interrupt handler
Date: Sat, 17 Oct 2026 17:45:04 +0200
Message-ID: <20261017160442.213643181@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

From: Marco Chen <marcochen.dev@gmail.com>

[ Upstream commit f0ea4824deebf21dacfbe397c4b0a5fd3e745a8d ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/health/max30102.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/iio/health/max30102.c b/drivers/iio/health/max30102.c
index 43c16fcdeae19..9419cc62a2a4d 100644
--- a/drivers/iio/health/max30102.c
+++ b/drivers/iio/health/max30102.c
@@ -292,9 +292,15 @@ static irqreturn_t max30102_interrupt_handler(int irq, void *private)
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
 
-- 
2.53.0



