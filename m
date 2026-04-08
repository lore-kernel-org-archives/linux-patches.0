Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1691C331A44;
	Wed,  8 Apr 2026 18:35:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775673318; cv=none; b=l8ibsPmvXtTtguUd6Mt1ZNfgodYPI2RFeESts2k8Dmx2U/zwIDlyfmq301xIeh751RS2QrXpop8+V8nfACxdAZnoBAAihQXn8GwtGSF6hDcq6sI+NYJgSeXrQQPSFB0rRHPigeJ1mzyu1cHPozKBBVJpYCcg8wOlXbengvrz5uo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775673318; c=relaxed/simple;
	bh=sTjnLvwRp+RL8INqBgO9Rp8928g6r66VSFPFhKfK00A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UZjyUa6plqD/K/1/8bqZ4nGa2FshOzPCONQKaNCrYMHDSE8v1BBEC7x8BbuaQdal/+ZcyHTgmNbS6IUbOek/tP2r3N5cgZ1h9i4pvngJ/PwDFlOboiaoPfNsIPuw1ZummUTnKY1MSyXckzxmdmd64sVk/kbXLtRXBPRgtvYEBCk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ifp1gQvJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ifp1gQvJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F9A4C19421;
	Wed,  8 Apr 2026 18:35:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775673318;
	bh=sTjnLvwRp+RL8INqBgO9Rp8928g6r66VSFPFhKfK00A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ifp1gQvJM65fmLaBQfZPNsWh6oA5DppbJDtbYW12fWvUs1S18DIzaeqg29RBCaCL/
	 BOU9E3TvIQLbXseBdDjjK6KHaxkcizTlzlZLFsyD5DwMoy774Og9AgWPfeYM0SQyJC
	 EEa2uM4/96T4iWHqffmZSzE2Pc1Ue+Fkh+IlcubQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Lechner <dlechner@baylibre.com>,
	Andy Shevchenko <andriy.shevchenko@intel.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.18 153/277] iio: add IIO_DECLARE_QUATERNION() macro
Date: Wed,  8 Apr 2026 20:02:18 +0200
Message-ID: <20260408175939.585329955@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175933.836769063@linuxfoundation.org>
References: <20260408175933.836769063@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Lechner <dlechner@baylibre.com>

commit 56bd57e7b161f75535df91b229b0b2c64c6e5581 upstream.

Add a new IIO_DECLARE_QUATERNION() macro that is used to declare the
field in an IIO buffer struct that contains a quaternion vector.

Quaternions are currently the only IIO data type that uses the .repeat
feature of struct iio_scan_type. This has an implicit rule that the
element in the buffer must be aligned to the entire size of the repeated
element. This macro will make that requirement explicit. Since this is
the only user, we just call the macro IIO_DECLARE_QUATERNION() instead
of something more generic.

Signed-off-by: David Lechner <dlechner@baylibre.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@intel.com>
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/iio/iio.h |   12 ++++++++++++
 1 file changed, 12 insertions(+)

--- a/include/linux/iio/iio.h
+++ b/include/linux/iio/iio.h
@@ -816,6 +816,18 @@ static inline void *iio_device_get_drvda
 #define IIO_DECLARE_DMA_BUFFER_WITH_TS(type, name, count) \
 	__IIO_DECLARE_BUFFER_WITH_TS(type, name, count) __aligned(IIO_DMA_MINALIGN)
 
+/**
+ * IIO_DECLARE_QUATERNION() - Declare a quaternion element
+ * @type: element type of the individual vectors
+ * @name: identifier name
+ *
+ * Quaternions are a vector composed of 4 elements (W, X, Y, Z). Use this macro
+ * to declare a quaternion element in a struct to ensure proper alignment in
+ * an IIO buffer.
+ */
+#define IIO_DECLARE_QUATERNION(type, name) \
+	type name[4] __aligned(sizeof(type) * 4)
+
 struct iio_dev *iio_device_alloc(struct device *parent, int sizeof_priv);
 
 /* The information at the returned address is guaranteed to be cacheline aligned */


