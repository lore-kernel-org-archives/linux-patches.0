Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E31226B2DD;
	Tue,  8 Apr 2025 11:25:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744111554; cv=none; b=BRV7SFRPO44oT8Zy+iUY+reJ01VToiZOCjz6vUL0Yq++kLDJyQ99L2/pKiI+WegJ4Y24de22qc9oW/oUadEios9A04iwdioRHuRE+AHuMFH7UlHOLT5MQ6OwRsyNPHOmoZ8j129qRQ9mcNsoDNlN/dKvRaDmqpBsUmCeVZkGl+c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744111554; c=relaxed/simple;
	bh=493WA2urAfDYlaRD/YgHpNCoBIz7N6e3pUtmfjlczqA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ja24QtF+wgf6NI704OLO5j3X2KLLgFo6TnYp5w2pgA8LUbukXoW93Dc8O0687f/ANZ98jJ4/gLk0UsB8LbsK/NC+Z1s2dvjViw7PmpCZ1IuvkQqyaPZxoFTh4wFzGjBO/eO0iUwBGvbGdLX0CHMWmoGYrOnAT0H2S8A5RhBujyg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K7xQ8QNQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K7xQ8QNQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11ACEC4CEE5;
	Tue,  8 Apr 2025 11:25:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744111554;
	bh=493WA2urAfDYlaRD/YgHpNCoBIz7N6e3pUtmfjlczqA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K7xQ8QNQy7LHk/5Hswgee7NwWYix3zpN0Akw9fAtINp0dCI1rjUM7ul+9QxZZpFFv
	 sfzvosgCbj5usYyPDgMgFmyUthoGclH6pyLaVnoc03VEPXeCwoStFppvdVP7nChJq2
	 X9B85WDPI8U00vRZHGHWk/vjHgBH5w0TXGssEUh4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Lechner <dlechner@baylibre.com>,
	Nuno Sa <nuno.sa@analog.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 474/731] iio: core: Rework claim and release of direct mode to work with sparse.
Date: Tue,  8 Apr 2025 12:46:11 +0200
Message-ID: <20250408104925.304083849@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
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

From: Jonathan Cameron <Jonathan.Cameron@huawei.com>

[ Upstream commit d795e38df4b7ebac1072bbf7d8a5500c1ea83332 ]

Initial thought was to do something similar to __cond_lock()

	do_iio_device_claim_direct_mode(iio_dev) ? : ({ __acquire(iio_dev); 0; })
+ Appropriate static inline iio_device_release_direct_mode()

However with that, sparse generates false positives. E.g.

drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_core.c:1811:17: warning: context imbalance in 'st_lsm6dsx_read_raw' - unexpected unlock

So instead, this patch rethinks the return type and makes it more
'conditional lock like' (which is part of what is going on under the hood
anyway) and return a boolean - true for successfully acquired, false for
did not acquire.

To allow a migration path given the rework is now non trivial, take a leaf
out of the naming of the conditional guard we currently have for IIO
device direct mode and drop the _mode postfix from the new functions giving
iio_device_claim_direct() and iio_device_release_direct()

Whilst the kernel supports __cond_acquires() upstream sparse does not
yet do so.  Hence rely on sparse expanding a static inline wrapper
to explicitly see whether __acquire() is called.

Note that even with the solution here, sparse sometimes gives false
positives. However in the few cases seen they were complex code
structures that benefited from simplification anyway.

Reviewed-by: David Lechner <dlechner@baylibre.com>
Reviewed-by: Nuno Sa <nuno.sa@analog.com>
Link: https://patch.msgid.link/20250209180624.701140-2-jic23@kernel.org
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Stable-dep-of: 7021d97fb89b ("iio: adc: ad7173: Grab direct mode for calibration")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/iio/iio.h | 26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/include/linux/iio/iio.h b/include/linux/iio/iio.h
index 56161e02f002c..5ed03e36178fc 100644
--- a/include/linux/iio/iio.h
+++ b/include/linux/iio/iio.h
@@ -10,6 +10,7 @@
 #include <linux/device.h>
 #include <linux/cdev.h>
 #include <linux/cleanup.h>
+#include <linux/compiler_types.h>
 #include <linux/slab.h>
 #include <linux/iio/types.h>
 /* IIO TODO LIST */
@@ -662,6 +663,31 @@ int iio_push_event(struct iio_dev *indio_dev, u64 ev_code, s64 timestamp);
 int iio_device_claim_direct_mode(struct iio_dev *indio_dev);
 void iio_device_release_direct_mode(struct iio_dev *indio_dev);
 
+/*
+ * Helper functions that allow claim and release of direct mode
+ * in a fashion that doesn't generate many false positives from sparse.
+ * Note this must remain static inline in the header so that sparse
+ * can see the __acquire() marking. Revisit when sparse supports
+ * __cond_acquires()
+ */
+static inline bool iio_device_claim_direct(struct iio_dev *indio_dev)
+{
+	int ret = iio_device_claim_direct_mode(indio_dev);
+
+	if (ret)
+		return false;
+
+	__acquire(iio_dev);
+
+	return true;
+}
+
+static inline void iio_device_release_direct(struct iio_dev *indio_dev)
+{
+	iio_device_release_direct_mode(indio_dev);
+	__release(indio_dev);
+}
+
 /*
  * This autocleanup logic is normally used via
  * iio_device_claim_direct_scoped().
-- 
2.39.5



