Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BE6270838;
	Mon, 23 Jun 2025 21:10:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750713007; cv=none; b=VmUFMieYH2kTrqPOi6vid5QoE3ebrWFf7FYoG7pDPV+5WtNeTxYp5bTSTTCwanOrg3JLbCXauNrQ2M+7VuBjdEB1hRE/0cxkLj1Kt3DeXn20iYkanEbQdqAkgt6kk+IcHwtXOa6YVwx//PkhEl5P72tYFgt7NEi4tt7pmIAYvpk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750713007; c=relaxed/simple;
	bh=NFyB5FXFlGCMpQE7RPyhwc+IVyK/wRCvzfac9Mmzp/M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=B4ItD4TvJEwtj7XWRytSk5/f3lAEhgVjfpSSPCRF0QryzTSMNzR83WtAuEKxfhzE5tjdJMqNl1i4ZOVvFuSitmWRxd/cNEW6qtyDlfgJXgxaAW+Vu4oEI862OYCaS5pzu3B5+Y/c1XIRQxcZP4qnm0wC0LisJocUhz4VjKS7P4k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CDkedgJF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CDkedgJF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18EF3C4CEEA;
	Mon, 23 Jun 2025 21:10:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750713007;
	bh=NFyB5FXFlGCMpQE7RPyhwc+IVyK/wRCvzfac9Mmzp/M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CDkedgJF/Mi8fImpssQYgh5vlNzNARfyVaDVeliJdWl/empf4NF4CXdUgOU5MfyrQ
	 PQaeECP0iSKcUgyo8TN4iJCUFY9sKj6Cjp7SIp2AlVN7ExGyi2qxXSsCQJBKQr9cP9
	 oGVghq55A4OZURRO+sfiaDElcMHEv9PW9mgmSGGw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Niklas=20S=C3=B6derlund?= <niklas.soderlund+renesas@ragnatech.se>,
	Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 305/592] media: rcar-vin: Fix stride setting for RAW8 formats
Date: Mon, 23 Jun 2025 15:04:23 +0200
Message-ID: <20250623130707.656451312@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130700.210182694@linuxfoundation.org>
References: <20250623130700.210182694@linuxfoundation.org>
User-Agent: quilt/0.68
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>

[ Upstream commit e7376745ad5c8548e31d9ea58adfb5a847e017a4 ]

Earlier versions of the datasheet where unclear about the stride setting
for RAW8 capture formats. Later datasheets clarifies that the stride
only process in this mode for non-image data. For image data the full
stride shall be used. Compare section "RAW: 8 Bits and Embedded 8-Bit
Non-Image Data, User Defined 8-bit Data" vs "RAW: 8 Bits".

Remove the special case from pixel formats that carry image data and
treat it as any other image format.

Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
Reviewed-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Link: https://lore.kernel.org/r/20250402183302.140055-1-niklas.soderlund+renesas@ragnatech.se
Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../media/platform/renesas/rcar-vin/rcar-dma.c   | 16 ----------------
 1 file changed, 16 deletions(-)

diff --git a/drivers/media/platform/renesas/rcar-vin/rcar-dma.c b/drivers/media/platform/renesas/rcar-vin/rcar-dma.c
index e303c13e1351f..3af67c1b303d6 100644
--- a/drivers/media/platform/renesas/rcar-vin/rcar-dma.c
+++ b/drivers/media/platform/renesas/rcar-vin/rcar-dma.c
@@ -679,22 +679,6 @@ void rvin_crop_scale_comp(struct rvin_dev *vin)
 
 	fmt = rvin_format_from_pixel(vin, vin->format.pixelformat);
 	stride = vin->format.bytesperline / fmt->bpp;
-
-	/* For RAW8 format bpp is 1, but the hardware process RAW8
-	 * format in 2 pixel unit hence configure VNIS_REG as stride / 2.
-	 */
-	switch (vin->format.pixelformat) {
-	case V4L2_PIX_FMT_SBGGR8:
-	case V4L2_PIX_FMT_SGBRG8:
-	case V4L2_PIX_FMT_SGRBG8:
-	case V4L2_PIX_FMT_SRGGB8:
-	case V4L2_PIX_FMT_GREY:
-		stride /= 2;
-		break;
-	default:
-		break;
-	}
-
 	rvin_write(vin, stride, VNIS_REG);
 }
 
-- 
2.39.5



