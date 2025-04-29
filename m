Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C753D243364;
	Tue, 29 Apr 2025 16:50:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745945426; cv=none; b=KXYEiBOWYJg1LlF8AptPLeQJ56VQYunxHkRuAWUPH/zfYBk+0cMuaBjXtnZ8fp2sMSOQKpWz7vN/mQ6D8kzHeCZt901cVj4oxaa7NNomB91e3ZBkWaRDz/lZLYrX/Cv1CCy3tHtyBMPvv2uj+HkMMTh0HZRnTWNaDgON1cF3Gv8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745945426; c=relaxed/simple;
	bh=jSQQJ6d6MyKByPgfu5UxgPovwba2SfKyHJYO7ZH5Fvc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aClmc9u0HzIFYyKyL1lAGJlY7fTKJCtK6XMZLMTZdxFIX9rd6xEMYuH48A9mHWsbIgXoZK76U2LuWgdPedW6HVVKr62Yd3/9tIVWSmu+BxRUU+3AMEEEVXb/3k3LTMpXRQobpeuA2vKDQQP6Hd0lX7X5XZR6FtrcUX7qBLHOr0o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aIgs3ugJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aIgs3ugJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AAB9C4CEE3;
	Tue, 29 Apr 2025 16:50:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745945426;
	bh=jSQQJ6d6MyKByPgfu5UxgPovwba2SfKyHJYO7ZH5Fvc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aIgs3ugJ7WV7Ml8Vdy74sdf8vXookvEO4vYllCfnqEXuElSciKfX/MfyWjKARTezH
	 6aPSWIvd9Zx/WKuERGB/vimfw1h0a5SaX0cm7msPqount9rJly5W5ybdgVN3/CFJPt
	 OyA02SAvpP1MlWTfmmnOntCVr6zO6poytCfV+CrE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nikita Zhandarovich <n.zhandarovich@fintech.ru>,
	Alex Lanzano <lanzano.alex@gmail.com>
Subject: [PATCH 5.4 108/179] drm/repaper: fix integer overflows in repeat functions
Date: Tue, 29 Apr 2025 18:40:49 +0200
Message-ID: <20250429161053.773267259@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161049.383278312@linuxfoundation.org>
References: <20250429161049.383278312@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nikita Zhandarovich <n.zhandarovich@fintech.ru>

commit 4d098000ac193f359e6b8ca4801dbdbd6a27b41f upstream.

There are conditions, albeit somewhat unlikely, under which right hand
expressions, calculating the end of time period in functions like
repaper_frame_fixed_repeat(), may overflow.

For instance, if 'factor10x' in repaper_get_temperature() is high
enough (170), as is 'epd->stage_time' in repaper_probe(), then the
resulting value of 'end' will not fit in unsigned int expression.

Mitigate this by casting 'epd->factored_stage_time' to wider type before
any multiplication is done.

Found by Linux Verification Center (linuxtesting.org) with static
analysis tool SVACE.

Fixes: 3589211e9b03 ("drm/tinydrm: Add RePaper e-ink driver")
Cc: stable@vger.kernel.org
Signed-off-by: Nikita Zhandarovich <n.zhandarovich@fintech.ru>
Signed-off-by: Alex Lanzano <lanzano.alex@gmail.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20250116134801.22067-1-n.zhandarovich@fintech.ru
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/tiny/repaper.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/tiny/repaper.c
+++ b/drivers/gpu/drm/tiny/repaper.c
@@ -454,7 +454,7 @@ static void repaper_frame_fixed_repeat(s
 				       enum repaper_stage stage)
 {
 	u64 start = local_clock();
-	u64 end = start + (epd->factored_stage_time * 1000 * 1000);
+	u64 end = start + ((u64)epd->factored_stage_time * 1000 * 1000);
 
 	do {
 		repaper_frame_fixed(epd, fixed_value, stage);
@@ -465,7 +465,7 @@ static void repaper_frame_data_repeat(st
 				      const u8 *mask, enum repaper_stage stage)
 {
 	u64 start = local_clock();
-	u64 end = start + (epd->factored_stage_time * 1000 * 1000);
+	u64 end = start + ((u64)epd->factored_stage_time * 1000 * 1000);
 
 	do {
 		repaper_frame_data(epd, image, mask, stage);


