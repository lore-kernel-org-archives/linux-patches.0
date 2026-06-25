Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C970828751B;
	Thu, 25 Jun 2026 13:10:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782393022; cv=none; b=lDDripGD8ovEXzeYEl/FexkI5tqKIb1Y60/PF8ZaY28Q+Od2lkfxOdAMLzTrxyvNG82iiVmHsn1Z5qXXh3H5BV2zwSxjxmLIk1TFpK17SOUojoLY+SUHfMyB2HmyG1YBjc9aQp1APsyi/tnVQSKspcIAgbX7EKrasIaxFy3ULQI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782393022; c=relaxed/simple;
	bh=pf8R/aTszRCXvLq/ENp95sRMTVuLzt/9Bw1hOLJTzlA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VaQnUewqCVyKrrX9NQ+A7xLt6zIdj0P73PpnzfQDuSCHJX9sb49lOkKo/3Gc4YN3z3bqiqH/H6Ig5EJTJEyBx9z85aBib8cYIfvEdBsnT69/Jx0uM7lnnW/ioO/1fxebGvjb0oKfAwW49ec87N+eiofH1w9fxqxNhdm2Wqs2PtQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IK0gPazx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IK0gPazx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC4B91F000E9;
	Thu, 25 Jun 2026 13:10:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1782393021;
	bh=qxNgmkkNfferXuXlzfiwcE4h/WpiViXxiY7YhQJxWtw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IK0gPazxtWywZRV7dmXDbReirjtG98f0c0KyxaBqPaIInrnbXr64bJTSBt17QWbXW
	 rtafz1u6i2Tvm7Z3SpYxtg00+nRXSHar42lqRZg9Py5pIAZln3m/TWHrD/K62G9K4w
	 izbTf74Ngrvl8uujo5ee1tE481Ev2Fw+cG/7Gm7I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Sam Daly <sam@samdaly.ie>,
	Javier Carrasco <javier.carrasco.cruz@gmail.com>,
	Jonathan Cameron <jic23@kernel.org>
Subject: [PATCH 7.0 33/49] iio: light: veml6075: add bounds check to veml6075_it_ms index
Date: Thu, 25 Jun 2026 14:03:45 +0100
Message-ID: <20260625125642.187174163@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260625125637.527552689@linuxfoundation.org>
References: <20260625125637.527552689@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sam Daly <sam@samdaly.ie>

commit 307dc4240bd41852d9e0912921e298160db1c109 upstream.

veml6075_it_ms has 5 elements but VEML6075_CONF_IT can yield values 0-7.
If it returns a value >= 5, this causes an out-of-bounds array access.
Add a bounds check and return -EINVAL if the index is out of range.

The problem values are reserved so should never be read from the
register. Hence this is hardening against fault device, missprogramming
or bus corruption.

Assisted-by: gkh_clanker_2000
Cc: stable <stable@kernel.org>
Signed-off-by: Sam Daly <sam@samdaly.ie>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Reviewed-by: Javier Carrasco <javier.carrasco.cruz@gmail.com>
Signed-off-by: Jonathan Cameron <jic23@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/light/veml6075.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/drivers/iio/light/veml6075.c
+++ b/drivers/iio/light/veml6075.c
@@ -100,7 +100,7 @@ static const struct iio_chan_spec veml60
 
 static int veml6075_request_measurement(struct veml6075_data *data)
 {
-	int ret, conf, int_time;
+	int ret, conf, int_time, int_index;
 
 	ret = regmap_read(data->regmap, VEML6075_CMD_CONF, &conf);
 	if (ret < 0)
@@ -117,7 +117,11 @@ static int veml6075_request_measurement(
 	 * time for all possible configurations. Using a 1.50 factor simplifies
 	 * operations and ensures reliability under all circumstances.
 	 */
-	int_time = veml6075_it_ms[FIELD_GET(VEML6075_CONF_IT, conf)];
+	int_index = FIELD_GET(VEML6075_CONF_IT, conf);
+	if (int_index >= ARRAY_SIZE(veml6075_it_ms))
+		return -EINVAL;
+
+	int_time = veml6075_it_ms[int_index];
 	msleep(int_time + (int_time / 2));
 
 	/* shutdown again, data registers are still accessible */


