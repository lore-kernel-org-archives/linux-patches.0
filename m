Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB69936C9CE
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:10:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302221; cv=none; b=CA+zbRYkXTKo9a0DJYsG8O3WLPUEb2LVNydmH91fh/LLmINDdmENwmHooMQNXu+4z0mkrpggsnwX+yHC0nZ6F1vXFnzGm8xbhML5s9kQWnVlN4URHEFwgpqkD84n+RRJlTIUzqakBUOJz5Wuizit3TEJHZqLXh0Os4FlMlir70o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302221; c=relaxed/simple;
	bh=JMife9VSAj8Kn42m2xZZTbLGNUzXXLYkp29/1qev2Vk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LpJAxtTsaTaStdLJqoptoz80IXTP9M6KqJKr/f1MdhbGcta9rE9zG307+QwPFVCyLkv6cChEJayCU5vmng06z67hJuykC5aEKG01IV0I1x+nhw2ClI5z+cHKJTQ8mDkV4lgAI00NQj9zR5LAbTYVtOfJd31FNkF9ybKOp8OyQHI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bhHuwGBQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bhHuwGBQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 469CEC19423;
	Sat, 28 Feb 2026 18:10:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302220;
	bh=JMife9VSAj8Kn42m2xZZTbLGNUzXXLYkp29/1qev2Vk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bhHuwGBQun+4oN/z7vb9f/MxE927f6jFmV3/VJdgJ6Hamwnl3kt77xJ6+qDVeSCvU
	 sdkrtQJwfJ1YOs8JqHF2+HntONxeZ3bz2WrXo5Udvh5e1CX0iOg8qPuXsb1oIjIMNt
	 gVy3b49TFvK7Dch43qdFx2lvfPY18xXmxNPy+tVs3XdEYDm2wRHY73D2ugLmNMQ9Pu
	 9DtvILRWC7NnSdiHxEBVZINTJZp60EWb3dGTE+Y/wOgD7vuxxx8ceR0DF7mNO65As9
	 NyPymR6K2OUOrmRdJ8JvtRi9BUVWufUS8kmVqquKo+ToAg4ir97iKHBdffShHvoKCh
	 m6UMNNoxo2PMg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Chaitanya Mishra <chaitanyamishra.ai@gmail.com>,
	Rui Miguel Silva <rui.silva@linaro.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 228/283] staging: greybus: lights: avoid NULL deref
Date: Sat, 28 Feb 2026 13:06:10 -0500
Message-ID: <20260228180709.1583486-228-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180709.1583486-1-sashal@kernel.org>
References: <20260228180709.1583486-1-sashal@kernel.org>
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

