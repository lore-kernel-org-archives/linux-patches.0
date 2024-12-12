Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95C8823ED45;
	Thu, 12 Dec 2024 16:12:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734019972; cv=none; b=tUBybkhUf/qUAS8rjQwlGsUyzuD9nin8hr5zEQe/re/sECW4bnBj5LLPhwetQ0pRROwJX7dHw8msHS7lWMnhcvpbB+BcfsFL0790mk8A8cFM0h6aTi8AY0UYMNdg0agEDbRSIiRxeKSIpRqrx/HijILtOf8tcWhZz5ALUpQokdM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734019972; c=relaxed/simple;
	bh=CgHLtzEaS5c1ah46wXom79o8CEAuQlcQKpccM4h1x1I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kNL/6OmC26B2y6WB8tirFw0W/g8O4QwGOK12qjUwNnljt3Iy/kuW/OqGtIQK4nVU2GxmuWY8gA8GV16adcMzN+EmAFJtmVv6zvYCAX8/1kl9awNcjreQ+UXTpw/0cyJ+4i2t1FOmeTuj0SjulgjqJbx1Tt4ZXYsuTIEAncmzwH0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JVa/a2MM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JVa/a2MM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF0F8C4CECE;
	Thu, 12 Dec 2024 16:12:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734019972;
	bh=CgHLtzEaS5c1ah46wXom79o8CEAuQlcQKpccM4h1x1I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JVa/a2MMv+uBadd9vNB0QqWxvjk5oiUMRFT+EVK/ptHncwatMpUccTKd+d4vdpA4L
	 KgmHEMZxyy4P0WekvughXw5Kdyja3B9W5wU8RIV5tJxGXCUlu3LbIxgj+l7VXwX8yx
	 ruPidYRDbYCq/aO9RYI+knW7JsxCWMzTL0fcu/9I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jammy Huang <jammy_huang@aspeedtech.com>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Bin Lan <bin.lan.cn@windriver.com>
Subject: [PATCH 6.1 345/772] media: aspeed: Fix memory overwrite if timing is 1600x900
Date: Thu, 12 Dec 2024 15:54:50 +0100
Message-ID: <20241212144404.168783546@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jammy Huang <jammy_huang@aspeedtech.com>

commit c281355068bc258fd619c5aefd978595bede7bfe upstream.

When capturing 1600x900, system could crash when system memory usage is
tight.

The way to reproduce this issue:
1. Use 1600x900 to display on host
2. Mount ISO through 'Virtual media' on OpenBMC's web
3. Run script as below on host to do sha continuously
  #!/bin/bash
  while [ [1] ];
  do
	find /media -type f -printf '"%h/%f"\n' | xargs sha256sum
  done
4. Open KVM on OpenBMC's web

The size of macro block captured is 8x8. Therefore, we should make sure
the height of src-buf is 8 aligned to fix this issue.

Signed-off-by: Jammy Huang <jammy_huang@aspeedtech.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Bin Lan <bin.lan.cn@windriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/platform/aspeed/aspeed-video.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/media/platform/aspeed/aspeed-video.c
+++ b/drivers/media/platform/aspeed/aspeed-video.c
@@ -1047,7 +1047,7 @@ static void aspeed_video_get_resolution(
 static void aspeed_video_set_resolution(struct aspeed_video *video)
 {
 	struct v4l2_bt_timings *act = &video->active_timings;
-	unsigned int size = act->width * act->height;
+	unsigned int size = act->width * ALIGN(act->height, 8);
 
 	/* Set capture/compression frame sizes */
 	aspeed_video_calc_compressed_size(video, size);
@@ -1064,7 +1064,7 @@ static void aspeed_video_set_resolution(
 		u32 width = ALIGN(act->width, 64);
 
 		aspeed_video_write(video, VE_CAP_WINDOW, width << 16 | act->height);
-		size = width * act->height;
+		size = width * ALIGN(act->height, 8);
 	} else {
 		aspeed_video_write(video, VE_CAP_WINDOW,
 				   act->width << 16 | act->height);


