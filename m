Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA0CF2DF3C9;
	Tue, 17 Jun 2025 15:40:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750174837; cv=none; b=iywydM7VEQu3DX0Zr3/2t26EMAY5F73F3WCnoqIjmsIroo0i+lp6yoNjmwuaCWPDITlpx/X/60St2tFeJJJe6X60BPWjXb0TBqF6SxTQsQeJynKdyl4BtDfZhdox5rIyk+z02sRxv1mGD19sdX1zYS/7Q91udfEsc8icwoe6fVM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750174837; c=relaxed/simple;
	bh=a01qzjbKVsHgc/I+WxaMOAoiqzwyFWvG9JwjdH5JwjM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZJzrY9/D9w/JJapymazkKONBkGjtFt8jM+kiRwrMhN9BMmLQ7GKmOU1fEFA6HPpv4N/Q6zOCzv5AlPxGmKOMFap3LyWIUpCC1ulQ4DpyMa4yVgjqtWzoqtH32yTL8+qGcOWvk3/b695TbNC8Dm8ACEyP5WrjqIG0odwV0T76wN8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zQsoaqOu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zQsoaqOu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58489C4CEF0;
	Tue, 17 Jun 2025 15:40:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750174836;
	bh=a01qzjbKVsHgc/I+WxaMOAoiqzwyFWvG9JwjdH5JwjM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zQsoaqOuhN4hLB8Ofsb824BjQFyvPq7chUfZqw6y83gsAXV2nRNkMEA6vdNp4YNAT
	 2hhhYwdbje4HtoLocDk4gzddt20Uc/2sv7mkDuRZRXdfpSfcSFqFPjce0Zqzs42WdW
	 Kk2XnoMcIae6WIGA9zpnsEFK7TjgWWqiv/H16R5s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Bee <knaerzche@gmail.com>,
	Jonas Karlman <jonas@kwiboo.se>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 065/512] media: rkvdec: Fix frame size enumeration
Date: Tue, 17 Jun 2025 17:20:31 +0200
Message-ID: <20250617152422.213835215@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152419.512865572@linuxfoundation.org>
References: <20250617152419.512865572@linuxfoundation.org>
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

From: Jonas Karlman <jonas@kwiboo.se>

[ Upstream commit f270005b99fa19fee9a6b4006e8dee37c10f1944 ]

The VIDIOC_ENUM_FRAMESIZES ioctl should return all frame sizes (i.e.
width and height in pixels) that the device supports for the given pixel
format.

It doesn't make a lot of sense to return the frame-sizes in a stepwise
manner, which is used to enforce hardware alignments requirements for
CAPTURE buffers, for coded formats.

Instead, applications should receive an indication, about the maximum
supported frame size for that hardware decoder, via a continuous
frame-size enumeration.

Fixes: cd33c830448b ("media: rkvdec: Add the rkvdec driver")
Suggested-by: Alex Bee <knaerzche@gmail.com>
Signed-off-by: Jonas Karlman <jonas@kwiboo.se>
Reviewed-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Signed-off-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/media/rkvdec/rkvdec.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/media/rkvdec/rkvdec.c b/drivers/staging/media/rkvdec/rkvdec.c
index ac398b5a97360..a1d941b0be00b 100644
--- a/drivers/staging/media/rkvdec/rkvdec.c
+++ b/drivers/staging/media/rkvdec/rkvdec.c
@@ -213,8 +213,14 @@ static int rkvdec_enum_framesizes(struct file *file, void *priv,
 	if (!fmt)
 		return -EINVAL;
 
-	fsize->type = V4L2_FRMSIZE_TYPE_STEPWISE;
-	fsize->stepwise = fmt->frmsize;
+	fsize->type = V4L2_FRMSIZE_TYPE_CONTINUOUS;
+	fsize->stepwise.min_width = 1;
+	fsize->stepwise.max_width = fmt->frmsize.max_width;
+	fsize->stepwise.step_width = 1;
+	fsize->stepwise.min_height = 1;
+	fsize->stepwise.max_height = fmt->frmsize.max_height;
+	fsize->stepwise.step_height = 1;
+
 	return 0;
 }
 
-- 
2.39.5



