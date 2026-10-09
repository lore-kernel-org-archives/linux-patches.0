Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BBD82BE7CD;
	Fri,  9 Oct 2026 14:27:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791556032; cv=none; b=DlzqWwXuIzCtoNdMMNM3TRexlZHOLzGh0nu8Zf4tihxlyz74GqJTakxYc+3SzkpeonjE019ySzf2xxCZSQQ59bJPOaJpwm0WbqfcbKckqLsTRuz3bT9QAnQyt2njF+uAd0m7W9umWU2G6SEbNiCAvhKrkCW5eMvSS4MnqspXvEw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791556032; c=relaxed/simple;
	bh=2u6HuNyPkbdtpHoAzbs3QCJEhAX4e/r4/YJf/bkUIKI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GsHlTjpozDbEEx2LTJE8bVR/J2o2pwd5v5/MbODVxStoHZFWRvoBmF1nyrefVuLnmFnONqQnW2cl3NDJWsvSKHeSEz84l9CqY2hEfLgMB/flpRGhly/7xmLqLpJ44J/rUv0hld+oyx3NcFKSDxrdOtQ1LYoCQiCW4njCXW/j270=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tmjYDaVE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tmjYDaVE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0688A1F000FF;
	Fri,  9 Oct 2026 14:27:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791556031;
	bh=HKnn/jQRU9QEHcuxgqwzM0CvSpKxc1ejLaz11GK8uUk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tmjYDaVEf9pdrkY5L4zJVb/kej84zeQc8VbDaDmS2VfT4EsPJ5yNXw9hhan9SqiHb
	 v7Gwnb4la07rQyaHkmDsPl7oDvwf5hl8Of3NTPiIXy2JMx41fq528rpnEsAKffitE7
	 hZyvE6rNAKeVT4hYLNYmrwvA06+fddxwiRZqv204=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Heidelberg <david@ixit.cz>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 6.18 153/403] Input: s6sy761 - fix resume ordering and restore sensing
Date: Fri,  9 Oct 2026 16:08:34 +0200
Message-ID: <20261009140955.649864073@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140952.119038291@linuxfoundation.org>
References: <20261009140952.119038291@linuxfoundation.org>
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

From: David Heidelberg <david@ixit.cz>

commit a215720959c5450b3699e243904b39c3f8f68888 upstream.

System suspend powers the controller off and resume powers it back on,
but the resume path enables the interrupt before s6sy761_power_on()
checks the boot. The firmware raises its boot-complete event on the
interrupt line, the threaded handler consumes it, s6sy761_power_on()
then reads an empty event and resume fails with -ENODEV, skipping the
touch function setup:

s6sy761 2-0048: PM: dpm_run_callback(): s6sy761_resume [s6sy761] returns -19

Power the chip on first and only then unmask the interrupt. Once resume
completes the boot handshake the chip comes back with sensing off, as
at probe where input_open() turns it on, so the touchscreen stays dead
after resume. Send SENSE_ON again when the input device is open.

Tested on a Pixel 3 XL over several s2idle cycles: resume succeeds and
the touch function and sense status match the pre-suspend state.

Assisted-by: LLM
Cc: stable@vger.kernel.org
Fixes: 0145a7141e59 ("Input: add support for the Samsung S6SY761 touchscreen")
Signed-off-by: David Heidelberg <david@ixit.cz>
Link: https://patch.msgid.link/20260926-s6sy761-suspend-v2-1-8f00a96ee6e8@ixit.cz
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/touchscreen/s6sy761.c |   14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

--- a/drivers/input/touchscreen/s6sy761.c
+++ b/drivers/input/touchscreen/s6sy761.c
@@ -500,10 +500,22 @@ static int s6sy761_suspend(struct device
 static int s6sy761_resume(struct device *dev)
 {
 	struct s6sy761_data *sdata = dev_get_drvdata(dev);
+	int err;
+
+	err = s6sy761_power_on(sdata);
+	if (err)
+		return err;
 
 	enable_irq(sdata->client->irq);
 
-	return s6sy761_power_on(sdata);
+	guard(mutex)(&sdata->input->mutex);
+
+	if (!input_device_enabled(sdata->input))
+		return 0;
+
+	err = i2c_smbus_write_byte(sdata->client, S6SY761_SENSE_ON);
+
+	return err;
 }
 
 static const struct dev_pm_ops s6sy761_pm_ops = {


