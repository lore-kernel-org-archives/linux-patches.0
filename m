Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90C8315E83
	for <patches@lists.linux.dev>; Mon, 23 Oct 2023 11:38:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uDapNi1M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 095D3C433C7;
	Mon, 23 Oct 2023 11:38:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1698061127;
	bh=Eqxjxii8yxt7C9GdhYGB0bz97sBUx482/ptag/WveRs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uDapNi1MsfdhzZTfXy8AfqY02I0BqhMZbIhfda5sqhfUTraMEzTwKLb5aSn3ZlCtn
	 jbboNwDRxMpP5iqPALmCHxicgnrXjWbBsEeMWo+pmiH7ifjOQFFDZRl/Ewqj5i3tDd
	 kfPOmAs6IL1fecsqG5glbvhMCLitxRDI7z/0Pq6Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
	Andy Shevchenko <andy.shevchenko@gmail.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 054/137] iio: core: introduce iio_device_{claim|release}_buffer_mode() APIs
Date: Mon, 23 Oct 2023 12:56:51 +0200
Message-ID: <20231023104822.820738024@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231023104820.849461819@linuxfoundation.org>
References: <20231023104820.849461819@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nuno Sá <nuno.sa@analog.com>

[ Upstream commit 0a8565425afd8ba0e1a0ea73e21da119ee6dacea ]

These APIs are analogous to iio_device_claim_direct_mode() and
iio_device_release_direct_mode() but, as the name suggests, with the
logic flipped. While this looks odd enough, it will have at least two
users (in following changes) and it will be important to move the IIO
mlock to the private struct.

Signed-off-by: Nuno Sá <nuno.sa@analog.com>
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Link: https://lore.kernel.org/r/20221012151620.1725215-2-nuno.sa@analog.com
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Stable-dep-of: 7771c8c80d62 ("iio: cros_ec: fix an use-after-free in cros_ec_sensors_push_data()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/industrialio-core.c | 38 +++++++++++++++++++++++++++++++++
 include/linux/iio/iio.h         |  2 ++
 2 files changed, 40 insertions(+)

diff --git a/drivers/iio/industrialio-core.c b/drivers/iio/industrialio-core.c
index 6145e6e4f0ffd..78c780d1ab897 100644
--- a/drivers/iio/industrialio-core.c
+++ b/drivers/iio/industrialio-core.c
@@ -2084,6 +2084,44 @@ void iio_device_release_direct_mode(struct iio_dev *indio_dev)
 }
 EXPORT_SYMBOL_GPL(iio_device_release_direct_mode);
 
+/**
+ * iio_device_claim_buffer_mode - Keep device in buffer mode
+ * @indio_dev:	the iio_dev associated with the device
+ *
+ * If the device is in buffer mode it is guaranteed to stay
+ * that way until iio_device_release_buffer_mode() is called.
+ *
+ * Use with iio_device_release_buffer_mode().
+ *
+ * Returns: 0 on success, -EBUSY on failure.
+ */
+int iio_device_claim_buffer_mode(struct iio_dev *indio_dev)
+{
+	mutex_lock(&indio_dev->mlock);
+
+	if (iio_buffer_enabled(indio_dev))
+		return 0;
+
+	mutex_unlock(&indio_dev->mlock);
+	return -EBUSY;
+}
+EXPORT_SYMBOL_GPL(iio_device_claim_buffer_mode);
+
+/**
+ * iio_device_release_buffer_mode - releases claim on buffer mode
+ * @indio_dev:	the iio_dev associated with the device
+ *
+ * Release the claim. Device is no longer guaranteed to stay
+ * in buffer mode.
+ *
+ * Use with iio_device_claim_buffer_mode().
+ */
+void iio_device_release_buffer_mode(struct iio_dev *indio_dev)
+{
+	mutex_unlock(&indio_dev->mlock);
+}
+EXPORT_SYMBOL_GPL(iio_device_release_buffer_mode);
+
 /**
  * iio_device_get_current_mode() - helper function providing read-only access to
  *				   the @currentmode variable
diff --git a/include/linux/iio/iio.h b/include/linux/iio/iio.h
index 0cac05d5ef1c3..9b43559e3acfd 100644
--- a/include/linux/iio/iio.h
+++ b/include/linux/iio/iio.h
@@ -575,6 +575,8 @@ int __devm_iio_device_register(struct device *dev, struct iio_dev *indio_dev,
 int iio_push_event(struct iio_dev *indio_dev, u64 ev_code, s64 timestamp);
 int iio_device_claim_direct_mode(struct iio_dev *indio_dev);
 void iio_device_release_direct_mode(struct iio_dev *indio_dev);
+int iio_device_claim_buffer_mode(struct iio_dev *indio_dev);
+void iio_device_release_buffer_mode(struct iio_dev *indio_dev);
 
 extern struct bus_type iio_bus_type;
 
-- 
2.40.1



