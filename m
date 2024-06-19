Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 891F612FB27;
	Wed, 19 Jun 2024 13:20:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718803228; cv=none; b=BegT5sA3KijCRvPmWjdVuQu7WmgWT1iUQ/XPiPlziwjNDr/cf8jKXmBMe6s+99W8kRgcrAfKziq0YcL4aWp0bq68bD8pUjOwkIjd634hSobpjXgjNCJiwzOukBR7W18kZhxC+N2pdKX4+9Gnbdvvl+34TaEwndtaxRuZvV76o9k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718803228; c=relaxed/simple;
	bh=PHds+d02STHppvl8yuWFZuI1j3js0ZxseoZTC+CoknI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ifoLcgJIk7EBTv2bYbOit12rsJqnN8xp0F0Nc4xSDnTJV6NS+gkxtOcpfhzSDXQhwzuw2qE6sUXXtrVqUoWxRU4sA1BKGiDpNoTZYa5KQwmTip4/LyXhDZakEOUScV0IW/44Cmc5b0R24El1rlumi/ajjGWM6NYsJt7rb7ZIQOk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u0QbPITS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u0QbPITS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13B1AC4AF1A;
	Wed, 19 Jun 2024 13:20:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718803228;
	bh=PHds+d02STHppvl8yuWFZuI1j3js0ZxseoZTC+CoknI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u0QbPITSkYJSsbABy8Hg/sH6cIlHXQ5Blb5ZsnlPy/aVtZALiZjdDLH4rjdsNgDNT
	 94wmy6OVN4rZd16F1RAdH6UjIaJ1v1L0C/ldaZDUiKn6W+j4220Yw1953EYTlNnNZS
	 ILBMdzEjGuTkhBcxe0P9y7D/i+e7dFj/RjnCOEBo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jean-Baptiste Maneyrol <jean-baptiste.maneyrol@tdk.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.9 196/281] iio: invensense: fix odr switching to same value
Date: Wed, 19 Jun 2024 14:55:55 +0200
Message-ID: <20240619125617.493103946@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125609.836313103@linuxfoundation.org>
References: <20240619125609.836313103@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jean-Baptiste Maneyrol <jean-baptiste.maneyrol@tdk.com>

commit 95444b9eeb8c5c0330563931d70c61ca3b101548 upstream.

ODR switching happens in 2 steps, update to store the new value and then
apply when the ODR change flag is received in the data. When switching to
the same ODR value, the ODR change flag is never happening, and frequency
switching is blocked waiting for the never coming apply.

Fix the issue by preventing update to happen when switching to same ODR
value.

Fixes: 0ecc363ccea7 ("iio: make invensense timestamp module generic")
Cc: stable@vger.kernel.org
Signed-off-by: Jean-Baptiste Maneyrol <jean-baptiste.maneyrol@tdk.com>
Link: https://lore.kernel.org/r/20240524124851.567485-1-inv.git-commit@tdk.com
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/common/inv_sensors/inv_sensors_timestamp.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/iio/common/inv_sensors/inv_sensors_timestamp.c
+++ b/drivers/iio/common/inv_sensors/inv_sensors_timestamp.c
@@ -60,11 +60,15 @@ EXPORT_SYMBOL_NS_GPL(inv_sensors_timesta
 int inv_sensors_timestamp_update_odr(struct inv_sensors_timestamp *ts,
 				     uint32_t period, bool fifo)
 {
+	uint32_t mult;
+
 	/* when FIFO is on, prevent odr change if one is already pending */
 	if (fifo && ts->new_mult != 0)
 		return -EAGAIN;
 
-	ts->new_mult = period / ts->chip.clock_period;
+	mult = period / ts->chip.clock_period;
+	if (mult != ts->mult)
+		ts->new_mult = mult;
 
 	return 0;
 }


