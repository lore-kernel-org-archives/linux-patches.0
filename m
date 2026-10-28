Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793211266;
	b=tPjmxItcX03svC/QbMHeU3tDx41JmDGKo0rs/7seR1LQVAN6YPd5UoewNRPtV0cApBTL
	 tPs/Me/576gRFWzM2vF6ys3GFO/nC0pE/ahksySIy6KQ9SwQ33h3XP5DcgVVhV2P3coQm
	 FYxWsFeLcZTmApT8gUsTFGx/uvMKtqfxJ35DJWTUCmgAq8dmwDXNpEsSxkzSUiVIAGtAt
	 db4HVmVBOD1Z7KFzT4/SmENSammiDDfATdsjqvNgz35UO2VH287FrKejt07guERWrY9Fo
	 vhv2yZnR2GUMNQfZI3tiGBB+rdEjjSjE+Z1x/QNEgLmh6v0yIvaYc5kvsO6SlkdsNXA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793211266;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=k4tlG1jPPibXyOEPp86AV/c3NbWBs59YSlaZC0PAS50=;
	b=YGv39JzWYteUfr/iAQ8jtwUj1JWsIptG+M62lKV5UNchC8rMzTSvK0Yi0bdJfBXvCG3W
	 R/qvcLwRREZyk6EPCZDYDUPoz6oJzswZCrXYqhoqVpC4aRnx7YIzBxoOSd1p+8Jxy7ynJ
	 CMsjISiSSFJ4bvLlyPAk1eJvXI3A4gEZn9IpqDfbihZBHDx55lHh+1o+sn+2F5CmFnLId
	 sj6w9i0tUGskkmcsyKVBob9SqCWx7jfgoA7vQr9HShj8M9m+CaaWs6rg/wCxGMfBFjiGz
	 CYeo3vMkqgcnnxGyshvjWyduhtVa0YLYyi5pStEpW5ELmPKGQKeH96uEHXxtd3NzTXQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EpEvcqHY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A138606BF68;
	Wed, 28 Oct 2026 18:14:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EpEvcqHY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BECB1F01829;
	Wed, 28 Oct 2026 18:14:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793211265;
	bh=k4tlG1jPPibXyOEPp86AV/c3NbWBs59YSlaZC0PAS50=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EpEvcqHYo2bf3PNAxBZxkG+IjnkM/ZRyXWpHyK3NFp5D/OtOE9skiviV9z4joBSBG
	 FNkNzDXrCs4NlKQ71TNKF9hWvnYQOjOYWGoNoJl7JBrRr6s+wxcEcyXnEW3Mp1L6cQ
	 z2eCXU/g+kgDG0o6SDUxh/8XTFpJXmKtE5t0j8Us=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Heidelberg <david@ixit.cz>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 315/571] Input: s6sy761 - fix resume ordering and restore sensing
Date: Wed, 28 Oct 2026 17:57:42 +0100
Message-ID: <20261028170015.475033938@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Heidelberg <david@ixit.cz>

[ Upstream commit a215720959c5450b3699e243904b39c3f8f68888 ]

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
[ sashal: Replaced guard(mutex) with explicit mutex_lock()/mutex_unlock() calls for C90 compatibility. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/input/touchscreen/s6sy761.c | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/drivers/input/touchscreen/s6sy761.c b/drivers/input/touchscreen/s6sy761.c
index 85a1f465c097e..6f1827cfc720d 100644
--- a/drivers/input/touchscreen/s6sy761.c
+++ b/drivers/input/touchscreen/s6sy761.c
@@ -510,10 +510,22 @@ static int __maybe_unused s6sy761_suspend(struct device *dev)
 static int __maybe_unused s6sy761_resume(struct device *dev)
 {
 	struct s6sy761_data *sdata = dev_get_drvdata(dev);
+	int err;
+
+	err = s6sy761_power_on(sdata);
+	if (err)
+		return err;
 
 	enable_irq(sdata->client->irq);
 
-	return s6sy761_power_on(sdata);
+	mutex_lock(&sdata->input->mutex);
+
+	if (input_device_enabled(sdata->input))
+		err = i2c_smbus_write_byte(sdata->client, S6SY761_SENSE_ON);
+
+	mutex_unlock(&sdata->input->mutex);
+
+	return err;
 }
 
 static const struct dev_pm_ops s6sy761_pm_ops = {
-- 
2.53.0



