Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F35F2566DD;
	Mon, 12 May 2025 17:46:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747071972; cv=none; b=iwOhij6dHukvmW5dPYC0hSTNtc+8hKD29/l3+eVmASyATVOTiaCGDQp3h+YT25iJ6HoRc9YqgHvO2QZiUZNYvO8Kn1Uz7uxUBwVB3WsYRTfabQyrhHWI90MqLC74Kh0yXNFHQcyuR1AaO5RL3rP6uh1NUaR8MtdzsmL1U0skBXg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747071972; c=relaxed/simple;
	bh=JhHdTo/bbX5Vc0+3ynXPXxE5o/KpBu7SbHnzvc1l2m8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W+XAJRLDyldHgr/n+PlEfLPJ26ygbZsVgG13+e34k3mPb28oUq+AJxE5pXbQvqhqJ9kPFrAUPDHOgXBlyouJ2g4jrMCYJ/u4jZL5moZDKwXlid93scMQMERQdGl+uFX+RvUdcCtYaMvRmp0YzEkiubdhKbY+XP9QfuTCPOdzeFE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LeY1Q5Js; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LeY1Q5Js"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03076C4CEE9;
	Mon, 12 May 2025 17:46:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747071972;
	bh=JhHdTo/bbX5Vc0+3ynXPXxE5o/KpBu7SbHnzvc1l2m8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LeY1Q5JsGhV4zfQPAn3PEWXx8tbwnpBSN/jAEoTbGf6wn8zuo8Q0UCPJcjqGG57gi
	 3mjJw+tZ6wIRPGQOuOIOcCF9Lk/pkM6nid/W07DEPVAXHN76Z8QcyE2kpCsRPxWM19
	 fHxPSh6ANBtf5gkYSDczIUKknhpzazZf9uqENvXI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Lixu <lixu.zhang@intel.com>,
	Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.14 094/197] iio: hid-sensor-prox: support multi-channel SCALE calculation
Date: Mon, 12 May 2025 19:39:04 +0200
Message-ID: <20250512172048.212333276@linuxfoundation.org>
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

commit 8b518cdb03f5f6e06d635cbfd9583d1fdbb39bfd upstream.

With the introduction of multi-channel support in commit 596ef5cf654b
("iio: hid-sensor-prox: Add support for more channels"), each channel
requires an independent SCALE calculation, but the existing code only
calculates SCALE for a single channel.

Addresses the problem by modifying the driver to perform independent
SCALE calculations for each channel.

Cc: stable@vger.kernel.org
Fixes: 596ef5cf654b ("iio: hid-sensor-prox: Add support for more channels")
Signed-off-by: Zhang Lixu <lixu.zhang@intel.com>
Acked-by: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Link: https://patch.msgid.link/20250331055022.1149736-3-lixu.zhang@intel.com
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/common/hid-sensors/hid-sensor-attributes.c |    4 ++
 drivers/iio/light/hid-sensor-prox.c                    |   24 +++++++++--------
 2 files changed, 17 insertions(+), 11 deletions(-)

--- a/drivers/iio/common/hid-sensors/hid-sensor-attributes.c
+++ b/drivers/iio/common/hid-sensors/hid-sensor-attributes.c
@@ -66,6 +66,10 @@ static struct {
 	{HID_USAGE_SENSOR_HUMIDITY, 0, 1000, 0},
 	{HID_USAGE_SENSOR_HINGE, 0, 0, 17453293},
 	{HID_USAGE_SENSOR_HINGE, HID_USAGE_SENSOR_UNITS_DEGREES, 0, 17453293},
+
+	{HID_USAGE_SENSOR_HUMAN_PRESENCE, 0, 1, 0},
+	{HID_USAGE_SENSOR_HUMAN_PROXIMITY, 0, 1, 0},
+	{HID_USAGE_SENSOR_HUMAN_ATTENTION, 0, 1, 0},
 };
 
 static void simple_div(int dividend, int divisor, int *whole,
--- a/drivers/iio/light/hid-sensor-prox.c
+++ b/drivers/iio/light/hid-sensor-prox.c
@@ -34,9 +34,9 @@ struct prox_state {
 	struct iio_chan_spec channels[MAX_CHANNELS];
 	u32 channel2usage[MAX_CHANNELS];
 	u32 human_presence[MAX_CHANNELS];
-	int scale_pre_decml;
-	int scale_post_decml;
-	int scale_precision;
+	int scale_pre_decml[MAX_CHANNELS];
+	int scale_post_decml[MAX_CHANNELS];
+	int scale_precision[MAX_CHANNELS];
 	unsigned long scan_mask[2]; /* One entry plus one terminator. */
 	int num_channels;
 };
@@ -116,9 +116,12 @@ static int prox_read_raw(struct iio_dev
 		ret_type = IIO_VAL_INT;
 		break;
 	case IIO_CHAN_INFO_SCALE:
-		*val = prox_state->scale_pre_decml;
-		*val2 = prox_state->scale_post_decml;
-		ret_type = prox_state->scale_precision;
+		if (chan->scan_index >= prox_state->num_channels)
+			return -EINVAL;
+
+		*val = prox_state->scale_pre_decml[chan->scan_index];
+		*val2 = prox_state->scale_post_decml[chan->scan_index];
+		ret_type = prox_state->scale_precision[chan->scan_index];
 		break;
 	case IIO_CHAN_INFO_OFFSET:
 		*val = hid_sensor_convert_exponent(
@@ -249,6 +252,10 @@ static int prox_parse_report(struct plat
 					     st->prox_attr[index].size);
 		dev_dbg(&pdev->dev, "prox %x:%x\n", st->prox_attr[index].index,
 			st->prox_attr[index].report_id);
+		st->scale_precision[index] =
+			hid_sensor_format_scale(usage_id, &st->prox_attr[index],
+						&st->scale_pre_decml[index],
+						&st->scale_post_decml[index]);
 		index++;
 	}
 
@@ -257,11 +264,6 @@ static int prox_parse_report(struct plat
 
 	st->num_channels = index;
 
-	st->scale_precision = hid_sensor_format_scale(hsdev->usage,
-						      &st->prox_attr[0],
-						      &st->scale_pre_decml,
-						      &st->scale_post_decml);
-
 	return 0;
 }
 


