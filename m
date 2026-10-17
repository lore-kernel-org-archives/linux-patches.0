Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53CBA23394D;
	Sat, 17 Oct 2026 17:03:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792256639; cv=none; b=bM5L9qStmWa9pngF5rEK1LhVKFbaReY3Nz/C3Nb7/40FP1+31SxPoUHSWbtNAVmS78bI1R+Hc4z2KiYtzasCtu0bsFXCVJGdC7sXZqCPV7nsKwEgz+msR7lR2ela4t+nwhPfweA1puPZ8/3axrUlROllVsiA96JixzgBGLiV8I8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792256639; c=relaxed/simple;
	bh=+H1RnE8eJTEEz8dJgtYBjTYZG8t3ysdE2vaAOAfby1A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XW0mKO2bkx7vihsByfxdOylCeWWr5Ri1+61GbzmVLE7EWAdrdt7pF+uHCRisOVixsTfWtZu/wwPl6LTt435512ayt9xdsXdxZKeozz/Hxu0sp0JMybnvHVyGfSlmtQqkIZ/smFR+a7I9mnGZW+yYbyAKbHMSd4/ABDXXT2HJLK8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XP4N4uWF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XP4N4uWF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A40CD1F000C4;
	Sat, 17 Oct 2026 17:03:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792256637;
	bh=FAZw4gmrQT0s8cNkD8fd6Vuh2KN45UYizUXs4Hkonxg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XP4N4uWFpntff3ADVBOsh/KY+oUt0VKHsmcw51zeoKAnAFowggQSisHTrfLojeBH2
	 ZEqNMHQOxLcTXYDMc2GOAySVxhR1d3YfWFJLS4R1NzMFly0EL7pKbRBgU5QnlQ7EVP
	 FIRpFtMQIAp7QKj5BtoX7KKkimkVBt+P0ua9Glg4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Heidelberg <david@ixit.cz>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 6.6 0250/1674] Input: s6sy761 - fix resume ordering and restore sensing
Date: Sat, 17 Oct 2026 17:42:02 +0200
Message-ID: <20261017160437.544733809@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -507,10 +507,22 @@ static int s6sy761_suspend(struct device
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


