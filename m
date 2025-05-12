Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3985E1C173C;
	Mon, 12 May 2025 17:48:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747072085; cv=none; b=tfbNJx55Kj48P0zxZLZjo0al0paw9vmBiV+GK5OjB47oa4yJXbaO7yB08Qvy3b8XCtDrgYFF1KgRCoBSYPUQStwLn9k2b/5mFeJAbu8u2d6hLbbQ0MsQfhxPMSZOwm8DroQhNDUgE9kTPGtriAjL0VqEGVxrFFfNJ6qrZxRoa5M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747072085; c=relaxed/simple;
	bh=UWD64vTkTWAb/roMKU1BEpijRZ30V6SyCaoPZMBsDE0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=un6hR268LbeeOSwgSx6vopB9fQUwCoxIRRAt6iXKj5TyqOegF2dW/28Ab7Y/0ZlzjqxUWHYNzCzMkbj1OcSUjFLQkelnXe+u2EZTWZ7/ADkcB8MHkfa5HcKJds3CE6F/pa11ir9enRkuO93nOPveeePSTScYvTaaNkndUmfYs7I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ow0Qim0z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ow0Qim0z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC0DDC4CEE7;
	Mon, 12 May 2025 17:48:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747072085;
	bh=UWD64vTkTWAb/roMKU1BEpijRZ30V6SyCaoPZMBsDE0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ow0Qim0z/0kTkcq1AXMrWXw/vvE8CM0Svb4pu+O9dSsZcSphC9eRFc19XaFEUvdqC
	 I7VAcLbu2fEjZI24iytkL7zD/sK6ETumBXcwhSzT9ECValFwlxYypQej5aOU7kRWoo
	 DDDGCPO2qzHpfv4A0iGmnTNaKOD03dGGkb9d01oU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Lixu <lixu.zhang@intel.com>,
	Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.14 095/197] iio: hid-sensor-prox: Fix incorrect OFFSET calculation
Date: Mon, 12 May 2025 19:39:05 +0200
Message-ID: <20250512172048.252462714@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250512172044.326436266@linuxfoundation.org>
References: <20250512172044.326436266@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhang Lixu <lixu.zhang@intel.com>

commit 79dabbd505210e41c88060806c92c052496dd61c upstream.

The OFFSET calculation in the prox_read_raw() was incorrectly using the
unit exponent, which is intended for SCALE calculations.

Remove the incorrect OFFSET calculation and set it to a fixed value of 0.

Cc: stable@vger.kernel.org
Fixes: 39a3a0138f61 ("iio: hid-sensors: Added Proximity Sensor Driver")
Signed-off-by: Zhang Lixu <lixu.zhang@intel.com>
Acked-by: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Link: https://patch.msgid.link/20250331055022.1149736-4-lixu.zhang@intel.com
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/light/hid-sensor-prox.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/iio/light/hid-sensor-prox.c
+++ b/drivers/iio/light/hid-sensor-prox.c
@@ -124,8 +124,7 @@ static int prox_read_raw(struct iio_dev
 		ret_type = prox_state->scale_precision[chan->scan_index];
 		break;
 	case IIO_CHAN_INFO_OFFSET:
-		*val = hid_sensor_convert_exponent(
-			prox_state->prox_attr[chan->scan_index].unit_expo);
+		*val = 0;
 		ret_type = IIO_VAL_INT;
 		break;
 	case IIO_CHAN_INFO_SAMP_FREQ:


