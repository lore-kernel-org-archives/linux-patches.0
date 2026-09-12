Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 522AB3148A7;
	Sat, 12 Sep 2026 19:40:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789242017; cv=none; b=LCGuRNraD2sUlVdg2wbCt4ZfLL334Ww02k6z5PvQwW5gWPsyJTvBOizsklD2ZjrPADR2M3NbX57SRftXH9XB/bjjujNRZ82F/H7u+gVDSkg8q1p10xaEN8GxPxASJVFqMrWo/RWZV0M8DVee8tlm9YDutK0vI4LlzPd4Flsrvvo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789242017; c=relaxed/simple;
	bh=UmWWvBgRc+/iBlYY9JbDQ1WDvSr7wzTwvumdpx+Zv/g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Gzg0ORUCH40mwgyKa0XiOalm4WdNCHP1Oqv6co09S97WsTCzRHLaJapKfHBFB79nJ9dQ4g+3nm8n0N13MPzpMwJMNlrqamc9z533GKFE1mOkQG5tu5wYycc+1MBfbUBZdA1S8TzptMIPmJyi6Qotl8tRi8u36BkcrsYMPC9blgo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=se5oM1t0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="se5oM1t0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 711151F000FF;
	Sat, 12 Sep 2026 19:40:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789242016;
	bh=kPbODB+/xUsq2XzpiBI76d654KQ1HqG3k91K744ZVhA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=se5oM1t08xwrPNQ8XDccJ99AFNZFm8dlg8bzuZplR71y/EScmx6RZ6U9N/m4zCz21
	 FBV6TPn+nkbKj18LId79ey6ch8TpETe0tFmsLr07FjTwhFyPpe9FpbKewblu6gixo3
	 v6FHF8jiH1AdrQHHWo9aBg7csTqos1VMW7NfinQI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Erick Henrique <erick.henrique.rodrigues@usp.br>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Subject: [PATCH 5.10 257/798] iio: dac: m62332: Fix regulator reference count imbalance
Date: Sat, 12 Sep 2026 08:58:05 +0200
Message-ID: <20260912065523.048807642@linuxfoundation.org>
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
@@ -34,6 +34,7 @@ static int m62332_set_value(struct iio_d
 {
 	struct m62332_data *data = iio_priv(indio_dev);
 	struct i2c_client *client = data->client;
+	bool enabling, disabling;
 	u8 outbuf[2];
 	int res;
 
@@ -45,7 +46,10 @@ static int m62332_set_value(struct iio_d
 
 	mutex_lock(&data->mutex);
 
-	if (val) {
+	enabling = val && !data->raw[channel];
+	disabling = !val && data->raw[channel];
+
+	if (enabling) {
 		res = regulator_enable(data->vcc);
 		if (res)
 			goto out;
@@ -54,14 +58,17 @@ static int m62332_set_value(struct iio_d
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


