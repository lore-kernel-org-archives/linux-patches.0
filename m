Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F172176242;
	Wed, 23 Apr 2025 15:33:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745422431; cv=none; b=MKhXA2qbMDZ4W+L8iMnFgnjFhp50J0NSRZwS4Kpt3cr0BNf1/7pEzRTP9B3lVtNqtX2Pc9zgaYjW5Dbutvk0mLieIgcMkc0795MJym0TOXt9MD9UCHBmjoBYnZpxkRdgDGF5FLhnV++/1L+jccvcCctWEuNAnB5WbdPlAUQetbE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745422431; c=relaxed/simple;
	bh=zr1IdI0r7UncH8qSEoQldn3tSH2++h7dTtGGkStKxlo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OY9eKQIRohMth5ENq3NHBX7jDEou6HLWK3nF5FNJ1i00KO0d0L9CGvGKh2sqWCWCI9HeEB6d2tkSN8TL+URGpvC3V6v6GpOm7FBpdlrHsbBGUDlXgtHcxgJWTY7cmOGNWEcTnrFDOFps6ymZWA77vMfu2F4j0tATgt2+unH9YmE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=U31IQJC6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U31IQJC6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4405DC4CEE2;
	Wed, 23 Apr 2025 15:33:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745422430;
	bh=zr1IdI0r7UncH8qSEoQldn3tSH2++h7dTtGGkStKxlo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=U31IQJC6EL5eAh2aVDCATCOTUW0GJJgU2iFsGwIsQHV9MErjdmcTs9hlcGf9BnLiu
	 AIZq2weDiBgfKh3rEe6puopjgyFciuhsKwcBN6igjehCM8U/LePL64DvinglzaBHeV
	 k6QjdZS09+ueBHHPsBB1rvJbInuZxQA7s68CUtpc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nikita Zhandarovich <n.zhandarovich@fintech.ru>,
	Alex Lanzano <lanzano.alex@gmail.com>
Subject: [PATCH 6.6 346/393] drm/repaper: fix integer overflows in repeat functions
Date: Wed, 23 Apr 2025 16:44:02 +0200
Message-ID: <20250423142657.630750686@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142643.246005366@linuxfoundation.org>
References: <20250423142643.246005366@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -455,7 +455,7 @@ static void repaper_frame_fixed_repeat(s
 				       enum repaper_stage stage)
 {
 	u64 start = local_clock();
-	u64 end = start + (epd->factored_stage_time * 1000 * 1000);
+	u64 end = start + ((u64)epd->factored_stage_time * 1000 * 1000);
 
 	do {
 		repaper_frame_fixed(epd, fixed_value, stage);
@@ -466,7 +466,7 @@ static void repaper_frame_data_repeat(st
 				      const u8 *mask, enum repaper_stage stage)
 {
 	u64 start = local_clock();
-	u64 end = start + (epd->factored_stage_time * 1000 * 1000);
+	u64 end = start + ((u64)epd->factored_stage_time * 1000 * 1000);
 
 	do {
 		repaper_frame_data(epd, image, mask, stage);


