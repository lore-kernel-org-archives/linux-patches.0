Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E211C35AC28
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:19:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302753; cv=none; b=ZaWmWDT8XNpcBYglOBl30TeRaLeMmpGQ1SyklTRb+A3P93tn+6DIYW1F3nbfD016OFNTwZlLUMrdnxsEG1Iiaa2+fH0zqbVbn4hPEfHS3wMobNgtmyDmturpsJhckZKFJjEwfT46sYyNl9nm3sap1l7dw8R+3JpnT5Ym3Fh19XU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302753; c=relaxed/simple;
	bh=bU/64E8pc+rMMXD87qpGwAyJYYKO9brwR4hNi53mfPQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F3kx8Mf3DSYpHNKxDDIz1zjm3g4p6ODgSBjc6BGv+T1opauiHy/Ti3a97uUWPah2veW6E+o26XGiOqcoBeis4ZbHAmCNdc6hESNnL13c6DSZfWcl6Oe3Jo3rgVuOH0lv7Kh29cA/Q7bP5eZxacTFvKkiCn+wuScHv06USq/Ld2E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=f8Jv4lKz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="f8Jv4lKz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D3FCC19425;
	Sat, 28 Feb 2026 18:19:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302752;
	bh=bU/64E8pc+rMMXD87qpGwAyJYYKO9brwR4hNi53mfPQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=f8Jv4lKztNRQccNWCJs4imB2IuvTBMMN0IZVLVfqJIV2Rqj3sNwZILBLeZA3FTiTl
	 /pUFzTTWuzXtU21JLGvp4MxKSemheuF/y0fpLunQexhmQXRGlSlrpFP5ami91X2/3/
	 Wg5dnFUE5HvbdRKoJXUrrN/eJBEIjTX1EN7LudLgEfd/jqKDheZHfBn6pkvsw81DLV
	 Y6AvJevPxFcizgsr1WNXK2z07B+4uXDhP4d5uKfoGYw2xtL0LbKGMBYQLTEThJirnC
	 RDGisrhUHwZVq52UsvcpvoheYSDgTdmnB4TcrgtqWlpg2w+IQ5r6GM+1Vn8PjWXuWP
	 aVbmzEozJF74g==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Chaitanya Mishra <chaitanyamishra.ai@gmail.com>,
	Rui Miguel Silva <rui.silva@linaro.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 121/147] staging: greybus: lights: avoid NULL deref
Date: Sat, 28 Feb 2026 13:17:09 -0500
Message-ID: <20260228181736.1605592-121-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181736.1605592-1-sashal@kernel.org>
References: <20260228181736.1605592-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Chaitanya Mishra <chaitanyamishra.ai@gmail.com>

[ Upstream commit efcffd9a6ad8d190651498d5eda53bfc7cf683a7 ]

gb_lights_light_config() stores channel_count before allocating the
channels array. If kcalloc() fails, gb_lights_release() iterates the
non-zero count and dereferences light->channels, which is NULL.

Allocate channels first and only then publish channels_count so the
cleanup path can't walk a NULL pointer.

Fixes: 2870b52bae4c ("greybus: lights: add lights implementation")
Link: https://lore.kernel.org/all/20260108103700.15384-1-chaitanyamishra.ai@gmail.com/
Reviewed-by: Rui Miguel Silva <rui.silva@linaro.org>
Signed-off-by: Chaitanya Mishra <chaitanyamishra.ai@gmail.com>
Link: https://patch.msgid.link/20260108151254.81553-1-chaitanyamishra.ai@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/greybus/light.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/greybus/light.c b/drivers/staging/greybus/light.c
index 7352d7deb8ba0..af91913794ee6 100644
--- a/drivers/staging/greybus/light.c
+++ b/drivers/staging/greybus/light.c
@@ -1030,14 +1030,18 @@ static int gb_lights_light_config(struct gb_lights *glights, u8 id)
 	if (!strlen(conf.name))
 		return -EINVAL;
 
-	light->channels_count = conf.channel_count;
 	light->name = kstrndup(conf.name, NAMES_MAX, GFP_KERNEL);
 	if (!light->name)
 		return -ENOMEM;
-	light->channels = kcalloc(light->channels_count,
+	light->channels = kcalloc(conf.channel_count,
 				  sizeof(struct gb_channel), GFP_KERNEL);
 	if (!light->channels)
 		return -ENOMEM;
+	/*
+	 * Publish channels_count only after channels allocation so cleanup
+	 * doesn't walk a NULL channels pointer on allocation failure.
+	 */
+	light->channels_count = conf.channel_count;
 
 	/* First we collect all the configurations for all channels */
 	for (i = 0; i < light->channels_count; i++) {
-- 
2.51.0

