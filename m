Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9955E379EF7
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:04:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301895; cv=none; b=CVVnc0SZwLuTyanzxzcxold1uLYAvlunGshs9D+p7WKzRhyJQkpJCwAfs2a3PG4PNkWlCLQhljYwmGGnu66+M2fnfJhvsqgFTcFrzHW/mMYsnrQtyMJn7X/MDPKTksxOJXV1Pzgu/bHM7sEyfmBWZI0KMFAkjDIykiihvopaLPo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301895; c=relaxed/simple;
	bh=AA2HjiYElr7IwZUtlYD6TnKCizyfA1L5AYEYBfY5zc4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cO/zNZL/iQU+cQ3/+b54HgjHeR8JMBZ0XJ+We3QdiRa55vH241588w6Vsg0ZteZ91FC/vShj7AHvcTmQ9OtVBTFZqD5sw6/OIwM0FQCbSZLf5wnKqnzgCeI/Z6vaquoQARVM+OLVeaoYEwIq7/sbWvK+tEqAlHjnGp/5y1qtZbw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=j8TJe2aw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="j8TJe2aw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3E00C116D0;
	Sat, 28 Feb 2026 18:04:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301895;
	bh=AA2HjiYElr7IwZUtlYD6TnKCizyfA1L5AYEYBfY5zc4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=j8TJe2awUrdXvubkWUrSOuQ/dyude/y9DDHWmh5gQf6kQqtBCjZ22TNxHA0icfAR4
	 m+u3pSDhQIUlU/dfGhj6jm6feeabKs2d7BfFsYoWfxHDeA2X+mJPlqrDT0771NShkv
	 kKA4BAW6P4V+ywjM6kdP5oZu+EK5BXmu/jP0CUmbR8F6zy9lm406OAFKgg5eY88/n4
	 f7I+66VkiMNXrGghlY455d2ZBg6Z3YofyhA16sUrFg9U0LvzbUFiGB6bYr354cLYwO
	 jot2NYUZE42o0+sPBY1uwHc2zCMSNiFXprlJBQ5v4Le5AFyoe4eOvfKki5ENA4JukG
	 uz5l239cnOEpw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Chaitanya Mishra <chaitanyamishra.ai@gmail.com>,
	Rui Miguel Silva <rui.silva@linaro.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 323/385] staging: greybus: lights: avoid NULL deref
Date: Sat, 28 Feb 2026 12:59:05 -0500
Message-ID: <20260228180011.1568201-323-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180011.1568201-1-sashal@kernel.org>
References: <20260228180011.1568201-1-sashal@kernel.org>
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

