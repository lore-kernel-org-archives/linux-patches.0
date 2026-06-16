Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5B5047A0B5;
	Tue, 16 Jun 2026 17:27:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781630861; cv=none; b=MSC5BRH2dypmWu67n1LJJGLe9Y5UWHfheLjj+oEdja63HexxNDlnXeKlOngJjAUwLRMUAbXbE2AuAhJkZgy5Xe2L8pfWq8mFP+QcAalR5rZXEd1PWRZYLEKllAf7OncGQ/sgdj1IicVQdrCujmDnjW9BLEBtc/QFMmrotXlQIkc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781630861; c=relaxed/simple;
	bh=25s3xHdCeNRvJhO85nAFWpKILrYWwNLkYtEodExSu0E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fevNnSx+qtBDnK6YR6RFBu+6HcFlY2DBNeEQ768CqE5xowgFTC5B7VeaUEeA7QFDYRcpQxQUO+eXCL9ssB4z/z8MvGlrxqdC7G2yX53/WVIcIxRqUMVpiVKLuiXdmOJLh+beDAIaeQsp9Gebc4jnzspEu/vcCEVBg8WZTUcbXRU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KycdfJqk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KycdfJqk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EE841F000E9;
	Tue, 16 Jun 2026 17:27:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781630859;
	bh=P5NSwa8wcyAghk9PkzZDXaUxFmw9zNj3lGIxAAcfBks=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KycdfJqkASJWQ6s2R1YCJSEAjgo1VrFQ7gEy1bxDal8L5C8EpccqLfkEBnp0NYVvI
	 ruLyahQyhICGlAM2JOcnP9hXJ0JqiZ0lCqJRPYyCkVuvA3etIpg6jxynmq0awkeAyG
	 h2ZeTXIWe01GdZj7seroaJeU/Ypu4pgLqObLCICw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Advait Dhamorikar <advaitd@mechasystems.com>,
	Andy Shevchenko <andriy.shevchenko@intel.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <jic23@kernel.org>
Subject: [PATCH 6.1 111/522] iio: magnetometer: st_magn: fix default DRDY pin selection for LIS2MDL
Date: Tue, 16 Jun 2026 20:24:18 +0530
Message-ID: <20260616145131.143155189@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145125.307082728@linuxfoundation.org>
References: <20260616145125.307082728@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Advait Dhamorikar <advaitd@mechasystems.com>

commit 49f79cd28f1e3333cbe0d616ce59ead0b24bf34e upstream.

The device tree binding for st,lis2mdl does not support
st,drdy-int-pin property. However, when no platform data is provided
and the property is absent, the driver falls back to default_magn_pdata
which hardcodes drdy_int_pin = 2. This causes
`st_sensors_set_drdy_int_pin` to fail with -EINVAL because the LIS2MDL
sensor settings have no INT2 DRDY mask defined.

Fix this by checking the sensor's INT2 DRDY mask availability at
probe time and selecting the appropriate default pin. Sensors that
do not support INT2 DRDY will default to INT1, while all others
retain the existing default of INT2.

Fixes: 38934daf7b5c ("iio: magnetometer: st_magn: Provide default platform data")
Signed-off-by: Advait Dhamorikar <advaitd@mechasystems.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@intel.com>
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <jic23@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/magnetometer/st_magn_core.c |   13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

--- a/drivers/iio/magnetometer/st_magn_core.c
+++ b/drivers/iio/magnetometer/st_magn_core.c
@@ -504,6 +504,11 @@ static const struct st_sensors_platform_
 	.drdy_int_pin = 2,
 };
 
+/* LIS2MDL only supports DRDY on INT1 */
+static const struct st_sensors_platform_data alt_magn_pdata = {
+	.drdy_int_pin = 1,
+};
+
 static int st_magn_read_raw(struct iio_dev *indio_dev,
 			struct iio_chan_spec const *ch, int *val,
 							int *val2, long mask)
@@ -626,8 +631,12 @@ int st_magn_common_probe(struct iio_dev
 	mdata->current_fullscale = &mdata->sensor_settings->fs.fs_avl[0];
 	mdata->odr = mdata->sensor_settings->odr.odr_avl[0].hz;
 
-	if (!pdata)
-		pdata = (struct st_sensors_platform_data *)&default_magn_pdata;
+	if (!pdata) {
+		if (mdata->sensor_settings->drdy_irq.int2.mask)
+			pdata = (struct st_sensors_platform_data *)&default_magn_pdata;
+		else
+			pdata = (struct st_sensors_platform_data *)&alt_magn_pdata;
+	}
 
 	err = st_sensors_init_sensor(indio_dev, pdata);
 	if (err < 0)


