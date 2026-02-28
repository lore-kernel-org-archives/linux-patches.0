Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C438359A90
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:14:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302448; cv=none; b=Qt77ptkZdzMTNo+LU0dE2bKkeErkQxAmfQAP8X4nCI/+vZ+DxDN8pNVfO6qUO2tm8PtYzL/SKECmmaIrgtBZ85n7zL4puTztm1I7IRao13EEHj3VKg58zh6JYKba/l2hLc0cffUZQ+GrxPYOoWEN86CjGeMIr47UMVrja85tObI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302448; c=relaxed/simple;
	bh=JMife9VSAj8Kn42m2xZZTbLGNUzXXLYkp29/1qev2Vk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EEEO7oNmu70tsun+v6K7V67q1uAM+FH/JC/alRojHS1vdso17IGDiwkC5tpVv+DWElEfSLDwyBu2WSKkwO0VC/w15F9B9j7lv2p6H3IxNNHgR0pmRnveYMzUvuphNiWE3sglf1K/p0zvwCq3aFrHMxOv13Pyg7DlmYWywQKp0g8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nnd/dZNW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nnd/dZNW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 591D1C116D0;
	Sat, 28 Feb 2026 18:14:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302447;
	bh=JMife9VSAj8Kn42m2xZZTbLGNUzXXLYkp29/1qev2Vk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nnd/dZNWtrivVmAP6bA3jib2rnSJnPLS/ajTfn1U7eHwMBQQSjJ/I8k8pZQDF1dDa
	 npo9R19hRYXFSt1GhScUwoO2XWxaOZ8quGpqypa3orKm1Hy+471W+XWDHvACCaHzBm
	 7JD7TSPIC1Db4zLOI/skhvJ5xLQPU83lmWXaV7kwM49SWNmpcf5zsJd4PERFoC5ptU
	 nNrALQURCk0OHFUocuWWTPRbQB9V2ia40yjCaW6OBwUMjqgvTl/ukMFru0p0r8IBkQ
	 QAUVhNdsgsIdtRdbkZ+Y5YxEiALubB2t/0XVrUm/i56tHos7NKnAdAFtsARRzkb2WW
	 xhbl8sc3p+jGA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Chaitanya Mishra <chaitanyamishra.ai@gmail.com>,
	Rui Miguel Silva <rui.silva@linaro.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 187/232] staging: greybus: lights: avoid NULL deref
Date: Sat, 28 Feb 2026 13:10:40 -0500
Message-ID: <20260228181127.1592657-187-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181127.1592657-1-sashal@kernel.org>
References: <20260228181127.1592657-1-sashal@kernel.org>
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
index 9999f84016992..eb69500e080e0 100644
--- a/drivers/staging/greybus/light.c
+++ b/drivers/staging/greybus/light.c
@@ -1029,14 +1029,18 @@ static int gb_lights_light_config(struct gb_lights *glights, u8 id)
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

