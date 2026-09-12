Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A188C3176EE;
	Sat, 12 Sep 2026 19:43:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789242235; cv=none; b=p/2WvVJKnYEchBdxlramqk7lXspA/SBh9GxWAkAYdALB0kCEsN4bJg+K+XEarsjgCKBrMjIo5IO+E6cHgtWQ7OARiIxQux5nViRXcU8qT9pTx6EOo+EGvT942/MV705gkRmsN8qngh5yWwMio/lHl/V5UMrXJ04BG8meg5W3JUQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789242235; c=relaxed/simple;
	bh=1vLC0HRxrX3voV6vqi6ilP7oCjKsxUhoqaCV5agPNjw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tKmxZjv9ohzmpg3Z0cZyEnay2JcGvtcJOQ7pGIZVafh/1pAIL8xjndk3NogXBL2L1OB845QD1pIgUI0L78rQ6ih6yc7FuFck+bQHjqMNSqUZfxxA+T6pfr1B9k9ie3Rce4vw+HvP1SN/PUWgOBhGtBI5nGE1SFjV5PxUJCsj/qo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Swnxtp+X; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Swnxtp+X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06BF51F00899;
	Sat, 12 Sep 2026 19:43:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789242234;
	bh=cl+lawptAsrxJwCRGKsTIiLrKdCM4HP9ZGS71aE2za0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Swnxtp+X9qbZFdF3p74ykspUF6AhvczFrS0YeTVmO/xCviLgywuEDjmx4Fn6/ue8+
	 kx+3zbH6/3pGurY4WOGp1Yy9uvctwHvb4d5BI19gHhoA0ufbsJf6oWnWzlW9Yi+fkS
	 qHeqtV6AcpiYST/Y3FVOadUoXYGWbDOWt7Iwbhz0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arash Golgol <arash.golgol@gmail.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 5.10 290/798] media: vimc: fix pixel format lookup in enum_framesizes
Date: Sat, 12 Sep 2026 08:58:38 +0200
Message-ID: <20260912065523.810020256@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arash Golgol <arash.golgol@gmail.com>

commit ad4c65fa30cfb00e2e06adae9a8eb407086eaa66 upstream.

vimc_capture_enum_framesizes() looks up the requested format using
vimc_pix_map_by_code(), which searches the pix map table by media
bus code (MEDIA_BUS_FMT_*).

However, v4l2_frmsizeenum::pixel_format holds a V4L2 pixel format
(V4L2_PIX_FMT_*), not a media bus code, so valid pixel formats end
up being rejected with -EINVAL.

Fix this by using vimc_pix_map_by_pixelformat() instead, which
performs the lookup by pixel format as the ioctl expects.

Fixes: 09c41a23a2e2 ("media: Revert "media: vimc: propagate pixel format in the stream"")
Cc: stable@vger.kernel.org
Signed-off-by: Arash Golgol <arash.golgol@gmail.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/test-drivers/vimc/vimc-capture.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/media/test-drivers/vimc/vimc-capture.c
+++ b/drivers/media/test-drivers/vimc/vimc-capture.c
@@ -176,8 +176,8 @@ static int vimc_cap_enum_framesizes(stru
 	if (fsize->index)
 		return -EINVAL;
 
-	/* Only accept code in the pix map table */
-	vpix = vimc_pix_map_by_code(fsize->pixel_format);
+	/* Only accept pixel_format in the pix map table */
+	vpix = vimc_pix_map_by_pixelformat(fsize->pixel_format);
 	if (!vpix)
 		return -EINVAL;
 


