Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3514139B970
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:16:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302617; cv=none; b=CJCiSnbQGStYTeNm+nPPVTa8pqeMXeTa4+fXbDz2sTSyJTkl3l02EDR8Zb2LByyP1AeddK+0ZFe1TZ5VWiXAo9ACyVbAPuB9cp7Jqjdcfqq6nKQLz1bC74C8TOvXIIx6tbhmh7dxLGthVf0vWwg8OM6TjNGJijsl1w4FlaACjcw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302617; c=relaxed/simple;
	bh=JMife9VSAj8Kn42m2xZZTbLGNUzXXLYkp29/1qev2Vk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M4zIon0312O6v/OZVUlk0bTxcx/W5gV9AJJ0Sad1i/xLmztJUI6RDteEf65+pj9VUNCSe2xh90wcF1kgGwlNs8hEaZdGcokNgXg7SFtJV2NbmTd3TfFCS9ZEIAL54aaCTN9nRIecQu4JrknaPBcCi788anqWe8dsvsDcK3QoMpg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZHOIAQtg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZHOIAQtg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F4C5C19423;
	Sat, 28 Feb 2026 18:16:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302617;
	bh=JMife9VSAj8Kn42m2xZZTbLGNUzXXLYkp29/1qev2Vk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZHOIAQtgKwm6Ra0q6iNl2iWvVUPj3FUKOaEaUffvw4liE2RG9bMUDpJb6wCYOHQ0F
	 rkPj7lNleIOBfxche1ZyFOl+YefO6FJVVfJ6AGzjTpL5XubTM8e5d9gSdAG4j2DfkF
	 +LMS0EfamEi2iaCSpl6zoeXPuFaiBSCKtP+QRvfj6VvD5hunWMlCh8CieX13FnrNUr
	 IoGfXqN4SlrdqP97AP2NcHkPs8QW9tCv+VWdXoa88GcrJZMN3/R7+GJQKTkAIzTAYk
	 Gaj0akBzEA5XiOMAfzkMtK7ldK2YwCGh5L+yGmRhdj+SteYK+UovfsTLZR9hvyFsyU
	 VD3irH0vkvl7w==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Chaitanya Mishra <chaitanyamishra.ai@gmail.com>,
	Rui Miguel Silva <rui.silva@linaro.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 134/164] staging: greybus: lights: avoid NULL deref
Date: Sat, 28 Feb 2026 13:14:33 -0500
Message-ID: <20260228181505.1600663-134-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181505.1600663-1-sashal@kernel.org>
References: <20260228181505.1600663-1-sashal@kernel.org>
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

