Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8651653D0B8;
	Wed,  9 Sep 2026 14:23:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788963835; cv=none; b=W/SY4AKmqiGHfE1So58QUXVy8P/l62rNrmbji2T9Eni7JTeEppvKGm6jbvWxpG6b3PP5mcWSV1wmRW7lM/EThJYsCaiQ7igLrO84xcU4Y+gBA/A+NdCuo/cfMiXlTbAv0zjqOsIXbdnt0UOI4wg5+mE2+y+8ndOVFaSQNB+6ub0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788963835; c=relaxed/simple;
	bh=WkascvZI1ils/yBlv1aMfxc6yGpm3Q9G8OnGM7oKGB8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mhEC8Rh2YkZ4CvPXF8NJbfYd7uXjue26wqtIRhx7Lfy/v9O8jERwzGkKrh1aNDXYQ808/fpbup16zU1HIgO1iIs4AoL4Xg/vAuk6+1Wv7cAzAmT+xtxMOQzE9SfywykxIcDfsrfvGmMw95SNm22FzknU97yvBA8NWdH3Pgeopis=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T6EOIv3T; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T6EOIv3T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEBD11F00A3A;
	Wed,  9 Sep 2026 14:23:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788963834;
	bh=+hatNru4GzIYRKOyAOpg04v1h6woJ0qMbYrJ/aEIyNE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=T6EOIv3TT0tzAex1A0BklSZo0GUafb/Z6jWyUb5c70m5X73deHLNv/ItTNtfplY1G
	 lcPiYt/tbfaw+JsUDjSOKL/W70+S8RuYDeSFoHO8rLCh6SHbsQ09Ot7OBj2rx8OD2v
	 /Duiwu8/kOpVi8OcXj++tveFHCb2V8Odlv06tD/E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Erick Henrique <erick.henrique.rodrigues@usp.br>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Subject: [PATCH 6.18 213/583] iio: dac: m62332: Fix regulator reference count imbalance
Date: Wed,  9 Sep 2026 15:38:18 +0200
Message-ID: <20260909134245.523099735@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134237.773280130@linuxfoundation.org>
References: <20260909134237.773280130@linuxfoundation.org>
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

From: Erick Henrique <erick.henrique.rodrigues@usp.br>

commit a130404ce0b69ca1438126bd81c1985d3b4d2e6f upstream.

m62332_set_value() enables the Vcc regulator on every write of a
non-zero value and disables it on every write of zero, without tracking
the channel's current state. Because the regulator is reference counted,
changing a channel directly from one non-zero value to another enables
it more than once, while a later write of zero disables it only once.
The reference count never returns to zero and the regulator is left
enabled indefinitely.

Only enable the regulator on the transition from zero to non-zero, and
only disable it on the transition from non-zero to zero, using the
previously stored channel value to detect the edge. Balance the
regulator on the I2C error path so the reference count stays consistent
if the write fails.

Fixes: b87b0c0f81e8 ("iio: add m62332 DAC driver")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://sashiko.dev/#/patchset/20260418130322.106769-1-erick.henrique.rodrigues%40usp.br
Cc: stable@vger.kernel.org
Signed-off-by: Erick Henrique <erick.henrique.rodrigues@usp.br>
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/dac/m62332.c |   17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

--- a/drivers/iio/dac/m62332.c
+++ b/drivers/iio/dac/m62332.c
@@ -32,6 +32,7 @@ static int m62332_set_value(struct iio_d
 {
 	struct m62332_data *data = iio_priv(indio_dev);
 	struct i2c_client *client = data->client;
+	bool enabling, disabling;
 	u8 outbuf[2];
 	int res;
 
@@ -43,7 +44,10 @@ static int m62332_set_value(struct iio_d
 
 	mutex_lock(&data->mutex);
 
-	if (val) {
+	enabling = val && !data->raw[channel];
+	disabling = !val && data->raw[channel];
+
+	if (enabling) {
 		res = regulator_enable(data->vcc);
 		if (res)
 			goto out;
@@ -52,14 +56,17 @@ static int m62332_set_value(struct iio_d
 	res = i2c_master_send(client, outbuf, ARRAY_SIZE(outbuf));
 	if (res >= 0 && res != ARRAY_SIZE(outbuf))
 		res = -EIO;
-	if (res < 0)
+	if (res < 0) {
+		if (enabling)
+			regulator_disable(data->vcc);
 		goto out;
+	}
 
-	data->raw[channel] = val;
-
-	if (!val)
+	if (disabling)
 		regulator_disable(data->vcc);
 
+	data->raw[channel] = val;
+
 	mutex_unlock(&data->mutex);
 
 	return 0;


