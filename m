Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E07736828B;
	Sat, 12 Sep 2026 19:48:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789242491; cv=none; b=V3K24+PCJFjKVobc7/hc59tY8HGMB50gGoTAwppNl+jXiWIHbMkpW37J2nqSR4OJnEUR94EtYKdfarMITXCPiYHXl1tRama9ff7kvP9h/mO4bL3Q1T+K3NNENhsLNpor/F3kmlCFf81Gj789jHgfU4/aISWSjj1jthw1mQ8/+zs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789242491; c=relaxed/simple;
	bh=3CqCOuZsqR1cP3tWdGuwbfM4qwXFYNyBjHbpd72Hrpo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j9BXjVog8tM16MERq0WU4re2i1R1uHW5/e4K13011hC0yoGpytDnT5mOL4vMBf7hT9hMKOyN25KPCpRsHE5vhH+MXZEayiGA7zYXFoEYWEqtgHpCfUSdEZfpXvf/5BRuzvt1KxnDDLi/ApbvMJi04pDLE3iSMkk6A0rF8yd6C90=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ItXiOMBb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ItXiOMBb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 898A21F000FF;
	Sat, 12 Sep 2026 19:48:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789242490;
	bh=kpnJZ7L6WOk5t0RIPIZPd4/ZI+krpxDgerF4WciMu+I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ItXiOMBb8qSvD6D2fpmU2z8j5udOG4vDtJZswsy1BvfzkBFhku5eci3HEB1aczhoS
	 KyHaj8vs/uqe20jyVxOsRKdS3gkDl1oyBWih/eaTD3RLdvXprdASjvHlPI+RlgVwcm
	 MbL4t3ubrutJk/obSKtJIgEKL9hbmxdAgMrCPIGE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mert Seftali <mertsftl@gmail.com>,
	Joshua Crofts <joshua.crofts1@gmail.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 420/798] iio: accel: dmard09: Implement IIO_CHAN_INFO_SCALE
Date: Sat, 12 Sep 2026 09:00:48 +0200
Message-ID: <20260912065526.776366602@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mert Seftali <mertsftl@gmail.com>

[ Upstream commit aa58ecc73466d0cb8c418de98e2225490bf600e3 ]

Reading the in_accel_scale attribute on the DMARD09 has always returned
-EINVAL: the channels advertise scale via info_mask_shared_by_type so the
IIO core exposes the attribute, but dmard09_read_raw() only handles
IIO_CHAN_INFO_RAW, so a SCALE read falls through to 'default: return
-EINVAL':

    $ cat .../iio:deviceX/in_accel_scale
    cat: in_accel_scale: Invalid argument

leaving userspace with raw counts it cannot convert to m/s^2.

The driver was written from a vendor source [1] without a datasheet, and
the scale was declared but never implemented. The vendor source carries
the sensitivity: its conversion is

    acc = raw * GRAVITY_EARTH_1000 / sensitivity   (then / 1000 -> m/s^2)

with sensitivity = 32 and GRAVITY_EARTH_1000 = 9807 ("about
(9.80665)*1000"), i.e. 32 counts correspond to 1 g.

That sensitivity applies to the value this driver already reports as raw:
the vendor reduces each 16-bit sample to a signed 9-bit value, and the
preparation in dmard09_read_raw() yields the same value. It is
self-consistent: 256 counts / 32 = 8 g full scale, matching the +/-8g
range.

Implement the scale derived from that sensitivity using standard gravity:

    scale = 9.80665 / 32 = 0.3064578125 m/s^2 per LSB

Link: https://github.com/minstrelsy/mediatek/blob/1f49d8c87b839651bc89afc870277e8e0f2e2d55/custom/common/kernel/accelerometer/dmard09/dmard09.c [1]
Fixes: a4fa6509dda4 ("iio: accel: add support for the Domintech DMARD09 3-axis accelerometer")
Signed-off-by: Mert Seftali <mertsftl@gmail.com>
Reviewed-by: Joshua Crofts <joshua.crofts1@gmail.com>
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/accel/dmard09.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/iio/accel/dmard09.c b/drivers/iio/accel/dmard09.c
index e6e28c9647776..e2f470d801493 100644
--- a/drivers/iio/accel/dmard09.c
+++ b/drivers/iio/accel/dmard09.c
@@ -8,6 +8,7 @@
 #include <asm/unaligned.h>
 #include <linux/module.h>
 #include <linux/i2c.h>
+#include <linux/units.h>
 #include <linux/iio/iio.h>
 
 #define DMARD09_DRV_NAME	"dmard09"
@@ -79,6 +80,12 @@ static int dmard09_read_raw(struct iio_dev *indio_dev,
 		*val = accel;
 
 		return IIO_VAL_INT;
+	case IIO_CHAN_INFO_SCALE:
+		*val = 0;
+		/* 1 g / 32 LSB, in m/s^2 */
+		*val2 = IIO_G_TO_M_S_2(NANO / 32);
+
+		return IIO_VAL_INT_PLUS_NANO;
 	default:
 		return -EINVAL;
 	}
-- 
2.53.0



