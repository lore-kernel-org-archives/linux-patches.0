Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5A0A27EC73;
	Wed, 23 Apr 2025 15:03:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745420637; cv=none; b=fVlMTqFPjSSE7j34mA4020hN5eROPAj2f0l3EfsmklUofRGBnvhzazlYrp7OPFdc4IQeN8tUxUc8l2DoSYX9qrJqiOW93fZ0W/9a68qd5IZ60F6ioHtV8m0jFEL8n0V8Nm65d9OATLufFbak5W4PZXSbRTNs4p54UrhaSwRvd/Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745420637; c=relaxed/simple;
	bh=+IiZMHPNJ5ju+QjCOVx8GcDAl3S9VyLX5vDLKMwe3nU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cqjS8HdzWA7rNKPB33K+R/E8P6L7/yz95Lpm1IJk0LGhoJHwY25oQcLoGVBmYKHyFMvxVbL2DaTzxTy0iIpJcB8/pI0Ib7aYH8wwJvr01tE16uxkLSmlLquFyUBz2SBpFrR0cf6fGsI4Osd//YHIrgr5n75PO3qvR8OOojXNcm4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=p//IxJIe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="p//IxJIe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56D83C4CEE2;
	Wed, 23 Apr 2025 15:03:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745420637;
	bh=+IiZMHPNJ5ju+QjCOVx8GcDAl3S9VyLX5vDLKMwe3nU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=p//IxJIeKpQZexzNRJd3Yd4lpx3nlav0Zp4Y0M8RGh5z/EHgy2qHKwWMPi2GW8eO1
	 BSbJSlZ9XF27lMO58j1oXl3+tF4mcj0ZPrEJBphsCXLW7mkuAbstCNIBd6e5HnQq1Q
	 8c+bIO8Q3vaqPDFoRr3QQ/9IhO+GpsbdfzEF6m24=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nikita Zhandarovich <n.zhandarovich@fintech.ru>,
	Alex Lanzano <lanzano.alex@gmail.com>
Subject: [PATCH 6.12 148/223] drm/repaper: fix integer overflows in repeat functions
Date: Wed, 23 Apr 2025 16:43:40 +0200
Message-ID: <20250423142623.206371477@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142617.120834124@linuxfoundation.org>
References: <20250423142617.120834124@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


