Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6255C26CE11;
	Fri, 15 May 2026 16:25:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778862356; cv=none; b=JiGfKIAUxsV62Xs5p4/ZO4UKnMXb5dw7U86ZKeQEyBWJG9vZVJP5gpYeD6qNdVYLY24iYe18fUXCcXcsJCvWUkAehW2Vglw1pWQCJcXNjV0Y8ihKAznljw40KJHsvaORqTwh/yLFiYejCMbQdlA6dTx/r1IRNn8YQAWgy7/7f+0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778862356; c=relaxed/simple;
	bh=n9Nmm9WI0Mff3ePXdn0t4X+YUN08Mn8XHo6ZSczbd54=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HrsbprclCpkaxpVeq13aG6D+7F/s45TJJplJQ25CBgarjA3FLMGiGc+3+nRoSbilfJP46uM4CWNV6cJgGJPvX1vRfoyb4julTWqUGw1JxHvK9nO6Hcie7o9xdL+85q1LPr9cEh304E8RPh7KiP7DNth1/V7TrQ10Pf/TxcND3/k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AGiAWUUQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AGiAWUUQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED367C2BCB0;
	Fri, 15 May 2026 16:25:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778862356;
	bh=n9Nmm9WI0Mff3ePXdn0t4X+YUN08Mn8XHo6ZSczbd54=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AGiAWUUQl0DF7UKdf9IrH6aYDvdc1d3Vayvnq3QpanOsTRAeJxVBWV03k+QcFIPpg
	 BLCPIgdBv+r7OjptRMJ0kBCEUrEBcWf+LdPhHDE8/KbqsVqw6I8xDTzICFqqGhaCzJ
	 npY/5ZI9sSPSNkQznYvtItTjXdgutMN5/LW2LU8E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tomi Valkeinen <tomi.valkeinen+renesas@ideasonboard.com>,
	=?UTF-8?q?Niklas=20S=C3=B6derlund?= <niklas.soderlund+renesas@ragnatech.se>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 7.0 018/201] media: renesas: vin: Fix RAW8 (again)
Date: Fri, 15 May 2026 17:47:16 +0200
Message-ID: <20260515154658.929125839@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154658.538039039@linuxfoundation.org>
References: <20260515154658.538039039@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tomi Valkeinen <tomi.valkeinen+renesas@ideasonboard.com>

commit 40c6da8a9c0f897f99a439330584d93ca7d41226 upstream.

Commit e7376745ad5c ("media: rcar-vin: Fix stride setting for RAW8
formats") removed dividing the stride by two for RAW8 formats. It is
unclear how this was tested, but in any of the recent tests this does
not seem to work and produces quite distorted images.

However, reverting the patch fixes the issues only partially. VNIS_REG
requires alignment to 16 bytes, and when dividing the stride by 2, in
some cases we end up with a non-aligned stride, producing a tilted
image. This issue has to be fixed in rvin_format_bytesperline() where we
do the alignment for bytesperline.

Adding back the stride division and increasing the alignment for RAW8
formats to 0x20 fixes the problems related to RAW8.

Fixes: e7376745ad5c ("media: rcar-vin: Fix stride setting for RAW8 formats")
Cc: stable@vger.kernel.org
Signed-off-by: Tomi Valkeinen <tomi.valkeinen+renesas@ideasonboard.com>
Reviewed-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/platform/renesas/rcar-vin/rcar-dma.c  |   22 ++++++++++++++++++++
 drivers/media/platform/renesas/rcar-vin/rcar-v4l2.c |   12 ++++++++++
 2 files changed, 34 insertions(+)

--- a/drivers/media/platform/renesas/rcar-vin/rcar-dma.c
+++ b/drivers/media/platform/renesas/rcar-vin/rcar-dma.c
@@ -676,8 +676,30 @@ void rvin_crop_scale_comp(struct rvin_de
 	if (vin->scaler)
 		vin->scaler(vin);
 
+	/*
+	 * VNIS_REG has four lowest bits always 0, i.e. the stride has to be
+	 * aligned to 16 bytes. This is done in rvin_format_bytesperline().
+	 */
+
 	fmt = rvin_format_from_pixel(vin, vin->format.pixelformat);
 	stride = vin->format.bytesperline / fmt->bpp;
+
+	/*
+	 * RAW8 format bpp is 1, but the hardware process RAW8 format in 2 pixel
+	 * units, so we need to divide the stride by 2.
+	 */
+	switch (vin->format.pixelformat) {
+	case V4L2_PIX_FMT_SBGGR8:
+	case V4L2_PIX_FMT_SGBRG8:
+	case V4L2_PIX_FMT_SGRBG8:
+	case V4L2_PIX_FMT_SRGGB8:
+	case V4L2_PIX_FMT_GREY:
+		stride /= 2;
+		break;
+	default:
+		break;
+	}
+
 	rvin_write(vin, stride, VNIS_REG);
 }
 
--- a/drivers/media/platform/renesas/rcar-vin/rcar-v4l2.c
+++ b/drivers/media/platform/renesas/rcar-vin/rcar-v4l2.c
@@ -155,6 +155,18 @@ static u32 rvin_format_bytesperline(stru
 	case V4L2_PIX_FMT_NV16:
 		align = 0x20;
 		break;
+	case V4L2_PIX_FMT_SBGGR8:
+	case V4L2_PIX_FMT_SGBRG8:
+	case V4L2_PIX_FMT_SGRBG8:
+	case V4L2_PIX_FMT_SRGGB8:
+	case V4L2_PIX_FMT_GREY:
+		/*
+		 * RAW8 format bpp is 1, but the hardware process RAW8 format in
+		 * 2 pixel units, and we need to align to 32 bytes. See
+		 * rvin_crop_scale_comp().
+		 */
+		align = 0x20;
+		break;
 	default:
 		align = 0x10;
 		break;


