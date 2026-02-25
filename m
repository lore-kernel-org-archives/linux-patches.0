Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81EBA3002D1;
	Wed, 25 Feb 2026 06:57:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772002676; cv=none; b=nyzmaDibZvuEm8htHmuxSSu6ryYguHmJSZ7NI/S+7DTTUSuaiGi+bLFGLvsMLGl/7acoxI12bMBaMGOfMAgklmPkp5RfUuJ2xoO8Cx9yFXA1p5tJJhZDC2ZHTdHV6lKfHrn8xnlG3qow1Ufcf/9++3cM4+7ajhS+707sRBjhyuk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772002676; c=relaxed/simple;
	bh=qULevEGnSN43D1ATjDeTK+wpxHPfPCq01XXuiqqe/ZY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dfixECp1f/8zcbmbrWNbCuzUdLvII/ZNC89yZ0maP4FcgnZl4+ofsy5AMfsIy7VaByACsSUnqsBhoUuNmK39+Wz4tk6wfz+CIGllp/fPSCuFDR5sib5ZQ/CP9uBdl7+9I/kM8bWw0Nf3HPrIqs0Wr23Rcfa6yEuSb6byyn0cMjA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CXVfhp/5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CXVfhp/5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E667C116D0;
	Wed, 25 Feb 2026 06:57:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1772002676;
	bh=qULevEGnSN43D1ATjDeTK+wpxHPfPCq01XXuiqqe/ZY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CXVfhp/51yviG4QROEtrlSZYSzZWKs62XFwQrNNi35AhXvIvxrowBEoIlD1f3nyfp
	 LspET7IKVbkrnGezUw5QQcJ5dpNLXfp9P0BLm7eiPtUtaC56EWhbhIu0/y2CZDF5S4
	 2dgg6nL/4TsPUYeOZUZiqy7bgeiCdJvHG+B1IJkA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rui Miguel Silva <rui.silva@linaro.org>,
	Chaitanya Mishra <chaitanyamishra.ai@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 460/641] staging: greybus: lights: avoid NULL deref
Date: Tue, 24 Feb 2026 17:23:06 -0800
Message-ID: <20260225012359.662197014@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012348.915798704@linuxfoundation.org>
References: <20260225012348.915798704@linuxfoundation.org>
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
index e509fdc715dbb..38c233a706c48 100644
--- a/drivers/staging/greybus/light.c
+++ b/drivers/staging/greybus/light.c
@@ -1008,14 +1008,18 @@ static int gb_lights_light_config(struct gb_lights *glights, u8 id)
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



