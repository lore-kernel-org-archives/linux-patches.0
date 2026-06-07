Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C2CB2C1595;
	Sun,  7 Jun 2026 10:35:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780828502; cv=none; b=usmaXDhltXKqQPF0hEq0n9ggUdLplpqNRWE/yEiy8AnawI7R8D06mOqPtApCzxoUiV68zfVZ3Sw83cBN/hLkMmx/xhOQLtOc+FDZ2vi90KTXyp5KokLc/sqwL9xCC8N7l0to4ojlK4e02FFAePWMyZJzfP3akoHAbUhOcJbXxAs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780828502; c=relaxed/simple;
	bh=kFHdJlQkCGOj9rV47qf8AYm/g677cMTR8mwLErvi050=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jnIIAf1jPAE0Hqr2ZTzBr0v9xXuFLvNtfy3KYwuWeSBH/5Vl3nAdTbZ7zRJ33U04q1m/tWchF46WJG13GykbTYcfPbZ5kOdBwdCCY7e9O963PU5xPnIigya1iYEpDOzUE+AOpff8EDEJPtBCJBOaDBBfWC7WljO2uzOqvc30XK4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=emNF3C/7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="emNF3C/7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8E951F00893;
	Sun,  7 Jun 2026 10:35:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780828501;
	bh=kltIOqnOsNREVueH90R2YUlk0Jyyh8yirpklWUeRkJg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=emNF3C/7zKySojAZgl9AMgiADk4m8u9JEmg/oMCxA4qiJpZ/Yh/nNUl1A/3QStRzy
	 dUQhoYs20RVel9D639l4Jypl4vBH7u8c9FNYz5VCtUh8zOsxpa8ataMkC6DFkrIh49
	 RRWqYaVNpKsT9K1cou638la6oQPVhVU6GfAdSa7A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Advait Dhamorikar <advaitd@mechasystems.com>,
	Andy Shevchenko <andriy.shevchenko@intel.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <jic23@kernel.org>
Subject: [PATCH 6.18 168/315] iio: magnetometer: st_magn: fix default DRDY pin selection for LIS2MDL
Date: Sun,  7 Jun 2026 11:59:15 +0200
Message-ID: <20260607095733.762947843@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095727.528828913@linuxfoundation.org>
References: <20260607095727.528828913@linuxfoundation.org>
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
@@ -506,6 +506,11 @@ static const struct st_sensors_platform_
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
@@ -628,8 +633,12 @@ int st_magn_common_probe(struct iio_dev
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


