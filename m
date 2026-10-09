Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2B3644BCB0;
	Fri,  9 Oct 2026 14:35:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791556547; cv=none; b=gxaOxBjX/ymkXt0kesvZuKzIPJPaXPRbBj0C8LEjm8hi4AhGDkr6ZAf5KS6rHnvgxCl4KeaIzC5XwKEMrJh4FOpJj6mdo/TyHKRSKV7lm7oxcb0YvMpPvlPcYnNJV+BI8djtAEpSqYJWy4KS/WrskXQZ0d7FU1i/VHuKGKWo6ss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791556547; c=relaxed/simple;
	bh=dvDw17PVRo0bK/0GG37hMeQoe85XGBTM6Esrzx1Zl68=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tgkc3PVr/F6obT89oAMYeVlWNzjyRCbvWGT7HpYJ5VaCqY4bzLPoQzthXddsZfuf4tc0FEVztDDXLRBzH/v/CQ8tw2wiAI/nJq/cVqmx0qI7E5AlXtjU+G1THsTid6sPdqEHvj2ZgOlRaUvlGXLx17tQEK+x+Xr4868/C3YWDOM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=n8J+qNWa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="n8J+qNWa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C37C1F000FF;
	Fri,  9 Oct 2026 14:35:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791556544;
	bh=007c9jmDC3tz6HMJI9+0FzTjqIo+t3Fgk1l01FwAF50=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=n8J+qNWalDI75JDhoJ9TwYIMxoCuH7ptRf5Ppj/uVIGNGQUrF7lLbkSxsJQ5KEnGC
	 BHqHfxKYiRLWX4mRMuzLKm1+4yyFPtUuDOA+7YQtCgq7oW2ELcYl2gBVlyFp3d39rS
	 nvyBiXaouwzKm0IPy8S7aQrR8Pby3oKOmipKNB7E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Heidelberg <david@ixit.cz>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 7.2 198/428] Input: s6sy761 - fix resume ordering and restore sensing
Date: Fri,  9 Oct 2026 16:08:55 +0200
Message-ID: <20261009140950.486817513@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140946.008206689@linuxfoundation.org>
References: <20261009140946.008206689@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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


