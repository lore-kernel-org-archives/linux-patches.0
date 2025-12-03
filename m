Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6651035CBDF;
	Wed,  3 Dec 2025 16:27:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764779223; cv=none; b=ulg3FBpbX7DQhj8wiRbrfNq7flqv+k+jo6Xe6nqnweRbOEyTQ59AzGSHyF1qlt85UUAn9dICu8yC5nXrOb9vEWiZRK4xPUBWX+Eat8R4z/zFAcHXClyccrzFodnJmNpSeo6nGT+roIiWY6Qx2VHzbgAnKrCOb8rcLkgeo6J6WdU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764779223; c=relaxed/simple;
	bh=hHWF6e7o9WBwr9bcIv4uuL/pascecDH6xrB7I9BqWP4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hGvy5CXFiXZ1mb1kmASL6newqQeVf+F6GczXQ2RA66bVAZO8FL5YQ/LIl8hNZ62hGxCBJD1sCQRq/Eg2GEAzbR6CHcZBRgZxwtKLaCBbqPDCkQ5PDyEPbJxAb5ffzYNyEJwyQ3MBnoRhsavS029CfxOuC1PC1831qMz10T+XB0Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=coKqMvft; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="coKqMvft"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E27BFC116C6;
	Wed,  3 Dec 2025 16:27:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764779223;
	bh=hHWF6e7o9WBwr9bcIv4uuL/pascecDH6xrB7I9BqWP4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=coKqMvftT4h09ti94ytCeoiO6UaExP9TdKgSwpdjvL6thXUqZTCP6Ls1/q6GaTggC
	 k4ymK2c2EFXwviTTvoP1spVX9G3/e7CFJlHqwEAyhTdNgNMCuK6CE80UVjH5J/pOmf
	 7b0q1Zj9vG1v+IE5I8pRoK1513Gil9uK8yqx4TJU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Niklas=20S=C3=B6derlund?= <niklas.soderlund+renesas@ragnatech.se>,
	Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 192/568] media: adv7180: Do not write format to device in set_fmt
Date: Wed,  3 Dec 2025 16:23:14 +0100
Message-ID: <20251203152447.757098778@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152440.645416925@linuxfoundation.org>
References: <20251203152440.645416925@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>

[ Upstream commit 46c1e7814d1c3310ef23c01ed1a582ef0c8ab1d2 ]

The .set_fmt callback should not write the new format directly do the
device, it should only store it and have it applied by .s_stream.

The .s_stream callback already calls adv7180_set_field_mode() so it's
safe to remove programming of the device and just store the format and
have .s_stream apply it.

Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
Reviewed-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/i2c/adv7180.c | 9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

diff --git a/drivers/media/i2c/adv7180.c b/drivers/media/i2c/adv7180.c
index a7977f9c64c88..74356ea06deee 100644
--- a/drivers/media/i2c/adv7180.c
+++ b/drivers/media/i2c/adv7180.c
@@ -803,14 +803,7 @@ static int adv7180_set_pad_format(struct v4l2_subdev *sd,
 	ret = adv7180_mbus_fmt(sd,  &format->format);
 
 	if (format->which == V4L2_SUBDEV_FORMAT_ACTIVE) {
-		if (state->field != format->format.field) {
-			guard(mutex)(&state->mutex);
-
-			state->field = format->format.field;
-			adv7180_set_power(state, false);
-			adv7180_set_field_mode(state);
-			adv7180_set_power(state, true);
-		}
+		state->field = format->format.field;
 	} else {
 		framefmt = v4l2_subdev_get_try_format(sd, sd_state, 0);
 		*framefmt = format->format;
-- 
2.51.0



